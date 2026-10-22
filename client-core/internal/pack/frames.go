package pack

// 隔空传送的数据流：一串「帧」，整体经 zstd 压缩。与复制同步用的 tar 流不同，
// 它能从任意一个文件的任意位置接着发，断了以后不用从头再来。见 design/send-files.md 第 6.3 节。
//
//	file{index, path, size, offset, …}   ← 4 字节大端长度 + 序列化的 SendFrame
//	<size - offset 个字节的文件内容>       ← 目录和符号链接没有
//	file_end{sha256}                     ← 只有普通文件有，是整个文件的哈希
//	file{index+1, …}
//	…
//	end{}

import (
	"bufio"
	"context"
	"crypto/sha256"
	"encoding/binary"
	"errors"
	"fmt"
	"hash"
	"io"
	"io/fs"
	"os"
	"path"
	"path/filepath"
	"strings"

	"github.com/klauspost/compress/zstd"
	"golang.org/x/text/unicode/norm"
	"google.golang.org/protobuf/proto"

	pb "github.com/baiyuze/pasteferry/proto/gen/pasteferry/v1"
)

// maxFrameSize 是一个控制帧的上限。帧里只有路径和几个数字，远用不了这么多；
// 对端发来更大的长度说明数据流坏了，不能照着去分配内存。
const maxFrameSize = 64 << 10

var (
	// ErrSourceChanged 表示源文件在发起之后被改过（大小或修改时间变了）
	ErrSourceChanged = errors.New("源文件在发送过程中被修改了")
	// ErrSourceMissing 表示源文件已经不在了
	ErrSourceMissing = errors.New("源文件已经不在了")
)

// ReadError 是读源文件时出的错，与写数据通道出的错（连接断了）区分开。
type ReadError struct{ Err error }

func (e *ReadError) Error() string { return "读取源文件: " + e.Err.Error() }
func (e *ReadError) Unwrap() error { return e.Err }

// Entry 是隔空传送清单里的一项：一个文件、目录或符号链接。
type Entry struct {
	Path   string // 相对路径，正斜杠分隔，第一段是顶层项目的名字
	Source string // 本机的完整路径，只在发送方有意义
	Size   int64
	IsDir  bool
	Mode   uint32
	MTime  int64
	Link   string // 非空表示符号链接，值是它指向的位置
}

// Top 是一个顶层项目，也就是用户拖进来的一个文件或文件夹。
type Top struct {
	Name  string
	Size  int64 // 文件夹是里面所有文件的总大小
	IsDir bool
}

// BuildManifest 遍历用户选中的路径，按发送的顺序列出所有条目。
//
// 顶层是符号链接时发送它指向的内容（用户拖的是一个替身，要的是原件）；
// 文件夹里面的符号链接按链接本身发送，不跟随，免得把整个外部目录卷进来。
// 打不开的文件跳过，与复制同步一致：尽量把能传的传过去。
// progress 每找到 500 个文件回调一次，可以为 nil。
func BuildManifest(ctx context.Context, paths []string, progress func(files int64)) ([]Entry, []Top, error) {
	var entries []Entry
	var tops []Top
	used := map[string]bool{}
	var files int64
	for _, root := range paths {
		info, err := os.Stat(root) // 跟随顶层的符号链接
		if err != nil {
			return nil, nil, fmt.Errorf("%w: %s", ErrSourceMissing, root)
		}
		name := uniqueTop(used, filepath.Base(root), info.IsDir())
		top := Top{Name: name, IsDir: info.IsDir()}
		if !info.IsDir() {
			if !readable(root) {
				return nil, nil, &ReadError{fmt.Errorf("打不开 %s", root)}
			}
			entries = append(entries, entryFor(name, root, info, ""))
			top.Size = info.Size()
			tops = append(tops, top)
			files++
			continue
		}
		resolved, err := filepath.EvalSymlinks(root)
		if err != nil {
			return nil, nil, &ReadError{err}
		}
		err = filepath.WalkDir(resolved, func(p string, d fs.DirEntry, err error) error {
			if err := ctx.Err(); err != nil {
				return err
			}
			if err != nil {
				if d != nil && d.IsDir() && p != resolved {
					return fs.SkipDir // 读不了的子文件夹跳过
				}
				return nil
			}
			if p != resolved && skipWhenPacking(d.Name()) {
				return nil
			}
			rel, err := filepath.Rel(resolved, p)
			if err != nil {
				return err
			}
			entryPath := name
			if rel != "." {
				entryPath = name + "/" + filepath.ToSlash(rel)
			}
			info, err := d.Info()
			if err != nil {
				return nil
			}
			var link string
			switch {
			case info.Mode()&os.ModeSymlink != 0:
				if link, err = os.Readlink(p); err != nil || link == "" {
					return nil
				}
			case info.Mode().IsRegular():
				if !readable(p) {
					return nil
				}
				top.Size += info.Size()
				files++
				if progress != nil && files%500 == 0 {
					progress(files)
				}
			case !info.IsDir():
				return nil // 设备文件、管道之类不传
			}
			entries = append(entries, entryFor(entryPath, p, info, link))
			return nil
		})
		if err != nil {
			return nil, nil, err
		}
		tops = append(tops, top)
	}
	if progress != nil {
		progress(files)
	}
	return entries, tops, nil
}

