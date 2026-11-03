"use strict";

// PasteFerry Tinycast 扩展。
// 直接调用本机通过 Homebrew 安装的 `pasteferry-cli -json`，读取后台 daemon 状态。
// 不依赖任何 HTTP 服务，只要 CLI 在 PATH 上即可。

const React = require("react");
const { List, ActionPanel, Action, Icon, showToast, Toast, Form, getPreferenceValues, confirmAlert } = require("@raycast/api");
const { execFile } = require("node:child_process");

const CLI = "pasteferry-cli";
const REFRESH_MS = 15000;

// ---- 调用本机 pasteferry-cli ----

function runJSON(args) {
  return new Promise((resolve, reject) => {
    execFile(CLI, ["-json", ...args], { timeout: 20000, maxBuffer: 8 * 1024 * 1024 },
      (err, stdout) => {
        if (err) {
          const out = String(stdout || "").trim();
          // CLI 在 JSON 模式下把错误也打成 {"ok":false,"error":"..."}
          if (out.startsWith("{")) {
            try {
              const j = JSON.parse(out);
              if (j && j.error) { reject(new Error(j.error)); return; }
            } catch (e) {}
          }
          reject(err);
          return;
        }
        const out = String(stdout || "").trim();
        try {
          resolve(JSON.parse(out));
        } catch (e) {
          reject(new Error("无法解析 CLI 输出: " + out.slice(0, 200)));
        }
      });
  });
}

async function guard(fn) {
  try {
    return await fn();
  } catch (e) {
    showToast(Toast.Style.Failure, "操作失败", String(e.message || e).slice(0, 200));
    return null;
  }
}

// ---- 工具函数 ----

function formatBytes(mb) {
  if (typeof mb !== "number") return "—";
  if (mb < 1) return Math.round(mb * 1024) + " KB";
  return mb.toFixed(1) + " MB";
}

function formatTime(unix) {
  if (!unix) return "—";
  return new Date(unix * 1000).toLocaleString("zh-CN", {
    month: "numeric", day: "numeric", hour: "2-digit", minute: "2-digit",
  });
}

function connectionText(c) {
  if (!c || c === "OFFLINE") return "离线";
  if (c === "DIRECT") return "直连";
  if (c === "RELAY") return "中转";
  return c.toLowerCase();
}

function platformText(p) {
  if (!p) return "";
  return p === "darwin" ? "macOS" : p === "windows" ? "Windows" : p === "linux" ? "Linux" : p;
}

function kindText(k) {
  if (k === "TEXT") return "文字";
  if (k === "IMAGE") return "图片";
  if (k === "FILE") return "文件";
  return k.toLowerCase();
}

// ---- 主页 ----

