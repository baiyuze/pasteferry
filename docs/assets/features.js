// 功能页的动画：开头截图随滚动放大、跨设备的弧线、快捷粘贴随滚动一步步演示、类型筛选与搜索的小演示。
// 没有脚本或要求减少动画时，页面停在每块最能说明问题的那一帧（见 features.css）。
(function () {
  var still = window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  var ticking = false;
  var onScroll = [];

  function frame() {
    ticking = false;
    onScroll.forEach(function (fn) { fn(); });
  }

  function request() {
    if (ticking) return;
    ticking = true;
    requestAnimationFrame(frame);
  }

  function clamp(x, a, b) {
    return Math.max(a, Math.min(b, x));
  }

  // 只在看得见时才跑的循环动画
  function whileVisible(el, start, stop) {
    if (!("IntersectionObserver" in window)) { start(); return; }
    new IntersectionObserver(function (entries) {
      entries[0].isIntersecting ? start() : stop();
    }, { threshold: 0.3 }).observe(el);
  }

  // ── 开头的截图：从稍小放大到原大，像窗口被推到眼前 ──
  var shot = document.querySelector("[data-zoom]");
  if (shot && !still) {
    onScroll.push(function () {
      var r = shot.getBoundingClientRect();
      var vh = window.innerHeight;
      // 截图顶边在视口底部时 0，升到视口 20% 处时 1
      var p = clamp((vh - r.top) / (vh * 0.8), 0, 1);
      shot.style.setProperty("--z", (0.86 + 0.14 * p).toFixed(4));
    });
  }

  // ── 跨设备：按三块屏幕的位置画两条弧线，Mac → Windows、Mac → Linux ──
  var trio = document.querySelector(".trio");
  if (trio) {
    var ns = "http://www.w3.org/2000/svg";
    var svg = document.createElementNS(ns, "svg");
    svg.setAttribute("class", "arcs");
    svg.setAttribute("aria-hidden", "true");
    var paths = [document.createElementNS(ns, "path"), document.createElementNS(ns, "path")];
    paths.forEach(function (p) { svg.appendChild(p); });
    trio.appendChild(svg);

    var drawArcs = function () {
      var box = trio.getBoundingClientRect();
      var scr = trio.querySelectorAll(".scr");
      var a = scr[0].getBoundingClientRect();
      svg.setAttribute("viewBox", "0 0 " + box.width + " " + box.height);
      var sx = a.left + a.width / 2 - box.left;
      var sy = a.top - box.top - 6;
      [1, 2].forEach(function (i) {
        var b = scr[i].getBoundingClientRect();
        var tx = b.left + b.width / 2 - box.left;
        var lift = (tx - sx) * (i === 1 ? 0.34 : 0.2);
        var d = "M" + sx + " " + sy + " Q" + (sx + tx) / 2 + " " + (sy - lift) + " " + tx + " " + sy;
        var p = paths[i - 1];
        p.setAttribute("d", d);
        p.style.setProperty("--len", Math.ceil(p.getTotalLength()) + "px");
      });
    };
    drawArcs();
    window.addEventListener("resize", drawArcs);
  }

  // ── 快捷粘贴：按这一节滚过的比例推进 ──
  var scene = document.querySelector("[data-scene]");
  if (scene && !still) {
    var stage = scene.querySelector(".qp-stage");
    var steps = scene.querySelector(".qp-steps");
    var items = steps.querySelectorAll("li");
    var q = stage.querySelector(".field .q");
    var typing = JSON.parse(stage.dataset.typing);
    var last = "";
    stage.classList.add("live");
    steps.classList.add("live");

    // 各个时刻（滚动进度 0–1）：键帽、窗口打开、逐字输入、搜到、回车、粘贴好
    var T = { keys: 0.06, open: 0.14, type: 0.28, typed: 0.44, filter: 0.46, enter: 0.6, done: 0.68 };

    onScroll.push(function () {
      var r = scene.getBoundingClientRect();
      var span = r.height - window.innerHeight;
      var p = clamp(-r.top / span, 0, 1);

      var typed = "";
      var composing = false;
      if (p >= T.type) {
        var i = Math.min(typing.length - 1, Math.floor((p - T.type) / (T.typed - T.type) * typing.length));
        typed = typing[i][0];
        composing = typing[i][1];
      }
      var state = [
        p >= T.keys && p < T.open + 0.08 ? "keys" : "",
        p >= T.open ? "open" : "",
        typed ? "" : "empty",
        composing ? "composing" : "",
        p >= T.filter ? "filtered" : "",
        p >= T.enter && p < T.done + 0.1 ? "enter" : "",
        p >= T.done ? "done" : "",
      ].join(" ");
      if (state !== last) {
        stage.className = "qp-stage live " + state;
        last = state;
      }
      if (q.textContent !== typed) q.textContent = typed;

      var step = p < 0.24 ? 0 : p < T.enter - 0.02 ? 1 : 2;
      items.forEach(function (li, j) { li.classList.toggle("on", j === step); });
    });
  }

  // ── 类型筛选：轮流点各个页签 ──
  var filter = document.querySelector("[data-filter]");
  if (filter && !still) {
    var tabs = filter.querySelectorAll(".seg span");
    var rows = filter.querySelectorAll(".mini-rows li");
    var order = ["all", "link", "image", "file", "fav", "text"];
    var at = 0;
    var timer = null;
    var show = function (kind) {
      tabs.forEach(function (t) { t.classList.toggle("on", t.dataset.tab === kind); });
      rows.forEach(function (r) {
        var keep = kind === "all" || (kind === "fav" ? r.hasAttribute("data-fav") : r.dataset.kind === kind);
        r.classList.toggle("out", !keep);
      });
    };
    whileVisible(filter, function () {
      if (timer) return;
      timer = setInterval(function () {
        at = (at + 1) % order.length;
        show(order[at]);
      }, 1800);
    }, function () {
      clearInterval(timer);
      timer = null;
    });
  }

  // ── 搜索：逐字输入，再出结果 ──
  var search = document.querySelector("[data-search]");
  if (search && !still) {
    var field = search.querySelector(".q");
    var word = Array.from(field.dataset.q);
    var hits = search.querySelectorAll(".hits li");
    var loop = null;
    var run = function () {
      var n = 0;
      field.textContent = "";
      hits.forEach(function (h) { h.classList.add("out"); });
      var type = setInterval(function () {
        n += 1;
        field.textContent = word.slice(0, n).join("");
        if (n >= word.length) {
          clearInterval(type);
          setTimeout(function () {
            hits.forEach(function (h) { h.classList.remove("out"); });
          }, 250);
        }
      }, 260);
    };
    whileVisible(search, function () {
      if (loop) return;
      run();
      loop = setInterval(run, 4800);
    }, function () {
      clearInterval(loop);
      loop = null;
    });
  }

  window.addEventListener("scroll", request, { passive: true });
  window.addEventListener("resize", request);
  frame();
})();
