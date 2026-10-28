import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

// 产物输出到后台服务的嵌入目录，由 client-core/internal/webshare 用 go:embed 提供。
// 后台服务的 CSP 只允许同源的脚本和样式，所以不能有内联脚本（关掉 modulePreload 的 polyfill），
// 也不内联小资源。开发时 `npm run dev`，接口转发到本机的测试后台服务。
export default defineConfig({
  plugins: [react(), tailwindcss()],
  base: './',
  build: {
    outDir: '../../client-core/internal/webshare/web',
    emptyOutDir: true,
    modulePreload: { polyfill: false },
    assetsInlineLimit: 0,
    target: ['es2020', 'safari14', 'chrome87'],
    sourcemap: false,
  },
  server: {
    proxy: { '/api': 'http://127.0.0.1:8790' },
  },
})