func entryFor(rel, source string, info os.FileInfo, link string) Entry {
	e := Entry{Path: rel, Source: source, IsDir: info.IsDir(), Mode: uint32(info.Mode().Perm()), MTime: info.ModTime().Unix(), Link: link}
	if info.Mode().IsRegular() {
		e.Size = info.Size()
	}
	return e
}

func readable(p string) bool {
	f, err := os.Open(p)
	if err != nil {
		return false
	}
	f.Close()
	return true
}

// uniqueTop 让两个同名的顶层项目（从不同文件夹拖进来的）各有各的名字。
func uniqueTop(used map[string]bool, name string, isDir bool) string {
	ext := path.Ext(name)
	stem := strings.TrimSuffix(name, ext)
	if isDir {
		stem, ext = name, ""
	}
	candidate := name
	for n := 2; used[strings.ToLower(candidate)]; n++ {
		candidate = fmt.Sprintf("%s (%d)%s", stem, n, ext)
	}
	used[strings.ToLower(candidate)] = true
	return candidate
}

// ─────────────────────── 发送方 ───────────────────────

// FrameWriter 把条目写成帧流。
type FrameWriter struct {
	enc  *zstd.Encoder
	sent func(n int64)
}

// NewFrameWriter 在 w 上开一个帧流。sent 在写出文件内容时收到字节数（未压缩），用来报进度，可以为 nil。
func NewFrameWriter(w io.Writer, sent func(n int64)) (*FrameWriter, error) {
	enc, err := zstd.NewWriter(w, zstd.WithEncoderLevel(zstd.SpeedFastest))
	if err != nil {
		return nil, fmt.Errorf("创建压缩流: %w", err)
	}
	return &FrameWriter{enc: enc, sent: sent}, nil
}

func (fw *FrameWriter) frame(f *pb.SendFrame) error {
	data, err := proto.Marshal(f)
	if err != nil {
		return err
	}
	var hdr [4]byte
	binary.BigEndian.PutUint32(hdr[:], uint32(len(data)))
	if _, err := fw.enc.Write(hdr[:]); err != nil {
		return err
	}
	_, err = fw.enc.Write(data)
	return err
}

// WriteEntry 发一个条目，普通文件从 offset 处接着发。
// 源文件的大小或修改时间与清单不一致时返回 ErrSourceChanged，读不了时返回 *ReadError，
// 其他错误来自数据流本身（多半是连接断了）。
func (fw *FrameWriter) WriteEntry(index int64, e Entry, offset int64) error {
	start := &pb.SendFileStart{
		Index: index, Path: e.Path, Size: e.Size, IsDir: e.IsDir,
		Mode: e.Mode, MtimeUnix: e.MTime, LinkTarget: e.Link,
	}
	if e.IsDir || e.Link != "" {
		return fw.frame(&pb.SendFrame{Payload: &pb.SendFrame_File{File: start}})
	}

	f, err := os.Open(e.Source)
	if err != nil {
		if errors.Is(err, fs.ErrNotExist) {
			return ErrSourceMissing
		}
		return &ReadError{err}
	}
	defer f.Close()
	info, err := f.Stat()
	if err != nil {
		return &ReadError{err}
	}
	if info.Size() != e.Size || info.ModTime().Unix() != e.MTime {
		return ErrSourceChanged
	}
	if offset < 0 || offset > e.Size {
		offset = 0
	}
	h := sha256.New()
	if offset > 0 {
		// 续传：哈希要覆盖整个文件，已经发过的那一段从磁盘再读一遍
		if _, err := io.CopyN(h, f, offset); err != nil {
			return &ReadError{err}
		}
	}
	start.Offset = offset
	if err := fw.frame(&pb.SendFrame{Payload: &pb.SendFrame_File{File: start}}); err != nil {
		return err
	}
	out := io.MultiWriter(fw.enc, h)
	if fw.sent != nil {
		out = io.MultiWriter(fw.enc, h, countWriter(fw.sent))
	}
	n, err := io.CopyN(out, readerOnly{f}, e.Size-offset)
	if err != nil {
		var re *readFailure
		if errors.As(err, &re) {
			if errors.Is(re.err, io.EOF) {
				return ErrSourceChanged // 文件变短了
			}
			return &ReadError{re.err}
		}
		if n < e.Size-offset && errors.Is(err, io.EOF) {
			return ErrSourceChanged
		}
		return err
	}
	return fw.frame(&pb.SendFrame{Payload: &pb.SendFrame_FileEnd{FileEnd: &pb.SendFileEnd{Sha256: h.Sum(nil)}}})
}

// Finish 写结束帧并刷出压缩流里剩下的数据。
func (fw *FrameWriter) Finish() error {
	if err := fw.frame(&pb.SendFrame{Payload: &pb.SendFrame_End{End: &pb.SendStreamEnd{}}}); err != nil {
		return err
	}
	return fw.enc.Close()
}

