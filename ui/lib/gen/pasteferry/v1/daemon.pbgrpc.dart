// This is a generated file - do not edit.
//
// Generated from pasteferry/v1/daemon.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'daemon.pb.dart' as $0;

export 'daemon.pb.dart';

@$pb.GrpcServiceName('pasteferry.v1.DaemonService')
class DaemonServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  DaemonServiceClient(super.channel, {super.options, super.interceptors});

  /// 订阅事件流。UI 启动后第一件事，断线需重连。
  $grpc.ResponseStream<$0.Event> subscribe(
    $0.SubscribeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$subscribe, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseFuture<$0.ListHistoryResponse> listHistory(
    $0.ListHistoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listHistory, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> deleteHistory(
    $0.DeleteHistoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteHistory, request, options: options);
  }

  /// 拉取仅有元数据的大文件记录。立即返回，进度走事件流。
  $grpc.ResponseFuture<$0.Empty> fetch(
    $0.FetchRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$fetch, request, options: options);
  }

  /// 把某条已就绪的记录重新放进本机剪贴板
  $grpc.ResponseFuture<$0.Empty> applyToClipboard(
    $0.ApplyToClipboardRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$applyToClipboard, request, options: options);
  }

  /// 只返回已就绪图片（或图片文件）在本机的路径，不改动剪贴板，也不把路径发给对端。
  $grpc.ResponseFuture<$0.GetImagePreviewResponse> getImagePreview(
    $0.GetImagePreviewRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getImagePreview, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListDevicesResponse> listDevices(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listDevices, request, options: options);
  }

  $grpc.ResponseFuture<$0.CreatePairingCodeResponse> createPairingCode(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createPairingCode, request, options: options);
  }

  $grpc.ResponseFuture<$0.RedeemPairingCodeResponse> redeemPairingCode(
    $0.RedeemPairingCodeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$redeemPairingCode, request, options: options);
  }

  /// 配对双方各自确认指纹后才真正互信
  $grpc.ResponseFuture<$0.Empty> confirmPairing(
    $0.ConfirmPairingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$confirmPairing, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> unpair(
    $0.UnpairRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$unpair, request, options: options);
  }

  /// 重新连接：已是直连时什么也不做；否则马上再试一次直连，打不通照旧走中转。
  /// 最多等十几秒，返回那时的连接状态
  $grpc.ResponseFuture<$0.ReconnectResponse> reconnect(
    $0.ReconnectRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$reconnect, request, options: options);
  }

  /// 手动告诉后台服务某台设备的局域网地址：跨网段、或两边都换了地址时用
  $grpc.ResponseFuture<$0.Empty> setDeviceAddress(
    $0.SetDeviceAddressRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setDeviceAddress, request, options: options);
  }

  /// 「搜索附近设备」窗口打开期间保持这个调用，窗口关掉时取消。期间本机在局域网里公开设备名，
  /// 并在附近同样打开了这个窗口的设备有变化时推送最新的列表
  $grpc.ResponseStream<$0.NearbyDevices> watchNearby(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$watchNearby, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// 向附近的一台设备发起配对。之后与 RedeemPairingCode 一样，双方核对指纹后各自 ConfirmPairing
  $grpc.ResponseFuture<$0.RedeemPairingCodeResponse> pairNearby(
    $0.PairNearbyRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$pairNearby, request, options: options);
  }

  $grpc.ResponseFuture<$0.Config> getConfig(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getConfig, request, options: options);
  }

  $grpc.ResponseFuture<$0.Config> updateConfig(
    $0.Config request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateConfig, request, options: options);
  }

  $grpc.ResponseFuture<$0.Status> getStatus(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getStatus, request, options: options);
  }

  /// 引导用户授予剪贴板权限（打开系统设置面板）
  $grpc.ResponseFuture<$0.Empty> requestClipboardPermission(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$requestClipboardPermission, request,
        options: options);
  }

  /// 让系统放行局域网访问：macOS 打开「本地网络」设置面板；
  /// Windows 申请管理员权限，在防火墙里放行后台服务。其他平台返回 UNIMPLEMENTED。
  $grpc.ResponseFuture<$0.Empty> requestLocalNetworkPermission(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$requestLocalNetworkPermission, request,
        options: options);
  }

  /// These belong to the background service, which also notifies with the UI closed.
  $grpc.ResponseFuture<$0.NotificationStatus> getNotificationStatus(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getNotificationStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.NotificationStatus> requestNotificationPermission(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$requestNotificationPermission, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.Empty> activateNotification(
    $0.NotificationAction request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$activateNotification, request, options: options);
  }

  /// 网络出口与打洞诊断：本机有几个出口、各自的公网地址，见 pasteferry-cli nat
  $grpc.ResponseFuture<$0.NetworkInfo> getNetwork(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getNetwork, request, options: options);
  }

  /// 反馈问题用的诊断报告：版本、系统、设置、设备与网络状态、最近的日志。
  /// 设备名、服务器地址、公网 IP、用户目录、文件名已换成占位符，用户看过后自己贴进 issue
  $grpc.ResponseFuture<$0.Diagnostics> exportDiagnostics(
    $0.ExportDiagnosticsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$exportDiagnostics, request, options: options);
  }

  /// 临时打开详细日志（调试级别），到时间自动关回去；minutes 为 0 立即关闭
  $grpc.ResponseFuture<$0.Status> setVerboseLog(
    $0.SetVerboseLogRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setVerboseLog, request, options: options);
  }

  /// 检查更新：从 GitHub 与 Gitee 同时取更新清单，验签后返回比当前新的各版更新日志。见 design/auto-update.md
  $grpc.ResponseFuture<$0.UpdateInfo> checkForUpdate(
    $0.CheckForUpdateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$checkForUpdate, request, options: options);
  }

  /// 下载并校验最近一次检查到的新版本。取消调用即停止下载
  $grpc.ResponseStream<$0.UpdateProgress> downloadUpdate(
    $0.DownloadUpdateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$downloadUpdate, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// 准备好新版本并启动更新助手。返回后界面应当立即退出：助手等它退出后替换文件，再重新打开
  $grpc.ResponseFuture<$0.Empty> installUpdate(
    $0.InstallUpdateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$installUpdate, request, options: options);
  }

  /// 收藏或取消收藏，见 design/quick-paste-and-favorites.md 第 3 节。
  /// 收藏时另存一份，返回新的收藏记录；取消时把收藏放回复制记录的最上面，返回放回去的那一条。
  /// 过程中照常推送 clip_added / clip_removed。已过期或已失败的图片、文件返回 FAILED_PRECONDITION
  $grpc.ResponseFuture<$0.ClipRecord> setFavorite(
    $0.SetFavoriteRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setFavorite, request, options: options);
  }

  /// 悬停提示框要显示的完整内容。ClipRecord 的 text_preview 最多 120 个字、换行被压平，不够用
  $grpc.ResponseFuture<$0.ClipDetail> getClipDetail(
    $0.GetClipDetailRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getClipDetail, request, options: options);
  }

  /// 给收藏起个别名，列表里显示别名、搜索也认它。alias 为空表示去掉别名
  $grpc.ResponseFuture<$0.ClipRecord> setAlias(
    $0.SetAliasRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setAlias, request, options: options);
  }

  /// 快捷粘贴窗口进程启动后一直保持这个调用：往上报自己的状态，往下收设置页发来的命令。
  /// 调用断开就当作快捷窗口没在运行
  $grpc.ResponseStream<$0.QuickPasteCommand> quickPasteSession(
    $async.Stream<$0.QuickPasteStatus> request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$quickPasteSession, request, options: options);
  }

  /// 设置页读快捷窗口的状态；状态变化时另有 quick_paste_changed 事件
  $grpc.ResponseFuture<$0.QuickPasteStatus> getQuickPasteStatus(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getQuickPasteStatus, request, options: options);
  }

  /// 设置页转给快捷窗口的命令。快捷窗口没在运行时返回 FAILED_PRECONDITION
  $grpc.ResponseFuture<$0.Empty> sendQuickPasteCommand(
    $0.QuickPasteCommand request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendQuickPasteCommand, request, options: options);
  }

  /// ── 隔空传送：把文件直接发给某一台设备，见 design/send-files.md ──
  /// 发给一台设备。立即返回这一批的记录，之后的状态与进度走 transfer_changed 事件。
  /// 对方不在线或不支持时返回 FAILED_PRECONDITION；路径不存在返回 INVALID_ARGUMENT。
  /// 要经官方服务中转而 allow_relay 为 false 时返回 FAILED_PRECONDITION，消息为 "relay"，界面确认后再调一次
  $grpc.ResponseFuture<$0.Transfer> sendFiles(
    $0.SendFilesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendFiles, request, options: options);
  }

  /// 取消一批（发出的或收到的都可以），两边都停下
  $grpc.ResponseFuture<$0.Empty> cancelTransfer(
    $0.TransferRef request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$cancelTransfer, request, options: options);
  }

  /// 发出的、已中断的一批从断点继续；对方已清掉没收完的部分时从头再发
  $grpc.ResponseFuture<$0.Empty> resumeTransfer(
    $0.TransferRef request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resumeTransfer, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListTransfersResponse> listTransfers(
    $0.ListTransfersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listTransfers, request, options: options);
  }

  /// 只删记录，不删文件；进行中的不删
  $grpc.ResponseFuture<$0.Empty> deleteTransfers(
    $0.DeleteTransfersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteTransfers, request, options: options);
  }

  /// 打开隔空传送页时调用：收到的都标为看过，侧边栏的数字清零
  $grpc.ResponseFuture<$0.Empty> markTransfersSeen(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$markTransfersSeen, request, options: options);
  }

  /// 检查保存位置能否写入。path 为空时检查当前设置的位置。
  /// 在 macOS 上会在这时触发系统的文件夹授权弹窗，所以要在用户看着界面时调用
  $grpc.ResponseFuture<$0.CheckReceiveDirResponse> checkReceiveDir(
    $0.CheckReceiveDirRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$checkReceiveDir, request, options: options);
  }

  /// 别人发来的、在等用户接受的一批：接受或拒绝。always 表示以后自动接收这个好友的文件
  $grpc.ResponseFuture<$0.Empty> answerIncoming(
    $0.AnswerIncomingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$answerIncoming, request, options: options);
  }

  /// ── 好友，见 design/friends-send.md ──
  $grpc.ResponseFuture<$0.Profile> getProfile(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getProfile, request, options: options);
  }

  $grpc.ResponseFuture<$0.Profile> setDisplayName(
    $0.SetDisplayNameRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setDisplayName, request, options: options);
  }

  /// 设置头像：图片文件或剪贴板里的图片，按裁剪区域裁成正方形，处理成 256×256 的 JPEG
  $grpc.ResponseFuture<$0.Profile> setAvatar(
    $0.SetAvatarRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setAvatar, request, options: options);
  }

  $grpc.ResponseFuture<$0.Profile> resetAvatar(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resetAvatar, request, options: options);
  }

  /// 本机或某个好友的头像（JPEG）。没有自定义头像时为空
  $grpc.ResponseFuture<$0.Avatar> getAvatar(
    $0.GetAvatarRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAvatar, request, options: options);
  }

  /// 生成好友码（F 加 6 位），5 分钟有效。别人兑换后推送 friend_request 事件
  $grpc.ResponseFuture<$0.CreatePairingCodeResponse> createFriendCode(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createFriendCode, request, options: options);
  }

  /// 输入好友码，返回对方的名片和会话；用户在确认框里点了以后调 ConfirmFriend
  $grpc.ResponseFuture<$0.FriendRequest> redeemFriendCode(
    $0.RedeemPairingCodeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$redeemFriendCode, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> confirmFriend(
    $0.ConfirmPairingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$confirmFriend, request, options: options);
  }

  $grpc.ResponseFuture<$0.ListFriendsResponse> listFriends(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listFriends, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> removeFriend(
    $0.FriendRef request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removeFriend, request, options: options);
  }

  $grpc.ResponseFuture<$0.Friend> setFriendAutoAccept(
    $0.SetFriendAutoAcceptRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setFriendAutoAccept, request, options: options);
  }

  /// 「所有人」模式下拒绝过的陌生设备，以后它的请求直接拒绝
  $grpc.ResponseFuture<$0.Empty> blockDevice(
    $0.FriendRef request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$blockDevice, request, options: options);
  }

  /// 隔空传送页打开期间保持这个调用：推送附近开着「所有人」的陌生设备（只在局域网里）
  $grpc.ResponseStream<$0.Strangers> watchStrangers(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$watchStrangers, $async.Stream.fromIterable([request]),
        options: options);
  }

  // method descriptors

  static final _$subscribe = $grpc.ClientMethod<$0.SubscribeRequest, $0.Event>(
      '/pasteferry.v1.DaemonService/Subscribe',
      ($0.SubscribeRequest value) => value.writeToBuffer(),
      $0.Event.fromBuffer);
  static final _$listHistory =
      $grpc.ClientMethod<$0.ListHistoryRequest, $0.ListHistoryResponse>(
          '/pasteferry.v1.DaemonService/ListHistory',
          ($0.ListHistoryRequest value) => value.writeToBuffer(),
          $0.ListHistoryResponse.fromBuffer);
  static final _$deleteHistory =
      $grpc.ClientMethod<$0.DeleteHistoryRequest, $0.Empty>(
          '/pasteferry.v1.DaemonService/DeleteHistory',
          ($0.DeleteHistoryRequest value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
  static final _$fetch = $grpc.ClientMethod<$0.FetchRequest, $0.Empty>(
      '/pasteferry.v1.DaemonService/Fetch',
      ($0.FetchRequest value) => value.writeToBuffer(),
      $0.Empty.fromBuffer);
  static final _$applyToClipboard =
      $grpc.ClientMethod<$0.ApplyToClipboardRequest, $0.Empty>(
          '/pasteferry.v1.DaemonService/ApplyToClipboard',
          ($0.ApplyToClipboardRequest value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
  static final _$getImagePreview =
      $grpc.ClientMethod<$0.GetImagePreviewRequest, $0.GetImagePreviewResponse>(
          '/pasteferry.v1.DaemonService/GetImagePreview',
          ($0.GetImagePreviewRequest value) => value.writeToBuffer(),
          $0.GetImagePreviewResponse.fromBuffer);
  static final _$listDevices =
      $grpc.ClientMethod<$0.Empty, $0.ListDevicesResponse>(
          '/pasteferry.v1.DaemonService/ListDevices',
          ($0.Empty value) => value.writeToBuffer(),
          $0.ListDevicesResponse.fromBuffer);
  static final _$createPairingCode =
      $grpc.ClientMethod<$0.Empty, $0.CreatePairingCodeResponse>(
          '/pasteferry.v1.DaemonService/CreatePairingCode',
          ($0.Empty value) => value.writeToBuffer(),
          $0.CreatePairingCodeResponse.fromBuffer);
  static final _$redeemPairingCode = $grpc.ClientMethod<
          $0.RedeemPairingCodeRequest, $0.RedeemPairingCodeResponse>(
      '/pasteferry.v1.DaemonService/RedeemPairingCode',
      ($0.RedeemPairingCodeRequest value) => value.writeToBuffer(),
      $0.RedeemPairingCodeResponse.fromBuffer);
  static final _$confirmPairing =
      $grpc.ClientMethod<$0.ConfirmPairingRequest, $0.Empty>(
          '/pasteferry.v1.DaemonService/ConfirmPairing',
          ($0.ConfirmPairingRequest value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
  static final _$unpair = $grpc.ClientMethod<$0.UnpairRequest, $0.Empty>(
      '/pasteferry.v1.DaemonService/Unpair',
      ($0.UnpairRequest value) => value.writeToBuffer(),
      $0.Empty.fromBuffer);
  static final _$reconnect =
      $grpc.ClientMethod<$0.ReconnectRequest, $0.ReconnectResponse>(
          '/pasteferry.v1.DaemonService/Reconnect',
          ($0.ReconnectRequest value) => value.writeToBuffer(),
          $0.ReconnectResponse.fromBuffer);
  static final _$setDeviceAddress =
      $grpc.ClientMethod<$0.SetDeviceAddressRequest, $0.Empty>(
          '/pasteferry.v1.DaemonService/SetDeviceAddress',
          ($0.SetDeviceAddressRequest value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
  static final _$watchNearby = $grpc.ClientMethod<$0.Empty, $0.NearbyDevices>(
      '/pasteferry.v1.DaemonService/WatchNearby',
      ($0.Empty value) => value.writeToBuffer(),
      $0.NearbyDevices.fromBuffer);
  static final _$pairNearby =
      $grpc.ClientMethod<$0.PairNearbyRequest, $0.RedeemPairingCodeResponse>(
          '/pasteferry.v1.DaemonService/PairNearby',
          ($0.PairNearbyRequest value) => value.writeToBuffer(),
          $0.RedeemPairingCodeResponse.fromBuffer);
  static final _$getConfig = $grpc.ClientMethod<$0.Empty, $0.Config>(
      '/pasteferry.v1.DaemonService/GetConfig',
      ($0.Empty value) => value.writeToBuffer(),
      $0.Config.fromBuffer);
  static final _$updateConfig = $grpc.ClientMethod<$0.Config, $0.Config>(
      '/pasteferry.v1.DaemonService/UpdateConfig',
      ($0.Config value) => value.writeToBuffer(),
      $0.Config.fromBuffer);
  static final _$getStatus = $grpc.ClientMethod<$0.Empty, $0.Status>(
      '/pasteferry.v1.DaemonService/GetStatus',
      ($0.Empty value) => value.writeToBuffer(),
      $0.Status.fromBuffer);
  static final _$requestClipboardPermission =
      $grpc.ClientMethod<$0.Empty, $0.Empty>(
          '/pasteferry.v1.DaemonService/RequestClipboardPermission',
          ($0.Empty value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
  static final _$requestLocalNetworkPermission =
      $grpc.ClientMethod<$0.Empty, $0.Empty>(
          '/pasteferry.v1.DaemonService/RequestLocalNetworkPermission',
          ($0.Empty value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
  static final _$getNotificationStatus =
      $grpc.ClientMethod<$0.Empty, $0.NotificationStatus>(
          '/pasteferry.v1.DaemonService/GetNotificationStatus',
          ($0.Empty value) => value.writeToBuffer(),
          $0.NotificationStatus.fromBuffer);
  static final _$requestNotificationPermission =
      $grpc.ClientMethod<$0.Empty, $0.NotificationStatus>(
          '/pasteferry.v1.DaemonService/RequestNotificationPermission',
          ($0.Empty value) => value.writeToBuffer(),
          $0.NotificationStatus.fromBuffer);
  static final _$activateNotification =
      $grpc.ClientMethod<$0.NotificationAction, $0.Empty>(
          '/pasteferry.v1.DaemonService/ActivateNotification',
          ($0.NotificationAction value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
  static final _$getNetwork = $grpc.ClientMethod<$0.Empty, $0.NetworkInfo>(
      '/pasteferry.v1.DaemonService/GetNetwork',
      ($0.Empty value) => value.writeToBuffer(),
      $0.NetworkInfo.fromBuffer);
  static final _$exportDiagnostics =
      $grpc.ClientMethod<$0.ExportDiagnosticsRequest, $0.Diagnostics>(
          '/pasteferry.v1.DaemonService/ExportDiagnostics',
          ($0.ExportDiagnosticsRequest value) => value.writeToBuffer(),
          $0.Diagnostics.fromBuffer);
  static final _$setVerboseLog =
      $grpc.ClientMethod<$0.SetVerboseLogRequest, $0.Status>(
          '/pasteferry.v1.DaemonService/SetVerboseLog',
          ($0.SetVerboseLogRequest value) => value.writeToBuffer(),
          $0.Status.fromBuffer);
  static final _$checkForUpdate =
      $grpc.ClientMethod<$0.CheckForUpdateRequest, $0.UpdateInfo>(
          '/pasteferry.v1.DaemonService/CheckForUpdate',
          ($0.CheckForUpdateRequest value) => value.writeToBuffer(),
          $0.UpdateInfo.fromBuffer);
  static final _$downloadUpdate =
      $grpc.ClientMethod<$0.DownloadUpdateRequest, $0.UpdateProgress>(
          '/pasteferry.v1.DaemonService/DownloadUpdate',
          ($0.DownloadUpdateRequest value) => value.writeToBuffer(),
          $0.UpdateProgress.fromBuffer);
  static final _$installUpdate =
      $grpc.ClientMethod<$0.InstallUpdateRequest, $0.Empty>(
          '/pasteferry.v1.DaemonService/InstallUpdate',
          ($0.InstallUpdateRequest value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
  static final _$setFavorite =
      $grpc.ClientMethod<$0.SetFavoriteRequest, $0.ClipRecord>(
          '/pasteferry.v1.DaemonService/SetFavorite',
          ($0.SetFavoriteRequest value) => value.writeToBuffer(),
          $0.ClipRecord.fromBuffer);
  static final _$getClipDetail =
      $grpc.ClientMethod<$0.GetClipDetailRequest, $0.ClipDetail>(
          '/pasteferry.v1.DaemonService/GetClipDetail',
          ($0.GetClipDetailRequest value) => value.writeToBuffer(),
          $0.ClipDetail.fromBuffer);
  static final _$setAlias =
      $grpc.ClientMethod<$0.SetAliasRequest, $0.ClipRecord>(
          '/pasteferry.v1.DaemonService/SetAlias',
          ($0.SetAliasRequest value) => value.writeToBuffer(),
          $0.ClipRecord.fromBuffer);
  static final _$quickPasteSession =
      $grpc.ClientMethod<$0.QuickPasteStatus, $0.QuickPasteCommand>(
          '/pasteferry.v1.DaemonService/QuickPasteSession',
          ($0.QuickPasteStatus value) => value.writeToBuffer(),
          $0.QuickPasteCommand.fromBuffer);
  static final _$getQuickPasteStatus =
      $grpc.ClientMethod<$0.Empty, $0.QuickPasteStatus>(
          '/pasteferry.v1.DaemonService/GetQuickPasteStatus',
          ($0.Empty value) => value.writeToBuffer(),
          $0.QuickPasteStatus.fromBuffer);
  static final _$sendQuickPasteCommand =
      $grpc.ClientMethod<$0.QuickPasteCommand, $0.Empty>(
          '/pasteferry.v1.DaemonService/SendQuickPasteCommand',
          ($0.QuickPasteCommand value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
  static final _$sendFiles =
      $grpc.ClientMethod<$0.SendFilesRequest, $0.Transfer>(
          '/pasteferry.v1.DaemonService/SendFiles',
          ($0.SendFilesRequest value) => value.writeToBuffer(),
          $0.Transfer.fromBuffer);
  static final _$cancelTransfer = $grpc.ClientMethod<$0.TransferRef, $0.Empty>(
      '/pasteferry.v1.DaemonService/CancelTransfer',
      ($0.TransferRef value) => value.writeToBuffer(),
      $0.Empty.fromBuffer);
  static final _$resumeTransfer = $grpc.ClientMethod<$0.TransferRef, $0.Empty>(
      '/pasteferry.v1.DaemonService/ResumeTransfer',
      ($0.TransferRef value) => value.writeToBuffer(),
      $0.Empty.fromBuffer);
  static final _$listTransfers =
      $grpc.ClientMethod<$0.ListTransfersRequest, $0.ListTransfersResponse>(
          '/pasteferry.v1.DaemonService/ListTransfers',
          ($0.ListTransfersRequest value) => value.writeToBuffer(),
          $0.ListTransfersResponse.fromBuffer);
  static final _$deleteTransfers =
      $grpc.ClientMethod<$0.DeleteTransfersRequest, $0.Empty>(
          '/pasteferry.v1.DaemonService/DeleteTransfers',
          ($0.DeleteTransfersRequest value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
  static final _$markTransfersSeen = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/pasteferry.v1.DaemonService/MarkTransfersSeen',
      ($0.Empty value) => value.writeToBuffer(),
      $0.Empty.fromBuffer);
  static final _$checkReceiveDir =
      $grpc.ClientMethod<$0.CheckReceiveDirRequest, $0.CheckReceiveDirResponse>(
          '/pasteferry.v1.DaemonService/CheckReceiveDir',
          ($0.CheckReceiveDirRequest value) => value.writeToBuffer(),
          $0.CheckReceiveDirResponse.fromBuffer);
  static final _$answerIncoming =
      $grpc.ClientMethod<$0.AnswerIncomingRequest, $0.Empty>(
          '/pasteferry.v1.DaemonService/AnswerIncoming',
          ($0.AnswerIncomingRequest value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
  static final _$getProfile = $grpc.ClientMethod<$0.Empty, $0.Profile>(
      '/pasteferry.v1.DaemonService/GetProfile',
      ($0.Empty value) => value.writeToBuffer(),
      $0.Profile.fromBuffer);
  static final _$setDisplayName =
      $grpc.ClientMethod<$0.SetDisplayNameRequest, $0.Profile>(
          '/pasteferry.v1.DaemonService/SetDisplayName',
          ($0.SetDisplayNameRequest value) => value.writeToBuffer(),
          $0.Profile.fromBuffer);
  static final _$setAvatar =
      $grpc.ClientMethod<$0.SetAvatarRequest, $0.Profile>(
          '/pasteferry.v1.DaemonService/SetAvatar',
          ($0.SetAvatarRequest value) => value.writeToBuffer(),
          $0.Profile.fromBuffer);
  static final _$resetAvatar = $grpc.ClientMethod<$0.Empty, $0.Profile>(
      '/pasteferry.v1.DaemonService/ResetAvatar',
      ($0.Empty value) => value.writeToBuffer(),
      $0.Profile.fromBuffer);
  static final _$getAvatar = $grpc.ClientMethod<$0.GetAvatarRequest, $0.Avatar>(
      '/pasteferry.v1.DaemonService/GetAvatar',
      ($0.GetAvatarRequest value) => value.writeToBuffer(),
      $0.Avatar.fromBuffer);
  static final _$createFriendCode =
      $grpc.ClientMethod<$0.Empty, $0.CreatePairingCodeResponse>(
          '/pasteferry.v1.DaemonService/CreateFriendCode',
          ($0.Empty value) => value.writeToBuffer(),
          $0.CreatePairingCodeResponse.fromBuffer);
  static final _$redeemFriendCode =
      $grpc.ClientMethod<$0.RedeemPairingCodeRequest, $0.FriendRequest>(
          '/pasteferry.v1.DaemonService/RedeemFriendCode',
          ($0.RedeemPairingCodeRequest value) => value.writeToBuffer(),
          $0.FriendRequest.fromBuffer);
  static final _$confirmFriend =
      $grpc.ClientMethod<$0.ConfirmPairingRequest, $0.Empty>(
          '/pasteferry.v1.DaemonService/ConfirmFriend',
          ($0.ConfirmPairingRequest value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
  static final _$listFriends =
      $grpc.ClientMethod<$0.Empty, $0.ListFriendsResponse>(
          '/pasteferry.v1.DaemonService/ListFriends',
          ($0.Empty value) => value.writeToBuffer(),
          $0.ListFriendsResponse.fromBuffer);
  static final _$removeFriend = $grpc.ClientMethod<$0.FriendRef, $0.Empty>(
      '/pasteferry.v1.DaemonService/RemoveFriend',
      ($0.FriendRef value) => value.writeToBuffer(),
      $0.Empty.fromBuffer);
  static final _$setFriendAutoAccept =
      $grpc.ClientMethod<$0.SetFriendAutoAcceptRequest, $0.Friend>(
          '/pasteferry.v1.DaemonService/SetFriendAutoAccept',
          ($0.SetFriendAutoAcceptRequest value) => value.writeToBuffer(),
          $0.Friend.fromBuffer);
  static final _$blockDevice = $grpc.ClientMethod<$0.FriendRef, $0.Empty>(
      '/pasteferry.v1.DaemonService/BlockDevice',
      ($0.FriendRef value) => value.writeToBuffer(),
      $0.Empty.fromBuffer);
  static final _$watchStrangers = $grpc.ClientMethod<$0.Empty, $0.Strangers>(
      '/pasteferry.v1.DaemonService/WatchStrangers',
      ($0.Empty value) => value.writeToBuffer(),
      $0.Strangers.fromBuffer);
}

@$pb.GrpcServiceName('pasteferry.v1.DaemonService')
abstract class DaemonServiceBase extends $grpc.Service {
  $core.String get $name => 'pasteferry.v1.DaemonService';

  DaemonServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SubscribeRequest, $0.Event>(
        'Subscribe',
        subscribe_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.SubscribeRequest.fromBuffer(value),
        ($0.Event value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListHistoryRequest, $0.ListHistoryResponse>(
            'ListHistory',
            listHistory_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListHistoryRequest.fromBuffer(value),
            ($0.ListHistoryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteHistoryRequest, $0.Empty>(
        'DeleteHistory',
        deleteHistory_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteHistoryRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FetchRequest, $0.Empty>(
        'Fetch',
        fetch_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FetchRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ApplyToClipboardRequest, $0.Empty>(
        'ApplyToClipboard',
        applyToClipboard_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ApplyToClipboardRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetImagePreviewRequest,
            $0.GetImagePreviewResponse>(
        'GetImagePreview',
        getImagePreview_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetImagePreviewRequest.fromBuffer(value),
        ($0.GetImagePreviewResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.ListDevicesResponse>(
        'ListDevices',
        listDevices_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.ListDevicesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.CreatePairingCodeResponse>(
        'CreatePairingCode',
        createPairingCode_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.CreatePairingCodeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RedeemPairingCodeRequest,
            $0.RedeemPairingCodeResponse>(
        'RedeemPairingCode',
        redeemPairingCode_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RedeemPairingCodeRequest.fromBuffer(value),
        ($0.RedeemPairingCodeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ConfirmPairingRequest, $0.Empty>(
        'ConfirmPairing',
        confirmPairing_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ConfirmPairingRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UnpairRequest, $0.Empty>(
        'Unpair',
        unpair_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UnpairRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReconnectRequest, $0.ReconnectResponse>(
        'Reconnect',
        reconnect_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ReconnectRequest.fromBuffer(value),
        ($0.ReconnectResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetDeviceAddressRequest, $0.Empty>(
        'SetDeviceAddress',
        setDeviceAddress_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SetDeviceAddressRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.NearbyDevices>(
        'WatchNearby',
        watchNearby_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.NearbyDevices value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.PairNearbyRequest, $0.RedeemPairingCodeResponse>(
            'PairNearby',
            pairNearby_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.PairNearbyRequest.fromBuffer(value),
            ($0.RedeemPairingCodeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Config>(
        'GetConfig',
        getConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Config value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Config, $0.Config>(
        'UpdateConfig',
        updateConfig_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Config.fromBuffer(value),
        ($0.Config value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Status>(
        'GetStatus',
        getStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'RequestClipboardPermission',
        requestClipboardPermission_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'RequestLocalNetworkPermission',
        requestLocalNetworkPermission_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.NotificationStatus>(
        'GetNotificationStatus',
        getNotificationStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.NotificationStatus value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.NotificationStatus>(
        'RequestNotificationPermission',
        requestNotificationPermission_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.NotificationStatus value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.NotificationAction, $0.Empty>(
        'ActivateNotification',
        activateNotification_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.NotificationAction.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.NetworkInfo>(
        'GetNetwork',
        getNetwork_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.NetworkInfo value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ExportDiagnosticsRequest, $0.Diagnostics>(
        'ExportDiagnostics',
        exportDiagnostics_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ExportDiagnosticsRequest.fromBuffer(value),
        ($0.Diagnostics value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetVerboseLogRequest, $0.Status>(
        'SetVerboseLog',
        setVerboseLog_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SetVerboseLogRequest.fromBuffer(value),
        ($0.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CheckForUpdateRequest, $0.UpdateInfo>(
        'CheckForUpdate',
        checkForUpdate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CheckForUpdateRequest.fromBuffer(value),
        ($0.UpdateInfo value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DownloadUpdateRequest, $0.UpdateProgress>(
        'DownloadUpdate',
        downloadUpdate_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.DownloadUpdateRequest.fromBuffer(value),
        ($0.UpdateProgress value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.InstallUpdateRequest, $0.Empty>(
        'InstallUpdate',
        installUpdate_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.InstallUpdateRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetFavoriteRequest, $0.ClipRecord>(
        'SetFavorite',
        setFavorite_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SetFavoriteRequest.fromBuffer(value),
        ($0.ClipRecord value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetClipDetailRequest, $0.ClipDetail>(
        'GetClipDetail',
        getClipDetail_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetClipDetailRequest.fromBuffer(value),
        ($0.ClipDetail value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetAliasRequest, $0.ClipRecord>(
        'SetAlias',
        setAlias_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SetAliasRequest.fromBuffer(value),
        ($0.ClipRecord value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QuickPasteStatus, $0.QuickPasteCommand>(
        'QuickPasteSession',
        quickPasteSession,
        true,
        true,
        ($core.List<$core.int> value) => $0.QuickPasteStatus.fromBuffer(value),
        ($0.QuickPasteCommand value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.QuickPasteStatus>(
        'GetQuickPasteStatus',
        getQuickPasteStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.QuickPasteStatus value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QuickPasteCommand, $0.Empty>(
        'SendQuickPasteCommand',
        sendQuickPasteCommand_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.QuickPasteCommand.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SendFilesRequest, $0.Transfer>(
        'SendFiles',
        sendFiles_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SendFilesRequest.fromBuffer(value),
        ($0.Transfer value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TransferRef, $0.Empty>(
        'CancelTransfer',
        cancelTransfer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.TransferRef.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TransferRef, $0.Empty>(
        'ResumeTransfer',
        resumeTransfer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.TransferRef.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListTransfersRequest, $0.ListTransfersResponse>(
            'ListTransfers',
            listTransfers_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListTransfersRequest.fromBuffer(value),
            ($0.ListTransfersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteTransfersRequest, $0.Empty>(
        'DeleteTransfers',
        deleteTransfers_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteTransfersRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'MarkTransfersSeen',
        markTransfersSeen_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CheckReceiveDirRequest,
            $0.CheckReceiveDirResponse>(
        'CheckReceiveDir',
        checkReceiveDir_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CheckReceiveDirRequest.fromBuffer(value),
        ($0.CheckReceiveDirResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AnswerIncomingRequest, $0.Empty>(
        'AnswerIncoming',
        answerIncoming_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AnswerIncomingRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Profile>(
        'GetProfile',
        getProfile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Profile value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetDisplayNameRequest, $0.Profile>(
        'SetDisplayName',
        setDisplayName_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SetDisplayNameRequest.fromBuffer(value),
        ($0.Profile value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetAvatarRequest, $0.Profile>(
        'SetAvatar',
        setAvatar_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SetAvatarRequest.fromBuffer(value),
        ($0.Profile value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Profile>(
        'ResetAvatar',
        resetAvatar_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Profile value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetAvatarRequest, $0.Avatar>(
        'GetAvatar',
        getAvatar_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetAvatarRequest.fromBuffer(value),
        ($0.Avatar value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.CreatePairingCodeResponse>(
        'CreateFriendCode',
        createFriendCode_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.CreatePairingCodeResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.RedeemPairingCodeRequest, $0.FriendRequest>(
            'RedeemFriendCode',
            redeemFriendCode_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.RedeemPairingCodeRequest.fromBuffer(value),
            ($0.FriendRequest value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ConfirmPairingRequest, $0.Empty>(
        'ConfirmFriend',
        confirmFriend_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ConfirmPairingRequest.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.ListFriendsResponse>(
        'ListFriends',
        listFriends_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.ListFriendsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FriendRef, $0.Empty>(
        'RemoveFriend',
        removeFriend_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FriendRef.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetFriendAutoAcceptRequest, $0.Friend>(
        'SetFriendAutoAccept',
        setFriendAutoAccept_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SetFriendAutoAcceptRequest.fromBuffer(value),
        ($0.Friend value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FriendRef, $0.Empty>(
        'BlockDevice',
        blockDevice_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FriendRef.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Strangers>(
        'WatchStrangers',
        watchStrangers_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Strangers value) => value.writeToBuffer()));
  }

  $async.Stream<$0.Event> subscribe_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SubscribeRequest> $request) async* {
    yield* subscribe($call, await $request);
  }

  $async.Stream<$0.Event> subscribe(
      $grpc.ServiceCall call, $0.SubscribeRequest request);

  $async.Future<$0.ListHistoryResponse> listHistory_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListHistoryRequest> $request) async {
    return listHistory($call, await $request);
  }

  $async.Future<$0.ListHistoryResponse> listHistory(
      $grpc.ServiceCall call, $0.ListHistoryRequest request);

  $async.Future<$0.Empty> deleteHistory_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteHistoryRequest> $request) async {
    return deleteHistory($call, await $request);
  }

  $async.Future<$0.Empty> deleteHistory(
      $grpc.ServiceCall call, $0.DeleteHistoryRequest request);

  $async.Future<$0.Empty> fetch_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.FetchRequest> $request) async {
    return fetch($call, await $request);
  }

  $async.Future<$0.Empty> fetch(
      $grpc.ServiceCall call, $0.FetchRequest request);

  $async.Future<$0.Empty> applyToClipboard_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ApplyToClipboardRequest> $request) async {
    return applyToClipboard($call, await $request);
  }

  $async.Future<$0.Empty> applyToClipboard(
      $grpc.ServiceCall call, $0.ApplyToClipboardRequest request);

  $async.Future<$0.GetImagePreviewResponse> getImagePreview_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetImagePreviewRequest> $request) async {
    return getImagePreview($call, await $request);
  }

  $async.Future<$0.GetImagePreviewResponse> getImagePreview(
      $grpc.ServiceCall call, $0.GetImagePreviewRequest request);

  $async.Future<$0.ListDevicesResponse> listDevices_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return listDevices($call, await $request);
  }

  $async.Future<$0.ListDevicesResponse> listDevices(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.CreatePairingCodeResponse> createPairingCode_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return createPairingCode($call, await $request);
  }

  $async.Future<$0.CreatePairingCodeResponse> createPairingCode(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.RedeemPairingCodeResponse> redeemPairingCode_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.RedeemPairingCodeRequest> $request) async {
    return redeemPairingCode($call, await $request);
  }

  $async.Future<$0.RedeemPairingCodeResponse> redeemPairingCode(
      $grpc.ServiceCall call, $0.RedeemPairingCodeRequest request);

  $async.Future<$0.Empty> confirmPairing_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ConfirmPairingRequest> $request) async {
    return confirmPairing($call, await $request);
  }

  $async.Future<$0.Empty> confirmPairing(
      $grpc.ServiceCall call, $0.ConfirmPairingRequest request);

  $async.Future<$0.Empty> unpair_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.UnpairRequest> $request) async {
    return unpair($call, await $request);
  }

  $async.Future<$0.Empty> unpair(
      $grpc.ServiceCall call, $0.UnpairRequest request);

  $async.Future<$0.ReconnectResponse> reconnect_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ReconnectRequest> $request) async {
    return reconnect($call, await $request);
  }

  $async.Future<$0.ReconnectResponse> reconnect(
      $grpc.ServiceCall call, $0.ReconnectRequest request);

  $async.Future<$0.Empty> setDeviceAddress_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SetDeviceAddressRequest> $request) async {
    return setDeviceAddress($call, await $request);
  }

  $async.Future<$0.Empty> setDeviceAddress(
      $grpc.ServiceCall call, $0.SetDeviceAddressRequest request);

  $async.Stream<$0.NearbyDevices> watchNearby_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async* {
    yield* watchNearby($call, await $request);
  }

  $async.Stream<$0.NearbyDevices> watchNearby(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.RedeemPairingCodeResponse> pairNearby_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.PairNearbyRequest> $request) async {
    return pairNearby($call, await $request);
  }

  $async.Future<$0.RedeemPairingCodeResponse> pairNearby(
      $grpc.ServiceCall call, $0.PairNearbyRequest request);

  $async.Future<$0.Config> getConfig_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getConfig($call, await $request);
  }

  $async.Future<$0.Config> getConfig($grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.Config> updateConfig_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Config> $request) async {
    return updateConfig($call, await $request);
  }

  $async.Future<$0.Config> updateConfig(
      $grpc.ServiceCall call, $0.Config request);

  $async.Future<$0.Status> getStatus_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getStatus($call, await $request);
  }

  $async.Future<$0.Status> getStatus($grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.Empty> requestClipboardPermission_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return requestClipboardPermission($call, await $request);
  }

  $async.Future<$0.Empty> requestClipboardPermission(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.Empty> requestLocalNetworkPermission_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return requestLocalNetworkPermission($call, await $request);
  }

  $async.Future<$0.Empty> requestLocalNetworkPermission(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.NotificationStatus> getNotificationStatus_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getNotificationStatus($call, await $request);
  }

  $async.Future<$0.NotificationStatus> getNotificationStatus(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.NotificationStatus> requestNotificationPermission_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return requestNotificationPermission($call, await $request);
  }

  $async.Future<$0.NotificationStatus> requestNotificationPermission(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.Empty> activateNotification_Pre($grpc.ServiceCall $call,
      $async.Future<$0.NotificationAction> $request) async {
    return activateNotification($call, await $request);
  }

  $async.Future<$0.Empty> activateNotification(
      $grpc.ServiceCall call, $0.NotificationAction request);

  $async.Future<$0.NetworkInfo> getNetwork_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getNetwork($call, await $request);
  }

  $async.Future<$0.NetworkInfo> getNetwork(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.Diagnostics> exportDiagnostics_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ExportDiagnosticsRequest> $request) async {
    return exportDiagnostics($call, await $request);
  }

  $async.Future<$0.Diagnostics> exportDiagnostics(
      $grpc.ServiceCall call, $0.ExportDiagnosticsRequest request);

  $async.Future<$0.Status> setVerboseLog_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SetVerboseLogRequest> $request) async {
    return setVerboseLog($call, await $request);
  }

  $async.Future<$0.Status> setVerboseLog(
      $grpc.ServiceCall call, $0.SetVerboseLogRequest request);

  $async.Future<$0.UpdateInfo> checkForUpdate_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CheckForUpdateRequest> $request) async {
    return checkForUpdate($call, await $request);
  }

  $async.Future<$0.UpdateInfo> checkForUpdate(
      $grpc.ServiceCall call, $0.CheckForUpdateRequest request);

  $async.Stream<$0.UpdateProgress> downloadUpdate_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DownloadUpdateRequest> $request) async* {
    yield* downloadUpdate($call, await $request);
  }

  $async.Stream<$0.UpdateProgress> downloadUpdate(
      $grpc.ServiceCall call, $0.DownloadUpdateRequest request);

  $async.Future<$0.Empty> installUpdate_Pre($grpc.ServiceCall $call,
      $async.Future<$0.InstallUpdateRequest> $request) async {
    return installUpdate($call, await $request);
  }

  $async.Future<$0.Empty> installUpdate(
      $grpc.ServiceCall call, $0.InstallUpdateRequest request);

  $async.Future<$0.ClipRecord> setFavorite_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SetFavoriteRequest> $request) async {
    return setFavorite($call, await $request);
  }

  $async.Future<$0.ClipRecord> setFavorite(
      $grpc.ServiceCall call, $0.SetFavoriteRequest request);

  $async.Future<$0.ClipDetail> getClipDetail_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetClipDetailRequest> $request) async {
    return getClipDetail($call, await $request);
  }

  $async.Future<$0.ClipDetail> getClipDetail(
      $grpc.ServiceCall call, $0.GetClipDetailRequest request);

  $async.Future<$0.ClipRecord> setAlias_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SetAliasRequest> $request) async {
    return setAlias($call, await $request);
  }

  $async.Future<$0.ClipRecord> setAlias(
      $grpc.ServiceCall call, $0.SetAliasRequest request);

  $async.Stream<$0.QuickPasteCommand> quickPasteSession(
      $grpc.ServiceCall call, $async.Stream<$0.QuickPasteStatus> request);

  $async.Future<$0.QuickPasteStatus> getQuickPasteStatus_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getQuickPasteStatus($call, await $request);
  }

  $async.Future<$0.QuickPasteStatus> getQuickPasteStatus(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.Empty> sendQuickPasteCommand_Pre($grpc.ServiceCall $call,
      $async.Future<$0.QuickPasteCommand> $request) async {
    return sendQuickPasteCommand($call, await $request);
  }

  $async.Future<$0.Empty> sendQuickPasteCommand(
      $grpc.ServiceCall call, $0.QuickPasteCommand request);

  $async.Future<$0.Transfer> sendFiles_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SendFilesRequest> $request) async {
    return sendFiles($call, await $request);
  }

  $async.Future<$0.Transfer> sendFiles(
      $grpc.ServiceCall call, $0.SendFilesRequest request);

  $async.Future<$0.Empty> cancelTransfer_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.TransferRef> $request) async {
    return cancelTransfer($call, await $request);
  }

  $async.Future<$0.Empty> cancelTransfer(
      $grpc.ServiceCall call, $0.TransferRef request);

  $async.Future<$0.Empty> resumeTransfer_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.TransferRef> $request) async {
    return resumeTransfer($call, await $request);
  }

  $async.Future<$0.Empty> resumeTransfer(
      $grpc.ServiceCall call, $0.TransferRef request);

  $async.Future<$0.ListTransfersResponse> listTransfers_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListTransfersRequest> $request) async {
    return listTransfers($call, await $request);
  }

  $async.Future<$0.ListTransfersResponse> listTransfers(
      $grpc.ServiceCall call, $0.ListTransfersRequest request);

  $async.Future<$0.Empty> deleteTransfers_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteTransfersRequest> $request) async {
    return deleteTransfers($call, await $request);
  }

  $async.Future<$0.Empty> deleteTransfers(
      $grpc.ServiceCall call, $0.DeleteTransfersRequest request);

  $async.Future<$0.Empty> markTransfersSeen_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return markTransfersSeen($call, await $request);
  }

  $async.Future<$0.Empty> markTransfersSeen(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.CheckReceiveDirResponse> checkReceiveDir_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CheckReceiveDirRequest> $request) async {
    return checkReceiveDir($call, await $request);
  }

  $async.Future<$0.CheckReceiveDirResponse> checkReceiveDir(
      $grpc.ServiceCall call, $0.CheckReceiveDirRequest request);

  $async.Future<$0.Empty> answerIncoming_Pre($grpc.ServiceCall $call,
      $async.Future<$0.AnswerIncomingRequest> $request) async {
    return answerIncoming($call, await $request);
  }

  $async.Future<$0.Empty> answerIncoming(
      $grpc.ServiceCall call, $0.AnswerIncomingRequest request);

  $async.Future<$0.Profile> getProfile_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return getProfile($call, await $request);
  }

  $async.Future<$0.Profile> getProfile(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.Profile> setDisplayName_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SetDisplayNameRequest> $request) async {
    return setDisplayName($call, await $request);
  }

  $async.Future<$0.Profile> setDisplayName(
      $grpc.ServiceCall call, $0.SetDisplayNameRequest request);

  $async.Future<$0.Profile> setAvatar_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SetAvatarRequest> $request) async {
    return setAvatar($call, await $request);
  }

  $async.Future<$0.Profile> setAvatar(
      $grpc.ServiceCall call, $0.SetAvatarRequest request);

  $async.Future<$0.Profile> resetAvatar_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return resetAvatar($call, await $request);
  }

  $async.Future<$0.Profile> resetAvatar(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.Avatar> getAvatar_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetAvatarRequest> $request) async {
    return getAvatar($call, await $request);
  }

  $async.Future<$0.Avatar> getAvatar(
      $grpc.ServiceCall call, $0.GetAvatarRequest request);

  $async.Future<$0.CreatePairingCodeResponse> createFriendCode_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return createFriendCode($call, await $request);
  }

  $async.Future<$0.CreatePairingCodeResponse> createFriendCode(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.FriendRequest> redeemFriendCode_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RedeemPairingCodeRequest> $request) async {
    return redeemFriendCode($call, await $request);
  }

  $async.Future<$0.FriendRequest> redeemFriendCode(
      $grpc.ServiceCall call, $0.RedeemPairingCodeRequest request);

  $async.Future<$0.Empty> confirmFriend_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ConfirmPairingRequest> $request) async {
    return confirmFriend($call, await $request);
  }

  $async.Future<$0.Empty> confirmFriend(
      $grpc.ServiceCall call, $0.ConfirmPairingRequest request);

  $async.Future<$0.ListFriendsResponse> listFriends_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return listFriends($call, await $request);
  }

  $async.Future<$0.ListFriendsResponse> listFriends(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$0.Empty> removeFriend_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.FriendRef> $request) async {
    return removeFriend($call, await $request);
  }

  $async.Future<$0.Empty> removeFriend(
      $grpc.ServiceCall call, $0.FriendRef request);

  $async.Future<$0.Friend> setFriendAutoAccept_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SetFriendAutoAcceptRequest> $request) async {
    return setFriendAutoAccept($call, await $request);
  }

  $async.Future<$0.Friend> setFriendAutoAccept(
      $grpc.ServiceCall call, $0.SetFriendAutoAcceptRequest request);

  $async.Future<$0.Empty> blockDevice_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.FriendRef> $request) async {
    return blockDevice($call, await $request);
  }

  $async.Future<$0.Empty> blockDevice(
      $grpc.ServiceCall call, $0.FriendRef request);

  $async.Stream<$0.Strangers> watchStrangers_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async* {
    yield* watchStrangers($call, await $request);
  }

  $async.Stream<$0.Strangers> watchStrangers(
      $grpc.ServiceCall call, $0.Empty request);
}
