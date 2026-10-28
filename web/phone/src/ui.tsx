// 通用组件：按钮、底部弹层、分段控件、搜索框、提示条。样式与 App 一致：中性灰底、白色分组容器、
// 强调色只用在主按钮、选中态和文字按钮上。
import { createContext, useCallback, useContext, useEffect, useRef, useState, type ReactNode } from 'react'
import { DismissCircleFilled, Search } from './icons'

export function cx(...parts: (string | false | null | undefined)[]) {
  return parts.filter(Boolean).join(' ')
}

type ButtonKind = 'primary' | 'secondary' | 'text' | 'plain'

const buttonStyles: Record<ButtonKind, string> = {
  primary: 'bg-accent text-white font-semibold active:opacity-80 disabled:opacity-40',
  secondary: 'bg-fill text-text font-medium active:opacity-70 disabled:opacity-40',
  text: 'text-accent font-medium active:opacity-60 disabled:text-faint',
  plain: 'text-text active:opacity-60 disabled:opacity-40',
}

export function Button({
  kind = 'secondary',
  className,
  ...rest
}: React.ButtonHTMLAttributes<HTMLButtonElement> & { kind?: ButtonKind }) {
  return (
    <button
      type="button"
      {...rest}
      className={cx('inline-flex items-center justify-center gap-1.5 rounded-md transition-opacity select-none', buttonStyles[kind], className)}
    />
  )
}

/** 底部弹层：点遮罩或按返回关闭。 */
export function Sheet({ open, onClose, children }: { open: boolean; onClose: () => void; children: ReactNode }) {
  const [shown, setShown] = useState(open)
  const [visible, setVisible] = useState(false)
  useEffect(() => {
    if (open) {
      setShown(true)
      const id = requestAnimationFrame(() => setVisible(true))
      return () => cancelAnimationFrame(id)
    }
    setVisible(false)
    const timer = setTimeout(() => setShown(false), 220)
    return () => clearTimeout(timer)
  }, [open])
  useEffect(() => {
    if (!open) return
    const onKey = (e: KeyboardEvent) => e.key === 'Escape' && onClose()
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [open, onClose])
  if (!shown) return null
  return (
    <div className="fixed inset-0 z-40 flex items-end justify-center">
      <div
        className={cx('absolute inset-0 bg-black/40 transition-opacity duration-200', visible ? 'opacity-100' : 'opacity-0')}
        onClick={onClose}
      />
      <div
        role="dialog"
        className={cx(
          'relative w-full max-w-xl max-h-[88vh] overflow-y-auto rounded-t-[14px] bg-surface pb-safe shadow-2xl',
          'transition-transform duration-200 ease-out',
          visible ? 'translate-y-0' : 'translate-y-full',
        )}
      >
        <div className="sticky top-0 z-10 flex justify-center bg-surface pt-2 pb-1">
          <div className="h-1 w-9 rounded-full bg-border" />
        </div>
        {children}
      </div>
    </div>
  )
}

export function Segmented<T extends string>({
  value,
  options,
  onChange,
}: {
  value: T
  options: { value: T; label: string }[]
  onChange: (v: T) => void
}) {
  return (
    <div className="no-scrollbar -mx-4 overflow-x-auto px-4">
      <div className="inline-flex min-w-full rounded-md bg-fill p-0.5">
        {options.map((o) => (
          <button
            key={o.value}
            type="button"
            onClick={() => onChange(o.value)}
            className={cx(
              'flex-1 whitespace-nowrap rounded-[7px] px-3 py-1.5 text-[13px] transition-colors',
              value === o.value ? 'bg-surface font-semibold text-text shadow-[0_1px_2px_rgba(0,0,0,0.08)]' : 'text-dim',
            )}
          >
            {o.label}
          </button>
        ))}
      </div>
    </div>
  )
}

export function SearchField({ value, onChange, placeholder }: { value: string; onChange: (v: string) => void; placeholder: string }) {
  return (
    <label className="flex h-10 items-center gap-2 rounded-md bg-fill px-3 text-dim">
      <Search size={18} className="shrink-0" />
      <input
        type="search"
        enterKeyHint="search"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        className="min-w-0 flex-1 bg-transparent text-[16px] text-text placeholder:text-faint focus:outline-none [&::-webkit-search-cancel-button]:hidden"
      />
      {value && (
        <button type="button" aria-label="clear" onClick={() => onChange('')} className="text-faint">
          <DismissCircleFilled size={18} />
        </button>
      )}
    </label>
  )
}

/** 分组容器：白底、细边框、14px 圆角，与 App 里的列表分组一致。 */
export function Group({ children, className }: { children: ReactNode; className?: string }) {
  return <div className={cx('overflow-hidden rounded-lg border border-border bg-surface', className)}>{children}</div>
}

/** 分组里的行与行之间的分隔线，从文字起始处开始，与 App 一致。 */
export function Separator({ inset = 52 }: { inset?: number }) {
  return <div className="h-px bg-separator" style={{ marginLeft: inset }} />
}

// ── 提示条 ──

const ToastContext = createContext<(msg: string) => void>(() => {})

export function ToastProvider({ children }: { children: ReactNode }) {
  const [msg, setMsg] = useState('')
  const [visible, setVisible] = useState(false)
  const timer = useRef(0)
  const show = useCallback((m: string) => {
    setMsg(m)
    setVisible(true)
    clearTimeout(timer.current)
    timer.current = window.setTimeout(() => setVisible(false), 2400)
  }, [])
  return (
    <ToastContext.Provider value={show}>
      {children}
      <div
        aria-live="polite"
        className={cx(
          'pointer-events-none fixed inset-x-0 z-50 flex justify-center px-6 transition-all duration-200',
          'bottom-[calc(76px+env(safe-area-inset-bottom))]',
          visible ? 'translate-y-0 opacity-100' : 'translate-y-2 opacity-0',
        )}
      >
        <div className="max-w-full rounded-md border border-border bg-surface px-4 py-2.5 text-center text-[14px] font-medium text-text shadow-[0_6px_24px_rgba(0,0,0,0.12)]">
          {msg}
        </div>
      </div>
    </ToastContext.Provider>
  )
}

export const useToast = () => useContext(ToastContext)
