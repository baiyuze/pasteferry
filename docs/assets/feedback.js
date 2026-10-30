(function () {
  'use strict';
  var copy = JSON.parse(document.getElementById('feedback-copy').textContent);
  var prefix = 'pasteferry.feedback.v1.';
  var records = [], draft = null, topic = null, cursor = '', loading = false, timer;
  var form = document.getElementById('feedback-form');
  var status = document.getElementById('feedback-status');
  var list = document.getElementById('feedback-list');
  var mine = document.getElementById('feedback-mine');
  var maxAge = 30 * 86400000;
  var storageOK = true;
  function text(tag, value, cls) { var el = document.createElement(tag); el.textContent = value; if (cls) el.className = cls; return el; }
  function button(label, action) { var el = text('button', label); el.type = 'button'; el.addEventListener('click', action); return el; }
  function announce(message) { status.textContent = message + (!storageOK && message !== copy.storage_warning ? ' ' + copy.storage_warning : ''); }
  function saveRecords() {
    records = records.filter(function (r) { return Date.now() - r.saved < maxAge; }).slice(-50);
    try { localStorage.setItem(prefix + 'records', JSON.stringify(records)); return true; }
    catch (_) { storageOK = false; announce(copy.storage_warning); return false; }
  }
  function restore() {
    try {
      var raw = JSON.parse(localStorage.getItem(prefix + 'records') || '[]');
      if (Array.isArray(raw)) records = raw.filter(function (r) { return r && r.input && typeof r.input.id === 'string' && typeof r.input.owner_token === 'string' && Date.now() - r.saved < maxAge; }).slice(-50);
      draft = JSON.parse(localStorage.getItem(prefix + 'draft') || 'null');
      if (draft && Date.now() - draft.saved >= maxAge) { draft = null; localStorage.removeItem(prefix + 'draft'); }
    } catch (_) { storageOK = false; announce(copy.storage_warning); }
  }
  async function api(path, body) {
    var controller = new AbortController();
    var timeout = setTimeout(function () { controller.abort(); }, 12000);
    try {
      var response = await fetch('/_feedback/v1/' + path, {
        method: body === undefined ? 'GET' : 'POST', credentials: 'omit', cache: 'no-store', signal: controller.signal,
        headers: body === undefined ? {} : {'Content-Type': 'application/json'},
        body: body === undefined ? undefined : JSON.stringify(body)
      });
      var data;
      try { data = await response.json(); }
      catch (parseError) { if (response.ok) throw parseError; data = {}; }
      if (!response.ok) { var err = new Error(data.code || 'error'); err.httpStatus = response.status; throw err; }
      return data;
    } finally { clearTimeout(timeout); }
  }
  function label(m) {
    if (m.status === 'pending') return m.route === 'manual' ? copy.manual : copy.pending;
    return copy[m.status] || copy.error;
  }
  function card(m, own) {
    var el = text('article', '', 'feedback-card');
    var meta = text('div', '', 'feedback-meta');
    meta.append(text('span', copy[m.category] || copy.discussion));
    meta.append(text('span', own ? label(m) : (copy[m.resolution] || copy.published)));
    meta.append(text('span', !m.nickname || m.nickname === 'Visitor' ? copy.visitor : m.nickname));
    if (m.platform || m.app_version) meta.append(text('span', [m.platform, m.app_version].filter(Boolean).join(' · ')));
    if (m.author_kind === 'official') meta.append(text('strong', copy.official));
    if (m.created_at) meta.append(text('span', new Date(m.created_at * 1000).toLocaleString()));
    el.append(meta);
    if (m.title) {
      var h = text('h3', '');
      if (!own || m.status === 'approved') { var a = text('a', m.title); a.href = '#' + (m.parent_id || m.id); h.append(a); }
      else h.textContent = m.title;
      el.append(h);
    }
    el.append(text('p', m.body || ''));
    if (own && m.reason) el.append(text('p', m.reason, 'feedback-note'));
    return el;
  }
  async function refreshMine() {
    if (!records.length) { renderMine(); return; }
    try {
      var data = await api('mine', {items: records.map(function (r) { return {id: r.input.id, owner_token: r.input.owner_token}; })});
      records.forEach(function (r) {
        var m = data.items.find(function (x) { return x.id === r.input.id; });
        if (m) { r.message = m; r.uncertain = false; r.expired = false; }
        else if (r.message) r.expired = true;
      });
      saveRecords(); renderMine();
    } catch (_) { /* Preserve the last confirmed state while offline. */ }
  }
  function renderMine() {
    mine.replaceChildren();
    records.slice().reverse().forEach(function (r) {
      var m = r.message || Object.assign({}, r.input, {status: 'pending', created_at: Math.floor(r.saved / 1000)});
      var el = card(m, true), actions = text('div', '', 'feedback-actions');
      if (r.expired) el.append(text('p', copy.expired, 'feedback-note'));
      else if (r.uncertain) { el.append(text('p', copy.uncertain, 'feedback-note')); actions.append(button(copy.retry, function () { void send(r); })); }
      else if (r.message && m.status !== 'withdrawn') actions.append(button(copy.withdraw, async function () {
        if (!window.confirm(copy.confirm_withdraw)) return;
        try { await api('messages/' + m.id + '/withdraw', {owner_token: r.input.owner_token}); await refreshMine(); await loadPage(false); announce(copy.withdrawn); }
        catch (_) { announce(copy.error); }
      }));
      el.append(actions); mine.append(el);
    });
  }
  function values() {
    var fields = new FormData(form), result = {};
    ['nickname','title','body','category','platform','app_version'].forEach(function (key) { result[key] = String(fields.get(key) || '').trim(); });
    result.parent_id = topic ? topic.id : ''; result.lang = copy.lang;
    if (topic) { result.title = ''; result.category = topic.category; }
    return result;
  }
  function fillForm(data) {
    ['nickname','title','body','category','platform','app_version'].forEach(function (key) { if (data[key] !== undefined) form.elements.namedItem(key).value = data[key]; });
  }
  function openForm() {
    form.hidden = false;
    document.getElementById('feedback-form-title').textContent = topic ? copy.reply : copy.new;
    document.getElementById('feedback-title-field').hidden = !!topic;
    document.getElementById('feedback-category-field').hidden = !!topic;
    form.elements.namedItem('title').required = !topic;
    if (draft && draft.values.parent_id === (topic ? topic.id : '')) fillForm(draft.values);
  }
  form.addEventListener('input', function () {
    clearTimeout(timer); timer = setTimeout(function () {
      draft = {saved: Date.now(), values: values()};
      try { localStorage.setItem(prefix + 'draft', JSON.stringify(draft)); document.getElementById('feedback-draft-state').textContent = copy.saved; }
      catch (_) { storageOK = false; document.getElementById('feedback-draft-state').textContent = copy.storage_warning; announce(copy.storage_warning); }
    }, 500);
  });
  async function send(record) {
    if (loading) return;
    loading = true; form.querySelector('[type=submit]').disabled = true;
    try {
      var message = await api('messages', record.input);
      record.message = message; record.uncertain = false; saveRecords();
      // Clear the draft only if it still belongs to the submitted content.
      if (draft && JSON.stringify(draft.values) === JSON.stringify(record.fields)) {
        draft = null; try { localStorage.removeItem(prefix + 'draft'); } catch (_) {}
      }
      form.reset(); form.hidden = true; document.getElementById('feedback-draft-state').textContent = '';
      announce(copy.submitted); renderMine(); await refreshMine(); await loadPage(false);
    } catch (err) {
      if (err.httpStatus && err.httpStatus < 500) {
        records = records.filter(function (r) { return r !== record; }); saveRecords();
        announce(err.message === 'content_not_allowed' ? copy.failure : copy.error);
      } else { record.uncertain = true; saveRecords(); announce(copy.uncertain); }
      renderMine();
    } finally { loading = false; form.querySelector('[type=submit]').disabled = false; }
  }
  form.addEventListener('submit', function (event) {
    event.preventDefault(); if (loading || !form.reportValidity()) return;
    clearTimeout(timer);
    var fields = values();
    var record = records.find(function (r) { return r.uncertain && JSON.stringify(r.fields) === JSON.stringify(fields); });
    if (!record) {
      var secret = new Uint8Array(32); crypto.getRandomValues(secret);
      var owner = btoa(String.fromCharCode.apply(null, secret)).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
      record = {input: Object.assign({id: crypto.randomUUID(), owner_token: owner}, fields), fields: fields, saved: Date.now(), uncertain: true};
      records.push(record); saveRecords();
    }
    void send(record);
  });
  var generation = 0;
  async function loadPage(append) {
    var gen = ++generation;
    var id = location.hash.slice(1), detail = /^[a-f0-9-]{36}$/.test(id);
    document.getElementById('feedback-back').hidden = !detail;
    document.getElementById('feedback-toolbar').hidden = detail;
    if (!append) { cursor = ''; list.replaceChildren(); }
    var query = new URLSearchParams();
    if (cursor) query.set('cursor', cursor);
    if (!detail) {
      query.set('category', document.getElementById('feedback-category').value);
      query.set('lang', document.getElementById('feedback-language').value);
    }
    try {
      var data = await api((detail ? 'topics/' + id : 'topics') + '?' + query);
      if (gen !== generation) return;
      if (detail) {
        topic = data.topic;
        if (!append) { list.append(card(topic, false)); list.append(text('h2', copy.reply)); }
        data.replies.forEach(function (m) { list.append(card(m, false)); });
        openForm();
      } else {
        topic = null;
        data.items.forEach(function (m) { list.append(card(m, false)); });
        if (!data.items.length && !append) list.append(text('p', copy.empty, 'feedback-note'));
      }
      cursor = data.next_cursor; document.getElementById('feedback-more').hidden = !cursor;
    } catch (err) {
      if (gen !== generation) return;
      if (detail) { topic = null; form.hidden = true; list.replaceChildren(text('p', err.httpStatus === 404 ? copy.no_topic : copy.error, 'feedback-note')); }
      else list.append(text('p', copy.error, 'feedback-note'));
      document.getElementById('feedback-more').hidden = true;
    }
  }
  document.getElementById('feedback-new').addEventListener('click', function () { openForm(); form.scrollIntoView({behavior: 'smooth'}); form.elements.namedItem('title').focus(); });
  document.getElementById('feedback-back').addEventListener('click', function () { location.hash = ''; });
  document.getElementById('feedback-more').addEventListener('click', function () { void loadPage(true); });
  ['feedback-category','feedback-language'].forEach(function (id) { document.getElementById(id).addEventListener('change', function () { void loadPage(false); }); });
  document.getElementById('feedback-clear').addEventListener('click', function () {
    if (!window.confirm(copy.confirm_clear)) return;
    clearTimeout(timer); records = []; draft = null;
    try { localStorage.removeItem(prefix + 'records'); localStorage.removeItem(prefix + 'draft'); } catch (_) { announce(copy.storage_warning); }
    form.reset(); document.getElementById('feedback-draft-state').textContent = ''; renderMine();
  });
  window.addEventListener('hashchange', function () { form.hidden = true; form.reset(); void loadPage(false); });
  document.addEventListener('visibilitychange', function () { if (!document.hidden) { void refreshMine(); void loadPage(false); } });
  setInterval(function () { if (!document.hidden) { void refreshMine(); if (topic) void loadPage(false); } }, 60000);
  restore(); renderMine(); void loadPage(false); void refreshMine();
  if (draft && !draft.values.parent_id && !location.hash) openForm();
})();
