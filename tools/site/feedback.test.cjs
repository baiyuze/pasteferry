const {test} = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const {webcrypto} = require('node:crypto');
const source = fs.readFileSync(path.join(__dirname, '../../docs/assets/feedback.js'), 'utf8');
const html = fs.readFileSync(path.join(__dirname, '../../docs/feedback/index.html'), 'utf8');
const copy = JSON.parse(html.match(/id="feedback-copy">([^<]+)<\/script>/)[1]);
const flush = () => new Promise(resolve => setImmediate(resolve));

test('all feedback languages enforce CSP before scripts and contain no inline JavaScript', () => {
  for (const lang of ['', 'en/', 'ja/', 'zh-tw/', 'zh-hk/']) {
    const page = fs.readFileSync(path.join(__dirname, '../../docs', lang, 'feedback/index.html'), 'utf8');
    assert.ok(page.indexOf('Content-Security-Policy') < page.indexOf('<script'));
    for (const match of page.matchAll(/<script\b([^>]*)>([\s\S]*?)<\/script>/g)) {
      assert.ok(/src=|type="application\/json"/.test(match[1]), lang + ': inline executable script');
    }
    assert.match(page, /assets\/platform\.js/);
  }
});

function fixture(options = {}) {
  class Element {
    constructor() { this.textContent = ''; this.value = ''; this.hidden = false; this.listeners = {}; this.children = []; }
    set innerHTML(_) { throw new Error('Untrusted HTML sink used'); }
    insertAdjacentHTML() { throw new Error('Untrusted HTML sink used'); }
    addEventListener(name, listener) { this.listeners[name] = listener; }
    append(...nodes) { this.children.push(...nodes); }
    replaceChildren(...nodes) { this.children = nodes; }
    scrollIntoView() { this.scrolled = true; }
    focus() { this.focused = true; }
  }
  const elements = new Map();
  const el = id => { if (!elements.has(id)) elements.set(id, new Element()); return elements.get(id); };
  el('feedback-copy').textContent = JSON.stringify(copy);
  const form = el('feedback-form'), button = new Element();
  const fields = Object.fromEntries(['nickname', 'title', 'body', 'category'].map(key => [key, new Element()]));
  fields.category.value = 'discussion';
  form.elements = {namedItem: key => fields[key] || null};
  form.querySelector = () => button;
  form.checkValidity = () => !!fields.body.value;
  form.reportValidity = () => { form.reported = true; };
  form.reset = () => { Object.values(fields).forEach(field => { field.value = ''; }); fields.category.value = 'discussion'; };
  const stored = options.storage || new Map(), requests = [], documentListeners = {}, windowListeners = {};
  let finish;
  const context = {
    document: {getElementById: el, createElement: () => new Element(), addEventListener(name, fn) { documentListeners[name] = fn; }},
    location: {protocol: 'https:', hostname: 'pasteferry.cc', host: 'pasteferry.cc', pathname: '/feedback/', search: '', hash: '', replace(url) { this.redirect = url; }},
    crypto: {getRandomValues: bytes => webcrypto.getRandomValues(bytes)},
    localStorage: {get length() { return stored.size; }, key: i => [...stored.keys()][i] || null, getItem: key => stored.get(key) || null, setItem: (key, value) => stored.set(key, value), removeItem: key => stored.delete(key)},
    FormData: class {get(key) { return fields[key]?.value || ''; }},
    AbortController, Uint8Array, URLSearchParams, setTimeout, clearTimeout, setInterval() {},
    btoa: value => Buffer.from(value, 'binary').toString('base64'), confirm: () => true, addEventListener(name, fn) { windowListeners[name] = fn; },
    fetch: async (url, init) => {
      if (url === '/_feedback/v1/messages') {
        const input = JSON.parse(init.body); requests.push(input);
        return new Promise(resolve => { finish = () => resolve(options.failure ? {ok: false, status: 429, json: async () => ({code: 'rate_limited'})} : {ok: true, status: 201, json: async () => ({...input, owner_token: undefined, status: 'pending', route: 'manual', ...options.ownerFields})}); });
      }
      return {ok: true, status: 200, json: async () => ({items: options.items || [], next_cursor: ''})};
    },
  };
  context.window = context;
  if (options.noCrypto) context.crypto = undefined;
  if (options.http) context.location.protocol = 'http:';
  vm.runInNewContext(source, context);
  return {el, form, fields, button, requests, stored, context, documentListeners, windowListeners, finish: () => finish(), submit: () => form.listeners.submit({preventDefault() {}})};
}

test('body-only mobile submission shows progress and uses secure UUID without randomUUID', async () => {
  const f = fixture();
  f.fields.body.value = '手机端反馈：只有正文也能提交\n补充说明';
  f.submit();
  assert.equal(f.button.textContent, copy.sending);
  assert.equal(f.el('feedback-form-status').textContent, copy.sending);
  assert.equal(f.button.disabled, true);
  assert.equal(f.requests.length, 1);
  const input = f.requests[0];
  assert.equal(input.title, '手机端反馈：只有正文也能提交');
  assert.match(input.id, /^[\da-f]{8}-[\da-f]{4}-4[\da-f]{3}-[89ab][\da-f]{3}-[\da-f]{12}$/);
  assert.equal(Buffer.from(input.owner_token, 'base64url').length, 32);
  assert.equal(JSON.parse(f.stored.get('pasteferry.feedback.v2.record.' + input.id)).input.id, input.id);
  f.finish(); await flush(); await flush();
  assert.equal(f.form.hidden, true);
  assert.equal(f.el('feedback-mine-panel').open, true);
  assert.equal(f.el('feedback-mine-count').textContent, '(1)');
  assert.equal(f.el('feedback-mine-panel').scrolled, true);
  assert.equal(f.button.disabled, false);
});

