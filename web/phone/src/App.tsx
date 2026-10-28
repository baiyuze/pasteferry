import { useCallback, useEffect, useMemo, useRef, useState, type ReactNode } from 'react'
import {
  ApiError,
  claim,
  clearHash,
  clearStored,
  eventsURL,
  loadStored,
  openEvent,
  parseHash,
  rpc,
  saveStored,
  sessionFrom,
  syncClock,
  unb64,
  writeHash,
  type HelloInfo,
  type Session,
  type WebRecord,
} from './api'
import { ConnContext, type Conn } from './context'
import { S, t } from './i18n'
import { Dismiss, Edit, History, HistoryFilled, Laptop, MoreHorizontal, PhoneAdd, Send, SendFilled, ShieldLock } from './icons'
import { RecordsView, type Filter } from './records'
import { SendView } from './send'
import { Button, Sheet, cx, useToast } from './ui'
import { errorText, guessName, homeSteps, inApp, standalone } from './util'

const HOME_NEVER_KEY = 'pf.webshare.homeNever'

type Screen =
  | { kind: 'loading' }
  | { kind: 'message'; title: string; body: string; retry?: () => void }
  | { kind: 'welcome'; inviteID: string; inviteKey: Uint8Array }
  | { kind: 'main'; session: Session; hello: HelloInfo }

export default function App() {
  const [screen, setScreen] = useState<Screen>({ kind: 'loading' })

  const removed = useCallback(() => {
    clearStored()
    clearHash()
    setScreen({ kind: 'message', title: t('removedTitle'), body: t('removedBody') })
  }, [])

  const start = useCallback(
    (session: Session) => {
      setScreen({ kind: 'loading' })
      rpc<HelloInfo>(session, 'hello', {}).then(
        (hello) => {
          syncClock(hello.now)
          saveStored(session, hello.name)
          writeHash(session)
          setScreen({ kind: 'main', session, hello })
        },
        (e) => {
          if (e instanceof ApiError && (e.code === 'unknown_session' || e.code === 'bad_key')) removed()
          else
            setScreen({
              kind: 'message',
              title: t('unreachableTitle'),
              body: e instanceof ApiError && e.code === 'network' ? t('unreachableBody') : errorText(e),
              retry: () => start(session),
            })
        },
      )
    },
    [removed],
  )

  useEffect(() => {
    const h = parseHash()
    if (h.i && h.k) {
      try {
        const key = unb64(h.k)
        if (key.length === 32) {
          setScreen({ kind: 'welcome', inviteID: h.i, inviteKey: key })
          return
        }
      } catch {
        // 格式不对，往下按没有凭据处理
      }
    }
    const fromHash = h.s && h.k ? sessionFrom(h.s, h.k) : null
    const stored = loadStored()
    const session = fromHash || (stored && sessionFrom(stored.sid, stored.key))
    if (session) start(session)
    else setScreen({ kind: 'message', title: t('noCredTitle'), body: t('noCredBody') })
  }, [start])

  let body: ReactNode
  switch (screen.kind) {
    case 'loading':
      body = <div className="min-h-dvh" />
      break
    case 'message':
      body = <MessageScreen title={screen.title} body={screen.body} retry={screen.retry} />
      break
    case 'welcome':
      body = (
        <WelcomeScreen
          onClaim={async (name) => {
            try {
              const info = await claim(screen.inviteID, screen.inviteKey, name)
              const session = sessionFrom(info.sid!, info.key!)!
              syncClock(info.now)
              saveStored(session, info.name)
              writeHash(session)
              setScreen({ kind: 'main', session, hello: info })
            } catch (e) {
              if (e instanceof ApiError && e.code === 'invite_used') {
                // 这台手机以前登记过：用它自己的会话，不必再扫
                const stored = loadStored()
                const session = stored && sessionFrom(stored.sid, stored.key)
                if (session) start(session)
                else setScreen({ kind: 'message', title: t('inviteUsedTitle'), body: t('inviteUsedBody') })
              } else if (e instanceof ApiError && e.code === 'network') {
                setScreen({ kind: 'message', title: t('unreachableTitle'), body: t('unreachableBody'), retry: () => location.reload() })
              } else {
                throw e
              }
            }
          }}
        />
      )
      break
    case 'main':
      body = <Main session={screen.session} hello={screen.hello} onRemoved={removed} />
  }

  return (
    <>
      {inApp && (
        <div className="bg-warning/12 px-4 pt-[calc(10px+env(safe-area-inset-top))] pb-2.5 text-[13px] leading-snug text-warning">{t('inAppBanner')}</div>
      )}
      {body}
    </>
  )
}

