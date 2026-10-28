// 复制记录：与 App 的记录页相同的结构——搜索框、按类型筛选、分组列表；
// 每行左边是类型图标（图片换成缩略图），中间是内容与「来自 × · 大小 · 时间」，右边是操作。
import { useCallback, useEffect, useRef, useState, type ReactNode } from 'react'
import { ApiError, fetchBin, rpc, type FileInfo, type WebItem, type WebRecord } from './api'
import { useConn } from './context'
import { t } from './i18n'
import { ArrowDownload, Checkmark, ChevronRight, Copy, Document, DocumentText, Folder, History, Image as ImageIcon, Link as LinkIcon, TextAlignLeft } from './icons'
import { Button, Group, SearchField, Segmented, Separator, Sheet, cx, useToast } from './ui'
import { copyText, errorText, humanSize, relativeTime, saveBlob } from './util'

export type Filter = 'all' | 'text' | 'link' | 'image' | 'file'

function matches(r: WebRecord, f: Filter): boolean {
  switch (f) {
    case 'text':
      return r.kind === 'text' && !r.link
    case 'link':
      return r.kind === 'text' && !!r.link
    case 'image':
      return r.kind === 'image'
    case 'file':
      return r.kind === 'file'
    default:
      return true
  }
}

function recordTitle(r: WebRecord): string {
  if (r.kind === 'text') return (r.text || r.preview).trim().split('\n')[0] || r.preview
  if (r.kind === 'image') return t('image')
  const items = r.items || []
  if (items.length > 1) return t('andMore', { name: items[0].name, n: items.length - 1 })
  return items[0]?.name || r.preview
}

function recordSource(r: WebRecord): string {
  return r.mine ? t('thisPhone') : t('fromDevice', { name: r.from })
}

function statusNote(r: WebRecord): string {
  switch (r.status) {
    case 'remote':
      return t('remoteOnly', { name: r.from })
    case 'fetching':
      return t('fetching')
    case 'failed':
      return t('failed')
    case 'expired':
      return t('expired')
    default:
      return ''
  }
}

function KindIcon({ r }: { r: WebRecord }) {
  const cls = 'text-dim'
  if (r.kind === 'text') return r.link ? <LinkIcon className={cls} /> : r.long ? <DocumentText className={cls} /> : <TextAlignLeft className={cls} />
  if (r.kind === 'image') return <ImageIcon className={cls} />
  const items = r.items || []
  if (items.length === 1 && items[0].dir) return <Folder className={cls} />
  return <Document className={cls} />
}

// ── 缩略图（进入视野才取，取过的留在内存里） ──

const thumbCache = new Map<string, string>()

function useThumb(r: WebRecord, el: React.RefObject<HTMLElement | null>): string {
  const conn = useConn()
  const wanted = r.status === 'ready' && (r.kind === 'image' || (r.images ?? 0) > 0)
  const [url, setURL] = useState(() => thumbCache.get(r.id) || '')
  useEffect(() => {
    if (!wanted || url || !el.current) return
    let cancelled = false
    const load = () =>
      fetchBin(conn.session, 'thumb', { clip: r.id }).then(
        (data) => {
          const u = URL.createObjectURL(new Blob([data as BlobPart], { type: 'image/png' }))
          thumbCache.set(r.id, u)
          if (!cancelled) setURL(u)
        },
        () => {},
      )
    if (!('IntersectionObserver' in window)) {
      load()
      return () => {
        cancelled = true
      }
    }
    const io = new IntersectionObserver(
      (entries) => {
        if (entries.some((e) => e.isIntersecting)) {
          io.disconnect()
          load()
        }
      },
      { rootMargin: '200px' },
    )
    io.observe(el.current)
    return () => {
      cancelled = true
      io.disconnect()
    }
  }, [wanted, url, r.id, conn.session, el])
  return url
}

// ── 下载 ──

