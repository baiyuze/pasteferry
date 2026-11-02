# typed: strict
# frozen_string_literal: true

# Homebrew formula for the PasteFerry CLI (pasteferry-cli).
#
# 用途：在无 GUI 的精简安装里，用 brew 装/更新 PasteFerry 的命令行客户端。
# 它和 Flutter GUI 走的是同一个 gRPC 接口（client-core/cmd/pasteferry-cli），
# 因此能管理已配对/待配对设备、剪贴板历史、配对码与连接配置。
#
# 安装（tap 后）：
#   brew install baiyuze/tap/pasteferry-cli
#
# 更新（你最关心的）：
#   brew upgrade pasteferry-cli
# 因为 head 指向上游 main，升级时 brew 会拉取新提交重新编译。
#
# 注意：本 formula 只装 CLI，不装后台守护进程 pasteferryd。
# 剪贴板同步需要 pasteferryd 在跑（开机自启的 LaunchAgent）。
# 想纯无头管理设备/历史，可另写 formula 装 pasteferryd；本文件先解决 CLI 的便利安装与更新。

# PasteFerry CLI：PasteFerry 的无图形界面命令行客户端。
#
# 它复用 Flutter GUI 同一套 gRPC 接口（client-core/cmd/pasteferry-cli），
# 可管理已配对/待配对设备、剪贴板历史、配对码与连接配置，方便在无 GUI 的
# 精简安装里使用，并随 brew upgrade 一起更新。
class PasteferryCli < Formula
  desc "PasteFerry 命令行客户端：管理配对设备、剪贴板历史、配对码与连接配置（无 GUI）"
  homepage "https://pasteferry.cc/"
  head "https://github.com/baiyuze/pasteferry.git", branch: "main"
  version "2.8.3"
  license "AGPL-3.0-only"

  depends_on "go" => :build

  def install
    # 以仓库根目录作为 Go workspace，构建 client-core/cmd/pasteferry-cli。
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", "-trimpath", "-ldflags", ldflags,
           "-o", bin/"pasteferry-cli", "./client-core/cmd/pasteferry-cli"
  end

  test do
    # version 子命令不依赖 daemon，是二进制可执行且参数解析正确的最稳校验。
    assert_match version, shell_output("#{bin}/pasteferry-cli version")
  end
end
