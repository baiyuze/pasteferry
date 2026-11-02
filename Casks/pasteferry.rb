# typed: strict
# frozen_string_literal: true

# Homebrew cask for the PasteFerry desktop app (GUI + 后台服务).
#
# 用途：一行命令装好官方 GUI、后台守护进程（pasteferryd）与剪贴板授权组件。
# 官方 dmg 里自带 `PasteFerry.app/Contents/Helpers/pasteferry-cli`，本 cask 通过
# `binary` stanza 把它也暴露到 PATH，所以装 GUI 的同时也拿到命令行客户端。
#
# 安装：
#   brew install baiyuze/tap/pasteferry
# 升级：
#   brew upgrade pasteferry
#
# 只想要命令行、不要 GUI？改用 formula：
#   brew install baiyuze/tap/pasteferry-cli
# 它从源码编译，无 GUI、无头，适合精简安装与自动化。

# PasteFerry：跨设备的剪贴板、复制历史与隔空传送（GUI + 后台服务 + 命令行客户端）。
cask "pasteferry" do
  version "2.8.3"
  sha256 "c9d2afc30b0989d7abc8962eac52e60c1559119db6d84714f501d8aea5452015"

  url "https://github.com/baiyuze/pasteferry/releases/download/v#{version}/PasteFerry.dmg",
      verified: "github.com/baiyuze/pasteferry/releases/"
  name "PasteFerry"
  desc "跨设备剪贴板、复制历史与隔空传送（GUI + 后台服务 + 命令行客户端）"
  homepage "https://pasteferry.cc/"

  livecheck do
    url "https://github.com/baiyuze/pasteferry/releases/latest"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :page_match
  end

  depends_on macos: :ventura

  app "PasteFerry.app"
  # 官方 app 自带命令行客户端；暴露到 PATH 后，GUI 与 CLI 共用同一套后台服务。
  binary "PasteFerry.app/Contents/Helpers/pasteferry-cli", target: "pasteferry-cli"

  zap trash: [
    "~/Library/Application Support/PasteFerry",
    "~/Library/Caches/com.pasteferry.app",
    "~/Library/Group Containers/*.com.pasteferry.app",
    "~/Library/HTTPStorages/com.pasteferry.app",
    "~/Library/LaunchAgents/com.pasteferry.app.daemon.plist",
    "~/Library/LaunchAgents/com.pasteferry.app.startup.plist",
    "~/Library/Preferences/com.pasteferry.app.plist",
  ]
end