// Close 在出错时释放压缩流，不再写任何东西。
func (fw *FrameWriter) Close() { fw.enc.Reset(io.Discard) }

// readFailure 标出「读源文件」时的错误，与 io.CopyN 里写数据流的错误区分开。
type readFailure struct{ err error }

func (e *readFailure) Error() string { return e.err.Error() }

type readerOnly struct{ f *os.File }

func (r readerOnly) Read(p []byte) (int, error) {
	n, err := r.f.Read(p)
	if err != nil && n == 0 {
		return 0, &readFailure{err}
	}
	return n, nil
}

type countWriter func(int64)

func (c countWriter) Write(p []byte) (int, error) {
	c(int64(len(p)))
	return len(p), nil
}

// ─────────────────────── 接收方 ───────────────────────

// FrameReader 从数据流里依次读出帧和文件内容。
type FrameReader struct {
	dec *zstd.Decoder
	r   *bufio.Reader
}

func NewFrameReader(r io.Reader) (*FrameReader, error) {
	dec, err := zstd.NewReader(r)
	if err != nil {
		return nil, fmt.Errorf("创建解压流: %w", err)
	}
	return &FrameReader{dec: dec, r: bufio.NewReaderSize(dec, 256<<10)}, nil
}

// Next 读下一个帧。数据流在帧中间断开时返回 io.ErrUnexpectedEOF。
func (fr *FrameReader) Next() (*pb.SendFrame, error) {
	var hdr [4]byte
	if _, err := io.ReadFull(fr.r, hdr[:]); err != nil {
		if errors.Is(err, io.EOF) {
			return nil, io.ErrUnexpectedEOF // end 帧之前就没了
		}
		return nil, err
	}
	n := binary.BigEndian.Uint32(hdr[:])
	if n > maxFrameSize {
		return nil, fmt.Errorf("帧长度 %d 超出上限", n)
	}
	buf := make([]byte, n)
	if _, err := io.ReadFull(fr.r, buf); err != nil {
		if errors.Is(err, io.EOF) {
			return nil, io.ErrUnexpectedEOF
		}
		return nil, err
	}
	var f pb.SendFrame
	if err := proto.Unmarshal(buf, &f); err != nil {
		return nil, fmt.Errorf("解析帧: %w", err)
	}
	return &f, nil
}

// CopyContent 把紧跟在 file 帧后面的 n 个字节写进 w，同时算进哈希。
// 数据流提前结束时返回 io.ErrUnexpectedEOF。
func (fr *FrameReader) CopyContent(w io.Writer, h hash.Hash, n int64) (int64, error) {
	got, err := io.CopyN(io.MultiWriter(w, h), fr.r, n)
	if err != nil && errors.Is(err, io.EOF) {
		err = io.ErrUnexpectedEOF
	}
	return got, err
}

func (fr *FrameReader) Close() { fr.dec.Close() }

// Names 决定收到的每个条目在本机落盘时的相对路径。
// Windows 上按 names.go 的规则把名字改成合法的，并处理只差大小写的重名；
// 其他平台原样使用。含 .. 或绝对路径的条目一律拒绝。
type Names struct{ d *destNames }

func NewNames() *Names { return &Names{d: newDestNames()} }

// Rel 返回条目 name（正斜杠分隔）落盘的相对路径（正斜杠分隔）。
func (n *Names) Rel(name string, isDir bool) (string, error) {
	clean := path.Clean(strings.TrimSuffix(name, "/"))
	if clean == "." || clean == ".." || strings.HasPrefix(clean, "../") || strings.HasPrefix(clean, "/") ||
		strings.Contains(clean, "\\") || strings.ContainsRune(clean, 0) {
		return "", fmt.Errorf("数据流中含非法路径: %q", name)
	}
	if !windowsNames {
		return clean, nil
	}
	return n.d.rel(clean, isDir)
}

// Restore 在续传时登记已经落盘的条目，让后面的条目沿用同样的映射、不撞名。
func (n *Names) Restore(name, mapped string, isDir bool) {
	if !windowsNames {
		return
	}
	n.d.used[strings.ToLower(mapped)] = usedName{mapped, isDir}
	if isDir {
		n.d.dirs[path.Clean(name)] = mapped
	}
}

// Renamed 判断一个条目落盘时名字是不是改过（Windows 上替换了不允许的字符，或者与只差大小写的同名条目错开）。
// Mac 上的分解形式统一成组合形式看不出区别，不算改名。
func Renamed(name, local string) bool {
	return path.Base(local) != norm.NFC.String(path.Base(strings.TrimSuffix(name, "/")))
}

// Skip 表示这个条目在本机不该落盘：Windows 上的 .DS_Store 与 AppleDouble 文件。
func Skip(name string) bool { return windowsNames && skipOnWindows(path.Base(name)) }

// SafeJoin 把相对路径接到 base 下面，拒绝逃出 base 的路径。
func SafeJoin(base, rel string) (string, error) { return safeJoin(base, rel) }
