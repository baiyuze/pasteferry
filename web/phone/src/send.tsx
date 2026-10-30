// 发送：输入或粘贴文字发到电脑，或者选照片和文件分块加密上传。
import { useRef, useState } from 'react'
import { ApiError, rpc, sendChunk, type WebRecord } from './api'
import { useConn } from './context'
import { t } from './i18n'
import { Attach, Checkmark, Document, SendFilled } from './icons'
import { Button, Group, Separator, cx, useToast } from './ui'
import { errorText, humanSize } from './util'

interface Job {
  key: string
  name: string
  size: number
  progress: number
  state: 'waiting' | 'uploading' | 'done' | 'failed'
  error?: string
}

export function readSlice(file: File, start: number, end: number): Promise<Uint8Array> {
  const blob = file.slice(start, end)
  if (blob.arrayBuffer) return blob.arrayBuffer().then((b) => new Uint8Array(b))
  return new Promise((resolve, reject) => {
    const r = new FileReader()
    r.onload = () => resolve(new Uint8Array(r.result as ArrayBuffer))
    r.onerror = () => reject(r.error)
    r.readAsArrayBuffer(blob)
  })
}

export async function withRetry<T>(fn: () => Promise<T>, times: number): Promise<T> {
  try {
    return await fn()
  } catch (e) {
    const retriable = e instanceof ApiError && ['network', 'stale', 'bad_reply'].includes(e.code)
    if (times <= 1 || !retriable) throw e
    await new Promise((r) => setTimeout(r, 800))
    return withRetry(fn, times - 1)
  }
}

export function SendView({ onSent }: { onSent: (r: WebRecord) => void }) {
  const conn = useConn()
  const toast = useToast()
  const [text, setText] = useState('')
  const [sending, setSending] = useState(false)
  const [jobs, setJobs] = useState<Job[]>([])
  const fileInput = useRef<HTMLInputElement>(null)

  const update = (key: string, patch: Partial<Job>) => setJobs((js) => js.map((j) => (j.key === key ? { ...j, ...patch } : j)))

  const sendText = async () => {
    if (!text.trim() || sending) return
    setSending(true)
    try {
      const r = await rpc<WebRecord>(conn.session, 'text', { text })
      setText('')
      onSent(r)
      toast(t('sent'))
      conn.succeeded()
    } catch (e) {
      toast(t('sendFailed', { msg: errorText(e) }))
    } finally {
      setSending(false)
    }
  }

  const upload = async (files: File[]) => {
    if (!files.length) return
    const batch = files.map((f, i) => ({ file: f, key: `${Date.now()}-${i}-${f.name}` }))
    setJobs((js) => [...js, ...batch.map((b) => ({ key: b.key, name: b.file.name, size: b.file.size, progress: 0, state: 'waiting' as const }))])
    const done: { key: string; id: string }[] = []
    for (const { file, key } of batch) {
      if (file.size > conn.maxUpload) {
        update(key, { state: 'failed', error: t('fileTooLarge', { size: humanSize(conn.maxUpload) }) })
        continue
      }
      let id = ''
      try {
        update(key, { state: 'uploading' })
        const st = await rpc<{ upload: string; chunk: number }>(conn.session, 'upload_start', { name: file.name, size: file.size })
        id = st.upload
        const chunk = st.chunk || conn.chunk
        const total = Math.ceil(file.size / chunk)
        for (let n = 0; n < total; n++) {
          const data = await readSlice(file, n * chunk, Math.min(file.size, (n + 1) * chunk))
          await withRetry(() => sendChunk(conn.session, id, n, data), 3)
          update(key, { progress: (n + 1) / total })
        }
        update(key, { progress: 1 })
        done.push({ key, id })
      } catch (e) {
        update(key, { state: 'failed', error: errorText(e) })
        if (id) rpc(conn.session, 'upload_cancel', { upload: id }).catch(() => {})
      }
    }
    if (!done.length) return
    try {
      const r = await rpc<WebRecord>(conn.session, 'upload_done', { uploads: done.map((d) => d.id) })
      done.forEach((d) => update(d.key, { state: 'done' }))
      onSent(r)
      toast(t('uploadsDone', { n: done.length }))
      conn.succeeded()
      setTimeout(() => setJobs((js) => js.filter((j) => !done.some((d) => d.key === j.key))), 4000)
    } catch (e) {
      done.forEach((d) => update(d.key, { state: 'failed', error: errorText(e) }))
    }
  }

  return (
    <div className="px-4 pb-6">
      <div className="rounded-lg border border-border bg-surface focus-within:border-accent">
        <textarea
          value={text}
          onChange={(e) => setText(e.target.value)}
          placeholder={t('textPlaceholder')}
          rows={6}
          className="block w-full resize-none rounded-lg bg-transparent px-4 py-3 text-[16px] leading-relaxed text-text placeholder:text-faint focus:outline-none"
        />
      </div>
      <div className="mt-3 flex gap-3">
        <Button kind="secondary" className="h-12 flex-1 text-[15px]" onClick={() => fileInput.current?.click()}>
          <Attach size={20} />
          {t('photosFiles')}
        </Button>
        <Button kind="primary" className="h-12 flex-1 text-[15px]" disabled={!text.trim() || sending} onClick={sendText}>
          <SendFilled size={20} />
          {t('send')}
        </Button>
        <input
          ref={fileInput}
          type="file"
          multiple
          hidden
          onChange={(e) => {
            const files = Array.from(e.target.files || [])
            e.target.value = ''
            upload(files)
          }}
        />
      </div>
      <p className="mt-3 px-1 text-[13px] leading-normal text-dim">{t('sendHint')}</p>

      {jobs.length > 0 && (
        <>
          <h2 className="mt-6 mb-2 px-1 text-[13px] font-semibold text-dim">{t('uploads')}</h2>
          <Group>
            {jobs.map((j, i) => (
              <div key={j.key}>
                {i > 0 && <Separator inset={52} />}
                <div className="flex items-center gap-3 px-4 py-3">
                  <Document className="shrink-0 text-dim" />
                  <div className="min-w-0 flex-1">
                    <div className="truncate text-[15px]">{j.name}</div>
                    {j.state === 'uploading' || j.state === 'waiting' ? (
                      <div className="mt-1.5 h-1 overflow-hidden rounded-full bg-fill">
                        <div className="h-full rounded-full bg-accent transition-[width] duration-200" style={{ width: `${Math.round(j.progress * 100)}%` }} />
                      </div>
                    ) : (
                      <div className={cx('mt-0.5 truncate text-[13px]', j.state === 'failed' ? 'text-danger' : 'text-dim')}>
                        {j.state === 'failed' ? `${t('uploadFailed')} · ${j.error}` : `${humanSize(j.size)} · ${t('uploaded')}`}
                      </div>
                    )}
                  </div>
                  <div className="shrink-0 text-[13px] tabular-nums text-dim">
                    {j.state === 'done' ? (
                      <Checkmark size={20} className="text-online" />
                    ) : j.state === 'uploading' ? (
                      t('uploading', { p: Math.round(j.progress * 100) })
                    ) : j.state === 'waiting' ? (
                      t('uploadWaiting')
                    ) : null}
                  </div>
                </div>
              </div>
            ))}
          </Group>
        </>
      )}
    </div>
  )
}
