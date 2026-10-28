import { ApiError } from './api'
import { S, lang, t } from './i18n'

export function humanSize(n: number): string {
  if (n < 1024) return `${n} B`
  const units = ['KB', 'MB', 'GB']
  let v = n
  for (let i = 0; i < units.length; i++) {
    v /= 1024
    if (v < 1024 || i === units.length - 1) return `${v < 10 ? v.toFixed(1) : Math.round(v)} ${units[i]}`
  }
  return `${n} B`
}

/** 与 App 记录页相同的相对时间：刚刚、N 分钟前、N 小时前，再早的写日期。 */
export function relativeTime(ms: number, now = Date.now()): string {
  const d = Math.max(0, now - ms)
  if (d < 60_000) return t('justNow')
  if (d < 3_600_000) return t('minutesAgo', { n: Math.floor(d / 60_000) })
  if (d < 86_400_000) return t('hoursAgo', { n: Math.floor(d / 3_600_000) })
  try {
    return new Intl.DateTimeFormat(lang, { month: 'numeric', day: 'numeric', hour: '2-digit', minute: '2-digit' }).format(ms)
  } catch {
    return new Date(ms).toLocaleString()
  }
}

export function errorText(e: unknown): string {
  const code = e instanceof ApiError ? e.code : ''
  switch (code) {
    case 'stale':
      return t('errStale')
    case 'too_large':
      return t('errTooLarge')
    case 'network':
      return t('errNetwork')
    case 'gone':
      return t('errGone')
    case 'not_ready':
      return t('errNotReady')
    default:
      return t('errGeneric', { msg: e instanceof Error ? e.message : String(e) })
  }
}

// ── 浏览器判断 ──

const ua = navigator.userAgent || ''
export const isIOS = /iPhone|iPad|iPod/.test(ua) || (/Macintosh/.test(ua) && navigator.maxTouchPoints > 1)
const isAndroid = /Android/.test(ua)
/** 微信、QQ 等 App 内置的浏览器：下载常被拦截，也不能添加到主屏幕 */
export const inApp = /MicroMessenger|\sQQ\/|Weibo|DingTalk|AlipayClient|Lark|Feishu/i.test(ua)

type HomeKind = 'Safari' | 'IOSChrome' | 'AndroidChrome' | 'Domestic' | 'InApp' | 'Other'

function browserKind(): HomeKind {
  if (inApp) return 'InApp'
  if (isIOS) return /CriOS/.test(ua) ? 'IOSChrome' : 'Safari'
  if (isAndroid) {
    if (/HuaweiBrowser|MiuiBrowser|XiaoMi|HeyTapBrowser|OppoBrowser|VivoBrowser|UCBrowser|Quark|MQQBrowser|baiduboxapp|SamsungBrowser/i.test(ua)) return 'Domestic'
    if (/Chrome\/\d/.test(ua) && !/EdgA|OPR\//.test(ua)) return 'AndroidChrome'
  }
  return 'Other'
}

/** 这个浏览器里「添加到主屏幕」的步骤 */
export function homeSteps(): string[] {
  return S[`home${browserKind()}`]
}

export function guessName(): string {
  if (/iPad/.test(ua) || (/Macintosh/.test(ua) && navigator.maxTouchPoints > 1)) return 'iPad'
  if (/iPhone|iPod/.test(ua)) return 'iPhone'
  if (isAndroid) return t('androidPhone')
  return t('phone')
}

/** 是不是从主屏幕图标打开的 */
export function standalone(): boolean {
  return (navigator as Navigator & { standalone?: boolean }).standalone === true || window.matchMedia?.('(display-mode: standalone)').matches
}

/**
 * 复制文字。必须在点击事件里同步调用：http 页面用不了 navigator.clipboard，只剩 execCommand，
 * 它只在用户手势里有效。浏览器不让复制时返回 false，调用方让用户自己复制。
 *
 * 临时输入框不能放到屏幕外（left:-9999px）：Android 上浏览器会把系统自带的
 * 选中工具条夹回可见区域，在列表上弹出一条「分享 / 复制」，看着像我们画的。
 * 改成放在视口左下角、1px 大小、全透明，选中工具条就不会跑到内容上。
 */
export function copyText(text: string): boolean {
  const ta = document.createElement('textarea')
  ta.value = text
  if (isIOS) ta.contentEditable = 'true' // iOS 上只读的输入框选不中文字
  else ta.setAttribute('readonly', '') // 不弹出键盘
  ta.setAttribute('aria-hidden', 'true')
  ta.tabIndex = -1
  ta.style.cssText =
    'position:fixed;left:0;bottom:0;width:1px;height:1px;padding:0;border:0;outline:0;opacity:0;' +
    'font-size:16px;pointer-events:none;z-index:-1'
  document.body.appendChild(ta)
  let ok = false
  try {
    ta.focus({ preventScroll: true })
    ta.select()
    ta.setSelectionRange(0, text.length)
    ok = document.execCommand('copy')
  } catch {
    ok = false
  }
  ta.remove()
  window.getSelection()?.removeAllRanges()
  return ok
}

/** 触发浏览器下载一个 Blob。 */
export function saveBlob(url: string, name: string) {
  const a = document.createElement('a')
  a.href = url
  a.download = name
  document.body.appendChild(a)
  a.click()
  a.remove()
}
