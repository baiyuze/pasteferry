// 与后台服务 client-core/internal/webshare 的协议。
//
// 页面走 http，crypto.subtle 用不了，内容用 tweetnacl 的 secretbox（XSalsa20-Poly1305）加密，
// 格式与 webshare/crypto.go 相同：24 字节随机 nonce 后接密文。密钥只在地址栏 # 后面，浏览器不会发给服务器。
// 每次请求带按电脑时间校正的时间戳与随机 rid，服务器据此拒绝重放。
import nacl from 'tweetnacl'

export class ApiError extends Error {
  code: string
  constructor(code: string, message?: string) {
    super(message || code)
    this.code = code
  }
}

export interface Session {
  sid: string
  key: Uint8Array
  keyText: string
}

export interface WebItem {
  name: string
  size: number
  dir?: boolean
}

export interface WebRecord {
  id: string
  kind: 'text' | 'image' | 'file'
  status: 'ready' | 'remote' | 'fetching' | 'failed' | 'expired'
  from: string
  mine: boolean
  text?: string
  long?: boolean
  preview: string
  items?: WebItem[]
  size: number
  at: number
  images?: number
  link?: boolean
}

export interface HelloInfo {
  sid?: string
  key?: string
  device: string
  name: string
  now: number
  chunk: number
  maxDownload: number
  maxUpload: number
  maxText: number
}

export interface FileInfo {
  name: string
  size: number
  chunks: number
  zip: boolean
  mime: string
}

export type WebEvent = { t: 'rec'; r: WebRecord } | { t: 'del'; id: string }

const enc = new TextEncoder()
const dec = new TextDecoder()

export function b64(u8: Uint8Array): string {
  let s = ''
  for (let i = 0; i < u8.length; i++) s += String.fromCharCode(u8[i])
  return btoa(s).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '')
}

export function unb64(s: string): Uint8Array {
  let t = s.replace(/-/g, '+').replace(/_/g, '/')
  while (t.length % 4) t += '='
  const bin = atob(t)
  const u = new Uint8Array(bin.length)
  for (let i = 0; i < bin.length; i++) u[i] = bin.charCodeAt(i)
  return u
}

function seal(key: Uint8Array, plain: Uint8Array): Uint8Array {
  const nonce = nacl.randomBytes(24)
  const box = nacl.secretbox(plain, nonce, key)
  const out = new Uint8Array(24 + box.length)
  out.set(nonce, 0)
  out.set(box, 24)
  return out
}

function open(key: Uint8Array, msg: Uint8Array): Uint8Array | null {
  if (msg.length < 24 + 16) return null
  return nacl.secretbox.open(msg.subarray(24), msg.subarray(0, 24), key)
}

const rid = () => b64(nacl.randomBytes(12))

// 本机时钟与电脑的差：hello 的回复里带着电脑的时间
let offset = 0
export function syncClock(serverNow: number) {
  offset = serverNow - Date.now()
}

function envelope(m: string, a: unknown): Uint8Array {
  return enc.encode(JSON.stringify({ ts: Date.now() + offset, rid: rid(), m, a: a ?? {} }))
}

async function post(path: string, body: Uint8Array): Promise<Uint8Array> {
  let r: Response
  try {
    r = await fetch(path, {
      method: 'POST',
      body: body as BodyInit,
      cache: 'no-store',
      credentials: 'omit',
      headers: { 'Content-Type': 'application/octet-stream' },
    })
  } catch {
    throw new ApiError('network')
  }
  if ((r.headers.get('Content-Type') || '').startsWith('application/json')) {
    const j = await r.json().catch(() => ({}))
    throw new ApiError(j.err || `http_${r.status}`)
  }
  return new Uint8Array(await r.arrayBuffer())
}

function decodeReply<T>(key: Uint8Array, data: Uint8Array): T {
  const plain = open(key, data)
  if (!plain) throw new ApiError('bad_reply')
  const rep = JSON.parse(dec.decode(plain))
  if (!rep.ok) throw new ApiError(rep.err, rep.msg)
  return rep.r as T
}

export async function rpc<T>(s: Session, m: string, a?: unknown): Promise<T> {
  const data = await post(`/api/rpc?s=${encodeURIComponent(s.sid)}`, seal(s.key, envelope(m, a)))
  return decodeReply<T>(s.key, data)
}

