import { useEffect, useRef, useState } from 'react'
import { ApiError, fetchBin, rpc, sendChunk, type FileInfo, type WebTransfer } from './api'
import { useConn } from './context'
import { t } from './i18n'
import { ArrowDownload, Attach, Checkmark, Copy, Document, Trash } from './icons'
import { readSlice, withRetry } from './send'
import { Button, Group, Separator, Sheet, useToast } from './ui'
import { errorText, humanSize } from './util'

export function TransfersView({ active }: { active: boolean }) {
  const conn = useConn()
  const toast = useToast()
  const [rows, setRows] = useState<WebTransfer[]>([])
  const [error, setError] = useState('')
  const [fileList, setFileList] = useState<WebTransfer | null>(null)
  const [selection, setSelection] = useState<File[]>([])
  const [job, setJob] = useState<{ names: string; done: number; total: number; committing: boolean } | null>(null)
  const [uploadError, setUploadError] = useState('')
  const [download, setDownload] = useState<{ id: string; item: number; progress: number } | null>(null)
  const [ready, setReady] = useState<{ id: string; item: number; url: string; name: string } | null>(null)
  const input = useRef<HTMLInputElement>(null)
  const busy = useRef(false)
  const cancelled = useRef(false)
  const loading = useRef(false)
  const reload = useRef(async () => {})
  reload.current = async () => {
    if (loading.current) return
    loading.current = true
    try {
      const res = await rpc<{ transfers: WebTransfer[] }>(conn.session, 'transfers')
      setRows(res.transfers)
      setError('')
    } catch (e) { setError(errorText(e)) }
    finally { loading.current = false }
  }
  useEffect(() => {
    if (!active) return
    void reload.current()
    const timer = window.setInterval(() => { if (document.visibilityState === 'visible') void reload.current() }, 3000)
    const visible = () => { if (document.visibilityState === 'visible') void reload.current() }
    document.addEventListener('visibilitychange', visible)
    return () => { clearInterval(timer); document.removeEventListener('visibilitychange', visible) }
  }, [active])
  useEffect(() => () => { if (ready) URL.revokeObjectURL(ready.url) }, [ready])

  const upload = async () => {
    if (busy.current || !selection.length) return
    busy.current = true
    cancelled.current = false
    setUploadError('')
    const files = selection.slice()
    setSelection([])
    const ids: string[] = []
    const total = files.reduce((n, f) => n + f.size, 0)
    let done = 0
    const batch = `web-${crypto.getRandomValues(new Uint32Array(4)).join('-')}`
    const check = () => { if (cancelled.current) throw new ApiError('cancelled', t('transferCancelled')) }
    try {
      setJob({ names: files.map(f => f.name).join(', '), done, total, committing: false })
      for (const file of files) {
        check()
        const st = await rpc<{ upload: string; chunk: number }>(conn.session, 'upload_start', { name: file.name, size: file.size })
        ids.push(st.upload)
        for (let n = 0; n < Math.ceil(file.size / st.chunk); n++) {
          check()
          const bytes = await readSlice(file, n * st.chunk, Math.min(file.size, (n + 1) * st.chunk))
          await withRetry(() => sendChunk(conn.session, st.upload, n, bytes), 3)
          done += bytes.length
          setJob({ names: files.map(f => f.name).join(', '), done, total, committing: false })
        }
      }
      check()
      setJob(j => j && { ...j, committing: true })
      await withRetry(() => rpc(conn.session, 'transfer_upload_done', { uploads: ids, batch }), 3)
      toast(t('uploadsDone', { n: files.length }))
      conn.succeeded()
      await reload.current()
    } catch (e) {
      await Promise.allSettled(ids.map(upload => rpc(conn.session, 'upload_cancel', { upload })))
      setUploadError(errorText(e))
    } finally { busy.current = false; setJob(null) }
  }

  const receive = async (row: WebTransfer, item: number) => {
    if (download || ready) return
    setFileList(null)
    setDownload({ id: row.id, item, progress: 0 })
    try {
      const info = await rpc<FileInfo>(conn.session, 'transfer_file_info', { id: row.id, item })
      if (info.size > conn.maxDownload) throw new ApiError('too_large_dl', t('tooLarge', { size: humanSize(conn.maxDownload) }))
      const parts: BlobPart[] = []
      for (let n = 0; n < info.chunks; n++) {
        parts.push(await withRetry(() => fetchBin(conn.session, 'transfer_chunk', { transfer: row.id, item, n }), 3) as BlobPart)
        setDownload({ id: row.id, item, progress: (n + 1) / info.chunks })
      }
      setReady({ id: row.id, item, name: info.name, url: URL.createObjectURL(new Blob(parts, { type: info.mime || 'application/octet-stream' })) })
    } catch (e) { toast(errorText(e)) }
    finally { setDownload(null) }
  }

  const remove = async (row: WebTransfer) => {
    try { await rpc(conn.session, 'transfer_delete', { id: row.id }); await reload.current() }
    catch (e) { toast(errorText(e)) }
  }

  return <div className="px-4 pb-6">
    <div className="rounded-lg border border-border bg-surface p-4">
      <div className="flex items-center gap-3"><div className="min-w-0 flex-1 text-[16px] font-semibold">{t('sendTitle', { device: conn.device })}</div><Button kind="secondary" className="min-h-10 shrink-0 px-3 py-2 text-[14px]" disabled={!!job} onClick={() => input.current?.click()}><Attach size={18} />{t('chooseFiles')}</Button></div>
      <p className="mt-2 text-[13px] leading-relaxed text-dim">{t('transferHint')}</p>
      <input ref={input} hidden multiple type="file" onChange={e => {
        const files = Array.from(e.target.files || []); e.target.value = ''
        if (files.length > 64) { toast(t('transferLimit')); return }
        if (files.some(f => f.size > conn.maxUpload)) { toast(t('fileTooLarge', { size: humanSize(conn.maxUpload) })); return }
        setSelection(files)
      }} />
      <p className="mt-3 text-[12px] leading-relaxed text-dim">{t('transferReceiveHint')}</p>
    </div>
    {error && <Button className="mt-3 w-full px-3 py-3 text-danger" onClick={() => reload.current()}>{error} · {t('retry')}</Button>}
    {job && <div className="mt-4 rounded-lg border border-border bg-surface p-4" aria-live="polite">
      <div className="line-clamp-2 break-all text-[15px] font-medium">{job.names}</div>
      <progress className="mt-3 h-1.5 w-full accent-accent" max={Math.max(job.total, 1)} value={job.done} />
      <div className="mt-2 text-[13px] text-dim">{humanSize(job.done)} / {humanSize(job.total)} · {job.committing ? t('transferFinishing') : t('uploading', { p: Math.round(job.done / Math.max(job.total, 1) * 100) })}</div>
      <Button className="mt-3 min-h-11 px-4" disabled={job.committing} onClick={() => { cancelled.current = true }}>{t('cancel')}</Button>
    </div>}
    {uploadError && <p role="alert" className="mt-3 break-words text-[13px] text-danger">{uploadError}</p>}
    <h2 className="mt-6 mb-2 px-1 text-[13px] font-semibold text-dim">{t('transferHistory')}</h2>
    {!rows.length && <p className="rounded-lg border border-border bg-surface px-4 py-8 text-center text-[14px] text-dim">{t('transferEmpty')}</p>}
    {rows.length > 0 && <Group>{rows.map((row, index) => <div key={row.id}>{index > 0 && <Separator inset={16} />}<article className="px-4 py-3">
      <div className="flex items-center gap-3">
        <span className="rounded-md bg-fill p-2.5 text-dim">{row.items.length > 1 ? <Copy size={22} /> : <Document size={22} />}</span>
        <div className="min-w-0 flex-1">
          <div className="line-clamp-2 break-all text-[15px] font-semibold">{row.items.length === 1 ? row.items[0].name : t('andMore', { name: row.items[0]?.name || '', n: row.items.length })}</div>
          <div className="mt-1 text-[12px] text-dim">{row.direction === 'upload' ? t('transferToComputer') : t('transferFromComputer')} · {humanSize(row.items.reduce((n, i) => n + i.size, 0))}</div>
          <div className="mt-0.5 flex flex-wrap items-center gap-x-2 text-[12px] text-dim">
            <time dateTime={new Date(row.at).toISOString()}>{new Date(row.at).toLocaleString()}</time>
            <span className="inline-flex items-center gap-1">{row.status === 'done' && <Checkmark size={14} className="text-online" />}{row.direction === 'upload' ? t('uploaded') : row.status === 'done' ? t('transferHandedOff') : t('transferReady')}</span>
          </div>
          {download?.id === row.id && <progress className="mt-2 h-1 w-full accent-accent" max={1} value={download.progress} />}
        </div>
        <div className="flex shrink-0 items-center gap-1">
          {row.direction === 'download' && <Button kind="secondary" aria-label={t('download')} title={t('download')} className="h-10 w-10" disabled={!!download || !!ready} onClick={() => row.items.length === 1 ? receive(row, 0) : setFileList(row)}><ArrowDownload size={20} /></Button>}
          <Button kind="plain" aria-label={t('transferDelete')} title={t('transferDelete')} className="h-10 w-10 text-dim" disabled={download?.id === row.id} onClick={() => remove(row)}><Trash size={18} /></Button>
        </div>
      </div>
    </article></div>)}</Group>}
    <p className="mt-3 px-1 text-[12px] text-dim">{t('transferDeleteHint')}</p>
    <Sheet open={!!fileList} onClose={() => setFileList(null)}>{fileList && <div className="px-4 pb-5">
      <h2 className="text-center text-[17px] font-semibold">{t('download')}</h2>
      <div className="mt-3">{fileList.items.map((item, i) => <div key={i}>
        {i > 0 && <Separator inset={0} />}
        <div className="flex items-center gap-3 py-3">
          <Document size={20} className="shrink-0 text-dim" />
          <div className="min-w-0 flex-1"><div className="break-all text-[14px]">{item.name}</div><div className="mt-1 text-[12px] text-dim">{humanSize(item.size)}</div></div>
          <Button kind="text" className="min-h-11 shrink-0 px-3" onClick={() => receive(fileList, i)}>{t('download')}</Button>
        </div>
      </div>)}</div>
      <Button className="mt-3 min-h-11 w-full" onClick={() => setFileList(null)}>{t('close')}</Button>
    </div>}</Sheet>
    <Sheet open={selection.length > 0} onClose={() => setSelection([])}><div className="px-4 pb-5">
      <h2 className="text-center text-[17px] font-semibold">{t('transferConfirm', { n: selection.length })}</h2>
      <div className="mt-4 space-y-2">{selection.map((f, i) => <div key={i} className="flex items-start gap-3 text-[14px]"><span className="min-w-0 flex-1 break-all">{f.name}</span><span className="shrink-0 text-dim">{humanSize(f.size)}</span></div>)}</div>
      <div className="mt-5 grid grid-cols-2 gap-3"><Button className="min-h-12" onClick={() => setSelection([])}>{t('cancel')}</Button><Button kind="primary" className="min-h-12" onClick={upload}>{t('send')}</Button></div>
    </div></Sheet>
    <Sheet open={!!ready} onClose={() => setReady(null)}>{ready && <div className="px-4 pb-5 text-center">
      <h2 className="break-all text-[17px] font-semibold">{ready.name}</h2><p className="mt-2 text-[13px] text-dim">{t('transferSaveHint')}</p>
      <a className="mt-4 inline-flex min-h-12 w-full items-center justify-center rounded-md bg-accent px-4 font-semibold text-white" href={ready.url} download={ready.name} onClick={() => {
        rpc(conn.session, 'transfer_downloaded', { id: ready.id, item: ready.item }).then(() => reload.current()).catch(e => toast(errorText(e)))
        conn.succeeded()
      }}>{t('download')}</a>
      <Button className="mt-3 min-h-11 w-full" onClick={() => setReady(null)}>{t('close')}</Button>
    </div>}</Sheet>
  </div>
}