// ── 欢迎、出错 ──

function AppIcon() {
  return <img src="./icon-192.png" alt="" className="h-[72px] w-[72px] rounded-[18px] shadow-[0_2px_10px_rgba(0,0,0,0.12)]" />
}

function MessageScreen({ title, body, retry }: { title: string; body: string; retry?: () => void }) {
  return (
    <div className="mx-auto flex min-h-dvh max-w-sm flex-col items-center justify-center px-8 pb-16 text-center pt-safe">
      <AppIcon />
      <h1 className="mt-6 text-[22px] font-semibold tracking-tight">{title}</h1>
      {body && <p className="mt-2 text-[15px] leading-relaxed text-dim">{body}</p>}
      {retry && (
        <Button kind="primary" className="mt-8 h-12 w-full text-[16px]" onClick={retry}>
          {t('retry')}
        </Button>
      )}
    </div>
  )
}

function WelcomeScreen({ onClaim }: { onClaim: (name: string) => Promise<void> }) {
  const toast = useToast()
  const [name, setName] = useState(guessName)
  const [busy, setBusy] = useState(false)
  const go = async () => {
    setBusy(true)
    try {
      await onClaim(name.trim() || guessName())
    } catch (e) {
      toast(errorText(e))
      setBusy(false)
    }
  }
  return (
    <div className="mx-auto flex min-h-dvh max-w-sm flex-col px-6 pt-safe">
      <div className="flex flex-1 flex-col items-center justify-center pb-10 text-center">
        <AppIcon />
        <h1 className="mt-6 text-[24px] font-semibold tracking-tight">{t('welcomeTitle')}</h1>
        <p className="mt-2 text-[15px] leading-relaxed text-dim">{t('welcomeBody')}</p>
        <label className="mt-8 block w-full text-left">
          <span className="mb-1.5 block px-1 text-[13px] text-dim">{t('nameLabel')}</span>
          <input
            value={name}
            maxLength={40}
            onChange={(e) => setName(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && go()}
            className="h-12 w-full rounded-md border border-border bg-surface px-4 text-[16px] focus:border-accent focus:outline-none"
          />
        </label>
        <Button kind="primary" className="mt-4 h-12 w-full text-[16px]" disabled={busy} onClick={go}>
          {t('start')}
        </Button>
      </div>
      <p className="flex items-start gap-2 pb-[calc(24px+env(safe-area-inset-bottom))] text-left text-[12px] leading-normal text-dim">
        <ShieldLock size={16} className="mt-px shrink-0" />
        {t('securityShort')}
      </p>
    </div>
  )
}

// ── 主界面 ──

type Tab = 'records' | 'send'

function Main({ session, hello: initial, onRemoved }: { session: Session; hello: HelloInfo; onRemoved: () => void }) {
  const toast = useToast()
  const [hello, setHello] = useState(initial)
  const [tab, setTab] = useState<Tab>('records')
  const [connected, setConnected] = useState<'on' | 'connecting' | 'off'>('connecting')
  const [menu, setMenu] = useState(false)
  const [dialog, setDialog] = useState<'home' | 'security' | 'rename' | null>(null)
  const [showHome, setShowHome] = useState(false)
  const homeOffered = useRef(false)

  // 记录
  const [records, setRecords] = useState<WebRecord[]>([])
  const [more, setMore] = useState(false)
  const [loading, setLoading] = useState(true)
  const [filter, setFilter] = useState<Filter>('all')
  const [query, setQuery] = useState('')
  const view = useRef({ filter, query })
  view.current = { filter, query }

  const load = useCallback(
    async (reset: boolean) => {
      const { filter, query } = view.current
      setLoading(true)
      try {
        const before = reset ? 0 : records.length ? records[records.length - 1].at : 0
        const res = await rpc<{ records: WebRecord[]; more: boolean }>(session, 'records', {
          limit: 30,
          before,
          filter,
          q: query,
        })
        if (view.current.filter !== filter || view.current.query !== query) return // 期间换了筛选
        setRecords((old) => (reset ? res.records : [...old, ...res.records.filter((r) => !old.some((o) => o.id === r.id))]))
        setMore(res.more)
      } catch (e) {
        if (e instanceof ApiError && (e.code === 'unknown_session' || e.code === 'bad_key')) onRemoved()
        else toast(errorText(e))
      } finally {
        setLoading(false)
      }
    },
    [session, records, onRemoved, toast],
  )

  const reloadRef = useRef(load)
  reloadRef.current = load

  useEffect(() => {
    const timer = setTimeout(() => reloadRef.current(true), query ? 250 : 0)
    return () => clearTimeout(timer)
  }, [filter, query])

  const upsert = useCallback((r: WebRecord) => {
    if (view.current.query) return // 搜索结果不随推送变
    setRecords((old) => {
      const i = old.findIndex((o) => o.id === r.id)
      if (i >= 0) {
        const next = old.slice()
        next[i] = r
        return next
      }
      return [r, ...old].sort((a, b) => b.at - a.at)
    })
  }, [])

  // 事件流：断了就换新凭据重连（EventSource 自己重连会带旧凭据，被当成重放拒绝）
  useEffect(() => {
    let es: EventSource | null = null
    let retry = 0
    let timer = 0
    let stopped = false
    const connect = () => {
      clearTimeout(timer)
      es?.close()
      const cur = new EventSource(eventsURL(session))
      es = cur
      cur.onopen = () => {
        retry = 0
        setConnected('on')
      }
      cur.onmessage = (m) => {
        const ev = openEvent(session, m.data)
        if (!ev) return
        if (ev.t === 'rec') upsert(ev.r)
        else setRecords((old) => old.filter((r) => r.id !== ev.id))
      }
      cur.onerror = () => {
        cur.close()
        if (es !== cur || stopped) return
        es = null
        setConnected(retry > 0 ? 'off' : 'connecting')
        rpc<HelloInfo>(session, 'hello', {}).then(
          (h) => {
            syncClock(h.now)
            setHello(h)
            schedule()
          },
          (e) => {
            if (e instanceof ApiError && (e.code === 'unknown_session' || e.code === 'bad_key')) onRemoved()
            else schedule()
          },
        )
      }
    }
    const schedule = () => {
      const delay = Math.min(30_000, 1000 * 2 ** retry++)
      timer = window.setTimeout(() => {
        connect()
        reloadRef.current(true)
      }, delay)
    }
    const onVisible = () => {
      if (document.visibilityState !== 'visible') return
      if (!es || es.readyState === EventSource.CLOSED) {
        retry = 0
        connect()
      }
      reloadRef.current(true)
    }
    connect()
    document.addEventListener('visibilitychange', onVisible)
    return () => {
      stopped = true
      clearTimeout(timer)
      es?.close()
      document.removeEventListener('visibilitychange', onVisible)
    }
  }, [session, upsert, onRemoved])

  const conn = useMemo<Conn>(
    () => ({
      session,
      device: hello.device,
      name: hello.name,
      chunk: hello.chunk,
      maxDownload: hello.maxDownload,
      maxUpload: hello.maxUpload,
      maxText: hello.maxText,
      succeeded: () => {
        if (homeOffered.current || standalone()) return
        try {
          if (localStorage.getItem(HOME_NEVER_KEY)) return
        } catch {
          // ignore
        }
        homeOffered.current = true
        setShowHome(true)
      },
    }),
    [session, hello],
  )

  const statusText = connected === 'on' ? t('connected') : connected === 'connecting' ? t('connecting') : t('disconnected')

  const homeTip = showHome && (
    <div className="mb-4 rounded-lg border border-border bg-surface p-4">
      <div className="flex items-start gap-3">
        <PhoneAdd className="mt-0.5 shrink-0 text-accent" />
        <div className="min-w-0 flex-1">
          <div className="text-[15px] font-semibold">{t('homeTitle')}</div>
          <div className="mt-0.5 text-[13px] text-dim">{t('homeBody')}</div>
        </div>
        <button type="button" aria-label={t('close')} className="-mt-1 -mr-1 p-1 text-faint" onClick={() => setShowHome(false)}>
          <Dismiss size={20} />
        </button>
      </div>
      <Steps steps={homeSteps()} />
      <div className="mt-3 flex items-center justify-between">
        <Button
          kind="plain"
          className="px-0 py-1 text-[14px] text-dim"
          onClick={() => {
            setShowHome(false)
            try {
              localStorage.setItem(HOME_NEVER_KEY, '1')
            } catch {
              // ignore
            }
          }}
        >
          {t('neverShow')}
        </Button>
        <Button kind="text" className="px-0 py-1 text-[15px]" onClick={() => setShowHome(false)}>
          {t('gotIt')}
        </Button>
      </div>
    </div>
  )

  return (
    <ConnContext.Provider value={conn}>
      <div className="mx-auto min-h-dvh max-w-xl pb-[calc(64px+env(safe-area-inset-bottom))]">
        <header className="px-4 pt-[calc(12px+env(safe-area-inset-top))] pb-3">
          <div className="flex h-9 items-center gap-2">
            <Laptop size={18} className="shrink-0 text-dim" />
            <span className="min-w-0 truncate text-[14px] font-medium">{hello.device}</span>
            <span
              className={cx(
                'flex shrink-0 items-center gap-1.5 text-[13px]',
                connected === 'on' ? 'text-online' : connected === 'off' ? 'text-danger' : 'text-dim',
              )}
            >
              <span className="h-1.5 w-1.5 rounded-full bg-current" />
              {statusText}
            </span>
            <button
              type="button"
              aria-label="menu"
              onClick={() => setMenu(true)}
              className="ml-auto flex h-9 w-9 items-center justify-center rounded-full bg-fill text-text active:opacity-70"
            >
              <MoreHorizontal size={20} />
            </button>
          </div>
          <h1 className="mt-2 text-[30px] font-bold tracking-tight">{tab === 'records' ? t('tabRecords') : t('sendTitle', { device: hello.device })}</h1>
        </header>

        {tab === 'records' ? (
          <RecordsView
            records={records}
            more={more && !query}
            loading={loading}
            filter={filter}
            query={query}
            onFilter={setFilter}
            onQuery={setQuery}
            onLoadMore={() => load(false)}
            header={homeTip}
          />
        ) : (
          <SendView
            onSent={(r) => {
              upsert(r)
            }}
          />
        )}
      </div>

      <TabBar tab={tab} onChange={setTab} />

      <Sheet open={menu} onClose={() => setMenu(false)}>
        <div className="px-4 pb-4">
          <div className="mb-3 text-center">
            <div className="text-[15px] font-semibold">{hello.name}</div>
            <div className="text-[13px] text-dim">
              {statusText} · {hello.device}
            </div>
          </div>
          <div className="overflow-hidden rounded-lg bg-fill">
            {(
              [
                ['home', PhoneAdd, t('menuHome')],
                ['rename', Edit, t('menuRename')],
                ['security', ShieldLock, t('menuSecurity')],
              ] as const
            ).map(([key, Icon, label], i) => (
              <button
                key={key}
                type="button"
                className={cx('flex w-full items-center gap-3 px-4 py-3.5 text-left text-[16px] active:bg-border', i > 0 && 'border-t border-border')}
                onClick={() => {
                  setMenu(false)
                  setDialog(key)
                }}
              >
                <Icon size={22} className="text-dim" />
                {label}
              </button>
            ))}
          </div>
          <Button kind="secondary" className="mt-3 h-12 w-full text-[16px]" onClick={() => setMenu(false)}>
            {t('cancel')}
          </Button>
        </div>
      </Sheet>

      <Sheet open={dialog === 'home'} onClose={() => setDialog(null)}>
        <div className="px-5 pb-5">
          <h3 className="text-center text-[17px] font-semibold">{t('homeTitle')}</h3>
          <p className="mt-1 text-center text-[14px] text-dim">{t('homeBody')}</p>
          <Steps steps={homeSteps()} />
          <p className="mt-3 text-[13px] text-dim">{t('homeNote')}</p>
          <Button kind="secondary" className="mt-4 h-11 w-full" onClick={() => setDialog(null)}>
            {t('close')}
          </Button>
        </div>
      </Sheet>

      <Sheet open={dialog === 'security'} onClose={() => setDialog(null)}>
        <div className="px-5 pb-5">
          <div className="flex justify-center text-accent">
            <ShieldLock size={32} />
          </div>
          <h3 className="mt-2 text-center text-[17px] font-semibold">{t('securityTitle')}</h3>
          <ul className="mt-3 space-y-2.5">
            {S.securityBody.map((s) => (
              <li key={s} className="flex gap-2.5 text-[14px] leading-relaxed text-text">
                <span className="mt-2 h-1 w-1 shrink-0 rounded-full bg-dim" />
                {s}
              </li>
            ))}
          </ul>
          <Button kind="secondary" className="mt-5 h-11 w-full" onClick={() => setDialog(null)}>
            {t('close')}
          </Button>
        </div>
      </Sheet>

      <RenameSheet
        open={dialog === 'rename'}
        name={hello.name}
        onClose={() => setDialog(null)}
        onSave={async (name) => {
          const h = await rpc<HelloInfo>(session, 'hello', { name })
          setHello(h)
          saveStored(session, h.name)
          toast(t('renamed'))
        }}
      />
    </ConnContext.Provider>
  )
}

function Steps({ steps }: { steps: string[] }) {
  return (
    <ol className="mt-3 space-y-2">
      {steps.map((s, i) => (
        <li key={i} className="flex items-start gap-2.5 text-[14px] leading-snug">
          <span className="flex h-5 w-5 shrink-0 items-center justify-center rounded-full bg-fill text-[12px] font-semibold text-dim tabular-nums">
            {i + 1}
          </span>
          <span className="pt-px">{s}</span>
        </li>
      ))}
    </ol>
  )
}

function RenameSheet({ open, name, onClose, onSave }: { open: boolean; name: string; onClose: () => void; onSave: (n: string) => Promise<void> }) {
  const toast = useToast()
  const [value, setValue] = useState(name)
  const [busy, setBusy] = useState(false)
  useEffect(() => {
    if (open) setValue(name)
  }, [open, name])
  return (
    <Sheet open={open} onClose={onClose}>
      <div className="px-5 pb-5">
        <h3 className="text-center text-[17px] font-semibold">{t('menuRename')}</h3>
        <input
          value={value}
          maxLength={40}
          onChange={(e) => setValue(e.target.value)}
          className="mt-4 h-12 w-full rounded-md border border-border bg-bg px-4 text-[16px] focus:border-accent focus:outline-none"
        />
        <div className="mt-4 grid grid-cols-2 gap-3">
          <Button kind="secondary" className="h-11" onClick={onClose}>
            {t('cancel')}
          </Button>
          <Button
            kind="primary"
            className="h-11"
            disabled={!value.trim() || busy}
            onClick={async () => {
              setBusy(true)
              try {
                await onSave(value.trim())
                onClose()
              } catch (e) {
                toast(errorText(e))
              } finally {
                setBusy(false)
              }
            }}
          >
            {t('save')}
          </Button>
        </div>
      </div>
    </Sheet>
  )
}

function TabBar({ tab, onChange }: { tab: Tab; onChange: (t: Tab) => void }) {
  const items = [
    { key: 'records' as const, label: t('tabRecords'), Icon: History, Active: HistoryFilled },
    { key: 'send' as const, label: t('tabSend'), Icon: Send, Active: SendFilled },
  ]
  return (
    <nav className="hairline-t fixed inset-x-0 bottom-0 z-30 bg-bar pb-safe backdrop-blur-xl">
      <div className="mx-auto flex max-w-xl">
        {items.map(({ key, label, Icon, Active }) => {
          const on = tab === key
          return (
            <button
              key={key}
              type="button"
              onClick={() => onChange(key)}
              className={cx('flex h-[56px] flex-1 flex-col items-center justify-center gap-0.5', on ? 'text-accent' : 'text-dim')}
            >
              {on ? <Active size={24} /> : <Icon size={24} />}
              <span className="text-[11px] font-medium">{label}</span>
            </button>
          )
        })}
      </div>
    </nav>
  )
}