function Command() {
  const [status, setStatus] = React.useState(null);
  const [devices, setDevices] = React.useState([]);
  const [history, setHistory] = React.useState([]);
  const [config, setConfig] = React.useState({});
  const [loading, setLoading] = React.useState(true);
  const [daemonDown, setDaemonDown] = React.useState(false);

  const reload = React.useCallback(async () => {
    const [s, d, h, c] = await Promise.all([
      guard(() => runJSON(["status"])),
      guard(() => runJSON(["devices"])),
      guard(() => runJSON(["history"])),
      guard(() => runJSON(["config", "get"])),
    ]);
    if (s === null && d === null && h === null && c === null) {
      setDaemonDown(true);
    } else {
      setDaemonDown(false);
    }
    if (s) setStatus(s.data.daemon || {});
    if (d) setDevices(d.data.peers || []);
    if (h) setHistory(h.data.records || []);
    if (c) setConfig(c || {});
    setLoading(false);
  }, []);

  React.useEffect(() => {
    reload();
    const id = setInterval(reload, REFRESH_MS);
    return () => clearInterval(id);
  }, [reload]);

  if (daemonDown) {
    return React.createElement(
      List,
      null,
      React.createElement(List.EmptyView, {
        icon: Icon.Wifi,
        title: "后台服务未运行",
        description: "请先启动 pasteferryd（例如开机自启的 PasteFerry 后台服务）。",
      })
    );
  }

  const peersOnline = (status && status.peers_online) || 0;
  const cacheMB = (status && status.cache_bytes_used_mb) || 0;

  const items = [];

  // 状态栏
  items.push(React.createElement(List.Item, {
    key: "__status",
    title: (status && status.device_name) || "本机",
    subtitle: "PasteFerry 后台状态",
    icon: Icon.Desktop,
    accessories: [
      { text: "在线 " + peersOnline },
      { text: formatBytes(cacheMB) },
    ],
    actions: React.createElement(ActionPanel, null,
      React.createElement(Action, { title: "刷新", icon: Icon.ArrowClockwise, onAction: reload }),
      React.createElement(Action.CopyToClipboard, { title: "复制设备名", content: (status && status.device_name) || "" }),
    ),
  }));

  // 设备
  items.push(React.createElement(List.Header, { key: "__dh", title: "设备", subtitle: "已配对 / 待配对" }));
  if (devices.length === 0) {
    items.push(React.createElement(List.EmptyView, {
      key: "__de",
      icon: Icon.People,
      title: "暂无设备",
      description: "用「生成配对码」或手机端扫码加入。",
    }));
  } else {
    devices.forEach((device) => {
      const pairing = device.pairing_session || "";
      const actions = [];
      if (pairing) {
        actions.push(React.createElement(Action, {
          key: "confirm",
          title: "确认配对",
          icon: Icon.Check,
          onAction: async () => {
            const r = await guard(() => runJSON(["confirm", pairing]));
            if (r) showToast(Toast.Style.Success, "已确认配对", device.name);
            reload();
          },
        }));
      }
      actions.push(React.createElement(Action, {
        key: "unpair",
        title: "取消配对",
        icon: Icon.Trash,
        onAction: async () => {
          const confirmed = await confirmAlert({
            title: "取消配对",
            message: "取消与 " + device.name + " 的配对？",
            primaryAction: { title: "取消配对" },
          });
          if (!confirmed) return;
          const r = await guard(() => runJSON(["unpair", device.id]));
          if (r) showToast(Toast.Style.Success, "已取消配对", device.name);
          reload();
        },
      }));
      const subtitleParts = [];
      subtitleParts.push(platformText(device.platform) || "未知平台");
      subtitleParts.push(connectionText(device.connection));
      if (pairing) subtitleParts.push("待确认配对");
      if (device.receive_disabled) subtitleParts.push("不收文件");

      items.push(React.createElement(List.Item, {
        key: "dev-" + device.id,
        title: device.name,
        subtitle: subtitleParts.join(" · "),
        icon: pairing ? Icon.Warning : Icon.Desktop,
        accessories: [
          device.online ? { text: "在线" } : { text: "离线", icon: Icon.Moon },
        ],
        actions: React.createElement(ActionPanel, null, actions),
      }));
    });
  }

  // 剪贴板历史
  items.push(React.createElement(List.Header, { key: "__hh", title: "剪贴板历史", subtitle: "共 " + history.length + " 条" }));
  if (history.length === 0) {
    items.push(React.createElement(List.EmptyView, {
      key: "__he",
      icon: Icon.Clipboard,
      title: "没有记录",
      description: "复制或收到内容后会出现在这里。",
    }));
  } else {
    history.forEach((record) => {
      const subtitleParts = [];
      subtitleParts.push(kindText(record.kind));
      subtitleParts.push(record.status === "READY" ? "就绪" : (record.status || "").toLowerCase());
      subtitleParts.push(record.outgoing ? "来自对端" : "本机复制");
      if (record.origin_name) subtitleParts.push("来自 " + record.origin_name);
      if (record.alias) subtitleParts.push("别名 " + record.alias);

      const actions = [];
      actions.push(React.createElement(Action, {
        key: "apply",
        title: record.kind === "TEXT" ? "写回剪贴板(纯文本)" : "写回剪贴板",
        icon: Icon.Clipboard,
        onAction: async () => {
          const r = await guard(() => runJSON(["apply", record.id, record.kind === "TEXT" ? "plain" : ""].filter(Boolean)));
          if (r) showToast(Toast.Style.Success, "已写入剪贴板");
          reload();
        },
      }));
      actions.push(React.createElement(Action, {
        key: "fav",
        title: record.favorited ? "取消收藏" : "收藏",
        icon: record.favorited ? Icon.StarDisabled : Icon.Star,
        onAction: async () => {
          const r = await guard(() => runJSON(["favorite", record.id, record.favorited ? "off" : ""].filter(Boolean)));
          if (r) showToast(Toast.Style.Success, record.favorited ? "已取消收藏" : "已收藏");
          reload();
        },
      }));

      items.push(React.createElement(List.Item, {
        key: "rec-" + record.id,
        title: record.text_preview || "(无预览)",
        subtitle: subtitleParts.join(" · "),
        icon: Icon.Clipboard,
        accessories: [
          { text: formatBytes(record.total_size_mb) },
          { text: formatTime(record.created_at_unix) },
          record.favorite ? { icon: Icon.Star, tooltip: "已收藏" } : null,
        ].filter(Boolean),
        actions: React.createElement(ActionPanel, null, actions),
      }));
    });
  }

  // 配对码
  items.push(React.createElement(List.Header, { key: "__ph", title: "配对码", subtitle: "生成后手机端输入" }));
  items.push(React.createElement(List.Item, {
    key: "__pair",
    title: "生成配对码",
    subtitle: "有效期 5 分钟，含本机局域网地址",
    icon: Icon.Lock,
    actions: React.createElement(ActionPanel, null,
      React.createElement(Action, {
        title: "生成配对码",
        icon: Icon.Lock,
        onAction: async () => {
          const r = await guard(() => runJSON(["pair"]));
          if (r && r.data) {
            const exp = formatTime(r.data.expires_at_unix);
            showToast(Toast.Style.Success, "配对码 " + r.data.code, "有效期至 " + exp);
          }
          reload();
        },
      }),
    ),
  }));

  // 连接配置
  items.push(React.createElement(List.Header, { key: "__ch", title: "连接配置", subtitle: "设备名 / 接收来源 / 局域网发现" }));
  items.push(React.createElement(List.Item, {
    key: "__cfg-name",
    title: "设备名称",
    subtitle: config.device_name || "—",
    icon: Icon.Person,
    actions: React.createElement(ActionPanel, null,
      React.createElement(Action.Push, {
        title: "修改设备名称",
        target: React.createElement(ConfigNameForm, { current: config.device_name || "", onDone: reload }),
      }),
    ),
  }));
  items.push(React.createElement(List.Item, {
    key: "__cfg-receive",
    title: "接收来源",
    subtitle: (config.receive_from || "friends") + (config.receive_disabled ? "（已关闭接收）" : ""),
    icon: Icon.Download,
    actions: React.createElement(ActionPanel, null,
      React.createElement(Action.Push, {
        title: "修改接收来源",
        target: React.createElement(ConfigReceiveForm, { current: config.receive_from || "friends", onDone: reload }),
      }),
    ),
  }));
  items.push(React.createElement(List.Item, {
    key: "__cfg-lan",
    title: "局域网发现",
    subtitle: config.lan_disabled ? "已关闭" : "已开启",
    icon: config.lan_disabled ? Icon.WifiDisabled : Icon.Wifi,
    actions: React.createElement(ActionPanel, null,
      React.createElement(Action, {
        title: config.lan_disabled ? "开启局域网发现" : "关闭局域网发现",
        icon: Icon.Wifi,
        onAction: async () => {
          const next = !config.lan_disabled;
          const r = await guard(() => runJSON(["config", "set", "lan-disabled", next ? "true" : "false"]));
          if (r) showToast(Toast.Style.Success, next ? "已开启局域网发现" : "已关闭局域网发现");
          reload();
        },
      }),
    ),
  }));

  return React.createElement(
    List,
    { isLoading: loading, searchBarPlaceholder: "搜索设备、历史…" },
    items
  );
}