export function useDownload() {
  const conn = useConn()
  const toast = useToast()
  const [progress, setProgress] = useState<Record<string, number>>({})
  const [preview, setPreview] = useState<{ url: string; name: string } | null>(null)

  const download = useCallback(
    async (r: WebRecord, item: number) => {
      const key = `${r.id}/${item}`
      setProgress((p) => ({ ...p, [key]: 0 }))
      try {
        const info = await rpc<FileInfo>(conn.session, 'file_info', { clip: r.id, item })
        if (info.size > conn.maxDownload) throw new ApiError('too_large_dl')
        const parts: BlobPart[] = []
        for (let n = 0; n < info.chunks; n++) {
          parts.push((await fetchBin(conn.session, 'chunk', { clip: r.id, item, n })) as BlobPart)
          setProgress((p) => ({ ...p, [key]: (n + 1) / Math.max(info.chunks, 1) }))
        }
        const url = URL.createObjectURL(new Blob(parts, { type: info.mime || 'application/octet-stream' }))
        if ((info.mime || '').startsWith('image/')) {
          setPreview({ url, name: info.name })
        } else {
          saveBlob(url, info.name)
          setTimeout(() => URL.revokeObjectURL(url), 60_000)
          toast(t('downloaded'))
        }
        conn.succeeded()
      } catch (e) {
        if (e instanceof ApiError && (e.code === 'too_large_dl' || e.code === 'too_large')) {
          toast(t('tooLarge', { size: humanSize(conn.maxDownload) }))
        } else {
          toast(errorText(e))
        }
      } finally {
        setProgress((p) => {
          const next = { ...p }
          delete next[key]
          return next
        })
      }
    },
    [conn, toast],
  )

  const closePreview = useCallback(() => {
    setPreview((p) => {
      if (p) setTimeout(() => URL.revokeObjectURL(p.url), 300)
      return null
    })
  }, [])

  const previewSheet = (
    <Sheet open={!!preview} onClose={closePreview}>
      {preview && (
        <div className="px-4 pb-4">
          <h3 className="mb-3 truncate text-center text-[15px] font-semibold">{preview.name}</h3>
          <img src={preview.url} alt="" className="mx-auto max-h-[60vh] rounded-md" />
          <p className="mt-3 text-center text-[13px] text-dim">{t('saveImageHint')}</p>
          <div className="mt-4 grid grid-cols-2 gap-3">
            <Button kind="secondary" className="h-11" onClick={closePreview}>
              {t('close')}
            </Button>
            <a
              href={preview.url}
              download={preview.name}
              className="inline-flex h-11 items-center justify-center gap-1.5 rounded-md bg-accent font-semibold text-white active:opacity-80"
            >
              <ArrowDownload size={20} />
              {t('download')}
            </a>
          </div>
        </div>
      )}
    </Sheet>
  )

  return { download, progress, previewSheet }
}

// ── 一行记录 ──

function Row({
  r,
  copied,
  onOpen,
  onCopy,
  onDownload,
  downloading,
}: {
  r: WebRecord
  copied: boolean
  onOpen: () => void
  onCopy: () => void
  onDownload: (item: number) => void
  downloading?: number
}) {
  const ref = useRef<HTMLDivElement>(null)
  const thumb = useThumb(r, ref)
  const note = statusNote(r)
  const ready = r.status === 'ready'
  const items = r.items || []
  const single = r.kind === 'image' || items.length === 1

  let action: ReactNode = null
  if (r.kind === 'text' && r.text) {
    action = (
      <Button
        kind="text"
        className={cx('min-w-[3.75rem] px-2 py-1 text-[15px]', copied && 'text-online')}
        onClick={(e) => (e.stopPropagation(), onCopy())}
      >
        {copied ? (
          <>
            <Checkmark size={18} />
            {t('copied')}
          </>
        ) : (
          t('copy')
        )}
      </Button>
    )
  } else if (ready && single && !(items[0]?.dir)) {
    action =
      downloading !== undefined ? (
        <span className="px-2 text-[13px] tabular-nums text-dim">{Math.round(downloading * 100)}%</span>
      ) : (
        <Button kind="text" className="px-2 py-1 text-[15px]" onClick={(e) => (e.stopPropagation(), onDownload(0))}>
          {t('download')}
        </Button>
      )
  } else {
    action = <ChevronRight size={20} className="mr-1 text-faint" />
  }

  return (
    <div ref={ref} role="button" tabIndex={0} onClick={onOpen} className="flex items-center gap-3 px-4 py-3 active:bg-fill">
      <div className="flex h-10 w-10 shrink-0 items-center justify-center self-start overflow-hidden rounded-sm">
        {thumb ? <img src={thumb} alt="" className="h-10 w-10 object-cover" /> : <KindIcon r={r} />}
      </div>
      <div className="min-w-0 flex-1">
        <div className={cx('line-clamp-2 break-words text-[15px] leading-snug', r.kind !== 'text' && 'truncate')}>{recordTitle(r)}</div>
        <div className="mt-0.5 truncate text-[13px] text-dim">
          <span className={cx(r.mine && 'text-accent')}>{recordSource(r)}</span>
          {r.kind !== 'text' || r.size > 0 ? ` · ${humanSize(r.size)}` : ''} · {relativeTime(r.at)}
        </div>
        {note && <div className="mt-0.5 text-[13px] text-dim">{note}</div>}
      </div>
      <div className="shrink-0">{action}</div>
    </div>
  )
}

// ── 详情弹层 ──