/** 扫码后的第一次连接：用二维码里的邀请密钥，换成这台手机专属的会话。 */
export async function claim(inviteID: string, inviteKey: Uint8Array, name: string): Promise<HelloInfo> {
  const data = await post(`/api/rpc?i=${encodeURIComponent(inviteID)}`, seal(inviteKey, envelope('hello', { name })))
  return decodeReply<HelloInfo>(inviteKey, data)
}

/** 取一块下载的数据或一张缩略图。回复解密后第一个字节是 0 时后面是数据，是 1 时后面是 JSON 错误。 */
export async function fetchBin(s: Session, m: 'chunk' | 'thumb', a: unknown): Promise<Uint8Array> {
  const data = await post(`/api/fetch?s=${encodeURIComponent(s.sid)}`, seal(s.key, envelope(m, a)))
  const plain = open(s.key, data)
  if (!plain || plain.length === 0) throw new ApiError('bad_reply')
  if (plain[0] === 1) {
    const rep = JSON.parse(dec.decode(plain.subarray(1)))
    throw new ApiError(rep.err, rep.msg)
  }
  return plain.subarray(1)
}

/** 上传一块：4 字节大端长度、说明（JSON）、数据，一起加密。块号因此也受认证保护。 */
export async function sendChunk(s: Session, upload: string, n: number, data: Uint8Array): Promise<void> {
  const header = enc.encode(JSON.stringify({ ts: Date.now() + offset, rid: rid(), u: upload, n }))
  const buf = new Uint8Array(4 + header.length + data.length)
  new DataView(buf.buffer).setUint32(0, header.length)
  buf.set(header, 4)
  buf.set(data, 4 + header.length)
  const r = await post(`/api/chunk?s=${encodeURIComponent(s.sid)}`, seal(s.key, buf))
  decodeReply<unknown>(s.key, r)
}

/** 事件流的网址。EventSource 不能带请求体，凭据是一段加密的 {ts, rid}，每次连接都要换新的。 */
export function eventsURL(s: Session): string {
  const token = b64(seal(s.key, envelope('events', null)))
  return `/api/events?s=${encodeURIComponent(s.sid)}&t=${encodeURIComponent(token)}`
}

export function openEvent(s: Session, data: string): WebEvent | null {
  try {
    const plain = open(s.key, unb64(data))
    return plain ? (JSON.parse(dec.decode(plain)) as WebEvent) : null
  } catch {
    return null
  }
}

// ── 凭据 ──

const STORE_KEY = 'pf.webshare.v1'

export function loadStored(): { sid: string; key: string; name?: string } | null {
  try {
    const v = JSON.parse(localStorage.getItem(STORE_KEY) || 'null')
    if (v && v.sid && v.key) return v
  } catch {
    // 隐私模式下可能读不了
  }
  return null
}

export function saveStored(s: Session, name: string) {
  try {
    localStorage.setItem(STORE_KEY, JSON.stringify({ sid: s.sid, key: s.keyText, name }))
  } catch {
    // 存不了也能用，只是下次要靠地址栏里的凭据
  }
}

export function clearStored() {
  try {
    localStorage.removeItem(STORE_KEY)
  } catch {
    // ignore
  }
}

export function sessionFrom(sid: string, keyText: string): Session | null {
  try {
    const key = unb64(keyText)
    return key.length === 32 ? { sid, key, keyText } : null
  } catch {
    return null
  }
}

/**
 * 地址栏 # 后面写成这台手机的会话：添加到主屏幕时一起存下来。
 * iOS 从主屏幕打开时用单独的存储，读不到 Safari 里存的东西，只能靠网址。
 */
export function writeHash(s: Session) {
  const h = `#s=${encodeURIComponent(s.sid)}&k=${encodeURIComponent(s.keyText)}`
  if (location.hash !== h) history.replaceState(null, '', location.pathname + location.search + h)
}

export function clearHash() {
  history.replaceState(null, '', location.pathname + location.search)
}

export function parseHash(): { i: string | null; s: string | null; k: string | null } {
  const p = new URLSearchParams(location.hash.replace(/^#/, ''))
  return { i: p.get('i'), s: p.get('s'), k: p.get('k') }
}