// ---- 配置表单 ----

function ConfigNameForm({ current, onDone }) {
  const [name, setName] = React.useState(current);
  return React.createElement(Form, {
    actions: React.createElement(ActionPanel, null,
      React.createElement(Form.SubmitForm, {
        title: "保存",
        onSubmit: async () => {
          const r = await guard(() => runJSON(["config", "set", "name", name]));
          if (r) showToast(Toast.Style.Success, "已更新设备名称");
          if (onDone) onDone();
        },
      }),
    ),
  },
    React.createElement(Form.TextField, {
      id: "name",
      title: "设备名称",
      placeholder: "例如 我的 MacBook",
      value: name,
      onChange: setName,
      autoFocus: true,
    })
  );
}

function ConfigReceiveForm({ current, onDone }) {
  const [value, setValue] = React.useState(current);
  return React.createElement(Form, {
    actions: React.createElement(ActionPanel, null,
      React.createElement(Form.SubmitForm, {
        title: "保存",
        onSubmit: async () => {
          const r = await guard(() => runJSON(["config", "set", "receive-from", value]));
          if (r) showToast(Toast.Style.Success, "已更新接收来源");
          if (onDone) onDone();
        },
      }),
    ),
  },
    React.createElement(Form.TextField, {
      id: "value",
      title: "接收来源",
      placeholder: "off / friends / everyone",
      info: "off=均不允许，friends=仅好友，everyone=所有人",
      value: value,
      onChange: setValue,
      autoFocus: true,
    })
  );
}

module.exports = { default: Command };