function Detail({
  r: open,
  copied,
  onClose,
  onCopy,
  onDownload,
  progress,
}: {
  r: WebRecord | null
  copied: boolean
  onClose: () => void
  onCopy: (r: WebRecord) => void
  onDownload: (r: WebRecord, item: number) => void
  progress: Record<string, number>
}) {
  const conn = useConn()
  const toast = useToast()
  const [full, setFull] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)
  // 关闭时弹层还要滑出一会儿，内容留着最后一条，不在动画开始前就清空
  const last = useRef<WebRecord | null>(null)
  if (open) last.current = open
  const r = open ?? last.current
  useEffect(() => setFull(null), [r?.id])
  const ref = useRef<HTMLDivElement>(null)
  const thumb = useThumbOptional(r, ref)

  if (!r) return null
  const text = full ?? r.text
  const ready = r.status === 'ready'
  const note = statusNote(r)

  return (
    <Sheet open={!!open} onClose={onClose}>
      <div ref={ref} className="px-4 pb-4">
        <div className="mb-3 text-center text-[13px] text-dim">
          {recordSource(r)} · {relativeTime(r.at)}
        </div>
        {r.kind === 'text' && (
          <>
            <div className="max-h-[50vh] overflow-y-auto whitespace-pre-wrap break-words rounded-md bg-fill p-3 text-[16px] leading-relaxed [overflow-wrap:anywhere]">
              {text || r.preview}
            </div>
            <div className="mt-4 grid gap-3">
              {r.long && !text ? (
                <Button
                  kind="secondary"
                  className="h-11"
                  disabled={loading}
                  onClick={async () => {
                    setLoading(true)
                    try {
                      const res = await rpc<{ text: string }>(conn.session, 'full_text', { clip: r.id })
                      setFull(res.text)
                    } catch (e) {
                      toast(errorText(e))
                    } finally {
                      setLoading(false)
                    }
                  }}
                >
                  {t('loadFull')}
                </Button>
              ) : (
                <Button kind="primary" className="h-11" onClick={() => onCopy({ ...r, text: text || '' })}>
                  {copied ? <Checkmark size={20} /> : <Copy size={20} />}
                  {copied ? t('copied') : t('copy')}
                </Button>
              )}
            </div>
          </>
        )}
        {r.kind !== 'text' && (
          <>
            {thumb && <img src={thumb} alt="" className="mx-auto mb-3 max-h-56 rounded-md" />}
            {note && <p className="mb-3 text-center text-[13px] text-dim">{note}</p>}
            <Group>
              {(r.kind === 'image' ? [{ name: t('image'), size: r.size } as WebItem] : r.items || []).map((it, i) => {
                const p = progress[`${r.id}/${i}`]
                return (
                  <div key={i}>
                    {i > 0 && <Separator inset={16} />}
                    <div className="flex items-center gap-3 px-4 py-3">
                      {it.dir ? <Folder className="shrink-0 text-dim" /> : r.kind === 'image' ? <ImageIcon className="shrink-0 text-dim" /> : <Document className="shrink-0 text-dim" />}
                      <div className="min-w-0 flex-1">
                        <div className="truncate text-[15px]">{it.name}</div>
                        <div className="text-[13px] text-dim">{it.dir ? 'ZIP' : humanSize(it.size)}</div>
                      </div>
                      {p !== undefined ? (
                        <span className="px-2 text-[13px] tabular-nums text-dim">{Math.round(p * 100)}%</span>
                      ) : (
                        <Button kind="text" className="px-2 py-1 text-[15px]" disabled={!ready} onClick={() => onDownload(r, i)}>
                          {t('download')}
                        </Button>
                      )}
                    </div>
                  </div>
                )
              })}
            </Group>
          </>
        )}
      </div>
    </Sheet>
  )
}

function useThumbOptional(r: WebRecord | null, ref: React.RefObject<HTMLElement | null>): string {
  const conn = useConn()
  const [url, setURL] = useState('')
  useEffect(() => {
    setURL('')
    if (!r || r.status !== 'ready' || !(r.kind === 'image' || (r.images ?? 0) > 0)) return
    const cached = thumbCache.get(r.id)
    if (cached) {
      setURL(cached)
      return
    }
    let cancelled = false
    fetchBin(conn.session, 'thumb', { clip: r.id }).then(
      (data) => {
        const u = URL.createObjectURL(new Blob([data as BlobPart], { type: 'image/png' }))
        thumbCache.set(r.id, u)
        if (!cancelled) setURL(u)
      },
      () => {},
    )
    return () => {
      cancelled = true
    }
  }, [r, conn.session, ref])
  return url
}

// ── 记录页 ──

