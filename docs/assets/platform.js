'use strict';
(function () {
  if (location.hostname !== 'baiyuze.github.io') return;
  var prefix = /^\/(?:pasteferry|copysync)(?=\/|$)/.exec(location.pathname);
  if (!prefix) return;
  var path = location.pathname.slice(prefix[0].length) || '/';
  location.replace('https://pasteferry.cc' + path + location.search + location.hash);
})();
document.documentElement.classList.add('js');
if (!/Mac|iPhone|iPad/.test(navigator.platform || navigator.userAgent)) {
  document.documentElement.classList.add('pc');
}
