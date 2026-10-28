import { createContext, useContext } from 'react'
import type { Session } from './api'

export interface Conn {
  session: Session
  device: string // 电脑的名字
  name: string // 这台手机的名字
  chunk: number
  maxDownload: number
  maxUpload: number
  maxText: number
  /** 第一次成功收发之后提示添加到主屏幕 */
  succeeded: () => void
}

export const ConnContext = createContext<Conn | null>(null)

export function useConn(): Conn {
  const c = useContext(ConnContext)
  if (!c) throw new Error('ConnContext missing')
  return c
}
