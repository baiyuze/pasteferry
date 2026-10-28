import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import App from './App'
import { lang, t } from './i18n'
import { ToastProvider } from './ui'
import './index.css'

document.documentElement.lang = lang
document.title = t('appName')

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <ToastProvider>
      <App />
    </ToastProvider>
  </StrictMode>,
)
