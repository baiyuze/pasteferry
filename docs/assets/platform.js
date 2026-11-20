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
  function a() {
    var t = p === 'light' || p === 'dark' ? p : (m && m.matches ? 'light' : 'dark');
    d.setAttribute('data-theme', t);
    d.setAttribute('data-theme-pref', p === 'light' || p === 'dark' ? p : 'system');
  }
  a();
  if (m && m.addEventListener) m.addEventListener('change', function () { if (p !== 'light' && p !== 'dark') a(); });
  window.pfSetTheme = function (v) {
    p = v;
    try { v === 'system' ? localStorage.removeItem(k) : localStorage.setItem(k, v); } catch (e) {}
    a();
  };
})();
if (!/Mac|iPhone|iPad/.test(navigator.platform || navigator.userAgent)) {
  document.documentElement.classList.add('pc');
}
