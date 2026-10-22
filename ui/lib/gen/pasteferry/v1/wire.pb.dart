// This is a generated file - do not edit.
//
// Generated from pasteferry/v1/wire.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'daemon.pb.dart' as $0;
import 'wire.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'wire.pbenum.dart';

/// 经服务器转发的消息一律包一层签名。接收方用配对时存下的
/// 对端公钥验签，服务器无法伪造。
class Signed extends $pb.GeneratedMessage {
  factory Signed({
    $core.List<$core.int>? payload,
    $core.List<$core.int>? signature,
    $core.String? fromDeviceId,
  }) {
    final result = Signed._();
    if (payload != null) result.payload = payload;
    if (signature != null) result.signature = signature;
    if (fromDeviceId != null) result.fromDeviceId = fromDeviceId;
    return result;
  }

  Signed._();

  factory Signed.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Signed()..mergeFromBuffer(data, registry);
  factory Signed.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Signed()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Signed',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: Signed.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'payload', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'signature', $pb.PbFieldType.OY)
    ..aOS(3, _omitFieldNames ? '' : 'fromDeviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Signed clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Signed copyWith(void Function(Signed) updates) =>
      super.copyWith((message) => updates(message as Signed)) as Signed;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Signed() / Signed.new instead')
  static Signed create() => Signed._();
  static $pb.GeneratedMessage $_createMessage() => Signed._();
  @$core.override
  Signed createEmptyInstance() => Signed._();
  @$core.pragma('dart2js:noInline')
  static Signed getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Signed>(Signed.$_createMessage);
  static Signed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get payload => $_getN(0);
  @$pb.TagNumber(1)
  set payload($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPayload() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayload() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get signature => $_getN(1);
  @$pb.TagNumber(2)
  set signature($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSignature() => $_has(1);
  @$pb.TagNumber(2)
  void clearSignature() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get fromDeviceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set fromDeviceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFromDeviceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFromDeviceId() => $_clearField(3);
}

enum SignalMessage_Payload {
  offer,
  answer,
  candidate,
  ping,
  lanHello,
  retryDirect,
  notSet
}

class SignalMessage extends $pb.GeneratedMessage {
  factory SignalMessage({
    $fixnum.Int64? timestampUnix,
    $core.List<$core.int>? nonce,
    $core.String? toDeviceId,
    $core.String? connectionAttemptId,
    $core.bool? officialRelay,
    $core.bool? gatewayCapable,
    $core.String? relayDenialCode,
    SdpOffer? offer,
    SdpAnswer? answer,
    IceCandidate? candidate,
    Ping? ping,
    LanHello? lanHello,
    RetryDirect? retryDirect,
  }) {
    final result = SignalMessage._();
    if (timestampUnix != null) result.timestampUnix = timestampUnix;
    if (nonce != null) result.nonce = nonce;
    if (toDeviceId != null) result.toDeviceId = toDeviceId;
    if (connectionAttemptId != null)
      result.connectionAttemptId = connectionAttemptId;
    if (officialRelay != null) result.officialRelay = officialRelay;
    if (gatewayCapable != null) result.gatewayCapable = gatewayCapable;
    if (relayDenialCode != null) result.relayDenialCode = relayDenialCode;
    if (offer != null) result.offer = offer;
    if (answer != null) result.answer = answer;
    if (candidate != null) result.candidate = candidate;
    if (ping != null) result.ping = ping;
    if (lanHello != null) result.lanHello = lanHello;
    if (retryDirect != null) result.retryDirect = retryDirect;
    return result;
  }

  SignalMessage._();

  factory SignalMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SignalMessage()..mergeFromBuffer(data, registry);
  factory SignalMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SignalMessage()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SignalMessage_Payload>
      _SignalMessage_PayloadByTag = {
    10: SignalMessage_Payload.offer,
    11: SignalMessage_Payload.answer,
    12: SignalMessage_Payload.candidate,
    13: SignalMessage_Payload.ping,
    14: SignalMessage_Payload.lanHello,
    15: SignalMessage_Payload.retryDirect,
    0: SignalMessage_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SignalMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: SignalMessage.$_createMessage)
    ..oo(0, [10, 11, 12, 13, 14, 15])
    ..aInt64(1, _omitFieldNames ? '' : 'timestampUnix')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'nonce', $pb.PbFieldType.OY)
    ..aOS(3, _omitFieldNames ? '' : 'toDeviceId')
    ..aOS(4, _omitFieldNames ? '' : 'connectionAttemptId')
    ..aOB(5, _omitFieldNames ? '' : 'officialRelay')
    ..aOB(6, _omitFieldNames ? '' : 'gatewayCapable')
    ..aOS(7, _omitFieldNames ? '' : 'relayDenialCode')
    ..aOM<SdpOffer>(10, _omitFieldNames ? '' : 'offer',
        subBuilder: SdpOffer.$_createMessage)
    ..aOM<SdpAnswer>(11, _omitFieldNames ? '' : 'answer',
        subBuilder: SdpAnswer.$_createMessage)
    ..aOM<IceCandidate>(12, _omitFieldNames ? '' : 'candidate',
        subBuilder: IceCandidate.$_createMessage)
    ..aOM<Ping>(13, _omitFieldNames ? '' : 'ping',
        subBuilder: Ping.$_createMessage)
    ..aOM<LanHello>(14, _omitFieldNames ? '' : 'lanHello',
        subBuilder: LanHello.$_createMessage)
    ..aOM<RetryDirect>(15, _omitFieldNames ? '' : 'retryDirect',
        subBuilder: RetryDirect.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignalMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignalMessage copyWith(void Function(SignalMessage) updates) =>
      super.copyWith((message) => updates(message as SignalMessage))
          as SignalMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SignalMessage() / SignalMessage.new instead')
  static SignalMessage create() => SignalMessage._();
  static $pb.GeneratedMessage $_createMessage() => SignalMessage._();
  @$core.override
  SignalMessage createEmptyInstance() => SignalMessage._();
  @$core.pragma('dart2js:noInline')
  static SignalMessage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SignalMessage>(
          SignalMessage.$_createMessage);
  static SignalMessage? _defaultInstance;

  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  SignalMessage_Payload whichPayload() =>
      _SignalMessage_PayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  void clearPayload() => $_clearField($_whichOneof(0));

  /// 防重放：接收方拒绝时间戳过旧或 nonce 重复的消息
  @$pb.TagNumber(1)
  $fixnum.Int64 get timestampUnix => $_getI64(0);
  @$pb.TagNumber(1)
  set timestampUnix($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTimestampUnix() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestampUnix() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get nonce => $_getN(1);
  @$pb.TagNumber(2)
  set nonce($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNonce() => $_has(1);
  @$pb.TagNumber(2)
  void clearNonce() => $_clearField(2);

  /// 接收方只收发给自己的消息：局域网里谁都能把截到的消息转发给第三台设备
  @$pb.TagNumber(3)
  $core.String get toDeviceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set toDeviceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToDeviceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearToDeviceId() => $_clearField(3);

  /// Client-only negotiation metadata; the server forwards Signed unchanged.
  @$pb.TagNumber(4)
  $core.String get connectionAttemptId => $_getSZ(3);
  @$pb.TagNumber(4)
  set connectionAttemptId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasConnectionAttemptId() => $_has(3);
  @$pb.TagNumber(4)
  void clearConnectionAttemptId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get officialRelay => $_getBF(4);
  @$pb.TagNumber(5)
  set officialRelay($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOfficialRelay() => $_has(4);
  @$pb.TagNumber(5)
  void clearOfficialRelay() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get gatewayCapable => $_getBF(5);
  @$pb.TagNumber(6)
  set gatewayCapable($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasGatewayCapable() => $_has(5);
  @$pb.TagNumber(6)
  void clearGatewayCapable() => $_clearField(6);

  /// Fixed relay-only denial codes; these never change pairing or direct trust.
  @$pb.TagNumber(7)
  $core.String get relayDenialCode => $_getSZ(6);
  @$pb.TagNumber(7)
  set relayDenialCode($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRelayDenialCode() => $_has(6);
  @$pb.TagNumber(7)
  void clearRelayDenialCode() => $_clearField(7);

  @$pb.TagNumber(10)
  SdpOffer get offer => $_getN(7);
  @$pb.TagNumber(10)
  set offer(SdpOffer value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasOffer() => $_has(7);
  @$pb.TagNumber(10)
  void clearOffer() => $_clearField(10);
  @$pb.TagNumber(10)
  SdpOffer ensureOffer() => $_ensure(7);

  @$pb.TagNumber(11)
  SdpAnswer get answer => $_getN(8);
  @$pb.TagNumber(11)
  set answer(SdpAnswer value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasAnswer() => $_has(8);
  @$pb.TagNumber(11)
  void clearAnswer() => $_clearField(11);
  @$pb.TagNumber(11)
  SdpAnswer ensureAnswer() => $_ensure(8);

  @$pb.TagNumber(12)
  IceCandidate get candidate => $_getN(9);
  @$pb.TagNumber(12)
  set candidate(IceCandidate value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCandidate() => $_has(9);
  @$pb.TagNumber(12)
  void clearCandidate() => $_clearField(12);
  @$pb.TagNumber(12)
  IceCandidate ensureCandidate() => $_ensure(9);

  @$pb.TagNumber(13)
  Ping get ping => $_getN(10);
  @$pb.TagNumber(13)
  set ping(Ping value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasPing() => $_has(10);
  @$pb.TagNumber(13)
  void clearPing() => $_clearField(13);
  @$pb.TagNumber(13)
  Ping ensurePing() => $_ensure(10);

  @$pb.TagNumber(14)
  LanHello get lanHello => $_getN(11);
  @$pb.TagNumber(14)
  set lanHello(LanHello value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasLanHello() => $_has(11);
  @$pb.TagNumber(14)
  void clearLanHello() => $_clearField(14);
  @$pb.TagNumber(14)
  LanHello ensureLanHello() => $_ensure(11);

  @$pb.TagNumber(15)
  RetryDirect get retryDirect => $_getN(12);
  @$pb.TagNumber(15)
  set retryDirect(RetryDirect value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasRetryDirect() => $_has(12);
  @$pb.TagNumber(15)
  void clearRetryDirect() => $_clearField(15);
  @$pb.TagNumber(15)
  RetryDirect ensureRetryDirect() => $_ensure(12);
}

/// 用户在应答方点了「重新连接」：只有发起方能做 ICE 重启，请它马上再试一次直连。
/// 旧版本不认识它，照旧按自己的间隔重试
class RetryDirect extends $pb.GeneratedMessage {
  factory RetryDirect() => RetryDirect._();

  RetryDirect._();

  factory RetryDirect.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RetryDirect()..mergeFromBuffer(data, registry);
  factory RetryDirect.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RetryDirect()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetryDirect',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: RetryDirect.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetryDirect clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetryDirect copyWith(void Function(RetryDirect) updates) =>
      super.copyWith((message) => updates(message as RetryDirect))
          as RetryDirect;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RetryDirect() / RetryDirect.new instead')
  static RetryDirect create() => RetryDirect._();
  static $pb.GeneratedMessage $_createMessage() => RetryDirect._();
  @$core.override
  RetryDirect createEmptyInstance() => RetryDirect._();
  @$core.pragma('dart2js:noInline')
  static RetryDirect getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RetryDirect>(
          RetryDirect.$_createMessage);
  static RetryDirect? _defaultInstance;
}

class SdpOffer extends $pb.GeneratedMessage {
  factory SdpOffer({
    $core.String? sdp,
    $core.String? dtlsFingerprint,
    $core.bool? answererWaits,
  }) {
    final result = SdpOffer._();
    if (sdp != null) result.sdp = sdp;
    if (dtlsFingerprint != null) result.dtlsFingerprint = dtlsFingerprint;
    if (answererWaits != null) result.answererWaits = answererWaits;
    return result;
  }

  SdpOffer._();

  factory SdpOffer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SdpOffer()..mergeFromBuffer(data, registry);
  factory SdpOffer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SdpOffer()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SdpOffer',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: SdpOffer.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'sdp')
    ..aOS(2, _omitFieldNames ? '' : 'dtlsFingerprint')
    ..aOB(3, _omitFieldNames ? '' : 'answererWaits')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SdpOffer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SdpOffer copyWith(void Function(SdpOffer) updates) =>
      super.copyWith((message) => updates(message as SdpOffer)) as SdpOffer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SdpOffer() / SdpOffer.new instead')
  static SdpOffer create() => SdpOffer._();
  static $pb.GeneratedMessage $_createMessage() => SdpOffer._();
  @$core.override
  SdpOffer createEmptyInstance() => SdpOffer._();
  @$core.pragma('dart2js:noInline')
  static SdpOffer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SdpOffer>(SdpOffer.$_createMessage);
  static SdpOffer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sdp => $_getSZ(0);
  @$pb.TagNumber(1)
  set sdp($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSdp() => $_has(0);
  @$pb.TagNumber(1)
  void clearSdp() => $_clearField(1);

  /// DTLS 证书指纹。经签名传输，杜绝信令服务器中间人攻击——
  /// 这是 P2P 通道真正的安全锚点。
  @$pb.TagNumber(2)
  $core.String get dtlsFingerprint => $_getSZ(1);
  @$pb.TagNumber(2)
  set dtlsFingerprint($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDtlsFingerprint() => $_has(1);
  @$pb.TagNumber(2)
  void clearDtlsFingerprint() => $_clearField(2);

  /// 应答方先别发自己的出口地址：等收到发起方的出口地址、先往那边发过包再发。
  /// 默认（false）是发起方这样等。谁先发包决定了谁的路由器先收到对方的包，
  /// 有的路由器会因此占住端口、打洞失败，所以换直连的重试里两种顺序轮流用。
  @$pb.TagNumber(3)
  $core.bool get answererWaits => $_getBF(2);
  @$pb.TagNumber(3)
  set answererWaits($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAnswererWaits() => $_has(2);
  @$pb.TagNumber(3)
  void clearAnswererWaits() => $_clearField(3);
}

class SdpAnswer extends $pb.GeneratedMessage {
  factory SdpAnswer({
    $core.String? sdp,
    $core.String? dtlsFingerprint,
  }) {
    final result = SdpAnswer._();
    if (sdp != null) result.sdp = sdp;
    if (dtlsFingerprint != null) result.dtlsFingerprint = dtlsFingerprint;
    return result;
  }

  SdpAnswer._();

  factory SdpAnswer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SdpAnswer()..mergeFromBuffer(data, registry);
  factory SdpAnswer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SdpAnswer()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SdpAnswer',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: SdpAnswer.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'sdp')
    ..aOS(2, _omitFieldNames ? '' : 'dtlsFingerprint')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SdpAnswer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SdpAnswer copyWith(void Function(SdpAnswer) updates) =>
      super.copyWith((message) => updates(message as SdpAnswer)) as SdpAnswer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SdpAnswer() / SdpAnswer.new instead')
  static SdpAnswer create() => SdpAnswer._();
  static $pb.GeneratedMessage $_createMessage() => SdpAnswer._();
  @$core.override
  SdpAnswer createEmptyInstance() => SdpAnswer._();
  @$core.pragma('dart2js:noInline')
  static SdpAnswer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SdpAnswer>(SdpAnswer.$_createMessage);
  static SdpAnswer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sdp => $_getSZ(0);
  @$pb.TagNumber(1)
  set sdp($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSdp() => $_has(0);
  @$pb.TagNumber(1)
  void clearSdp() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get dtlsFingerprint => $_getSZ(1);
  @$pb.TagNumber(2)
  set dtlsFingerprint($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDtlsFingerprint() => $_has(1);
  @$pb.TagNumber(2)
  void clearDtlsFingerprint() => $_clearField(2);
}

class IceCandidate extends $pb.GeneratedMessage {
  factory IceCandidate({
    $core.String? candidate,
    $core.String? sdpMid,
    $core.int? sdpMlineIndex,
  }) {
    final result = IceCandidate._();
    if (candidate != null) result.candidate = candidate;
    if (sdpMid != null) result.sdpMid = sdpMid;
    if (sdpMlineIndex != null) result.sdpMlineIndex = sdpMlineIndex;
    return result;
  }

  IceCandidate._();

  factory IceCandidate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IceCandidate()..mergeFromBuffer(data, registry);
  factory IceCandidate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IceCandidate()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IceCandidate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: IceCandidate.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'candidate')
    ..aOS(2, _omitFieldNames ? '' : 'sdpMid')
    ..aI(3, _omitFieldNames ? '' : 'sdpMlineIndex',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IceCandidate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IceCandidate copyWith(void Function(IceCandidate) updates) =>
      super.copyWith((message) => updates(message as IceCandidate))
          as IceCandidate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use IceCandidate() / IceCandidate.new instead')
  static IceCandidate create() => IceCandidate._();
  static $pb.GeneratedMessage $_createMessage() => IceCandidate._();
  @$core.override
  IceCandidate createEmptyInstance() => IceCandidate._();
  @$core.pragma('dart2js:noInline')
  static IceCandidate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IceCandidate>(
          IceCandidate.$_createMessage);
  static IceCandidate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get candidate => $_getSZ(0);
  @$pb.TagNumber(1)
  set candidate($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCandidate() => $_has(0);
  @$pb.TagNumber(1)
  void clearCandidate() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sdpMid => $_getSZ(1);
  @$pb.TagNumber(2)
  set sdpMid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSdpMid() => $_has(1);
  @$pb.TagNumber(2)
  void clearSdpMid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get sdpMlineIndex => $_getIZ(2);
  @$pb.TagNumber(3)
  set sdpMlineIndex($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSdpMlineIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearSdpMlineIndex() => $_clearField(3);
}

class Ping extends $pb.GeneratedMessage {
  factory Ping({
    $fixnum.Int64? sentAtUnix,
  }) {
    final result = Ping._();
    if (sentAtUnix != null) result.sentAtUnix = sentAtUnix;
    return result;
  }

  Ping._();

  factory Ping.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Ping()..mergeFromBuffer(data, registry);
  factory Ping.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Ping()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Ping',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: Ping.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'sentAtUnix')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ping clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ping copyWith(void Function(Ping) updates) =>
      super.copyWith((message) => updates(message as Ping)) as Ping;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Ping() / Ping.new instead')
  static Ping create() => Ping._();
  static $pb.GeneratedMessage $_createMessage() => Ping._();
  @$core.override
  Ping createEmptyInstance() => Ping._();
  @$core.pragma('dart2js:noInline')
  static Ping getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Ping>(Ping.$_createMessage);
  static Ping? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get sentAtUnix => $_getI64(0);
  @$pb.TagNumber(1)
  set sentAtUnix($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSentAtUnix() => $_has(0);
  @$pb.TagNumber(1)
  void clearSentAtUnix() => $_clearField(1);
}

class ClientHello extends $pb.GeneratedMessage {
  factory ClientHello({
    $core.String? deviceId,
    $core.String? deviceName,
    $core.String? platform,
    $core.List<$core.int>? publicKey,
    $core.List<$core.int>? signature,
    $core.Iterable<$core.String>? pairedDeviceIds,
  }) {
    final result = ClientHello._();
    if (deviceId != null) result.deviceId = deviceId;
    if (deviceName != null) result.deviceName = deviceName;
    if (platform != null) result.platform = platform;
    if (publicKey != null) result.publicKey = publicKey;
    if (signature != null) result.signature = signature;
    if (pairedDeviceIds != null) result.pairedDeviceIds.addAll(pairedDeviceIds);
    return result;
  }

  ClientHello._();

  factory ClientHello.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClientHello()..mergeFromBuffer(data, registry);
  factory ClientHello.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClientHello()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClientHello',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: ClientHello.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'deviceName')
    ..aOS(3, _omitFieldNames ? '' : 'platform')
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        5, _omitFieldNames ? '' : 'signature', $pb.PbFieldType.OY)
    ..pPS(6, _omitFieldNames ? '' : 'pairedDeviceIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientHello clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientHello copyWith(void Function(ClientHello) updates) =>
      super.copyWith((message) => updates(message as ClientHello))
          as ClientHello;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ClientHello() / ClientHello.new instead')
  static ClientHello create() => ClientHello._();
  static $pb.GeneratedMessage $_createMessage() => ClientHello._();
  @$core.override
  ClientHello createEmptyInstance() => ClientHello._();
  @$core.pragma('dart2js:noInline')
  static ClientHello getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClientHello>(
          ClientHello.$_createMessage);
  static ClientHello? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeviceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get platform => $_getSZ(2);
  @$pb.TagNumber(3)
  set platform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatform() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get publicKey => $_getN(3);
  @$pb.TagNumber(4)
  set publicKey($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPublicKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearPublicKey() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get signature => $_getN(4);
  @$pb.TagNumber(5)
  set signature($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSignature() => $_has(4);
  @$pb.TagNumber(5)
  void clearSignature() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get pairedDeviceIds => $_getList(5);
}

class ServerHello extends $pb.GeneratedMessage {
  factory ServerHello({
    $core.List<$core.int>? challenge,
    $core.Iterable<IceServer>? iceServers,
    $fixnum.Int64? serverTimeUnix,
  }) {
    final result = ServerHello._();
    if (challenge != null) result.challenge = challenge;
    if (iceServers != null) result.iceServers.addAll(iceServers);
    if (serverTimeUnix != null) result.serverTimeUnix = serverTimeUnix;
    return result;
  }

  ServerHello._();

  factory ServerHello.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ServerHello()..mergeFromBuffer(data, registry);
  factory ServerHello.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ServerHello()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerHello',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: ServerHello.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'challenge', $pb.PbFieldType.OY)
    ..pPM<IceServer>(2, _omitFieldNames ? '' : 'iceServers',
        subBuilder: IceServer.$_createMessage)
    ..aInt64(3, _omitFieldNames ? '' : 'serverTimeUnix')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerHello clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerHello copyWith(void Function(ServerHello) updates) =>
      super.copyWith((message) => updates(message as ServerHello))
          as ServerHello;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ServerHello() / ServerHello.new instead')
  static ServerHello create() => ServerHello._();
  static $pb.GeneratedMessage $_createMessage() => ServerHello._();
  @$core.override
  ServerHello createEmptyInstance() => ServerHello._();
  @$core.pragma('dart2js:noInline')
  static ServerHello getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerHello>(
          ServerHello.$_createMessage);
  static ServerHello? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get challenge => $_getN(0);
  @$pb.TagNumber(1)
  set challenge($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChallenge() => $_has(0);
  @$pb.TagNumber(1)
  void clearChallenge() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<IceServer> get iceServers => $_getList(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get serverTimeUnix => $_getI64(2);
  @$pb.TagNumber(3)
  set serverTimeUnix($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasServerTimeUnix() => $_has(2);
  @$pb.TagNumber(3)
  void clearServerTimeUnix() => $_clearField(3);
}

class IceServer extends $pb.GeneratedMessage {
  factory IceServer({
    $core.Iterable<$core.String>? urls,
    $core.String? username,
    $core.String? credential,
    $fixnum.Int64? expiresAtUnix,
  }) {
    final result = IceServer._();
    if (urls != null) result.urls.addAll(urls);
    if (username != null) result.username = username;
    if (credential != null) result.credential = credential;
    if (expiresAtUnix != null) result.expiresAtUnix = expiresAtUnix;
    return result;
  }

  IceServer._();

  factory IceServer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IceServer()..mergeFromBuffer(data, registry);
  factory IceServer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IceServer()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IceServer',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: IceServer.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'urls')
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..aOS(3, _omitFieldNames ? '' : 'credential')
    ..aInt64(4, _omitFieldNames ? '' : 'expiresAtUnix')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IceServer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IceServer copyWith(void Function(IceServer) updates) =>
      super.copyWith((message) => updates(message as IceServer)) as IceServer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use IceServer() / IceServer.new instead')
  static IceServer create() => IceServer._();
  static $pb.GeneratedMessage $_createMessage() => IceServer._();
  @$core.override
  IceServer createEmptyInstance() => IceServer._();
  @$core.pragma('dart2js:noInline')
  static IceServer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IceServer>(IceServer.$_createMessage);
  static IceServer? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get urls => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get credential => $_getSZ(2);
  @$pb.TagNumber(3)
  set credential($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCredential() => $_has(2);
  @$pb.TagNumber(3)
  void clearCredential() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expiresAtUnix => $_getI64(3);
  @$pb.TagNumber(4)
  set expiresAtUnix($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpiresAtUnix() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpiresAtUnix() => $_clearField(4);
}

class PeerPresence extends $pb.GeneratedMessage {
  factory PeerPresence({
    $core.String? deviceId,
    $core.bool? online,
  }) {
    final result = PeerPresence._();
    if (deviceId != null) result.deviceId = deviceId;
    if (online != null) result.online = online;
    return result;
  }

  PeerPresence._();

  factory PeerPresence.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PeerPresence()..mergeFromBuffer(data, registry);
  factory PeerPresence.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PeerPresence()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PeerPresence',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: PeerPresence.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOB(2, _omitFieldNames ? '' : 'online')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PeerPresence clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PeerPresence copyWith(void Function(PeerPresence) updates) =>
      super.copyWith((message) => updates(message as PeerPresence))
          as PeerPresence;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PeerPresence() / PeerPresence.new instead')
  static PeerPresence create() => PeerPresence._();
  static $pb.GeneratedMessage $_createMessage() => PeerPresence._();
  @$core.override
  PeerPresence createEmptyInstance() => PeerPresence._();
  @$core.pragma('dart2js:noInline')
  static PeerPresence getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PeerPresence>(
          PeerPresence.$_createMessage);
  static PeerPresence? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get online => $_getBF(1);
  @$pb.TagNumber(2)
  set online($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOnline() => $_has(1);
  @$pb.TagNumber(2)
  void clearOnline() => $_clearField(2);
}

class PairingCreateRequest extends $pb.GeneratedMessage {
  factory PairingCreateRequest({
    $core.String? deviceName,
    $core.List<$core.int>? publicKey,
  }) {
    final result = PairingCreateRequest._();
    if (deviceName != null) result.deviceName = deviceName;
    if (publicKey != null) result.publicKey = publicKey;
    return result;
  }

  PairingCreateRequest._();

  factory PairingCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PairingCreateRequest()..mergeFromBuffer(data, registry);
  factory PairingCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PairingCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PairingCreateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: PairingCreateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'deviceName')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PairingCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PairingCreateRequest copyWith(void Function(PairingCreateRequest) updates) =>
      super.copyWith((message) => updates(message as PairingCreateRequest))
          as PairingCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PairingCreateRequest() / PairingCreateRequest.new instead')
  static PairingCreateRequest create() => PairingCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() => PairingCreateRequest._();
  @$core.override
  PairingCreateRequest createEmptyInstance() => PairingCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static PairingCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PairingCreateRequest>(
          PairingCreateRequest.$_createMessage);
  static PairingCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceName => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceName() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get publicKey => $_getN(1);
  @$pb.TagNumber(2)
  set publicKey($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublicKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublicKey() => $_clearField(2);
}

class PairingCreateResponse extends $pb.GeneratedMessage {
  factory PairingCreateResponse({
    $core.String? code,
    $fixnum.Int64? expiresAtUnix,
  }) {
    final result = PairingCreateResponse._();
    if (code != null) result.code = code;
    if (expiresAtUnix != null) result.expiresAtUnix = expiresAtUnix;
    return result;
  }

  PairingCreateResponse._();

  factory PairingCreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PairingCreateResponse()..mergeFromBuffer(data, registry);
  factory PairingCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PairingCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PairingCreateResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: PairingCreateResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aInt64(2, _omitFieldNames ? '' : 'expiresAtUnix')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PairingCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PairingCreateResponse copyWith(
          void Function(PairingCreateResponse) updates) =>
      super.copyWith((message) => updates(message as PairingCreateResponse))
          as PairingCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PairingCreateResponse() / PairingCreateResponse.new instead')
  static PairingCreateResponse create() => PairingCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() => PairingCreateResponse._();
  @$core.override
  PairingCreateResponse createEmptyInstance() => PairingCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static PairingCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PairingCreateResponse>(
          PairingCreateResponse.$_createMessage);
  static PairingCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get expiresAtUnix => $_getI64(1);
  @$pb.TagNumber(2)
  set expiresAtUnix($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpiresAtUnix() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpiresAtUnix() => $_clearField(2);
}

class PairingRedeemRequest extends $pb.GeneratedMessage {
  factory PairingRedeemRequest({
    $core.String? code,
    $core.String? deviceId,
    $core.String? deviceName,
    $core.List<$core.int>? publicKey,
  }) {
    final result = PairingRedeemRequest._();
    if (code != null) result.code = code;
    if (deviceId != null) result.deviceId = deviceId;
    if (deviceName != null) result.deviceName = deviceName;
    if (publicKey != null) result.publicKey = publicKey;
    return result;
  }

  PairingRedeemRequest._();

  factory PairingRedeemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PairingRedeemRequest()..mergeFromBuffer(data, registry);
  factory PairingRedeemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PairingRedeemRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PairingRedeemRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: PairingRedeemRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'deviceId')
    ..aOS(3, _omitFieldNames ? '' : 'deviceName')
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PairingRedeemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PairingRedeemRequest copyWith(void Function(PairingRedeemRequest) updates) =>
      super.copyWith((message) => updates(message as PairingRedeemRequest))
          as PairingRedeemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PairingRedeemRequest() / PairingRedeemRequest.new instead')
  static PairingRedeemRequest create() => PairingRedeemRequest._();
  static $pb.GeneratedMessage $_createMessage() => PairingRedeemRequest._();
  @$core.override
  PairingRedeemRequest createEmptyInstance() => PairingRedeemRequest._();
  @$core.pragma('dart2js:noInline')
  static PairingRedeemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PairingRedeemRequest>(
          PairingRedeemRequest.$_createMessage);
  static PairingRedeemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeviceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get deviceName => $_getSZ(2);
  @$pb.TagNumber(3)
  set deviceName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDeviceName() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeviceName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get publicKey => $_getN(3);
  @$pb.TagNumber(4)
  set publicKey($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPublicKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearPublicKey() => $_clearField(4);
}

class PairingRedeemResponse extends $pb.GeneratedMessage {
  factory PairingRedeemResponse({
    $core.String? peerDeviceId,
    $core.String? peerDeviceName,
    $core.String? peerPlatform,
    $core.List<$core.int>? peerPublicKey,
  }) {
    final result = PairingRedeemResponse._();
    if (peerDeviceId != null) result.peerDeviceId = peerDeviceId;
    if (peerDeviceName != null) result.peerDeviceName = peerDeviceName;
    if (peerPlatform != null) result.peerPlatform = peerPlatform;
    if (peerPublicKey != null) result.peerPublicKey = peerPublicKey;
    return result;
  }

  PairingRedeemResponse._();

  factory PairingRedeemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PairingRedeemResponse()..mergeFromBuffer(data, registry);
  factory PairingRedeemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PairingRedeemResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PairingRedeemResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: PairingRedeemResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'peerDeviceId')
    ..aOS(2, _omitFieldNames ? '' : 'peerDeviceName')
    ..aOS(3, _omitFieldNames ? '' : 'peerPlatform')
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'peerPublicKey', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PairingRedeemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PairingRedeemResponse copyWith(
          void Function(PairingRedeemResponse) updates) =>
      super.copyWith((message) => updates(message as PairingRedeemResponse))
          as PairingRedeemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PairingRedeemResponse() / PairingRedeemResponse.new instead')
  static PairingRedeemResponse create() => PairingRedeemResponse._();
  static $pb.GeneratedMessage $_createMessage() => PairingRedeemResponse._();
  @$core.override
  PairingRedeemResponse createEmptyInstance() => PairingRedeemResponse._();
  @$core.pragma('dart2js:noInline')
  static PairingRedeemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PairingRedeemResponse>(
          PairingRedeemResponse.$_createMessage);
  static PairingRedeemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get peerDeviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set peerDeviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPeerDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get peerDeviceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set peerDeviceName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPeerDeviceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeerDeviceName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get peerPlatform => $_getSZ(2);
  @$pb.TagNumber(3)
  set peerPlatform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPeerPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeerPlatform() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get peerPublicKey => $_getN(3);
  @$pb.TagNumber(4)
  set peerPublicKey($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPeerPublicKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearPeerPublicKey() => $_clearField(4);
}

/// 服务器 → 发起方：有人兑换了你的配对码
class PairingRedeemed extends $pb.GeneratedMessage {
  factory PairingRedeemed({
    $core.String? peerDeviceId,
    $core.String? peerDeviceName,
    $core.String? peerPlatform,
    $core.List<$core.int>? peerPublicKey,
  }) {
    final result = PairingRedeemed._();
    if (peerDeviceId != null) result.peerDeviceId = peerDeviceId;
    if (peerDeviceName != null) result.peerDeviceName = peerDeviceName;
    if (peerPlatform != null) result.peerPlatform = peerPlatform;
    if (peerPublicKey != null) result.peerPublicKey = peerPublicKey;
    return result;
  }

  PairingRedeemed._();

  factory PairingRedeemed.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PairingRedeemed()..mergeFromBuffer(data, registry);
  factory PairingRedeemed.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PairingRedeemed()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PairingRedeemed',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: PairingRedeemed.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'peerDeviceId')
    ..aOS(2, _omitFieldNames ? '' : 'peerDeviceName')
    ..aOS(3, _omitFieldNames ? '' : 'peerPlatform')
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'peerPublicKey', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PairingRedeemed clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PairingRedeemed copyWith(void Function(PairingRedeemed) updates) =>
      super.copyWith((message) => updates(message as PairingRedeemed))
          as PairingRedeemed;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PairingRedeemed() / PairingRedeemed.new instead')
  static PairingRedeemed create() => PairingRedeemed._();
  static $pb.GeneratedMessage $_createMessage() => PairingRedeemed._();
  @$core.override
  PairingRedeemed createEmptyInstance() => PairingRedeemed._();
  @$core.pragma('dart2js:noInline')
  static PairingRedeemed getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PairingRedeemed>(
          PairingRedeemed.$_createMessage);
  static PairingRedeemed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get peerDeviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set peerDeviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPeerDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get peerDeviceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set peerDeviceName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPeerDeviceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeerDeviceName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get peerPlatform => $_getSZ(2);
  @$pb.TagNumber(3)
  set peerPlatform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPeerPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeerPlatform() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get peerPublicKey => $_getN(3);
  @$pb.TagNumber(4)
  set peerPublicKey($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPeerPublicKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearPeerPublicKey() => $_clearField(4);
}

/// TURN 凭证是按设备签发且有有效期的，因此必须在认证完成后才能下发，
/// 之后也会在临近过期时重新推送。
class IceConfig extends $pb.GeneratedMessage {
  factory IceConfig({
    $core.Iterable<IceServer>? iceServers,
  }) {
    final result = IceConfig._();
    if (iceServers != null) result.iceServers.addAll(iceServers);
    return result;
  }

  IceConfig._();

  factory IceConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IceConfig()..mergeFromBuffer(data, registry);
  factory IceConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      IceConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IceConfig',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: IceConfig.$_createMessage)
    ..pPM<IceServer>(1, _omitFieldNames ? '' : 'iceServers',
        subBuilder: IceServer.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IceConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IceConfig copyWith(void Function(IceConfig) updates) =>
      super.copyWith((message) => updates(message as IceConfig)) as IceConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use IceConfig() / IceConfig.new instead')
  static IceConfig create() => IceConfig._();
  static $pb.GeneratedMessage $_createMessage() => IceConfig._();
  @$core.override
  IceConfig createEmptyInstance() => IceConfig._();
  @$core.pragma('dart2js:noInline')
  static IceConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IceConfig>(IceConfig.$_createMessage);
  static IceConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<IceServer> get iceServers => $_getList(0);
}

enum ServerEnvelope_Payload {
  hello,
  forwarded,
  presence,
  pairingCreated,
  pairingRedeemedResult,
  pairingRedeemed,
  error,
  iceConfig,
  notSet
}

/// 客户端 ↔ 服务器的顶层信封
class ServerEnvelope extends $pb.GeneratedMessage {
  factory ServerEnvelope({
    ServerHello? hello,
    Signed? forwarded,
    PeerPresence? presence,
    PairingCreateResponse? pairingCreated,
    PairingRedeemResponse? pairingRedeemedResult,
    PairingRedeemed? pairingRedeemed,
    ServerError? error,
    IceConfig? iceConfig,
  }) {
    final result = ServerEnvelope._();
    if (hello != null) result.hello = hello;
    if (forwarded != null) result.forwarded = forwarded;
    if (presence != null) result.presence = presence;
    if (pairingCreated != null) result.pairingCreated = pairingCreated;
    if (pairingRedeemedResult != null)
      result.pairingRedeemedResult = pairingRedeemedResult;
    if (pairingRedeemed != null) result.pairingRedeemed = pairingRedeemed;
    if (error != null) result.error = error;
    if (iceConfig != null) result.iceConfig = iceConfig;
    return result;
  }

  ServerEnvelope._();

  factory ServerEnvelope.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ServerEnvelope()..mergeFromBuffer(data, registry);
  factory ServerEnvelope.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ServerEnvelope()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ServerEnvelope_Payload>
      _ServerEnvelope_PayloadByTag = {
    1: ServerEnvelope_Payload.hello,
    2: ServerEnvelope_Payload.forwarded,
    3: ServerEnvelope_Payload.presence,
    4: ServerEnvelope_Payload.pairingCreated,
    5: ServerEnvelope_Payload.pairingRedeemedResult,
    6: ServerEnvelope_Payload.pairingRedeemed,
    7: ServerEnvelope_Payload.error,
    8: ServerEnvelope_Payload.iceConfig,
    0: ServerEnvelope_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerEnvelope',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: ServerEnvelope.$_createMessage)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8])
    ..aOM<ServerHello>(1, _omitFieldNames ? '' : 'hello',
        subBuilder: ServerHello.$_createMessage)
    ..aOM<Signed>(2, _omitFieldNames ? '' : 'forwarded',
        subBuilder: Signed.$_createMessage)
    ..aOM<PeerPresence>(3, _omitFieldNames ? '' : 'presence',
        subBuilder: PeerPresence.$_createMessage)
    ..aOM<PairingCreateResponse>(4, _omitFieldNames ? '' : 'pairingCreated',
        subBuilder: PairingCreateResponse.$_createMessage)
    ..aOM<PairingRedeemResponse>(
        5, _omitFieldNames ? '' : 'pairingRedeemedResult',
        subBuilder: PairingRedeemResponse.$_createMessage)
    ..aOM<PairingRedeemed>(6, _omitFieldNames ? '' : 'pairingRedeemed',
        subBuilder: PairingRedeemed.$_createMessage)
    ..aOM<ServerError>(7, _omitFieldNames ? '' : 'error',
        subBuilder: ServerError.$_createMessage)
    ..aOM<IceConfig>(8, _omitFieldNames ? '' : 'iceConfig',
        subBuilder: IceConfig.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerEnvelope clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerEnvelope copyWith(void Function(ServerEnvelope) updates) =>
      super.copyWith((message) => updates(message as ServerEnvelope))
          as ServerEnvelope;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ServerEnvelope() / ServerEnvelope.new instead')
  static ServerEnvelope create() => ServerEnvelope._();
  static $pb.GeneratedMessage $_createMessage() => ServerEnvelope._();
  @$core.override
  ServerEnvelope createEmptyInstance() => ServerEnvelope._();
  @$core.pragma('dart2js:noInline')
  static ServerEnvelope getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerEnvelope>(
          ServerEnvelope.$_createMessage);
  static ServerEnvelope? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  ServerEnvelope_Payload whichPayload() =>
      _ServerEnvelope_PayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ServerHello get hello => $_getN(0);
  @$pb.TagNumber(1)
  set hello(ServerHello value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHello() => $_has(0);
  @$pb.TagNumber(1)
  void clearHello() => $_clearField(1);
  @$pb.TagNumber(1)
  ServerHello ensureHello() => $_ensure(0);

  @$pb.TagNumber(2)
  Signed get forwarded => $_getN(1);
  @$pb.TagNumber(2)
  set forwarded(Signed value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasForwarded() => $_has(1);
  @$pb.TagNumber(2)
  void clearForwarded() => $_clearField(2);
  @$pb.TagNumber(2)
  Signed ensureForwarded() => $_ensure(1);

  @$pb.TagNumber(3)
  PeerPresence get presence => $_getN(2);
  @$pb.TagNumber(3)
  set presence(PeerPresence value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPresence() => $_has(2);
  @$pb.TagNumber(3)
  void clearPresence() => $_clearField(3);
  @$pb.TagNumber(3)
  PeerPresence ensurePresence() => $_ensure(2);

  @$pb.TagNumber(4)
  PairingCreateResponse get pairingCreated => $_getN(3);
  @$pb.TagNumber(4)
  set pairingCreated(PairingCreateResponse value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPairingCreated() => $_has(3);
  @$pb.TagNumber(4)
  void clearPairingCreated() => $_clearField(4);
  @$pb.TagNumber(4)
  PairingCreateResponse ensurePairingCreated() => $_ensure(3);

  @$pb.TagNumber(5)
  PairingRedeemResponse get pairingRedeemedResult => $_getN(4);
  @$pb.TagNumber(5)
  set pairingRedeemedResult(PairingRedeemResponse value) =>
      $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPairingRedeemedResult() => $_has(4);
  @$pb.TagNumber(5)
  void clearPairingRedeemedResult() => $_clearField(5);
  @$pb.TagNumber(5)
  PairingRedeemResponse ensurePairingRedeemedResult() => $_ensure(4);

  @$pb.TagNumber(6)
  PairingRedeemed get pairingRedeemed => $_getN(5);
  @$pb.TagNumber(6)
  set pairingRedeemed(PairingRedeemed value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPairingRedeemed() => $_has(5);
  @$pb.TagNumber(6)
  void clearPairingRedeemed() => $_clearField(6);
  @$pb.TagNumber(6)
  PairingRedeemed ensurePairingRedeemed() => $_ensure(5);

  @$pb.TagNumber(7)
  ServerError get error => $_getN(6);
  @$pb.TagNumber(7)
  set error(ServerError value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasError() => $_has(6);
  @$pb.TagNumber(7)
  void clearError() => $_clearField(7);
  @$pb.TagNumber(7)
  ServerError ensureError() => $_ensure(6);

  @$pb.TagNumber(8)
  IceConfig get iceConfig => $_getN(7);
  @$pb.TagNumber(8)
  set iceConfig(IceConfig value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasIceConfig() => $_has(7);
  @$pb.TagNumber(8)
  void clearIceConfig() => $_clearField(8);
  @$pb.TagNumber(8)
  IceConfig ensureIceConfig() => $_ensure(7);
}

enum ClientEnvelope_Payload {
  hello,
  forward,
  pairingCreate,
  pairingRedeem,
  notSet
}

class ClientEnvelope extends $pb.GeneratedMessage {
  factory ClientEnvelope({
    ClientHello? hello,
    Signed? forward,
    PairingCreateRequest? pairingCreate,
    PairingRedeemRequest? pairingRedeem,
  }) {
    final result = ClientEnvelope._();
    if (hello != null) result.hello = hello;
    if (forward != null) result.forward = forward;
    if (pairingCreate != null) result.pairingCreate = pairingCreate;
    if (pairingRedeem != null) result.pairingRedeem = pairingRedeem;
    return result;
  }

  ClientEnvelope._();

  factory ClientEnvelope.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClientEnvelope()..mergeFromBuffer(data, registry);
  factory ClientEnvelope.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClientEnvelope()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ClientEnvelope_Payload>
      _ClientEnvelope_PayloadByTag = {
    1: ClientEnvelope_Payload.hello,
    2: ClientEnvelope_Payload.forward,
    3: ClientEnvelope_Payload.pairingCreate,
    4: ClientEnvelope_Payload.pairingRedeem,
    0: ClientEnvelope_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClientEnvelope',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: ClientEnvelope.$_createMessage)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<ClientHello>(1, _omitFieldNames ? '' : 'hello',
        subBuilder: ClientHello.$_createMessage)
    ..aOM<Signed>(2, _omitFieldNames ? '' : 'forward',
        subBuilder: Signed.$_createMessage)
    ..aOM<PairingCreateRequest>(3, _omitFieldNames ? '' : 'pairingCreate',
        subBuilder: PairingCreateRequest.$_createMessage)
    ..aOM<PairingRedeemRequest>(4, _omitFieldNames ? '' : 'pairingRedeem',
        subBuilder: PairingRedeemRequest.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientEnvelope clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClientEnvelope copyWith(void Function(ClientEnvelope) updates) =>
      super.copyWith((message) => updates(message as ClientEnvelope))
          as ClientEnvelope;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ClientEnvelope() / ClientEnvelope.new instead')
  static ClientEnvelope create() => ClientEnvelope._();
  static $pb.GeneratedMessage $_createMessage() => ClientEnvelope._();
  @$core.override
  ClientEnvelope createEmptyInstance() => ClientEnvelope._();
  @$core.pragma('dart2js:noInline')
  static ClientEnvelope getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClientEnvelope>(
          ClientEnvelope.$_createMessage);
  static ClientEnvelope? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  ClientEnvelope_Payload whichPayload() =>
      _ClientEnvelope_PayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ClientHello get hello => $_getN(0);
  @$pb.TagNumber(1)
  set hello(ClientHello value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHello() => $_has(0);
  @$pb.TagNumber(1)
  void clearHello() => $_clearField(1);
  @$pb.TagNumber(1)
  ClientHello ensureHello() => $_ensure(0);

  @$pb.TagNumber(2)
  Signed get forward => $_getN(1);
  @$pb.TagNumber(2)
  set forward(Signed value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasForward() => $_has(1);
  @$pb.TagNumber(2)
  void clearForward() => $_clearField(2);
  @$pb.TagNumber(2)
  Signed ensureForward() => $_ensure(1);

  @$pb.TagNumber(3)
  PairingCreateRequest get pairingCreate => $_getN(2);
  @$pb.TagNumber(3)
  set pairingCreate(PairingCreateRequest value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPairingCreate() => $_has(2);
  @$pb.TagNumber(3)
  void clearPairingCreate() => $_clearField(3);
  @$pb.TagNumber(3)
  PairingCreateRequest ensurePairingCreate() => $_ensure(2);

  @$pb.TagNumber(4)
  PairingRedeemRequest get pairingRedeem => $_getN(3);
  @$pb.TagNumber(4)
  set pairingRedeem(PairingRedeemRequest value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPairingRedeem() => $_has(3);
  @$pb.TagNumber(4)
  void clearPairingRedeem() => $_clearField(4);
  @$pb.TagNumber(4)
  PairingRedeemRequest ensurePairingRedeem() => $_ensure(3);
}

class ServerError extends $pb.GeneratedMessage {
  factory ServerError({
    $core.String? code,
    $core.String? message,
  }) {
    final result = ServerError._();
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    return result;
  }

  ServerError._();

  factory ServerError.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ServerError()..mergeFromBuffer(data, registry);
  factory ServerError.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ServerError()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerError',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: ServerError.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerError clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerError copyWith(void Function(ServerError) updates) =>
      super.copyWith((message) => updates(message as ServerError))
          as ServerError;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ServerError() / ServerError.new instead')
  static ServerError create() => ServerError._();
  static $pb.GeneratedMessage $_createMessage() => ServerError._();
  @$core.override
  ServerError createEmptyInstance() => ServerError._();
  @$core.pragma('dart2js:noInline')
  static ServerError getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerError>(
          ServerError.$_createMessage);
  static ServerError? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

enum LanPacket_Payload {
  signal,
  pairRequest,
  pairResponse,
  pairReject,
  nearbyRequest,
  nearbyPing,
  notSet
}

class LanPacket extends $pb.GeneratedMessage {
  factory LanPacket({
    Signed? signal,
    LanPairSigned? pairRequest,
    LanPairSigned? pairResponse,
    LanPairReject? pairReject,
    LanPairSigned? nearbyRequest,
    LanNearbyPing? nearbyPing,
  }) {
    final result = LanPacket._();
    if (signal != null) result.signal = signal;
    if (pairRequest != null) result.pairRequest = pairRequest;
    if (pairResponse != null) result.pairResponse = pairResponse;
    if (pairReject != null) result.pairReject = pairReject;
    if (nearbyRequest != null) result.nearbyRequest = nearbyRequest;
    if (nearbyPing != null) result.nearbyPing = nearbyPing;
    return result;
  }

  LanPacket._();

  factory LanPacket.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LanPacket()..mergeFromBuffer(data, registry);
  factory LanPacket.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LanPacket()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, LanPacket_Payload> _LanPacket_PayloadByTag =
      {
    1: LanPacket_Payload.signal,
    2: LanPacket_Payload.pairRequest,
    3: LanPacket_Payload.pairResponse,
    4: LanPacket_Payload.pairReject,
    5: LanPacket_Payload.nearbyRequest,
    6: LanPacket_Payload.nearbyPing,
    0: LanPacket_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LanPacket',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: LanPacket.$_createMessage)
    ..oo(0, [1, 2, 3, 4, 5, 6])
    ..aOM<Signed>(1, _omitFieldNames ? '' : 'signal',
        subBuilder: Signed.$_createMessage)
    ..aOM<LanPairSigned>(2, _omitFieldNames ? '' : 'pairRequest',
        subBuilder: LanPairSigned.$_createMessage)
    ..aOM<LanPairSigned>(3, _omitFieldNames ? '' : 'pairResponse',
        subBuilder: LanPairSigned.$_createMessage)
    ..aOM<LanPairReject>(4, _omitFieldNames ? '' : 'pairReject',
        subBuilder: LanPairReject.$_createMessage)
    ..aOM<LanPairSigned>(5, _omitFieldNames ? '' : 'nearbyRequest',
        subBuilder: LanPairSigned.$_createMessage)
    ..aOM<LanNearbyPing>(6, _omitFieldNames ? '' : 'nearbyPing',
        subBuilder: LanNearbyPing.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LanPacket clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LanPacket copyWith(void Function(LanPacket) updates) =>
      super.copyWith((message) => updates(message as LanPacket)) as LanPacket;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LanPacket() / LanPacket.new instead')
  static LanPacket create() => LanPacket._();
  static $pb.GeneratedMessage $_createMessage() => LanPacket._();
  @$core.override
  LanPacket createEmptyInstance() => LanPacket._();
  @$core.pragma('dart2js:noInline')
  static LanPacket getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LanPacket>(LanPacket.$_createMessage);
  static LanPacket? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  LanPacket_Payload whichPayload() => _LanPacket_PayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Signed get signal => $_getN(0);
  @$pb.TagNumber(1)
  set signal(Signed value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSignal() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignal() => $_clearField(1);
  @$pb.TagNumber(1)
  Signed ensureSignal() => $_ensure(0);

  @$pb.TagNumber(2)
  LanPairSigned get pairRequest => $_getN(1);
  @$pb.TagNumber(2)
  set pairRequest(LanPairSigned value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPairRequest() => $_has(1);
  @$pb.TagNumber(2)
  void clearPairRequest() => $_clearField(2);
  @$pb.TagNumber(2)
  LanPairSigned ensurePairRequest() => $_ensure(1);

  @$pb.TagNumber(3)
  LanPairSigned get pairResponse => $_getN(2);
  @$pb.TagNumber(3)
  set pairResponse(LanPairSigned value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPairResponse() => $_has(2);
  @$pb.TagNumber(3)
  void clearPairResponse() => $_clearField(3);
  @$pb.TagNumber(3)
  LanPairSigned ensurePairResponse() => $_ensure(2);

  @$pb.TagNumber(4)
  LanPairReject get pairReject => $_getN(3);
  @$pb.TagNumber(4)
  set pairReject(LanPairReject value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPairReject() => $_has(3);
  @$pb.TagNumber(4)
  void clearPairReject() => $_clearField(4);
  @$pb.TagNumber(4)
  LanPairReject ensurePairReject() => $_ensure(3);

  @$pb.TagNumber(5)
  LanPairSigned get nearbyRequest => $_getN(4);
  @$pb.TagNumber(5)
  set nearbyRequest(LanPairSigned value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasNearbyRequest() => $_has(4);
  @$pb.TagNumber(5)
  void clearNearbyRequest() => $_clearField(5);
  @$pb.TagNumber(5)
  LanPairSigned ensureNearbyRequest() => $_ensure(4);

  @$pb.TagNumber(6)
  LanNearbyPing get nearbyPing => $_getN(5);
  @$pb.TagNumber(6)
  set nearbyPing(LanNearbyPing value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasNearbyPing() => $_has(5);
  @$pb.TagNumber(6)
  void clearNearbyPing() => $_clearField(6);
  @$pb.TagNumber(6)
  LanNearbyPing ensureNearbyPing() => $_ensure(5);
}

/// 已配对设备之间的上线通知。还没连通时定期发，连通后低频保活。
/// 两端都往对方发，有状态的防火墙（Windows）会放行对方的包。
class LanHello extends $pb.GeneratedMessage {
  factory LanHello({
    $core.Iterable<$core.String>? addresses,
    $core.bool? replyWanted,
    $core.int? intervalSeconds,
    $core.List<$core.int>? boot,
  }) {
    final result = LanHello._();
    if (addresses != null) result.addresses.addAll(addresses);
    if (replyWanted != null) result.replyWanted = replyWanted;
    if (intervalSeconds != null) result.intervalSeconds = intervalSeconds;
    if (boot != null) result.boot = boot;
    return result;
  }

  LanHello._();

  factory LanHello.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LanHello()..mergeFromBuffer(data, registry);
  factory LanHello.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LanHello()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LanHello',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: LanHello.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'addresses')
    ..aOB(2, _omitFieldNames ? '' : 'replyWanted')
    ..aI(3, _omitFieldNames ? '' : 'intervalSeconds',
        fieldType: $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
        4, _omitFieldNames ? '' : 'boot', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LanHello clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LanHello copyWith(void Function(LanHello) updates) =>
      super.copyWith((message) => updates(message as LanHello)) as LanHello;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LanHello() / LanHello.new instead')
  static LanHello create() => LanHello._();
  static $pb.GeneratedMessage $_createMessage() => LanHello._();
  @$core.override
  LanHello createEmptyInstance() => LanHello._();
  @$core.pragma('dart2js:noInline')
  static LanHello getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LanHello>(LanHello.$_createMessage);
  static LanHello? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get addresses => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get replyWanted => $_getBF(1);
  @$pb.TagNumber(2)
  set replyWanted($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReplyWanted() => $_has(1);
  @$pb.TagNumber(2)
  void clearReplyWanted() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get intervalSeconds => $_getIZ(2);
  @$pb.TagNumber(3)
  set intervalSeconds($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIntervalSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearIntervalSeconds() => $_clearField(3);

  /// 发送方每次启动时随机生成。变了说明对方重启过，旧的 P2P 连接已经失效，
  /// 要立即重建，而不是等连接超时（用服务器时，这件事由上下线通知完成）
  @$pb.TagNumber(4)
  $core.List<$core.int> get boot => $_getN(3);
  @$pb.TagNumber(4)
  set boot($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBoot() => $_has(3);
  @$pb.TagNumber(4)
  void clearBoot() => $_clearField(4);
}

/// payload 是序列化后的 LanPairInfo，signature 用 LanPairInfo.public_key 签名。
class LanPairSigned extends $pb.GeneratedMessage {
  factory LanPairSigned({
    $core.List<$core.int>? payload,
    $core.List<$core.int>? signature,
  }) {
    final result = LanPairSigned._();
    if (payload != null) result.payload = payload;
    if (signature != null) result.signature = signature;
    return result;
  }

  LanPairSigned._();

  factory LanPairSigned.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LanPairSigned()..mergeFromBuffer(data, registry);
  factory LanPairSigned.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LanPairSigned()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LanPairSigned',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: LanPairSigned.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'payload', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'signature', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LanPairSigned clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LanPairSigned copyWith(void Function(LanPairSigned) updates) =>
      super.copyWith((message) => updates(message as LanPairSigned))
          as LanPairSigned;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LanPairSigned() / LanPairSigned.new instead')
  static LanPairSigned create() => LanPairSigned._();
  static $pb.GeneratedMessage $_createMessage() => LanPairSigned._();
  @$core.override
  LanPairSigned createEmptyInstance() => LanPairSigned._();
  @$core.pragma('dart2js:noInline')
  static LanPairSigned getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LanPairSigned>(
          LanPairSigned.$_createMessage);
  static LanPairSigned? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get payload => $_getN(0);
  @$pb.TagNumber(1)
  set payload($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPayload() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayload() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get signature => $_getN(1);
  @$pb.TagNumber(2)
  set signature($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSignature() => $_has(1);
  @$pb.TagNumber(2)
  void clearSignature() => $_clearField(2);
}

class LanPairInfo extends $pb.GeneratedMessage {
  factory LanPairInfo({
    $core.String? code,
    $core.String? deviceId,
    $core.String? deviceName,
    $core.String? platform,
    $core.List<$core.int>? publicKey,
    $core.Iterable<$core.String>? addresses,
    $fixnum.Int64? timestampUnix,
    $core.List<$core.int>? nonce,
    $core.List<$core.int>? requestNonce,
  }) {
    final result = LanPairInfo._();
    if (code != null) result.code = code;
    if (deviceId != null) result.deviceId = deviceId;
    if (deviceName != null) result.deviceName = deviceName;
    if (platform != null) result.platform = platform;
    if (publicKey != null) result.publicKey = publicKey;
    if (addresses != null) result.addresses.addAll(addresses);
    if (timestampUnix != null) result.timestampUnix = timestampUnix;
    if (nonce != null) result.nonce = nonce;
    if (requestNonce != null) result.requestNonce = requestNonce;
    return result;
  }

  LanPairInfo._();

  factory LanPairInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LanPairInfo()..mergeFromBuffer(data, registry);
  factory LanPairInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LanPairInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LanPairInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: LanPairInfo.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'deviceId')
    ..aOS(3, _omitFieldNames ? '' : 'deviceName')
    ..aOS(4, _omitFieldNames ? '' : 'platform')
    ..a<$core.List<$core.int>>(
        5, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.OY)
    ..pPS(6, _omitFieldNames ? '' : 'addresses')
    ..aInt64(7, _omitFieldNames ? '' : 'timestampUnix')
    ..a<$core.List<$core.int>>(
        8, _omitFieldNames ? '' : 'nonce', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        9, _omitFieldNames ? '' : 'requestNonce', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LanPairInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LanPairInfo copyWith(void Function(LanPairInfo) updates) =>
      super.copyWith((message) => updates(message as LanPairInfo))
          as LanPairInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LanPairInfo() / LanPairInfo.new instead')
  static LanPairInfo create() => LanPairInfo._();
  static $pb.GeneratedMessage $_createMessage() => LanPairInfo._();
  @$core.override
  LanPairInfo createEmptyInstance() => LanPairInfo._();
  @$core.pragma('dart2js:noInline')
  static LanPairInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LanPairInfo>(
          LanPairInfo.$_createMessage);
  static LanPairInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeviceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get deviceName => $_getSZ(2);
  @$pb.TagNumber(3)
  set deviceName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDeviceName() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeviceName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get platform => $_getSZ(3);
  @$pb.TagNumber(4)
  set platform($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPlatform() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlatform() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get publicKey => $_getN(4);
  @$pb.TagNumber(5)
  set publicKey($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPublicKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearPublicKey() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get addresses => $_getList(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get timestampUnix => $_getI64(6);
  @$pb.TagNumber(7)
  set timestampUnix($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTimestampUnix() => $_has(6);
  @$pb.TagNumber(7)
  void clearTimestampUnix() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.List<$core.int> get nonce => $_getN(7);
  @$pb.TagNumber(8)
  set nonce($core.List<$core.int> value) => $_setBytes(7, value);
  @$pb.TagNumber(8)
  $core.bool hasNonce() => $_has(7);
  @$pb.TagNumber(8)
  void clearNonce() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.List<$core.int> get requestNonce => $_getN(8);
  @$pb.TagNumber(9)
  set requestNonce($core.List<$core.int> value) => $_setBytes(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRequestNonce() => $_has(8);
  @$pb.TagNumber(9)
  void clearRequestNonce() => $_clearField(9);
}

class LanPairReject extends $pb.GeneratedMessage {
  factory LanPairReject({
    $core.List<$core.int>? requestNonce,
    $core.String? reason,
  }) {
    final result = LanPairReject._();
    if (requestNonce != null) result.requestNonce = requestNonce;
    if (reason != null) result.reason = reason;
    return result;
  }

  LanPairReject._();

  factory LanPairReject.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LanPairReject()..mergeFromBuffer(data, registry);
  factory LanPairReject.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LanPairReject()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LanPairReject',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: LanPairReject.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'requestNonce', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LanPairReject clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LanPairReject copyWith(void Function(LanPairReject) updates) =>
      super.copyWith((message) => updates(message as LanPairReject))
          as LanPairReject;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LanPairReject() / LanPairReject.new instead')
  static LanPairReject create() => LanPairReject._();
  static $pb.GeneratedMessage $_createMessage() => LanPairReject._();
  @$core.override
  LanPairReject createEmptyInstance() => LanPairReject._();
  @$core.pragma('dart2js:noInline')
  static LanPairReject getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LanPairReject>(
          LanPairReject.$_createMessage);
  static LanPairReject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get requestNonce => $_getN(0);
  @$pb.TagNumber(1)
  set requestNonce($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestNonce() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestNonce() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class LanNearbyPing extends $pb.GeneratedMessage {
  factory LanNearbyPing({
    $core.String? instance,
    $core.String? name,
    $core.String? platform,
    $core.String? token,
  }) {
    final result = LanNearbyPing._();
    if (instance != null) result.instance = instance;
    if (name != null) result.name = name;
    if (platform != null) result.platform = platform;
    if (token != null) result.token = token;
    return result;
  }

  LanNearbyPing._();

  factory LanNearbyPing.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LanNearbyPing()..mergeFromBuffer(data, registry);
  factory LanNearbyPing.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LanNearbyPing()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LanNearbyPing',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: LanNearbyPing.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'instance')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'platform')
    ..aOS(4, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LanNearbyPing clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LanNearbyPing copyWith(void Function(LanNearbyPing) updates) =>
      super.copyWith((message) => updates(message as LanNearbyPing))
          as LanNearbyPing;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LanNearbyPing() / LanNearbyPing.new instead')
  static LanNearbyPing create() => LanNearbyPing._();
  static $pb.GeneratedMessage $_createMessage() => LanNearbyPing._();
  @$core.override
  LanNearbyPing createEmptyInstance() => LanNearbyPing._();
  @$core.pragma('dart2js:noInline')
  static LanNearbyPing getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LanNearbyPing>(
          LanNearbyPing.$_createMessage);
  static LanNearbyPing? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instance => $_getSZ(0);
  @$pb.TagNumber(1)
  set instance($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstance() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstance() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get platform => $_getSZ(2);
  @$pb.TagNumber(3)
  set platform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatform() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get token => $_getSZ(3);
  @$pb.TagNumber(4)
  set token($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasToken() => $_has(3);
  @$pb.TagNumber(4)
  void clearToken() => $_clearField(4);
}

enum PeerMessage_Payload {
  offer,
  fetch,
  reject,
  header,
  done,
  link,
  display,
  features,
  sendOffer,
  sendAnswer,
  sendCancel,
  sendResult,
  notSet
}

/// 控制通道消息
class PeerMessage extends $pb.GeneratedMessage {
  factory PeerMessage({
    ClipOffer? offer,
    PeerFetch? fetch,
    FetchReject? reject,
    TransferHeader? header,
    TransferDone? done,
    LinkInfo? link,
    PeerDisplay? display,
    PeerFeatures? features,
    SendOffer? sendOffer,
    SendAnswer? sendAnswer,
    SendCancel? sendCancel,
    SendResult? sendResult,
  }) {
    final result = PeerMessage._();
    if (offer != null) result.offer = offer;
    if (fetch != null) result.fetch = fetch;
    if (reject != null) result.reject = reject;
    if (header != null) result.header = header;
    if (done != null) result.done = done;
    if (link != null) result.link = link;
    if (display != null) result.display = display;
    if (features != null) result.features = features;
    if (sendOffer != null) result.sendOffer = sendOffer;
    if (sendAnswer != null) result.sendAnswer = sendAnswer;
    if (sendCancel != null) result.sendCancel = sendCancel;
    if (sendResult != null) result.sendResult = sendResult;
    return result;
  }

  PeerMessage._();

  factory PeerMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PeerMessage()..mergeFromBuffer(data, registry);
  factory PeerMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PeerMessage()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, PeerMessage_Payload>
      _PeerMessage_PayloadByTag = {
    1: PeerMessage_Payload.offer,
    2: PeerMessage_Payload.fetch,
    3: PeerMessage_Payload.reject,
    4: PeerMessage_Payload.header,
    5: PeerMessage_Payload.done,
    6: PeerMessage_Payload.link,
    7: PeerMessage_Payload.display,
    8: PeerMessage_Payload.features,
    9: PeerMessage_Payload.sendOffer,
    10: PeerMessage_Payload.sendAnswer,
    11: PeerMessage_Payload.sendCancel,
    12: PeerMessage_Payload.sendResult,
    0: PeerMessage_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PeerMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: PeerMessage.$_createMessage)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
    ..aOM<ClipOffer>(1, _omitFieldNames ? '' : 'offer',
        subBuilder: ClipOffer.$_createMessage)
    ..aOM<PeerFetch>(2, _omitFieldNames ? '' : 'fetch',
        subBuilder: PeerFetch.$_createMessage)
    ..aOM<FetchReject>(3, _omitFieldNames ? '' : 'reject',
        subBuilder: FetchReject.$_createMessage)
    ..aOM<TransferHeader>(4, _omitFieldNames ? '' : 'header',
        subBuilder: TransferHeader.$_createMessage)
    ..aOM<TransferDone>(5, _omitFieldNames ? '' : 'done',
        subBuilder: TransferDone.$_createMessage)
    ..aOM<LinkInfo>(6, _omitFieldNames ? '' : 'link',
        subBuilder: LinkInfo.$_createMessage)
    ..aOM<PeerDisplay>(7, _omitFieldNames ? '' : 'display',
        subBuilder: PeerDisplay.$_createMessage)
    ..aOM<PeerFeatures>(8, _omitFieldNames ? '' : 'features',
        subBuilder: PeerFeatures.$_createMessage)
    ..aOM<SendOffer>(9, _omitFieldNames ? '' : 'sendOffer',
        subBuilder: SendOffer.$_createMessage)
    ..aOM<SendAnswer>(10, _omitFieldNames ? '' : 'sendAnswer',
        subBuilder: SendAnswer.$_createMessage)
    ..aOM<SendCancel>(11, _omitFieldNames ? '' : 'sendCancel',
        subBuilder: SendCancel.$_createMessage)
    ..aOM<SendResult>(12, _omitFieldNames ? '' : 'sendResult',
        subBuilder: SendResult.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PeerMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PeerMessage copyWith(void Function(PeerMessage) updates) =>
      super.copyWith((message) => updates(message as PeerMessage))
          as PeerMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PeerMessage() / PeerMessage.new instead')
  static PeerMessage create() => PeerMessage._();
  static $pb.GeneratedMessage $_createMessage() => PeerMessage._();
  @$core.override
  PeerMessage createEmptyInstance() => PeerMessage._();
  @$core.pragma('dart2js:noInline')
  static PeerMessage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PeerMessage>(
          PeerMessage.$_createMessage);
  static PeerMessage? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  PeerMessage_Payload whichPayload() =>
      _PeerMessage_PayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ClipOffer get offer => $_getN(0);
  @$pb.TagNumber(1)
  set offer(ClipOffer value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOffer() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffer() => $_clearField(1);
  @$pb.TagNumber(1)
  ClipOffer ensureOffer() => $_ensure(0);

  @$pb.TagNumber(2)
  PeerFetch get fetch => $_getN(1);
  @$pb.TagNumber(2)
  set fetch(PeerFetch value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFetch() => $_has(1);
  @$pb.TagNumber(2)
  void clearFetch() => $_clearField(2);
  @$pb.TagNumber(2)
  PeerFetch ensureFetch() => $_ensure(1);

  @$pb.TagNumber(3)
  FetchReject get reject => $_getN(2);
  @$pb.TagNumber(3)
  set reject(FetchReject value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReject() => $_has(2);
  @$pb.TagNumber(3)
  void clearReject() => $_clearField(3);
  @$pb.TagNumber(3)
  FetchReject ensureReject() => $_ensure(2);

  @$pb.TagNumber(4)
  TransferHeader get header => $_getN(3);
  @$pb.TagNumber(4)
  set header(TransferHeader value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasHeader() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeader() => $_clearField(4);
  @$pb.TagNumber(4)
  TransferHeader ensureHeader() => $_ensure(3);

  @$pb.TagNumber(5)
  TransferDone get done => $_getN(4);
  @$pb.TagNumber(5)
  set done(TransferDone value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDone() => $_has(4);
  @$pb.TagNumber(5)
  void clearDone() => $_clearField(5);
  @$pb.TagNumber(5)
  TransferDone ensureDone() => $_ensure(4);

  @$pb.TagNumber(6)
  LinkInfo get link => $_getN(5);
  @$pb.TagNumber(6)
  set link(LinkInfo value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasLink() => $_has(5);
  @$pb.TagNumber(6)
  void clearLink() => $_clearField(6);
  @$pb.TagNumber(6)
  LinkInfo ensureLink() => $_ensure(5);

  @$pb.TagNumber(7)
  PeerDisplay get display => $_getN(6);
  @$pb.TagNumber(7)
  set display(PeerDisplay value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasDisplay() => $_has(6);
  @$pb.TagNumber(7)
  void clearDisplay() => $_clearField(7);
  @$pb.TagNumber(7)
  PeerDisplay ensureDisplay() => $_ensure(6);

  @$pb.TagNumber(8)
  PeerFeatures get features => $_getN(7);
  @$pb.TagNumber(8)
  set features(PeerFeatures value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasFeatures() => $_has(7);
  @$pb.TagNumber(8)
  void clearFeatures() => $_clearField(8);
  @$pb.TagNumber(8)
  PeerFeatures ensureFeatures() => $_ensure(7);

  /// 隔空传送：把文件直接发给某一台设备，见 design/send-files.md
  @$pb.TagNumber(9)
  SendOffer get sendOffer => $_getN(8);
  @$pb.TagNumber(9)
  set sendOffer(SendOffer value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSendOffer() => $_has(8);
  @$pb.TagNumber(9)
  void clearSendOffer() => $_clearField(9);
  @$pb.TagNumber(9)
  SendOffer ensureSendOffer() => $_ensure(8);

  @$pb.TagNumber(10)
  SendAnswer get sendAnswer => $_getN(9);
  @$pb.TagNumber(10)
  set sendAnswer(SendAnswer value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasSendAnswer() => $_has(9);
  @$pb.TagNumber(10)
  void clearSendAnswer() => $_clearField(10);
  @$pb.TagNumber(10)
  SendAnswer ensureSendAnswer() => $_ensure(9);

  @$pb.TagNumber(11)
  SendCancel get sendCancel => $_getN(10);
  @$pb.TagNumber(11)
  set sendCancel(SendCancel value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasSendCancel() => $_has(10);
  @$pb.TagNumber(11)
  void clearSendCancel() => $_clearField(11);
  @$pb.TagNumber(11)
  SendCancel ensureSendCancel() => $_ensure(10);

  @$pb.TagNumber(12)
  SendResult get sendResult => $_getN(11);
  @$pb.TagNumber(12)
  set sendResult(SendResult value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasSendResult() => $_has(11);
  @$pb.TagNumber(12)
  void clearSendResult() => $_clearField(12);
  @$pb.TagNumber(12)
  SendResult ensureSendResult() => $_ensure(11);
}

/// 连接就绪后各自发一次，与 LinkInfo 一起；功能开关变了再发一次。
/// 旧版本不发，也不认识它，对方据此当作不支持。
class PeerFeatures extends $pb.GeneratedMessage {
  factory PeerFeatures({
    $core.Iterable<$core.String>? features,
  }) {
    final result = PeerFeatures._();
    if (features != null) result.features.addAll(features);
    return result;
  }

  PeerFeatures._();

  factory PeerFeatures.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PeerFeatures()..mergeFromBuffer(data, registry);
  factory PeerFeatures.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PeerFeatures()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PeerFeatures',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: PeerFeatures.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'features')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PeerFeatures clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PeerFeatures copyWith(void Function(PeerFeatures) updates) =>
      super.copyWith((message) => updates(message as PeerFeatures))
          as PeerFeatures;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PeerFeatures() / PeerFeatures.new instead')
  static PeerFeatures create() => PeerFeatures._();
  static $pb.GeneratedMessage $_createMessage() => PeerFeatures._();
  @$core.override
  PeerFeatures createEmptyInstance() => PeerFeatures._();
  @$core.pragma('dart2js:noInline')
  static PeerFeatures getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PeerFeatures>(
          PeerFeatures.$_createMessage);
  static PeerFeatures? _defaultInstance;

  /// "send_files_v1"：能接收隔空传送。关闭了接收时不带它，改带 "send_files_off"，
  /// 对方的雷达显示「不接收文件」而不是「需要更新」
  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get features => $_getList(0);
}

/// 连接就绪后各自发一次。只有本端能确定自己发出的数据是否走 TURN：
/// 对端经中转发来的包，在本端看来可能只是一个普通地址（peer-reflexive），
/// 单靠自己的视角会把中转误判成直连。两端交换后，任一端经中转即显示为中转。
class LinkInfo extends $pb.GeneratedMessage {
  factory LinkInfo({
    $core.bool? relayed,
  }) {
    final result = LinkInfo._();
    if (relayed != null) result.relayed = relayed;
    return result;
  }

  LinkInfo._();

  factory LinkInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkInfo()..mergeFromBuffer(data, registry);
  factory LinkInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: LinkInfo.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'relayed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkInfo copyWith(void Function(LinkInfo) updates) =>
      super.copyWith((message) => updates(message as LinkInfo)) as LinkInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LinkInfo() / LinkInfo.new instead')
  static LinkInfo create() => LinkInfo._();
  static $pb.GeneratedMessage $_createMessage() => LinkInfo._();
  @$core.override
  LinkInfo createEmptyInstance() => LinkInfo._();
  @$core.pragma('dart2js:noInline')
  static LinkInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinkInfo>(LinkInfo.$_createMessage);
  static LinkInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get relayed => $_getBF(0);
  @$pb.TagNumber(1)
  set relayed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRelayed() => $_has(0);
  @$pb.TagNumber(1)
  void clearRelayed() => $_clearField(1);
}

class PeerDisplay extends $pb.GeneratedMessage {
  factory PeerDisplay({
    $core.String? name,
    $core.String? platform,
  }) {
    final result = PeerDisplay._();
    if (name != null) result.name = name;
    if (platform != null) result.platform = platform;
    return result;
  }

  PeerDisplay._();

  factory PeerDisplay.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PeerDisplay()..mergeFromBuffer(data, registry);
  factory PeerDisplay.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PeerDisplay()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PeerDisplay',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: PeerDisplay.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'platform')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PeerDisplay clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PeerDisplay copyWith(void Function(PeerDisplay) updates) =>
      super.copyWith((message) => updates(message as PeerDisplay))
          as PeerDisplay;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PeerDisplay() / PeerDisplay.new instead')
  static PeerDisplay create() => PeerDisplay._();
  static $pb.GeneratedMessage $_createMessage() => PeerDisplay._();
  @$core.override
  PeerDisplay createEmptyInstance() => PeerDisplay._();
  @$core.pragma('dart2js:noInline')
  static PeerDisplay getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PeerDisplay>(
          PeerDisplay.$_createMessage);
  static PeerDisplay? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get platform => $_getSZ(1);
  @$pb.TagNumber(2)
  set platform($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlatform() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatform() => $_clearField(2);
}

/// 复制发生时广播给所有在线对端。
/// 小于阈值的内容会紧接着主动推送；大于阈值的只发这条，等对方来取。
class ClipOffer extends $pb.GeneratedMessage {
  factory ClipOffer({
    $core.String? clipId,
    $0.ClipKind? kind,
    $core.Iterable<$0.ClipItem>? items,
    $fixnum.Int64? totalSize,
    $core.String? textContent,
    $fixnum.Int64? createdAtUnix,
    $core.bool? willPush,
    $core.String? plainText,
    $core.bool? backlog,
  }) {
    final result = ClipOffer._();
    if (clipId != null) result.clipId = clipId;
    if (kind != null) result.kind = kind;
    if (items != null) result.items.addAll(items);
    if (totalSize != null) result.totalSize = totalSize;
    if (textContent != null) result.textContent = textContent;
    if (createdAtUnix != null) result.createdAtUnix = createdAtUnix;
    if (willPush != null) result.willPush = willPush;
    if (plainText != null) result.plainText = plainText;
    if (backlog != null) result.backlog = backlog;
    return result;
  }

  ClipOffer._();

  factory ClipOffer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClipOffer()..mergeFromBuffer(data, registry);
  factory ClipOffer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClipOffer()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClipOffer',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: ClipOffer.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'clipId')
    ..aE<$0.ClipKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: $0.ClipKind.values)
    ..pPM<$0.ClipItem>(3, _omitFieldNames ? '' : 'items',
        subBuilder: $0.ClipItem.$_createMessage)
    ..aInt64(4, _omitFieldNames ? '' : 'totalSize')
    ..aOS(5, _omitFieldNames ? '' : 'textContent')
    ..aInt64(6, _omitFieldNames ? '' : 'createdAtUnix')
    ..aOB(7, _omitFieldNames ? '' : 'willPush')
    ..aOS(8, _omitFieldNames ? '' : 'plainText')
    ..aOB(9, _omitFieldNames ? '' : 'backlog')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClipOffer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClipOffer copyWith(void Function(ClipOffer) updates) =>
      super.copyWith((message) => updates(message as ClipOffer)) as ClipOffer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ClipOffer() / ClipOffer.new instead')
  static ClipOffer create() => ClipOffer._();
  static $pb.GeneratedMessage $_createMessage() => ClipOffer._();
  @$core.override
  ClipOffer createEmptyInstance() => ClipOffer._();
  @$core.pragma('dart2js:noInline')
  static ClipOffer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClipOffer>(ClipOffer.$_createMessage);
  static ClipOffer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClipId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.ClipKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind($0.ClipKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$0.ClipItem> get items => $_getList(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get totalSize => $_getI64(3);
  @$pb.TagNumber(4)
  set totalSize($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get textContent => $_getSZ(4);
  @$pb.TagNumber(5)
  set textContent($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTextContent() => $_has(4);
  @$pb.TagNumber(5)
  void clearTextContent() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get createdAtUnix => $_getI64(5);
  @$pb.TagNumber(6)
  set createdAtUnix($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatedAtUnix() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAtUnix() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get willPush => $_getBF(6);
  @$pb.TagNumber(7)
  set willPush($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasWillPush() => $_has(6);
  @$pb.TagNumber(7)
  void clearWillPush() => $_clearField(7);

  /// HTML 的纯文本形式（此时 text_content 是 HTML 标记）。旧版本不发这个字段，
  /// 收到空值时由接收方从 HTML 中提取。
  @$pb.TagNumber(8)
  $core.String get plainText => $_getSZ(7);
  @$pb.TagNumber(8)
  set plainText($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPlainText() => $_has(7);
  @$pb.TagNumber(8)
  void clearPlainText() => $_clearField(8);

  /// 补发：复制时对端连不上，连接恢复后才发过去的旧内容。
  /// 只进复制记录，不写进对端的剪贴板，免得覆盖对方此刻正在用的内容。
  @$pb.TagNumber(9)
  $core.bool get backlog => $_getBF(8);
  @$pb.TagNumber(9)
  set backlog($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBacklog() => $_has(8);
  @$pb.TagNumber(9)
  void clearBacklog() => $_clearField(9);
}

/// 与 daemon.proto 的 FetchRequest（UI→daemon）区分：这条是 daemon→peer
class PeerFetch extends $pb.GeneratedMessage {
  factory PeerFetch({
    $core.String? clipId,
  }) {
    final result = PeerFetch._();
    if (clipId != null) result.clipId = clipId;
    return result;
  }

  PeerFetch._();

  factory PeerFetch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PeerFetch()..mergeFromBuffer(data, registry);
  factory PeerFetch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PeerFetch()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PeerFetch',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: PeerFetch.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'clipId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PeerFetch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PeerFetch copyWith(void Function(PeerFetch) updates) =>
      super.copyWith((message) => updates(message as PeerFetch)) as PeerFetch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PeerFetch() / PeerFetch.new instead')
  static PeerFetch create() => PeerFetch._();
  static $pb.GeneratedMessage $_createMessage() => PeerFetch._();
  @$core.override
  PeerFetch createEmptyInstance() => PeerFetch._();
  @$core.pragma('dart2js:noInline')
  static PeerFetch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PeerFetch>(PeerFetch.$_createMessage);
  static PeerFetch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClipId() => $_clearField(1);
}

class FetchReject extends $pb.GeneratedMessage {
  factory FetchReject({
    $core.String? clipId,
    $core.String? reason,
  }) {
    final result = FetchReject._();
    if (clipId != null) result.clipId = clipId;
    if (reason != null) result.reason = reason;
    return result;
  }

  FetchReject._();

  factory FetchReject.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FetchReject()..mergeFromBuffer(data, registry);
  factory FetchReject.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FetchReject()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FetchReject',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: FetchReject.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'clipId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FetchReject clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FetchReject copyWith(void Function(FetchReject) updates) =>
      super.copyWith((message) => updates(message as FetchReject))
          as FetchReject;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FetchReject() / FetchReject.new instead')
  static FetchReject create() => FetchReject._();
  static $pb.GeneratedMessage $_createMessage() => FetchReject._();
  @$core.override
  FetchReject createEmptyInstance() => FetchReject._();
  @$core.pragma('dart2js:noInline')
  static FetchReject getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FetchReject>(
          FetchReject.$_createMessage);
  static FetchReject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClipId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

/// 数据流的第一条消息，之后是裸字节流直到 total_bytes
class TransferHeader extends $pb.GeneratedMessage {
  factory TransferHeader({
    $core.String? clipId,
    $core.String? streamId,
    $fixnum.Int64? totalBytes,
    Compression? compression,
    Packaging? packaging,
  }) {
    final result = TransferHeader._();
    if (clipId != null) result.clipId = clipId;
    if (streamId != null) result.streamId = streamId;
    if (totalBytes != null) result.totalBytes = totalBytes;
    if (compression != null) result.compression = compression;
    if (packaging != null) result.packaging = packaging;
    return result;
  }

  TransferHeader._();

  factory TransferHeader.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TransferHeader()..mergeFromBuffer(data, registry);
  factory TransferHeader.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TransferHeader()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransferHeader',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: TransferHeader.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'clipId')
    ..aOS(2, _omitFieldNames ? '' : 'streamId')
    ..aInt64(3, _omitFieldNames ? '' : 'totalBytes')
    ..aE<Compression>(4, _omitFieldNames ? '' : 'compression',
        enumValues: Compression.values)
    ..aE<Packaging>(5, _omitFieldNames ? '' : 'packaging',
        enumValues: Packaging.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferHeader clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferHeader copyWith(void Function(TransferHeader) updates) =>
      super.copyWith((message) => updates(message as TransferHeader))
          as TransferHeader;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TransferHeader() / TransferHeader.new instead')
  static TransferHeader create() => TransferHeader._();
  static $pb.GeneratedMessage $_createMessage() => TransferHeader._();
  @$core.override
  TransferHeader createEmptyInstance() => TransferHeader._();
  @$core.pragma('dart2js:noInline')
  static TransferHeader getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransferHeader>(
          TransferHeader.$_createMessage);
  static TransferHeader? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClipId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get streamId => $_getSZ(1);
  @$pb.TagNumber(2)
  set streamId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStreamId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStreamId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get totalBytes => $_getI64(2);
  @$pb.TagNumber(3)
  set totalBytes($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalBytes() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalBytes() => $_clearField(3);

  @$pb.TagNumber(4)
  Compression get compression => $_getN(3);
  @$pb.TagNumber(4)
  set compression(Compression value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCompression() => $_has(3);
  @$pb.TagNumber(4)
  void clearCompression() => $_clearField(4);

  @$pb.TagNumber(5)
  Packaging get packaging => $_getN(4);
  @$pb.TagNumber(5)
  set packaging(Packaging value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPackaging() => $_has(4);
  @$pb.TagNumber(5)
  void clearPackaging() => $_clearField(5);
}

class TransferDone extends $pb.GeneratedMessage {
  factory TransferDone({
    $core.String? clipId,
    $core.String? streamId,
    $core.bool? ok,
    $core.String? error,
    $core.List<$core.int>? sha256,
  }) {
    final result = TransferDone._();
    if (clipId != null) result.clipId = clipId;
    if (streamId != null) result.streamId = streamId;
    if (ok != null) result.ok = ok;
    if (error != null) result.error = error;
    if (sha256 != null) result.sha256 = sha256;
    return result;
  }

  TransferDone._();

  factory TransferDone.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TransferDone()..mergeFromBuffer(data, registry);
  factory TransferDone.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TransferDone()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransferDone',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: TransferDone.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'clipId')
    ..aOS(2, _omitFieldNames ? '' : 'streamId')
    ..aOB(3, _omitFieldNames ? '' : 'ok')
    ..aOS(4, _omitFieldNames ? '' : 'error')
    ..a<$core.List<$core.int>>(
        5, _omitFieldNames ? '' : 'sha256', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferDone clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferDone copyWith(void Function(TransferDone) updates) =>
      super.copyWith((message) => updates(message as TransferDone))
          as TransferDone;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TransferDone() / TransferDone.new instead')
  static TransferDone create() => TransferDone._();
  static $pb.GeneratedMessage $_createMessage() => TransferDone._();
  @$core.override
  TransferDone createEmptyInstance() => TransferDone._();
  @$core.pragma('dart2js:noInline')
  static TransferDone getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransferDone>(
          TransferDone.$_createMessage);
  static TransferDone? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClipId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get streamId => $_getSZ(1);
  @$pb.TagNumber(2)
  set streamId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStreamId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStreamId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get ok => $_getBF(2);
  @$pb.TagNumber(3)
  set ok($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOk() => $_has(2);
  @$pb.TagNumber(3)
  void clearOk() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get error => $_getSZ(3);
  @$pb.TagNumber(4)
  set error($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasError() => $_has(3);
  @$pb.TagNumber(4)
  void clearError() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get sha256 => $_getN(4);
  @$pb.TagNumber(5)
  set sha256($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSha256() => $_has(4);
  @$pb.TagNumber(5)
  void clearSha256() => $_clearField(5);
}

class SendOffer extends $pb.GeneratedMessage {
  factory SendOffer({
    $core.String? transferId,
    $core.int? attempt,
    $core.Iterable<$0.ClipItem>? items,
    $fixnum.Int64? totalBytes,
    $fixnum.Int64? fileCount,
    $fixnum.Int64? largestFile,
    $fixnum.Int64? createdAtUnix,
    $core.bool? resume,
  }) {
    final result = SendOffer._();
    if (transferId != null) result.transferId = transferId;
    if (attempt != null) result.attempt = attempt;
    if (items != null) result.items.addAll(items);
    if (totalBytes != null) result.totalBytes = totalBytes;
    if (fileCount != null) result.fileCount = fileCount;
    if (largestFile != null) result.largestFile = largestFile;
    if (createdAtUnix != null) result.createdAtUnix = createdAtUnix;
    if (resume != null) result.resume = resume;
    return result;
  }

  SendOffer._();

  factory SendOffer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendOffer()..mergeFromBuffer(data, registry);
  factory SendOffer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendOffer()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendOffer',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: SendOffer.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'transferId')
    ..aI(2, _omitFieldNames ? '' : 'attempt', fieldType: $pb.PbFieldType.OU3)
    ..pPM<$0.ClipItem>(3, _omitFieldNames ? '' : 'items',
        subBuilder: $0.ClipItem.$_createMessage)
    ..aInt64(4, _omitFieldNames ? '' : 'totalBytes')
    ..aInt64(5, _omitFieldNames ? '' : 'fileCount')
    ..aInt64(6, _omitFieldNames ? '' : 'largestFile')
    ..aInt64(7, _omitFieldNames ? '' : 'createdAtUnix')
    ..aOB(8, _omitFieldNames ? '' : 'resume')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendOffer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendOffer copyWith(void Function(SendOffer) updates) =>
      super.copyWith((message) => updates(message as SendOffer)) as SendOffer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SendOffer() / SendOffer.new instead')
  static SendOffer create() => SendOffer._();
  static $pb.GeneratedMessage $_createMessage() => SendOffer._();
  @$core.override
  SendOffer createEmptyInstance() => SendOffer._();
  @$core.pragma('dart2js:noInline')
  static SendOffer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendOffer>(SendOffer.$_createMessage);
  static SendOffer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get transferId => $_getSZ(0);
  @$pb.TagNumber(1)
  set transferId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTransferId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransferId() => $_clearField(1);

  /// 第几次发起，从 1 开始。数据通道名带上它，旧的通道晚到时直接丢弃
  @$pb.TagNumber(2)
  $core.int get attempt => $_getIZ(1);
  @$pb.TagNumber(2)
  set attempt($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAttempt() => $_has(1);
  @$pb.TagNumber(2)
  void clearAttempt() => $_clearField(2);

  /// 顶层的文件和文件夹，显示用；文件夹的 size 是里面文件的总大小
  @$pb.TagNumber(3)
  $pb.PbList<$0.ClipItem> get items => $_getList(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get totalBytes => $_getI64(3);
  @$pb.TagNumber(4)
  set totalBytes($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalBytes() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalBytes() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get fileCount => $_getI64(4);
  @$pb.TagNumber(5)
  set fileCount($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFileCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearFileCount() => $_clearField(5);

  /// 最大的单个文件，接收方据此判断 FAT32 这类单文件 4 GB 的上限
  @$pb.TagNumber(6)
  $fixnum.Int64 get largestFile => $_getI64(5);
  @$pb.TagNumber(6)
  set largestFile($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLargestFile() => $_has(5);
  @$pb.TagNumber(6)
  void clearLargestFile() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get createdAtUnix => $_getI64(6);
  @$pb.TagNumber(7)
  set createdAtUnix($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCreatedAtUnix() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAtUnix() => $_clearField(7);

  /// 续传：同一个 transfer_id 再次发起
  @$pb.TagNumber(8)
  $core.bool get resume => $_getBF(7);
  @$pb.TagNumber(8)
  set resume($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasResume() => $_has(7);
  @$pb.TagNumber(8)
  void clearResume() => $_clearField(8);
}

class SendAnswer extends $pb.GeneratedMessage {
  factory SendAnswer({
    $core.String? transferId,
    $core.int? attempt,
    $core.bool? accepted,
    $core.String? reason,
    $fixnum.Int64? shortfallBytes,
    $fixnum.Int64? resumeIndex,
    $fixnum.Int64? resumeOffset,
    $core.String? lanAddr,
  }) {
    final result = SendAnswer._();
    if (transferId != null) result.transferId = transferId;
    if (attempt != null) result.attempt = attempt;
    if (accepted != null) result.accepted = accepted;
    if (reason != null) result.reason = reason;
    if (shortfallBytes != null) result.shortfallBytes = shortfallBytes;
    if (resumeIndex != null) result.resumeIndex = resumeIndex;
    if (resumeOffset != null) result.resumeOffset = resumeOffset;
    if (lanAddr != null) result.lanAddr = lanAddr;
    return result;
  }

  SendAnswer._();

  factory SendAnswer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendAnswer()..mergeFromBuffer(data, registry);
  factory SendAnswer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendAnswer()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendAnswer',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: SendAnswer.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'transferId')
    ..aI(2, _omitFieldNames ? '' : 'attempt', fieldType: $pb.PbFieldType.OU3)
    ..aOB(3, _omitFieldNames ? '' : 'accepted')
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..aInt64(5, _omitFieldNames ? '' : 'shortfallBytes')
    ..aInt64(6, _omitFieldNames ? '' : 'resumeIndex')
    ..aInt64(7, _omitFieldNames ? '' : 'resumeOffset')
    ..aOS(8, _omitFieldNames ? '' : 'lanAddr')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendAnswer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendAnswer copyWith(void Function(SendAnswer) updates) =>
      super.copyWith((message) => updates(message as SendAnswer)) as SendAnswer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SendAnswer() / SendAnswer.new instead')
  static SendAnswer create() => SendAnswer._();
  static $pb.GeneratedMessage $_createMessage() => SendAnswer._();
  @$core.override
  SendAnswer createEmptyInstance() => SendAnswer._();
  @$core.pragma('dart2js:noInline')
  static SendAnswer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendAnswer>(SendAnswer.$_createMessage);
  static SendAnswer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get transferId => $_getSZ(0);
  @$pb.TagNumber(1)
  set transferId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTransferId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransferId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get attempt => $_getIZ(1);
  @$pb.TagNumber(2)
  set attempt($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAttempt() => $_has(1);
  @$pb.TagNumber(2)
  void clearAttempt() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get accepted => $_getBF(2);
  @$pb.TagNumber(3)
  set accepted($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAccepted() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccepted() => $_clearField(3);

  /// 回绝的原因，固定代码：disabled / no_space / dest_unavailable / file_too_large /
  /// busy / unknown_transfer / cancelled；already_done（2.5.1）：续传时发现上次已经收完，发送方直接标为送达
  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get shortfallBytes => $_getI64(4);
  @$pb.TagNumber(5)
  set shortfallBytes($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasShortfallBytes() => $_has(4);
  @$pb.TagNumber(5)
  void clearShortfallBytes() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get resumeIndex => $_getI64(5);
  @$pb.TagNumber(6)
  set resumeIndex($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasResumeIndex() => $_has(5);
  @$pb.TagNumber(6)
  void clearResumeIndex() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get resumeOffset => $_getI64(6);
  @$pb.TagNumber(7)
  set resumeOffset($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasResumeOffset() => $_has(6);
  @$pb.TagNumber(7)
  void clearResumeOffset() => $_clearField(7);

  /// 局域网快速通道（2.5.1）：接收方为这次尝试临时监听的 TCP 地址（ip:port）。
  /// 只在两端都声明 send_files_tcp_v1、且当前连接是局域网直连时给出；为空或连不上时走数据通道
  @$pb.TagNumber(8)
  $core.String get lanAddr => $_getSZ(7);
  @$pb.TagNumber(8)
  set lanAddr($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLanAddr() => $_has(7);
  @$pb.TagNumber(8)
  void clearLanAddr() => $_clearField(8);
}

/// 任何一方取消，或者发送方读源文件出错时发出。对方停下并清理没收完的部分
class SendCancel extends $pb.GeneratedMessage {
  factory SendCancel({
    $core.String? transferId,
    $core.String? reason,
  }) {
    final result = SendCancel._();
    if (transferId != null) result.transferId = transferId;
    if (reason != null) result.reason = reason;
    return result;
  }

  SendCancel._();

  factory SendCancel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendCancel()..mergeFromBuffer(data, registry);
  factory SendCancel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendCancel()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendCancel',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: SendCancel.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'transferId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendCancel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendCancel copyWith(void Function(SendCancel) updates) =>
      super.copyWith((message) => updates(message as SendCancel)) as SendCancel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SendCancel() / SendCancel.new instead')
  static SendCancel create() => SendCancel._();
  static $pb.GeneratedMessage $_createMessage() => SendCancel._();
  @$core.override
  SendCancel createEmptyInstance() => SendCancel._();
  @$core.pragma('dart2js:noInline')
  static SendCancel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendCancel>(SendCancel.$_createMessage);
  static SendCancel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get transferId => $_getSZ(0);
  @$pb.TagNumber(1)
  set transferId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTransferId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransferId() => $_clearField(1);

  /// cancelled / source_changed / source_missing / read_error / dest_unavailable
  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

/// 接收方全部收完（或中途失败）后回给发送方
class SendResult extends $pb.GeneratedMessage {
  factory SendResult({
    $core.String? transferId,
    $core.int? attempt,
    $core.bool? ok,
    $core.String? error,
    $fixnum.Int64? failedIndex,
  }) {
    final result = SendResult._();
    if (transferId != null) result.transferId = transferId;
    if (attempt != null) result.attempt = attempt;
    if (ok != null) result.ok = ok;
    if (error != null) result.error = error;
    if (failedIndex != null) result.failedIndex = failedIndex;
    return result;
  }

  SendResult._();

  factory SendResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendResult()..mergeFromBuffer(data, registry);
  factory SendResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendResult()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: SendResult.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'transferId')
    ..aI(2, _omitFieldNames ? '' : 'attempt', fieldType: $pb.PbFieldType.OU3)
    ..aOB(3, _omitFieldNames ? '' : 'ok')
    ..aOS(4, _omitFieldNames ? '' : 'error')
    ..aInt64(5, _omitFieldNames ? '' : 'failedIndex')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendResult copyWith(void Function(SendResult) updates) =>
      super.copyWith((message) => updates(message as SendResult)) as SendResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SendResult() / SendResult.new instead')
  static SendResult create() => SendResult._();
  static $pb.GeneratedMessage $_createMessage() => SendResult._();
  @$core.override
  SendResult createEmptyInstance() => SendResult._();
  @$core.pragma('dart2js:noInline')
  static SendResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendResult>(SendResult.$_createMessage);
  static SendResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get transferId => $_getSZ(0);
  @$pb.TagNumber(1)
  set transferId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTransferId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransferId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get attempt => $_getIZ(1);
  @$pb.TagNumber(2)
  set attempt($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAttempt() => $_has(1);
  @$pb.TagNumber(2)
  void clearAttempt() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get ok => $_getBF(2);
  @$pb.TagNumber(3)
  set ok($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOk() => $_has(2);
  @$pb.TagNumber(3)
  void clearOk() => $_clearField(3);

  /// hash_mismatch / write_failed / dest_unavailable / bad_stream
  @$pb.TagNumber(4)
  $core.String get error => $_getSZ(3);
  @$pb.TagNumber(4)
  set error($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasError() => $_has(3);
  @$pb.TagNumber(4)
  void clearError() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get failedIndex => $_getI64(4);
  @$pb.TagNumber(5)
  set failedIndex($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFailedIndex() => $_has(4);
  @$pb.TagNumber(5)
  void clearFailedIndex() => $_clearField(5);
}

enum SendFrame_Payload { file, fileEnd, end, notSet }

/// 隔空传送数据流里的帧：4 字节大端长度 + 序列化的 SendFrame。
/// file 之后紧跟 size - offset 个字节的文件内容（目录和链接没有内容），
/// 普通文件的内容之后是 file_end。最后是 end。整个帧流再经 zstd 压缩。
class SendFrame extends $pb.GeneratedMessage {
  factory SendFrame({
    SendFileStart? file,
    SendFileEnd? fileEnd,
    SendStreamEnd? end,
  }) {
    final result = SendFrame._();
    if (file != null) result.file = file;
    if (fileEnd != null) result.fileEnd = fileEnd;
    if (end != null) result.end = end;
    return result;
  }

  SendFrame._();

  factory SendFrame.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendFrame()..mergeFromBuffer(data, registry);
  factory SendFrame.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendFrame()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SendFrame_Payload> _SendFrame_PayloadByTag =
      {
    1: SendFrame_Payload.file,
    2: SendFrame_Payload.fileEnd,
    3: SendFrame_Payload.end,
    0: SendFrame_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendFrame',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: SendFrame.$_createMessage)
    ..oo(0, [1, 2, 3])
    ..aOM<SendFileStart>(1, _omitFieldNames ? '' : 'file',
        subBuilder: SendFileStart.$_createMessage)
    ..aOM<SendFileEnd>(2, _omitFieldNames ? '' : 'fileEnd',
        subBuilder: SendFileEnd.$_createMessage)
    ..aOM<SendStreamEnd>(3, _omitFieldNames ? '' : 'end',
        subBuilder: SendStreamEnd.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendFrame clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendFrame copyWith(void Function(SendFrame) updates) =>
      super.copyWith((message) => updates(message as SendFrame)) as SendFrame;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SendFrame() / SendFrame.new instead')
  static SendFrame create() => SendFrame._();
  static $pb.GeneratedMessage $_createMessage() => SendFrame._();
  @$core.override
  SendFrame createEmptyInstance() => SendFrame._();
  @$core.pragma('dart2js:noInline')
  static SendFrame getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendFrame>(SendFrame.$_createMessage);
  static SendFrame? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  SendFrame_Payload whichPayload() => _SendFrame_PayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  SendFileStart get file => $_getN(0);
  @$pb.TagNumber(1)
  set file(SendFileStart value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFile() => $_has(0);
  @$pb.TagNumber(1)
  void clearFile() => $_clearField(1);
  @$pb.TagNumber(1)
  SendFileStart ensureFile() => $_ensure(0);

  @$pb.TagNumber(2)
  SendFileEnd get fileEnd => $_getN(1);
  @$pb.TagNumber(2)
  set fileEnd(SendFileEnd value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFileEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileEnd() => $_clearField(2);
  @$pb.TagNumber(2)
  SendFileEnd ensureFileEnd() => $_ensure(1);

  @$pb.TagNumber(3)
  SendStreamEnd get end => $_getN(2);
  @$pb.TagNumber(3)
  set end(SendStreamEnd value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEnd() => $_has(2);
  @$pb.TagNumber(3)
  void clearEnd() => $_clearField(3);
  @$pb.TagNumber(3)
  SendStreamEnd ensureEnd() => $_ensure(2);
}

class SendFileStart extends $pb.GeneratedMessage {
  factory SendFileStart({
    $fixnum.Int64? index,
    $core.String? path,
    $fixnum.Int64? size,
    $core.bool? isDir,
    $core.int? mode,
    $fixnum.Int64? mtimeUnix,
    $fixnum.Int64? offset,
    $core.String? linkTarget,
  }) {
    final result = SendFileStart._();
    if (index != null) result.index = index;
    if (path != null) result.path = path;
    if (size != null) result.size = size;
    if (isDir != null) result.isDir = isDir;
    if (mode != null) result.mode = mode;
    if (mtimeUnix != null) result.mtimeUnix = mtimeUnix;
    if (offset != null) result.offset = offset;
    if (linkTarget != null) result.linkTarget = linkTarget;
    return result;
  }

  SendFileStart._();

  factory SendFileStart.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendFileStart()..mergeFromBuffer(data, registry);
  factory SendFileStart.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendFileStart()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendFileStart',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: SendFileStart.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'index')
    ..aOS(2, _omitFieldNames ? '' : 'path')
    ..aInt64(3, _omitFieldNames ? '' : 'size')
    ..aOB(4, _omitFieldNames ? '' : 'isDir')
    ..aI(5, _omitFieldNames ? '' : 'mode', fieldType: $pb.PbFieldType.OU3)
    ..aInt64(6, _omitFieldNames ? '' : 'mtimeUnix')
    ..aInt64(7, _omitFieldNames ? '' : 'offset')
    ..aOS(8, _omitFieldNames ? '' : 'linkTarget')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendFileStart clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendFileStart copyWith(void Function(SendFileStart) updates) =>
      super.copyWith((message) => updates(message as SendFileStart))
          as SendFileStart;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SendFileStart() / SendFileStart.new instead')
  static SendFileStart create() => SendFileStart._();
  static $pb.GeneratedMessage $_createMessage() => SendFileStart._();
  @$core.override
  SendFileStart createEmptyInstance() => SendFileStart._();
  @$core.pragma('dart2js:noInline')
  static SendFileStart getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SendFileStart>(
          SendFileStart.$_createMessage);
  static SendFileStart? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get index => $_getI64(0);
  @$pb.TagNumber(1)
  set index($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndex() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get size => $_getI64(2);
  @$pb.TagNumber(3)
  set size($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isDir => $_getBF(3);
  @$pb.TagNumber(4)
  set isDir($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsDir() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsDir() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get mode => $_getIZ(4);
  @$pb.TagNumber(5)
  set mode($core.int value) => $_setUnsignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMode() => $_has(4);
  @$pb.TagNumber(5)
  void clearMode() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get mtimeUnix => $_getI64(5);
  @$pb.TagNumber(6)
  set mtimeUnix($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMtimeUnix() => $_has(5);
  @$pb.TagNumber(6)
  void clearMtimeUnix() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get offset => $_getI64(6);
  @$pb.TagNumber(7)
  set offset($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOffset() => $_has(6);
  @$pb.TagNumber(7)
  void clearOffset() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get linkTarget => $_getSZ(7);
  @$pb.TagNumber(8)
  set linkTarget($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLinkTarget() => $_has(7);
  @$pb.TagNumber(8)
  void clearLinkTarget() => $_clearField(8);
}

class SendFileEnd extends $pb.GeneratedMessage {
  factory SendFileEnd({
    $core.List<$core.int>? sha256,
  }) {
    final result = SendFileEnd._();
    if (sha256 != null) result.sha256 = sha256;
    return result;
  }

  SendFileEnd._();

  factory SendFileEnd.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendFileEnd()..mergeFromBuffer(data, registry);
  factory SendFileEnd.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendFileEnd()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendFileEnd',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: SendFileEnd.$_createMessage)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'sha256', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendFileEnd clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendFileEnd copyWith(void Function(SendFileEnd) updates) =>
      super.copyWith((message) => updates(message as SendFileEnd))
          as SendFileEnd;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SendFileEnd() / SendFileEnd.new instead')
  static SendFileEnd create() => SendFileEnd._();
  static $pb.GeneratedMessage $_createMessage() => SendFileEnd._();
  @$core.override
  SendFileEnd createEmptyInstance() => SendFileEnd._();
  @$core.pragma('dart2js:noInline')
  static SendFileEnd getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SendFileEnd>(
          SendFileEnd.$_createMessage);
  static SendFileEnd? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get sha256 => $_getN(0);
  @$pb.TagNumber(1)
  set sha256($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSha256() => $_has(0);
  @$pb.TagNumber(1)
  void clearSha256() => $_clearField(1);
}

class SendStreamEnd extends $pb.GeneratedMessage {
  factory SendStreamEnd() => SendStreamEnd._();

  SendStreamEnd._();

  factory SendStreamEnd.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendStreamEnd()..mergeFromBuffer(data, registry);
  factory SendStreamEnd.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendStreamEnd()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendStreamEnd',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: SendStreamEnd.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendStreamEnd clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendStreamEnd copyWith(void Function(SendStreamEnd) updates) =>
      super.copyWith((message) => updates(message as SendStreamEnd))
          as SendStreamEnd;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SendStreamEnd() / SendStreamEnd.new instead')
  static SendStreamEnd create() => SendStreamEnd._();
  static $pb.GeneratedMessage $_createMessage() => SendStreamEnd._();
  @$core.override
  SendStreamEnd createEmptyInstance() => SendStreamEnd._();
  @$core.pragma('dart2js:noInline')
  static SendStreamEnd getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SendStreamEnd>(
          SendStreamEnd.$_createMessage);
  static SendStreamEnd? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