export function RecordsView({
  records,
  more,
  loading,
  filter,
  query,
  onFilter,
  onQuery,
  onLoadMore,
  header,
}: {
  records: WebRecord[]
  more: boolean
  loading: boolean
  filter: Filter
  query: string
  onFilter: (f: Filter) => void
  onQuery: (q: string) => void
  onLoadMore: () => void
  header: ReactNode
}) {
  const conn = useConn()
  const { download, progress, previewSheet } = useDownload()
  const [open, setOpen] = useState<WebRecord | null>(null)
  const [manual, setManual] = useState<string | null>(null)
  const [copiedId, setCopiedId] = useState('')
  const copiedTimer = useRef(0)
  const sentinel = useRef<HTMLDivElement>(null)

  useEffect(() => () => window.clearTimeout(copiedTimer.current), [])

  useEffect(() => {
    if (!more || !sentinel.current || !('IntersectionObserver' in window)) return
    const io = new IntersectionObserver((es) => es.some((e) => e.isIntersecting) && onLoadMore(), { rootMargin: '400px' })
    io.observe(sentinel.current)
    return () => io.disconnect()
  }, [more, onLoadMore, records.length])

  const copy = (r: WebRecord) => {
    if (!r.text) return
    if (copyText(r.text)) {
      // 在网页自己所在的设备上复制了记录：告诉后台忽略这次剪贴板变化，
      // 否则（页面和后台在同一台电脑上时）会把自己复制的内容又记成一条新记录。
      rpc(conn.session, 'own_copy', {}).catch(() => {})
      // 复制的反馈留在按钮上，不弹提示条：这个页面主要给手机用，
      // 浮在内容上的提示会挡住列表，和 App 里的做法也不一致。
      setCopiedId(r.id)
      window.clearTimeout(copiedTimer.current)
      copiedTimer.current = window.setTimeout(() => setCopiedId(''), 1600)
      conn.succeeded()
    } else {
      setManual(r.text)
    }
  }

  const filters: { value: Filter; label: string }[] = [
    { value: 'all', label: t('filterAll') },
    { value: 'text', label: t('filterText') },
    { value: 'link', label: t('filterLink') },
    { value: 'image', label: t('filterImage') },
    { value: 'file', label: t('filterFile') },
  ]
  const shown = records.filter((r) => matches(r, filter))

  return (
    <>
      <div className="space-y-3 px-4 pb-3">
        <SearchField value={query} onChange={onQuery} placeholder={t('searchPlaceholder')} />
        <Segmented value={filter} options={filters} onChange={onFilter} />
      </div>
      <div className="px-4 pb-6">
        {header}
        {shown.length > 0 ? (
          <Group>
            {shown.map((r, i) => (
              <div key={r.id}>
                {i > 0 && <Separator inset={68} />}
                <Row
                  r={r}
                  copied={copiedId === r.id}
                  onOpen={() => setOpen(r)}
                  onCopy={() => copy(r)}
                  onDownload={(item) => download(r, item)}
                  downloading={progress[`${r.id}/0`]}
                />
              </div>
            ))}
          </Group>
        ) : (
          !loading && (
            <div className="flex flex-col items-center px-6 pt-16 text-center">
              <History size={40} className="text-faint" />
              <div className="mt-3 text-[17px] font-semibold">
                {query ? t('searchEmpty', { q: query }) : filter !== 'all' ? t('filterEmpty') : t('recordsEmptyTitle')}
              </div>
              {!query && filter === 'all' && <p className="mt-1 text-[14px] text-dim">{t('recordsEmptyBody')}</p>}
            </div>
          )
        )}
        <div ref={sentinel} />
        {more && (
          <div className="mt-3 flex justify-center">
            <Button kind="text" className="px-3 py-2 text-[15px]" onClick={onLoadMore} disabled={loading}>
              {t('loadMore')}
            </Button>
          </div>
        )}
      </div>

      <Detail
        r={open && (records.find((x) => x.id === open.id) || open)}
        copied={!!open && copiedId === open.id}
        onClose={() => setOpen(null)}
        onCopy={(r) => copy(r)}
        onDownload={(r, i) => download(r, i)}
        progress={progress}
      />
      {previewSheet}
      <Sheet open={manual !== null} onClose={() => setManual(null)}>
        <div className="px-4 pb-4">
          <h3 className="text-center text-[17px] font-semibold">{t('copyManualTitle')}</h3>
          <p className="mt-1 text-center text-[13px] text-dim">{t('copyManualBody')}</p>
          <div className="selectable mt-3 max-h-[50vh] overflow-y-auto whitespace-pre-wrap break-words rounded-md bg-fill p-3 text-[16px] [overflow-wrap:anywhere]">
            {manual}
          </div>
          <Button kind="secondary" className="mt-4 h-11 w-full" onClick={() => setManual(null)}>
            {t('close')}
          </Button>
        </div>
      </Sheet>
    </>
  )
}


