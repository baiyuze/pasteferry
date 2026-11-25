// 首屏动画、代码块的「复制」按钮、分页（部署教程按系统分页、快速开始按部署方式分页）、语言菜单与「更多」菜单、
// 滚动到才淡入的块、记住选过的语言。
// 没有脚本时页面照样完整：动画停在复制完成的样子，分页的内容依次排开。
(function () {
  // Load the localized tour only when requested. The href remains a normal
  // standalone page for browsers without dialog support or JavaScript.
  var tourLink = document.querySelector('[data-tour-open]');
  var tourDialog = document.querySelector('.tour-dialog');
  if (tourLink && tourDialog && typeof tourDialog.showModal === 'function') {
    var tourFrame = tourDialog.querySelector('iframe');
    tourLink.addEventListener('click', function (event) {
      if (event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
      event.preventDefault();
      tourDialog.showModal();
      document.documentElement.classList.add('tour-is-open');
      if (!tourFrame.hasAttribute('src')) tourFrame.src = tourFrame.dataset.src;
      else tourFrame.contentWindow.postMessage('tour:play', location.origin);
    });
    tourDialog.addEventListener('click', function (event) {
      if (event.target === tourDialog) tourDialog.close();
    });
    tourDialog.addEventListener('close', function () {
      tourFrame.contentWindow.postMessage('tour:pause', location.origin);
      document.documentElement.classList.remove('tour-is-open');
      tourLink.focus();
    });
    window.addEventListener('message', function (event) {
      if (event.origin !== location.origin || event.source !== tourFrame.contentWindow) return;
      if (event.data === 'tour:close') tourDialog.close();
      if (event.data === 'tour:ready') tourFrame.contentWindow.postMessage(tourDialog.open ? 'tour:play' : 'tour:pause', location.origin);
    });
  }

  // 首屏演示：点 Mac 桌面上的一样东西（或选中后按 ⌘C / Ctrl+C）就复制，化作一张纸飞到 Windows 笔记本上粘贴。
  // 下面切换两台电脑在家里和公司（先经服务器交换连接信息，再直连），还是同一个 Wi‑Fi（不用服务器）。
  // 看得见时像宣传视频一样轮流复制四样东西；访客点了哪样、或按了暂停就停下，再按一次继续。
  // 滚出视野或切到别的标签页时不轮播；系统设置了减少动态效果时不轮播，也不显示暂停按钮
  var stage = document.querySelector("[data-play]");
  if (stage) {
    var demo = stage.closest("[data-demo]");
    var files = Array.prototype.slice.call(stage.querySelectorAll(".mac .file"));
    var landed = stage.querySelector(".win .file");
    var status = demo.querySelector("[data-demo-status]");
    var pauseButton = demo.querySelector("[data-demo-pause]");
    var reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    var current = files[0];
    var announce;
    var cycle;
    var started = false;
    var visible = false;
    var paused = reduce || !pauseButton;

    // 按实际位置算出纸飞行的起点、终点与唯一的传输弧线，以及服务器说明的位置
    var layout = function () {
      var src = current.querySelector(".doc");
      var dst = landed.querySelector(".doc");
      var sheet = stage.querySelector(".sheet-fly");
      var path = stage.querySelector(".arc .direct");
      var label = stage.querySelector(".arc-label");
      var box = stage.getBoundingClientRect();
      var a = src.getBoundingClientRect();
      var b = dst.getBoundingClientRect();
      var ma = stage.querySelector(".mac .screen").getBoundingClientRect();
      var wa = stage.querySelector(".win .screen").getBoundingClientRect();
      var w = sheet.offsetWidth;
      var h = sheet.offsetHeight;
      var sx = a.left + a.width / 2 - box.left;
      var sy = a.top + a.height / 2 - box.top;
      var tx = b.left + b.width / 2 - box.left;
      var ty = b.top + b.height / 2 - box.top;
      var mx = (ma.left + ma.right) / 2 - box.left;
      var wx = (wa.left + wa.right) / 2 - box.left;
      var top = Math.min(ma.top, wa.top) - box.top;
      // 弧线的控制点在屏幕顶上 rise 处；纸飞到弧线顶附近；服务器在弧线上方。
      // rise 按两块屏幕的距离算，不随复制的是哪一样变，轮播时服务器不会上下跳。
      // 上限与 site.css 里 .demo .stage 上方的留白对应
      var rise = Math.min(Math.max(30, (wx - mx) * 0.16), 84);
      var peak = top - rise;
      var startY = sy - a.height / 2;
      var endY = ty - b.height / 2;
      var apex = (startY + 2 * peak + endY) / 4;
      stage.style.setProperty("--sx", sx - w / 2 + "px");
      stage.style.setProperty("--sy", sy - h / 2 + "px");
      stage.style.setProperty("--tx", tx - w / 2 + "px");
      stage.style.setProperty("--ty", ty - h / 2 + "px");
      stage.style.setProperty("--lift", Math.min(sy, ty) - apex + h * 0.2 + "px");
      path.setAttribute("d", "M" + sx + " " + startY + " Q" + (sx + tx) / 2 + " " + peak + " " + tx + " " + endY);
      label.style.setProperty("--ly", apex - 26 + "px");
      var px = (mx + wx) / 2;
      var py = peak - 40;
      stage.style.setProperty("--px", px + "px");
      stage.style.setProperty("--py", py + "px");
    };

    // 只有访客自己点的才读给读屏软件听，自动轮播的不读
    var play = function (file, speak) {
      current = file;
      files.forEach(function (f) { f.classList.toggle("sel", f === file); });
      // 落在 Windows 上的那一样换成刚复制的；动画开始时它先藏着，落地时才出现
      landed.querySelector(".doc").className = file.querySelector(".doc").className;
      landed.querySelector(".name").textContent = file.getAttribute("data-name");
      layout();
      stage.classList.remove("play");
      void stage.offsetWidth; // 强制重排，让动画从头再来
      stage.classList.add("play");
      clearTimeout(announce);
      if (!speak) return;
      announce = setTimeout(function () {
        status.textContent = demo.getAttribute("data-pasted").replace("{item}", file.getAttribute("data-name"));
      }, reduce ? 0 : stage.getAttribute("data-mode") === "wan" ? 3100 : 2300);
    };

    // 一次演示跨网络约 4.4 秒、同一网络约 3.6 秒，播完停一会儿再复制下一样
    var schedule = function () {
      clearTimeout(cycle);
      if (paused || !visible || document.hidden) return;
      cycle = setTimeout(function () {
        play(files[(files.indexOf(current) + 1) % files.length]);
        schedule();
      }, stage.getAttribute("data-mode") === "wan" ? 5600 : 4800);
    };

    var setPaused = function (value) {
      paused = value;
      if (pauseButton) {
        pauseButton.classList.toggle("paused", value);
        var label = pauseButton.getAttribute(value ? "data-resume" : "data-pause");
        pauseButton.setAttribute("aria-label", label);
        pauseButton.title = label;
      }
      schedule();
    };

    if (pauseButton && !reduce) {
      pauseButton.hidden = false;
      pauseButton.addEventListener("click", function () {
        if (paused) {
          setPaused(false);
          play(files[(files.indexOf(current) + 1) % files.length]);
          schedule();
        } else {
          setPaused(true);
        }
      });
    }

    var pick = function (file) {
      if (pauseButton && !reduce) setPaused(true);
      play(file, true);
    };

    files.forEach(function (file) {
      file.addEventListener("click", function () { pick(file); });
      file.addEventListener("keydown", function (e) {
        if ((e.metaKey || e.ctrlKey) && (e.key === "c" || e.key === "C")) {
          e.preventDefault();
          pick(file);
        }
      });
    });

    var modes = Array.prototype.slice.call(demo.querySelectorAll("[data-mode]")).filter(function (b) { return b !== stage; });
    modes.forEach(function (button) {
      button.addEventListener("click", function () {
        modes.forEach(function (b) {
          b.setAttribute("aria-checked", b === button ? "true" : "false");
          b.tabIndex = b === button ? 0 : -1;
        });
        stage.setAttribute("data-mode", button.getAttribute("data-mode"));
        play(current, true);
        schedule();
      });
      button.addEventListener("keydown", function (e) {
        var step = e.key === "ArrowRight" ? 1 : e.key === "ArrowLeft" ? -1 : 0;
        if (!step) return;
        e.preventDefault();
        var next = modes[(modes.indexOf(button) + step + modes.length) % modes.length];
        next.focus();
        next.click();
      });
    });

    layout();
    window.addEventListener("resize", layout);
    document.addEventListener("visibilitychange", schedule);
    // 滚动到可见时才开始，免得还没看到就播完了；滚出视野后停止轮播，回来时接着播
    if ("IntersectionObserver" in window) {
      var seen = new IntersectionObserver(function (entries) {
        visible = entries[0].isIntersecting;
        if (visible && !started) {
          started = true;
          play(current);
        }
        schedule();
      }, { threshold: 0.25 });
      seen.observe(stage);
    } else {
      visible = started = true;
      play(current);
      schedule();
    }
  }

  document.querySelectorAll(".code").forEach(function (block) {
    var button = block.querySelector(".copy");
    var pre = block.querySelector("pre");
    if (!button || !pre || !navigator.clipboard) {
      if (button) button.hidden = true;
      return;
    }
    var label = button.textContent;
    button.addEventListener("click", function () {
      navigator.clipboard.writeText(pre.innerText.trim()).then(function () {
        button.textContent = button.dataset.done || "Copied";
        setTimeout(function () { button.textContent = label; }, 1600);
      });
    });
  });

  // 分页。链接里带了 #windows、#plan-lan 之类就打开那一页；否则按系统分页（data-tabs="os"）的按访问者的系统，
  // 按部署方式分页（data-tabs="plan"）的打开第一页
  document.querySelectorAll("[data-tabs]").forEach(function (box) {
    var list = box.querySelector("[role=tablist]");
    var tabs = Array.prototype.slice.call(list.querySelectorAll("[role=tab]"));
    var panels = tabs.map(function (t) { return document.getElementById(t.getAttribute("aria-controls")); });

    function select(i, focus) {
      tabs.forEach(function (t, j) {
        t.setAttribute("aria-selected", i === j ? "true" : "false");
        t.tabIndex = i === j ? 0 : -1;
        panels[j].hidden = i !== j;
      });
      if (focus) tabs[i].focus();
    }

    tabs.forEach(function (t, i) {
      t.addEventListener("click", function () {
        select(i);
        history.replaceState(null, "", "#" + panels[i].id);
      });
      t.addEventListener("keydown", function (e) {
        var step = e.key === "ArrowRight" ? 1 : e.key === "ArrowLeft" ? -1 : 0;
        if (step) {
          e.preventDefault();
          select((i + step + tabs.length) % tabs.length, true);
        }
      });
    });

    var ids = panels.map(function (p) { return p.id; });
    var pick = ids.indexOf(location.hash.slice(1));
    var linked = pick >= 0;
    if (!linked && box.dataset.tabs !== "os") {
      pick = 0;
    } else if (!linked) {
      var ua = navigator.userAgent;
      pick = /Windows/.test(ua) ? 0 : /Macintosh/.test(ua) ? 1 : /Linux|X11/.test(ua) && !/Android/.test(ua) ? 2 : 0;
    }
    list.hidden = false;
    box.classList.add("tabs-on");
    select(pick);
    // 其他系统的内容收起来了，页面变短，重新对准链接指向的位置
    if (linked) box.scrollIntoView();
  });

  // 下载页：猜这台 Mac 是哪种芯片，把对应的按钮放在前面、改成主按钮。
  // 浏览器不直接告诉芯片，只能看显卡型号：Chrome、Firefox 会给出 Intel 或 Apple M…，
  // Safari 只说 Apple GPU，猜不出来就保持默认（Apple 芯片在前）
  var chips = document.querySelector("[data-mac-chip]");
  if (chips && /Macintosh/.test(navigator.userAgent)) {
    try {
      var gl = document.createElement("canvas").getContext("webgl");
      var info = gl && gl.getExtension("WEBGL_debug_renderer_info");
      var gpu = info ? String(gl.getParameter(info.UNMASKED_RENDERER_WEBGL)) : "";
      if (/Intel|AMD|Radeon/i.test(gpu) && !/Apple M/i.test(gpu)) {
        var buttons = chips.querySelectorAll(".button");
        buttons[0].classList.add("quiet");
        buttons[1].classList.remove("quiet");
        chips.insertBefore(buttons[1], buttons[0]);
      }
    } catch (e) {}
  }

  // 外观菜单：默认深色。选择存在 localStorage，由 <head> 里的脚本（反馈页是 platform.js）
  // 在下次打开时先于绘制应用
  var themeButtons = document.querySelectorAll("[data-theme-set]");
  function markTheme() {
    var pref = document.documentElement.getAttribute("data-theme-pref") || "dark";
    themeButtons.forEach(function (b) {
      b.setAttribute("aria-pressed", b.getAttribute("data-theme-set") === pref ? "true" : "false");
    });
  }
  themeButtons.forEach(function (b) {
    b.addEventListener("click", function () {
      if (window.pfSetTheme) window.pfSetTheme(b.getAttribute("data-theme-set"));
      markTheme();
      var menu = b.closest("details");
      if (menu) {
        menu.open = false;
        menu.querySelector("summary").focus();
      }
    });
  });
  markTheme();

  // 语言菜单、外观菜单与「更多」菜单：点菜单外面或按 Esc 收起，打开一个时收起另一个
  var menus = document.querySelectorAll("details.lang, details.menu");
  menus.forEach(function (menu) {
    document.addEventListener("click", function (e) {
      if (menu.open && !menu.contains(e.target)) menu.open = false;
    });
    menu.addEventListener("toggle", function () {
      if (!menu.open) return;
      menus.forEach(function (other) { if (other !== menu) other.open = false; });
    });
    menu.addEventListener("keydown", function (e) {
      if (e.key === "Escape" && menu.open) {
        menu.open = false;
        menu.querySelector("summary").focus();
      }
    });
  });

  // 带 data-reveal 的块滚动到时淡入。没有 IntersectionObserver 的浏览器直接显示
  var reveals = document.querySelectorAll("[data-reveal]");
  if ("IntersectionObserver" in window) {
    var shown = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (!entry.isIntersecting) return;
        entry.target.classList.add("in");
        shown.unobserve(entry.target);
      });
    }, { threshold: 0.18, rootMargin: "0px 0px -8% 0px" });
    reveals.forEach(function (el) { shown.observe(el); });
  } else {
    reveals.forEach(function (el) { el.classList.add("in"); });
  }

  // GitHub Star 按钮上的星数：向 GitHub 取一次，在本地存一小时（GitHub 对不登录的访问每小时限 60 次）。
  // 取不到、或者还不到两位数时只显示 Star，不影响链接
  var stars = document.querySelectorAll("[data-gh-stars]");
  if (stars.length && window.fetch) {
    var show = function (n) {
      if (n < 10) return;
      var text = n >= 1000 ? (n / 1000).toFixed(n >= 10000 ? 0 : 1).replace(/\.0$/, "") + "k" : String(n);
      stars.forEach(function (a) {
        var box = a.querySelector(".gh-count");
        box.querySelector("b").textContent = text;
        box.hidden = false;
      });
    };
    var cached = null;
    try { cached = JSON.parse(localStorage.getItem("pasteferry-stars") || "null"); } catch (e) {}
    if (cached && Date.now() - cached.at < 3600 * 1000) {
      show(cached.n);
    } else {
      fetch("https://api.github.com/repos/baiyuze/pasteferry", { headers: { Accept: "application/vnd.github+json" } })
        .then(function (r) { return r.ok ? r.json() : null; })
        .then(function (d) {
          if (!d || typeof d.stargazers_count !== "number") return;
          show(d.stargazers_count);
          try { localStorage.setItem("pasteferry-stars", JSON.stringify({ n: d.stargazers_count, at: Date.now() })); } catch (e) {}
        })
        .catch(function () {});
    }
  }

  // 选过语言，以后打开首页就直接是这种语言，不再按浏览器语言跳转
  document.querySelectorAll("a[data-lang]").forEach(function (link) {
    link.addEventListener("click", function () {
      try { localStorage.setItem("pasteferry-lang", link.dataset.lang); } catch (e) {}
    });
  });
})();