test('missing body gives a visible validation message and sends nothing', () => {
  const f = fixture(); f.submit();
  assert.equal(f.requests.length, 0);
  assert.equal(f.el('feedback-form-status').textContent, copy.required_fields);
});

test('missing secure randomness gives a visible error and never falls back to weak tokens', () => {
  const f = fixture({noCrypto: true}); f.fields.body.value = 'Example'; f.submit();
  assert.equal(f.requests.length, 0);
  assert.equal(f.el('feedback-form-status').textContent, copy.secure_unavailable);
});

test('rate limiting preserves input and shows the reason beside the enabled button', async () => {
  const f = fixture({failure: true}); f.fields.body.value = 'Example'; f.submit(); f.finish();
  await flush(); await flush();
  assert.equal(f.el('feedback-form-status').textContent, copy.rate_limited);
  assert.equal(f.fields.body.value, 'Example');
  assert.equal(f.button.disabled, false);
  assert.equal([...f.stored.keys()].some(key => key.startsWith('pasteferry.feedback.v2.record.')), false);
});

test('HTTP upgrades before reading or generating owner credentials', () => {
  const f = fixture({http: true});
  assert.equal(f.context.location.redirect, 'https://pasteferry.cc/feedback/');
  assert.equal(f.form.listeners.submit, undefined);
  assert.equal(f.requests.length, 0);
});


test('discussion topics and replies do not display issue progress', async () => {
  const base = {id: 'a0b1c2d3-1111-4111-8111-111111111111', title: 'Topic', body: 'Content', status: 'approved', resolution: 'open'};
  const text = element => [element.textContent, ...element.children.map(text)].join(' ');
  for (const [category, parent_id, hasProgress] of [['discussion', '', false], ['bug', '', true], ['bug', 'parent', false]]) {
    const f = fixture({items: [{...base, category, parent_id}]}); await flush();
    const rendered = text(f.el('feedback-list'));
    assert.equal(rendered.includes(copy.open), hasProgress, category + '/' + parent_id);
  }
});

test('malicious public and owner content stays text and never becomes HTML', async () => {
  const payload = '</script><img src=x onerror=alert(1)><svg/onload=alert(2)>';
  const item = {id: 'a0b1c2d3-1111-4111-8111-111111111111', nickname: payload, title: payload, body: payload, reason: payload, status: 'approved', category: 'discussion'};
  const f = fixture({items: [item], ownerFields: {reason: payload}}); await flush();
  const all = element => [element, ...element.children.flatMap(all)];
  let nodes = all(f.el('feedback-list'));
  assert.equal(nodes.filter(node => node.textContent === payload).length, 3);
  assert.equal(nodes.find(node => node.href)?.href, '#' + item.id);
  f.fields.nickname.value = payload; f.fields.title.value = payload; f.fields.body.value = payload;
  f.submit(); f.finish(); await flush(); await flush();
  nodes = all(f.el('feedback-mine'));
  assert.equal(nodes.filter(node => node.textContent === payload).length, 4);
});

test('multiple tabs preserve independent owner credentials and clearing cannot resurrect them', async () => {
  const storage = new Map(), first = fixture({storage}), second = fixture({storage});
  async function submit(f, body) { f.fields.body.value = body; f.submit(); f.finish(); await flush(); await flush(); }
  await submit(first, 'First tab');
  await submit(second, 'Second tab');
  first.documentListeners.visibilitychange(); await flush(); await flush();
  const fresh = fixture({storage}); await flush();
  assert.equal(fresh.el('feedback-mine-count').textContent, '(2)');
  for (const input of [...first.requests, ...second.requests]) {
    assert.equal(JSON.parse(storage.get('pasteferry.feedback.v2.record.' + input.id)).input.owner_token, input.owner_token);
  }
  second.el('feedback-clear').listeners.click();
  first.documentListeners.visibilitychange(); await flush(); await flush();
  assert.equal(fixture({storage}).el('feedback-mine-count').textContent, '(0)');
});

test('legacy credentials migrate once and old tabs cannot overwrite or restore cleared records', async () => {
  const old = {input:{id:'a0b1c2d3-1111-4111-8111-111111111111',owner_token:'legacy-secret',body:'Old text'},saved:Date.now()};
  const storage = new Map([['pasteferry.feedback.v1.records',JSON.stringify([old])]]);
  const f = fixture({storage}); await flush();
  assert.equal(f.el('feedback-mine-count').textContent, '(1)');
  storage.set('pasteferry.feedback.v1.records', '[]');
  assert.equal(fixture({storage}).el('feedback-mine-count').textContent, '(1)');
  f.el('feedback-clear').listeners.click();
  storage.set('pasteferry.feedback.v1.records', JSON.stringify([old]));
  assert.equal(fixture({storage}).el('feedback-mine-count').textContent, '(0)');
});

test('successful submission clears an older debounced draft', async () => {
  const storage = new Map([['pasteferry.feedback.v1.draft',JSON.stringify({saved:Date.now(),values:{parent_id:'',body:'Earlier draft'}})]]);
  const f = fixture({storage}); f.fields.body.value = 'Submitted content'; f.submit(); f.finish(); await flush(); await flush();
  assert.equal(storage.has('pasteferry.feedback.v1.draft'), false);
});
