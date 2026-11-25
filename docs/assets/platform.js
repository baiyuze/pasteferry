'use strict';
(function () {
  if (location.hostname !== 'baiyuze.github.io') return;
  var prefix = /^\/(?:pasteferry|copysync)(?=\/|$)/.exec(location.pathname);
  if (!prefix) return;
  var path = location.pathname.slice(prefix[0].length) || '/';
  location.replace('https://pasteferry.cc' + path + location.search + location.hash);
})();
document.documentElement.classList.add('js');
// 外观：与其他页面 <head> 里的内联脚本相同（反馈页的内容安全策略不允许内联脚本）
(function () {
  var d = document.documentElement, k = 'pasteferry-theme', p;
  var m = window.matchMedia && matchMedia('(prefers-color-scheme: light)');
  try { p = localStorage.getItem(k); } catch (e) {}
  p = p === 'light' || p === 'system' ? p : 'dark';
  function a() {
    var t = p === 'system' ? (m && m.matches ? 'light' : 'dark') : p;
    d.setAttribute('data-theme', t);
    d.setAttribute('data-theme-pref', p);
    var c = document.querySelector('meta[name="theme-color"]');
    if (c) c.setAttribute('content', t === 'light' ? '#ffffff' : '#141416');
  }
  a();
  if (m && m.addEventListener) m.addEventListener('change', function () { if (p === 'system') a(); });
  window.pfSetTheme = function (v) {
    p = v === 'light' || v === 'system' ? v : 'dark';
    try { localStorage.setItem(k, p); } catch (e) {}
    a();
  };
})();
if (!/Mac|iPhone|iPad/.test(navigator.platform || navigator.userAgent)) {
  document.documentElement.classList.add('pc');
}
