// Anonymous website counters. No cookies, persistent visitor IDs or query strings.
(function () {
  'use strict';
  if (location.hostname !== 'pasteferry.cc' || window.top !== window.self ||
      navigator.doNotTrack === '1' || navigator.globalPrivacyControl) return;
  var languages = {'zh-CN': 'zh', 'zh-TW': 'zh-tw', 'zh-HK': 'zh-hk', en: 'en', ja: 'ja'};
  var lang = languages[document.documentElement.lang];
  if (!lang || !crypto.randomUUID) return;
  function send(kind, version, source, asset) {
    var body = JSON.stringify({id: crypto.randomUUID(), kind: kind, lang: lang,
      path: location.pathname, version: version || '', source: source || '', asset: asset || ''});
    // Download links stay direct: slow or unavailable analytics never delays a download.
    try {
      if (navigator.sendBeacon && navigator.sendBeacon('/_stats/event', body)) return;
      fetch('/_stats/event', {method: 'POST', body: body, keepalive: true,
        credentials: 'omit', headers: {'Content-Type': 'text/plain'}}).catch(function () {});
    } catch (_) {}
  }
  send('pageview');
  function download(event) {
    if (!event.isTrusted || (event.type === 'auxclick' && event.button !== 1)) return;
    var link = event.target.closest('a[href]');
    if (!link) return;
    var url = new URL(link.href);
    var source = url.hostname === 'gitee.com' ? 'gitee' : url.hostname === 'github.com' ? 'github' : '';
    var match = url.pathname.match(/^\/baiyuze\/pasteferry\/releases\/download\/(v[0-9]+\.[0-9]+\.[0-9]+)\/([^/]+)$/);
    if (source && match && match[2] !== 'SHA256SUMS')
      send('download', match[1], source, decodeURIComponent(match[2]));
  }
  document.addEventListener('click', download);
  document.addEventListener('auxclick', download);
})();
