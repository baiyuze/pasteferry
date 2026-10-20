// This is a generated file - do not edit.
//
// Generated from pasteferry/v1/daemon.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'daemon.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'daemon.pbenum.dart';

class Empty extends $pb.GeneratedMessage {
  factory Empty() => Empty._();

  Empty._();

  factory Empty.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Empty()..mergeFromBuffer(data, registry);
  factory Empty.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Empty()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Empty',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: Empty.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Empty clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Empty copyWith(void Function(Empty) updates) =>
      super.copyWith((message) => updates(message as Empty)) as Empty;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Empty() / Empty.new instead')
  static Empty create() => Empty._();
  static $pb.GeneratedMessage $_createMessage() => Empty._();
  @$core.override
  Empty createEmptyInstance() => Empty._();
  @$core.pragma('dart2js:noInline')
  static Empty getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Empty>(Empty.$_createMessage);
  static Empty? _defaultInstance;
}

class ClipItem extends $pb.GeneratedMessage {
  factory ClipItem({
    $core.String? name,
    $fixnum.Int64? size,
    $core.bool? isDir,
    $core.String? contentType,
  }) {
    final result = ClipItem._();
    if (name != null) result.name = name;
    if (size != null) result.size = size;
    if (isDir != null) result.isDir = isDir;
    if (contentType != null) result.contentType = contentType;
    return result;
  }

  ClipItem._();

  factory ClipItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClipItem()..mergeFromBuffer(data, registry);
  factory ClipItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClipItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClipItem',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: ClipItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aInt64(2, _omitFieldNames ? '' : 'size')
    ..aOB(3, _omitFieldNames ? '' : 'isDir')
    ..aOS(4, _omitFieldNames ? '' : 'contentType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClipItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClipItem copyWith(void Function(ClipItem) updates) =>
      super.copyWith((message) => updates(message as ClipItem)) as ClipItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ClipItem() / ClipItem.new instead')
  static ClipItem create() => ClipItem._();
  static $pb.GeneratedMessage $_createMessage() => ClipItem._();
  @$core.override
  ClipItem createEmptyInstance() => ClipItem._();
  @$core.pragma('dart2js:noInline')
  static ClipItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClipItem>(ClipItem.$_createMessage);
  static ClipItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get size => $_getI64(1);
  @$pb.TagNumber(2)
  set size($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isDir => $_getBF(2);
  @$pb.TagNumber(3)
  set isDir($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsDir() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsDir() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get contentType => $_getSZ(3);
  @$pb.TagNumber(4)
  set contentType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContentType() => $_has(3);
  @$pb.TagNumber(4)
  void clearContentType() => $_clearField(4);
}

class ClipRecord extends $pb.GeneratedMessage {
  factory ClipRecord({
    $core.String? id,
    ClipKind? kind,
    ClipStatus? status,
    $core.String? originDeviceId,
    $core.String? originDeviceName,
    $core.bool? outgoing,
    $core.Iterable<ClipItem>? items,
    $fixnum.Int64? totalSize,
    $core.String? textPreview,
    $fixnum.Int64? createdAtUnix,
    $fixnum.Int64? expiresAtUnix,
    $core.String? error,
    $core.int? imageCount,
    $core.bool? favorite,
    $core.bool? favorited,
    $fixnum.Int64? favoritedAtUnix,
    $core.bool? isLink,
  }) {
    final result = ClipRecord._();
    if (id != null) result.id = id;
    if (kind != null) result.kind = kind;
    if (status != null) result.status = status;
    if (originDeviceId != null) result.originDeviceId = originDeviceId;
    if (originDeviceName != null) result.originDeviceName = originDeviceName;
    if (outgoing != null) result.outgoing = outgoing;
    if (items != null) result.items.addAll(items);
    if (totalSize != null) result.totalSize = totalSize;
    if (textPreview != null) result.textPreview = textPreview;
    if (createdAtUnix != null) result.createdAtUnix = createdAtUnix;
    if (expiresAtUnix != null) result.expiresAtUnix = expiresAtUnix;
    if (error != null) result.error = error;
    if (imageCount != null) result.imageCount = imageCount;
    if (favorite != null) result.favorite = favorite;
    if (favorited != null) result.favorited = favorited;
    if (favoritedAtUnix != null) result.favoritedAtUnix = favoritedAtUnix;
    if (isLink != null) result.isLink = isLink;
    return result;
  }

  ClipRecord._();

  factory ClipRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClipRecord()..mergeFromBuffer(data, registry);
  factory ClipRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClipRecord()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClipRecord',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: ClipRecord.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aE<ClipKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: ClipKind.values)
    ..aE<ClipStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: ClipStatus.values)
    ..aOS(4, _omitFieldNames ? '' : 'originDeviceId')
    ..aOS(5, _omitFieldNames ? '' : 'originDeviceName')
    ..aOB(6, _omitFieldNames ? '' : 'outgoing')
    ..pPM<ClipItem>(7, _omitFieldNames ? '' : 'items',
        subBuilder: ClipItem.$_createMessage)
    ..aInt64(8, _omitFieldNames ? '' : 'totalSize')
    ..aOS(9, _omitFieldNames ? '' : 'textPreview')
    ..aInt64(10, _omitFieldNames ? '' : 'createdAtUnix')
    ..aInt64(11, _omitFieldNames ? '' : 'expiresAtUnix')
    ..aOS(12, _omitFieldNames ? '' : 'error')
    ..aI(13, _omitFieldNames ? '' : 'imageCount')
    ..aOB(14, _omitFieldNames ? '' : 'favorite')
    ..aOB(15, _omitFieldNames ? '' : 'favorited')
    ..aInt64(16, _omitFieldNames ? '' : 'favoritedAtUnix')
    ..aOB(17, _omitFieldNames ? '' : 'isLink')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClipRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClipRecord copyWith(void Function(ClipRecord) updates) =>
      super.copyWith((message) => updates(message as ClipRecord)) as ClipRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ClipRecord() / ClipRecord.new instead')
  static ClipRecord create() => ClipRecord._();
  static $pb.GeneratedMessage $_createMessage() => ClipRecord._();
  @$core.override
  ClipRecord createEmptyInstance() => ClipRecord._();
  @$core.pragma('dart2js:noInline')
  static ClipRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClipRecord>(ClipRecord.$_createMessage);
  static ClipRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  ClipKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(ClipKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  ClipStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(ClipStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get originDeviceId => $_getSZ(3);
  @$pb.TagNumber(4)
  set originDeviceId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOriginDeviceId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOriginDeviceId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get originDeviceName => $_getSZ(4);
  @$pb.TagNumber(5)
  set originDeviceName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOriginDeviceName() => $_has(4);
  @$pb.TagNumber(5)
  void clearOriginDeviceName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get outgoing => $_getBF(5);
  @$pb.TagNumber(6)
  set outgoing($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOutgoing() => $_has(5);
  @$pb.TagNumber(6)
  void clearOutgoing() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<ClipItem> get items => $_getList(6);

  @$pb.TagNumber(8)
  $fixnum.Int64 get totalSize => $_getI64(7);
  @$pb.TagNumber(8)
  set totalSize($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTotalSize() => $_has(7);
  @$pb.TagNumber(8)
  void clearTotalSize() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get textPreview => $_getSZ(8);
  @$pb.TagNumber(9)
  set textPreview($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTextPreview() => $_has(8);
  @$pb.TagNumber(9)
  void clearTextPreview() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get createdAtUnix => $_getI64(9);
  @$pb.TagNumber(10)
  set createdAtUnix($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAtUnix() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAtUnix() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get expiresAtUnix => $_getI64(10);
  @$pb.TagNumber(11)
  set expiresAtUnix($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasExpiresAtUnix() => $_has(10);
  @$pb.TagNumber(11)
  void clearExpiresAtUnix() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get error => $_getSZ(11);
  @$pb.TagNumber(12)
  set error($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasError() => $_has(11);
  @$pb.TagNumber(12)
  void clearError() => $_clearField(12);

  /// 能在界面里预览的图片数：剪贴板图片为 1，文件记录是其中图片文件的个数。
  /// 由本机后台服务按文件名判断，HEIC、TIFF 这类格式只有能转换它的平台才算。
  @$pb.TagNumber(13)
  $core.int get imageCount => $_getIZ(12);
  @$pb.TagNumber(13)
  set imageCount($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasImageCount() => $_has(12);
  @$pb.TagNumber(13)
  void clearImageCount() => $_clearField(13);

  /// 这一条是收藏，不是复制记录。收藏的 expires_at_unix 为 0，表示不会过期
  @$pb.TagNumber(14)
  $core.bool get favorite => $_getBF(13);
  @$pb.TagNumber(14)
  set favorite($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasFavorite() => $_has(13);
  @$pb.TagNumber(14)
  void clearFavorite() => $_clearField(14);

  /// 复制记录里的这一条已经收藏过（星标亮着）
  @$pb.TagNumber(15)
  $core.bool get favorited => $_getBF(14);
  @$pb.TagNumber(15)
  set favorited($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(15)
  $core.bool hasFavorited() => $_has(14);
  @$pb.TagNumber(15)
  void clearFavorited() => $_clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get favoritedAtUnix => $_getI64(15);
  @$pb.TagNumber(16)
  set favoritedAtUnix($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasFavoritedAtUnix() => $_has(15);
  @$pb.TagNumber(16)
  void clearFavoritedAtUnix() => $_clearField(16);

  /// 整条文字就是一个 http(s) 网址
  @$pb.TagNumber(17)
  $core.bool get isLink => $_getBF(16);
  @$pb.TagNumber(17)
  set isLink($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(17)
  $core.bool hasIsLink() => $_has(16);
  @$pb.TagNumber(17)
  void clearIsLink() => $_clearField(17);
}

class SubscribeRequest extends $pb.GeneratedMessage {
  factory SubscribeRequest({
    $fixnum.Int64? sinceUnix,
  }) {
    final result = SubscribeRequest._();
    if (sinceUnix != null) result.sinceUnix = sinceUnix;
    return result;
  }

  SubscribeRequest._();

  factory SubscribeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubscribeRequest()..mergeFromBuffer(data, registry);
  factory SubscribeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubscribeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscribeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: SubscribeRequest.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'sinceUnix')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscribeRequest copyWith(void Function(SubscribeRequest) updates) =>
      super.copyWith((message) => updates(message as SubscribeRequest))
          as SubscribeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SubscribeRequest() / SubscribeRequest.new instead')
  static SubscribeRequest create() => SubscribeRequest._();
  static $pb.GeneratedMessage $_createMessage() => SubscribeRequest._();
  @$core.override
  SubscribeRequest createEmptyInstance() => SubscribeRequest._();
  @$core.pragma('dart2js:noInline')
  static SubscribeRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubscribeRequest>(
          SubscribeRequest.$_createMessage);
  static SubscribeRequest? _defaultInstance;

  /// 断线重连时带上最后收到的记录时间，daemon 补发这之后的记录
  @$pb.TagNumber(1)
  $fixnum.Int64 get sinceUnix => $_getI64(0);
  @$pb.TagNumber(1)
  set sinceUnix($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSinceUnix() => $_has(0);
  @$pb.TagNumber(1)
  void clearSinceUnix() => $_clearField(1);
}

class TransferProgress extends $pb.GeneratedMessage {
  factory TransferProgress({
    $core.String? clipId,
    $fixnum.Int64? transferred,
    $fixnum.Int64? total,
    $core.double? bytesPerSecond,
  }) {
    final result = TransferProgress._();
    if (clipId != null) result.clipId = clipId;
    if (transferred != null) result.transferred = transferred;
    if (total != null) result.total = total;
    if (bytesPerSecond != null) result.bytesPerSecond = bytesPerSecond;
    return result;
  }

  TransferProgress._();

  factory TransferProgress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TransferProgress()..mergeFromBuffer(data, registry);
  factory TransferProgress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TransferProgress()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransferProgress',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: TransferProgress.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'clipId')
    ..aInt64(2, _omitFieldNames ? '' : 'transferred')
    ..aInt64(3, _omitFieldNames ? '' : 'total')
    ..aD(4, _omitFieldNames ? '' : 'bytesPerSecond')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferProgress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferProgress copyWith(void Function(TransferProgress) updates) =>
      super.copyWith((message) => updates(message as TransferProgress))
          as TransferProgress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TransferProgress() / TransferProgress.new instead')
  static TransferProgress create() => TransferProgress._();
  static $pb.GeneratedMessage $_createMessage() => TransferProgress._();
  @$core.override
  TransferProgress createEmptyInstance() => TransferProgress._();
  @$core.pragma('dart2js:noInline')
  static TransferProgress getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransferProgress>(
          TransferProgress.$_createMessage);
  static TransferProgress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClipId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get transferred => $_getI64(1);
  @$pb.TagNumber(2)
  set transferred($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTransferred() => $_has(1);
  @$pb.TagNumber(2)
  void clearTransferred() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get total => $_getI64(2);
  @$pb.TagNumber(3)
  set total($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotal() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotal() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get bytesPerSecond => $_getN(3);
  @$pb.TagNumber(4)
  set bytesPerSecond($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBytesPerSecond() => $_has(3);
  @$pb.TagNumber(4)
  void clearBytesPerSecond() => $_clearField(4);
}

class Device extends $pb.GeneratedMessage {
  factory Device({
    $core.String? id,
    $core.String? name,
    $core.String? platform,
    $core.bool? online,
    ConnectionKind? connection,
    $core.String? publicKeyFingerprint,
    $fixnum.Int64? pairedAtUnix,
    $core.String? pairingSession,
  }) {
    final result = Device._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (platform != null) result.platform = platform;
    if (online != null) result.online = online;
    if (connection != null) result.connection = connection;
    if (publicKeyFingerprint != null)
      result.publicKeyFingerprint = publicKeyFingerprint;
    if (pairedAtUnix != null) result.pairedAtUnix = pairedAtUnix;
    if (pairingSession != null) result.pairingSession = pairingSession;
    return result;
  }

  Device._();

  factory Device.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Device()..mergeFromBuffer(data, registry);
  factory Device.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Device()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Device',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: Device.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'platform')
    ..aOB(4, _omitFieldNames ? '' : 'online')
    ..aE<ConnectionKind>(5, _omitFieldNames ? '' : 'connection',
        enumValues: ConnectionKind.values)
    ..aOS(6, _omitFieldNames ? '' : 'publicKeyFingerprint')
    ..aInt64(7, _omitFieldNames ? '' : 'pairedAtUnix')
    ..aOS(8, _omitFieldNames ? '' : 'pairingSession')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Device clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Device copyWith(void Function(Device) updates) =>
      super.copyWith((message) => updates(message as Device)) as Device;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Device() / Device.new instead')
  static Device create() => Device._();
  static $pb.GeneratedMessage $_createMessage() => Device._();
  @$core.override
  Device createEmptyInstance() => Device._();
  @$core.pragma('dart2js:noInline')
  static Device getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Device>(Device.$_createMessage);
  static Device? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

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
  $core.bool get online => $_getBF(3);
  @$pb.TagNumber(4)
  set online($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOnline() => $_has(3);
  @$pb.TagNumber(4)
  void clearOnline() => $_clearField(4);

  @$pb.TagNumber(5)
  ConnectionKind get connection => $_getN(4);
  @$pb.TagNumber(5)
  set connection(ConnectionKind value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasConnection() => $_has(4);
  @$pb.TagNumber(5)
  void clearConnection() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get publicKeyFingerprint => $_getSZ(5);
  @$pb.TagNumber(6)
  set publicKeyFingerprint($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPublicKeyFingerprint() => $_has(5);
  @$pb.TagNumber(6)
  void clearPublicKeyFingerprint() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get pairedAtUnix => $_getI64(6);
  @$pb.TagNumber(7)
  set pairedAtUnix($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPairedAtUnix() => $_has(6);
  @$pb.TagNumber(7)
  void clearPairedAtUnix() => $_clearField(7);

  /// 非空表示这是一条**待用户核对指纹**的配对请求，而非已配对设备。
  /// 用此值调 ConfirmPairing 完成或拒绝配对。
  /// 配对码的发起方是被动收到兑换通知的，靠这个字段把确认入口推给界面。
  @$pb.TagNumber(8)
  $core.String get pairingSession => $_getSZ(7);
  @$pb.TagNumber(8)
  set pairingSession($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPairingSession() => $_has(7);
  @$pb.TagNumber(8)
  void clearPairingSession() => $_clearField(8);
}

enum Event_Payload {
  clipAdded,
  clipUpdated,
  clipRemoved,
  progress,
  deviceChanged,
  permissionChanged,
  statusChanged,
  clipboardWritten,
  configChanged,
  quickPasteChanged,
  notSet
}

class Event extends $pb.GeneratedMessage {
  factory Event({
    ClipRecord? clipAdded,
    ClipRecord? clipUpdated,
    $core.String? clipRemoved,
    TransferProgress? progress,
    Device? deviceChanged,
    ClipboardPermission? permissionChanged,
    Status? statusChanged,
    ClipboardWriteResult? clipboardWritten,
    Config? configChanged,
    QuickPasteStatus? quickPasteChanged,
  }) {
    final result = Event._();
    if (clipAdded != null) result.clipAdded = clipAdded;
    if (clipUpdated != null) result.clipUpdated = clipUpdated;
    if (clipRemoved != null) result.clipRemoved = clipRemoved;
    if (progress != null) result.progress = progress;
    if (deviceChanged != null) result.deviceChanged = deviceChanged;
    if (permissionChanged != null) result.permissionChanged = permissionChanged;
    if (statusChanged != null) result.statusChanged = statusChanged;
    if (clipboardWritten != null) result.clipboardWritten = clipboardWritten;
    if (configChanged != null) result.configChanged = configChanged;
    if (quickPasteChanged != null) result.quickPasteChanged = quickPasteChanged;
    return result;
  }

  Event._();

  factory Event.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Event()..mergeFromBuffer(data, registry);
  factory Event.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Event()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Event_Payload> _Event_PayloadByTag = {
    1: Event_Payload.clipAdded,
    2: Event_Payload.clipUpdated,
    3: Event_Payload.clipRemoved,
    4: Event_Payload.progress,
    5: Event_Payload.deviceChanged,
    6: Event_Payload.permissionChanged,
    7: Event_Payload.statusChanged,
    8: Event_Payload.clipboardWritten,
    9: Event_Payload.configChanged,
    10: Event_Payload.quickPasteChanged,
    0: Event_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Event',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: Event.$_createMessage)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    ..aOM<ClipRecord>(1, _omitFieldNames ? '' : 'clipAdded',
        subBuilder: ClipRecord.$_createMessage)
    ..aOM<ClipRecord>(2, _omitFieldNames ? '' : 'clipUpdated',
        subBuilder: ClipRecord.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'clipRemoved')
    ..aOM<TransferProgress>(4, _omitFieldNames ? '' : 'progress',
        subBuilder: TransferProgress.$_createMessage)
    ..aOM<Device>(5, _omitFieldNames ? '' : 'deviceChanged',
        subBuilder: Device.$_createMessage)
    ..aE<ClipboardPermission>(6, _omitFieldNames ? '' : 'permissionChanged',
        enumValues: ClipboardPermission.values)
    ..aOM<Status>(7, _omitFieldNames ? '' : 'statusChanged',
        subBuilder: Status.$_createMessage)
    ..aOM<ClipboardWriteResult>(8, _omitFieldNames ? '' : 'clipboardWritten',
        subBuilder: ClipboardWriteResult.$_createMessage)
    ..aOM<Config>(9, _omitFieldNames ? '' : 'configChanged',
        subBuilder: Config.$_createMessage)
    ..aOM<QuickPasteStatus>(10, _omitFieldNames ? '' : 'quickPasteChanged',
        subBuilder: QuickPasteStatus.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Event clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Event copyWith(void Function(Event) updates) =>
      super.copyWith((message) => updates(message as Event)) as Event;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Event() / Event.new instead')
  static Event create() => Event._();
  static $pb.GeneratedMessage $_createMessage() => Event._();
  @$core.override
  Event createEmptyInstance() => Event._();
  @$core.pragma('dart2js:noInline')
  static Event getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Event>(Event.$_createMessage);
  static Event? _defaultInstance;

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
  Event_Payload whichPayload() => _Event_PayloadByTag[$_whichOneof(0)]!;
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
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ClipRecord get clipAdded => $_getN(0);
  @$pb.TagNumber(1)
  set clipAdded(ClipRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasClipAdded() => $_has(0);
  @$pb.TagNumber(1)
  void clearClipAdded() => $_clearField(1);
  @$pb.TagNumber(1)
  ClipRecord ensureClipAdded() => $_ensure(0);

  @$pb.TagNumber(2)
  ClipRecord get clipUpdated => $_getN(1);
  @$pb.TagNumber(2)
  set clipUpdated(ClipRecord value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasClipUpdated() => $_has(1);
  @$pb.TagNumber(2)
  void clearClipUpdated() => $_clearField(2);
  @$pb.TagNumber(2)
  ClipRecord ensureClipUpdated() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get clipRemoved => $_getSZ(2);
  @$pb.TagNumber(3)
  set clipRemoved($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasClipRemoved() => $_has(2);
  @$pb.TagNumber(3)
  void clearClipRemoved() => $_clearField(3);

  @$pb.TagNumber(4)
  TransferProgress get progress => $_getN(3);
  @$pb.TagNumber(4)
  set progress(TransferProgress value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasProgress() => $_has(3);
  @$pb.TagNumber(4)
  void clearProgress() => $_clearField(4);
  @$pb.TagNumber(4)
  TransferProgress ensureProgress() => $_ensure(3);

  @$pb.TagNumber(5)
  Device get deviceChanged => $_getN(4);
  @$pb.TagNumber(5)
  set deviceChanged(Device value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDeviceChanged() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeviceChanged() => $_clearField(5);
  @$pb.TagNumber(5)
  Device ensureDeviceChanged() => $_ensure(4);

  @$pb.TagNumber(6)
  ClipboardPermission get permissionChanged => $_getN(5);
  @$pb.TagNumber(6)
  set permissionChanged(ClipboardPermission value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPermissionChanged() => $_has(5);
  @$pb.TagNumber(6)
  void clearPermissionChanged() => $_clearField(6);

  @$pb.TagNumber(7)
  Status get statusChanged => $_getN(6);
  @$pb.TagNumber(7)
  set statusChanged(Status value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStatusChanged() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatusChanged() => $_clearField(7);
  @$pb.TagNumber(7)
  Status ensureStatusChanged() => $_ensure(6);

  @$pb.TagNumber(8)
  ClipboardWriteResult get clipboardWritten => $_getN(7);
  @$pb.TagNumber(8)
  set clipboardWritten(ClipboardWriteResult value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasClipboardWritten() => $_has(7);
  @$pb.TagNumber(8)
  void clearClipboardWritten() => $_clearField(8);
  @$pb.TagNumber(8)
  ClipboardWriteResult ensureClipboardWritten() => $_ensure(7);

  /// 设置保存后推送，快捷窗口据此重新注册快捷键
  @$pb.TagNumber(9)
  Config get configChanged => $_getN(8);
  @$pb.TagNumber(9)
  set configChanged(Config value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasConfigChanged() => $_has(8);
  @$pb.TagNumber(9)
  void clearConfigChanged() => $_clearField(9);
  @$pb.TagNumber(9)
  Config ensureConfigChanged() => $_ensure(8);

  @$pb.TagNumber(10)
  QuickPasteStatus get quickPasteChanged => $_getN(9);
  @$pb.TagNumber(10)
  set quickPasteChanged(QuickPasteStatus value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasQuickPasteChanged() => $_has(9);
  @$pb.TagNumber(10)
  void clearQuickPasteChanged() => $_clearField(10);
  @$pb.TagNumber(10)
  QuickPasteStatus ensureQuickPasteChanged() => $_ensure(9);
}

class NotificationStatus extends $pb.GeneratedMessage {
  factory NotificationStatus({
    $core.bool? supported,
    $core.bool? actionsSupported,
    $core.String? permission,
  }) {
    final result = NotificationStatus._();
    if (supported != null) result.supported = supported;
    if (actionsSupported != null) result.actionsSupported = actionsSupported;
    if (permission != null) result.permission = permission;
    return result;
  }

  NotificationStatus._();

  factory NotificationStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NotificationStatus()..mergeFromBuffer(data, registry);
  factory NotificationStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NotificationStatus()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: NotificationStatus.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'supported')
    ..aOB(2, _omitFieldNames ? '' : 'actionsSupported')
    ..aOS(3, _omitFieldNames ? '' : 'permission')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationStatus copyWith(void Function(NotificationStatus) updates) =>
      super.copyWith((message) => updates(message as NotificationStatus))
          as NotificationStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use NotificationStatus() / NotificationStatus.new instead')
  static NotificationStatus create() => NotificationStatus._();
  static $pb.GeneratedMessage $_createMessage() => NotificationStatus._();
  @$core.override
  NotificationStatus createEmptyInstance() => NotificationStatus._();
  @$core.pragma('dart2js:noInline')
  static NotificationStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationStatus>(
          NotificationStatus.$_createMessage);
  static NotificationStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get supported => $_getBF(0);
  @$pb.TagNumber(1)
  set supported($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSupported() => $_has(0);
  @$pb.TagNumber(1)
  void clearSupported() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get actionsSupported => $_getBF(1);
  @$pb.TagNumber(2)
  set actionsSupported($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasActionsSupported() => $_has(1);
  @$pb.TagNumber(2)
  void clearActionsSupported() => $_clearField(2);

  /// unknown, not_requested, allowed, denied, unavailable
  @$pb.TagNumber(3)
  $core.String get permission => $_getSZ(2);
  @$pb.TagNumber(3)
  set permission($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPermission() => $_has(2);
  @$pb.TagNumber(3)
  void clearPermission() => $_clearField(3);
}

class NotificationAction extends $pb.GeneratedMessage {
  factory NotificationAction({
    $core.String? clipId,
    $core.String? action,
  }) {
    final result = NotificationAction._();
    if (clipId != null) result.clipId = clipId;
    if (action != null) result.action = action;
    return result;
  }

  NotificationAction._();

  factory NotificationAction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NotificationAction()..mergeFromBuffer(data, registry);
  factory NotificationAction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NotificationAction()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotificationAction',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: NotificationAction.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'clipId')
    ..aOS(2, _omitFieldNames ? '' : 'action')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationAction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotificationAction copyWith(void Function(NotificationAction) updates) =>
      super.copyWith((message) => updates(message as NotificationAction))
          as NotificationAction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use NotificationAction() / NotificationAction.new instead')
  static NotificationAction create() => NotificationAction._();
  static $pb.GeneratedMessage $_createMessage() => NotificationAction._();
  @$core.override
  NotificationAction createEmptyInstance() => NotificationAction._();
  @$core.pragma('dart2js:noInline')
  static NotificationAction getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotificationAction>(
          NotificationAction.$_createMessage);
  static NotificationAction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClipId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get action => $_getSZ(1);
  @$pb.TagNumber(2)
  set action($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAction() => $_clearField(2);
}

/// READY still means downloaded, not necessarily the current system clipboard.
class ClipboardWriteResult extends $pb.GeneratedMessage {
  factory ClipboardWriteResult({
    $core.String? clipId,
    ClipboardWriteOutcome? outcome,
    $core.String? error,
  }) {
    final result = ClipboardWriteResult._();
    if (clipId != null) result.clipId = clipId;
    if (outcome != null) result.outcome = outcome;
    if (error != null) result.error = error;
    return result;
  }

  ClipboardWriteResult._();

  factory ClipboardWriteResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClipboardWriteResult()..mergeFromBuffer(data, registry);
  factory ClipboardWriteResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClipboardWriteResult()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClipboardWriteResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: ClipboardWriteResult.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'clipId')
    ..aE<ClipboardWriteOutcome>(2, _omitFieldNames ? '' : 'outcome',
        enumValues: ClipboardWriteOutcome.values)
    ..aOS(3, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClipboardWriteResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClipboardWriteResult copyWith(void Function(ClipboardWriteResult) updates) =>
      super.copyWith((message) => updates(message as ClipboardWriteResult))
          as ClipboardWriteResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ClipboardWriteResult() / ClipboardWriteResult.new instead')
  static ClipboardWriteResult create() => ClipboardWriteResult._();
  static $pb.GeneratedMessage $_createMessage() => ClipboardWriteResult._();
  @$core.override
  ClipboardWriteResult createEmptyInstance() => ClipboardWriteResult._();
  @$core.pragma('dart2js:noInline')
  static ClipboardWriteResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClipboardWriteResult>(
          ClipboardWriteResult.$_createMessage);
  static ClipboardWriteResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClipId() => $_clearField(1);

  @$pb.TagNumber(2)
  ClipboardWriteOutcome get outcome => $_getN(1);
  @$pb.TagNumber(2)
  set outcome(ClipboardWriteOutcome value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOutcome() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutcome() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get error => $_getSZ(2);
  @$pb.TagNumber(3)
  set error($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => $_clearField(3);
}

class ListHistoryRequest extends $pb.GeneratedMessage {
  factory ListHistoryRequest({
    $core.int? limit,
    $fixnum.Int64? beforeUnix,
    ClipKind? kindFilter,
    $core.String? query,
    $core.bool? favorites,
    $core.bool? linksOnly,
  }) {
    final result = ListHistoryRequest._();
    if (limit != null) result.limit = limit;
    if (beforeUnix != null) result.beforeUnix = beforeUnix;
    if (kindFilter != null) result.kindFilter = kindFilter;
    if (query != null) result.query = query;
    if (favorites != null) result.favorites = favorites;
    if (linksOnly != null) result.linksOnly = linksOnly;
    return result;
  }

  ListHistoryRequest._();

  factory ListHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListHistoryRequest()..mergeFromBuffer(data, registry);
  factory ListHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListHistoryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListHistoryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: ListHistoryRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'limit')
    ..aInt64(2, _omitFieldNames ? '' : 'beforeUnix')
    ..aE<ClipKind>(3, _omitFieldNames ? '' : 'kindFilter',
        enumValues: ClipKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'query')
    ..aOB(5, _omitFieldNames ? '' : 'favorites')
    ..aOB(6, _omitFieldNames ? '' : 'linksOnly')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHistoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHistoryRequest copyWith(void Function(ListHistoryRequest) updates) =>
      super.copyWith((message) => updates(message as ListHistoryRequest))
          as ListHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListHistoryRequest() / ListHistoryRequest.new instead')
  static ListHistoryRequest create() => ListHistoryRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListHistoryRequest._();
  @$core.override
  ListHistoryRequest createEmptyInstance() => ListHistoryRequest._();
  @$core.pragma('dart2js:noInline')
  static ListHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListHistoryRequest>(
          ListHistoryRequest.$_createMessage);
  static ListHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get limit => $_getIZ(0);
  @$pb.TagNumber(1)
  set limit($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimit() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get beforeUnix => $_getI64(1);
  @$pb.TagNumber(2)
  set beforeUnix($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBeforeUnix() => $_has(1);
  @$pb.TagNumber(2)
  void clearBeforeUnix() => $_clearField(2);

  /// UNSPECIFIED 表示不过滤。TEXT 是界面上的「文字」：纯文本与网页格式，不含链接
  @$pb.TagNumber(3)
  ClipKind get kindFilter => $_getN(2);
  @$pb.TagNumber(3)
  set kindFilter(ClipKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKindFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearKindFilter() => $_clearField(3);

  /// 搜索词：非空时只返回文字内容或文件名包含它的记录（不分大小写），按时间倒序，
  /// 忽略 before_unix。匹配处不在预览片段里的文字记录，text_preview 换成匹配处前后的一段。
  @$pb.TagNumber(4)
  $core.String get query => $_getSZ(3);
  @$pb.TagNumber(4)
  set query($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuery() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuery() => $_clearField(4);

  /// true 时只返回收藏，按收藏时间倒序，忽略 before_unix；false 时只返回复制记录
  @$pb.TagNumber(5)
  $core.bool get favorites => $_getBF(4);
  @$pb.TagNumber(5)
  set favorites($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFavorites() => $_has(4);
  @$pb.TagNumber(5)
  void clearFavorites() => $_clearField(5);

  /// 只返回链接（is_link）
  @$pb.TagNumber(6)
  $core.bool get linksOnly => $_getBF(5);
  @$pb.TagNumber(6)
  set linksOnly($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLinksOnly() => $_has(5);
  @$pb.TagNumber(6)
  void clearLinksOnly() => $_clearField(6);
}

class ListHistoryResponse extends $pb.GeneratedMessage {
  factory ListHistoryResponse({
    $core.Iterable<ClipRecord>? records,
    $core.bool? searched,
  }) {
    final result = ListHistoryResponse._();
    if (records != null) result.records.addAll(records);
    if (searched != null) result.searched = searched;
    return result;
  }

  ListHistoryResponse._();

  factory ListHistoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListHistoryResponse()..mergeFromBuffer(data, registry);
  factory ListHistoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListHistoryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListHistoryResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: ListHistoryResponse.$_createMessage)
    ..pPM<ClipRecord>(1, _omitFieldNames ? '' : 'records',
        subBuilder: ClipRecord.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'searched')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHistoryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHistoryResponse copyWith(void Function(ListHistoryResponse) updates) =>
      super.copyWith((message) => updates(message as ListHistoryResponse))
          as ListHistoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListHistoryResponse() / ListHistoryResponse.new instead')
  static ListHistoryResponse create() => ListHistoryResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListHistoryResponse._();
  @$core.override
  ListHistoryResponse createEmptyInstance() => ListHistoryResponse._();
  @$core.pragma('dart2js:noInline')
  static ListHistoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListHistoryResponse>(
          ListHistoryResponse.$_createMessage);
  static ListHistoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ClipRecord> get records => $_getList(0);

  /// 按 query 搜索过。旧版后台服务不认识 query，会照常返回全部记录，界面据此识别
  @$pb.TagNumber(2)
  $core.bool get searched => $_getBF(1);
  @$pb.TagNumber(2)
  set searched($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSearched() => $_has(1);
  @$pb.TagNumber(2)
  void clearSearched() => $_clearField(2);
}

class DeleteHistoryRequest extends $pb.GeneratedMessage {
  factory DeleteHistoryRequest({
    $core.Iterable<$core.String>? ids,
    $core.bool? all,
  }) {
    final result = DeleteHistoryRequest._();
    if (ids != null) result.ids.addAll(ids);
    if (all != null) result.all = all;
    return result;
  }

  DeleteHistoryRequest._();

  factory DeleteHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteHistoryRequest()..mergeFromBuffer(data, registry);
  factory DeleteHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteHistoryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteHistoryRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: DeleteHistoryRequest.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'ids')
    ..aOB(2, _omitFieldNames ? '' : 'all')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteHistoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteHistoryRequest copyWith(void Function(DeleteHistoryRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteHistoryRequest))
          as DeleteHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DeleteHistoryRequest() / DeleteHistoryRequest.new instead')
  static DeleteHistoryRequest create() => DeleteHistoryRequest._();
  static $pb.GeneratedMessage $_createMessage() => DeleteHistoryRequest._();
  @$core.override
  DeleteHistoryRequest createEmptyInstance() => DeleteHistoryRequest._();
  @$core.pragma('dart2js:noInline')
  static DeleteHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteHistoryRequest>(
          DeleteHistoryRequest.$_createMessage);
  static DeleteHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get ids => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get all => $_getBF(1);
  @$pb.TagNumber(2)
  set all($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAll() => $_has(1);
  @$pb.TagNumber(2)
  void clearAll() => $_clearField(2);
}

class FetchRequest extends $pb.GeneratedMessage {
  factory FetchRequest({
    $core.String? clipId,
    $core.bool? preserveClipboard,
  }) {
    final result = FetchRequest._();
    if (clipId != null) result.clipId = clipId;
    if (preserveClipboard != null) result.preserveClipboard = preserveClipboard;
    return result;
  }

  FetchRequest._();

  factory FetchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FetchRequest()..mergeFromBuffer(data, registry);
  factory FetchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FetchRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FetchRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: FetchRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'clipId')
    ..aOB(2, _omitFieldNames ? '' : 'preserveClipboard')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FetchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FetchRequest copyWith(void Function(FetchRequest) updates) =>
      super.copyWith((message) => updates(message as FetchRequest))
          as FetchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FetchRequest() / FetchRequest.new instead')
  static FetchRequest create() => FetchRequest._();
  static $pb.GeneratedMessage $_createMessage() => FetchRequest._();
  @$core.override
  FetchRequest createEmptyInstance() => FetchRequest._();
  @$core.pragma('dart2js:noInline')
  static FetchRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FetchRequest>(
          FetchRequest.$_createMessage);
  static FetchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClipId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get preserveClipboard => $_getBF(1);
  @$pb.TagNumber(2)
  set preserveClipboard($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPreserveClipboard() => $_has(1);
  @$pb.TagNumber(2)
  void clearPreserveClipboard() => $_clearField(2);
}

class ApplyToClipboardRequest extends $pb.GeneratedMessage {
  factory ApplyToClipboardRequest({
    $core.String? clipId,
    $core.bool? plainText,
  }) {
    final result = ApplyToClipboardRequest._();
    if (clipId != null) result.clipId = clipId;
    if (plainText != null) result.plainText = plainText;
    return result;
  }

  ApplyToClipboardRequest._();

  factory ApplyToClipboardRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApplyToClipboardRequest()..mergeFromBuffer(data, registry);
  factory ApplyToClipboardRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApplyToClipboardRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApplyToClipboardRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: ApplyToClipboardRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'clipId')
    ..aOB(2, _omitFieldNames ? '' : 'plainText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyToClipboardRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyToClipboardRequest copyWith(
          void Function(ApplyToClipboardRequest) updates) =>
      super.copyWith((message) => updates(message as ApplyToClipboardRequest))
          as ApplyToClipboardRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ApplyToClipboardRequest() / ApplyToClipboardRequest.new instead')
  static ApplyToClipboardRequest create() => ApplyToClipboardRequest._();
  static $pb.GeneratedMessage $_createMessage() => ApplyToClipboardRequest._();
  @$core.override
  ApplyToClipboardRequest createEmptyInstance() => ApplyToClipboardRequest._();
  @$core.pragma('dart2js:noInline')
  static ApplyToClipboardRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApplyToClipboardRequest>(
          ApplyToClipboardRequest.$_createMessage);
  static ApplyToClipboardRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClipId() => $_clearField(1);

  /// 只写纯文本，去掉网页格式（快捷窗口里按 ⇧回车）
  @$pb.TagNumber(2)
  $core.bool get plainText => $_getBF(1);
  @$pb.TagNumber(2)
  set plainText($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlainText() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlainText() => $_clearField(2);
}

class SetFavoriteRequest extends $pb.GeneratedMessage {
  factory SetFavoriteRequest({
    $core.String? clipId,
    $core.bool? favorite,
  }) {
    final result = SetFavoriteRequest._();
    if (clipId != null) result.clipId = clipId;
    if (favorite != null) result.favorite = favorite;
    return result;
  }

  SetFavoriteRequest._();

  factory SetFavoriteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetFavoriteRequest()..mergeFromBuffer(data, registry);
  factory SetFavoriteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetFavoriteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetFavoriteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: SetFavoriteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'clipId')
    ..aOB(2, _omitFieldNames ? '' : 'favorite')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetFavoriteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetFavoriteRequest copyWith(void Function(SetFavoriteRequest) updates) =>
      super.copyWith((message) => updates(message as SetFavoriteRequest))
          as SetFavoriteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SetFavoriteRequest() / SetFavoriteRequest.new instead')
  static SetFavoriteRequest create() => SetFavoriteRequest._();
  static $pb.GeneratedMessage $_createMessage() => SetFavoriteRequest._();
  @$core.override
  SetFavoriteRequest createEmptyInstance() => SetFavoriteRequest._();
  @$core.pragma('dart2js:noInline')
  static SetFavoriteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetFavoriteRequest>(
          SetFavoriteRequest.$_createMessage);
  static SetFavoriteRequest? _defaultInstance;

  /// 收藏时传复制记录的 ID；取消收藏时传收藏的 ID 或原记录的 ID 都可以
  @$pb.TagNumber(1)
  $core.String get clipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClipId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get favorite => $_getBF(1);
  @$pb.TagNumber(2)
  set favorite($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFavorite() => $_has(1);
  @$pb.TagNumber(2)
  void clearFavorite() => $_clearField(2);
}

class GetClipDetailRequest extends $pb.GeneratedMessage {
  factory GetClipDetailRequest({
    $core.String? clipId,
  }) {
    final result = GetClipDetailRequest._();
    if (clipId != null) result.clipId = clipId;
    return result;
  }

  GetClipDetailRequest._();

  factory GetClipDetailRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetClipDetailRequest()..mergeFromBuffer(data, registry);
  factory GetClipDetailRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetClipDetailRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetClipDetailRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: GetClipDetailRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'clipId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetClipDetailRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetClipDetailRequest copyWith(void Function(GetClipDetailRequest) updates) =>
      super.copyWith((message) => updates(message as GetClipDetailRequest))
          as GetClipDetailRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetClipDetailRequest() / GetClipDetailRequest.new instead')
  static GetClipDetailRequest create() => GetClipDetailRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetClipDetailRequest._();
  @$core.override
  GetClipDetailRequest createEmptyInstance() => GetClipDetailRequest._();
  @$core.pragma('dart2js:noInline')
  static GetClipDetailRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetClipDetailRequest>(
          GetClipDetailRequest.$_createMessage);
  static GetClipDetailRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClipId() => $_clearField(1);
}

class ClipDetail extends $pb.GeneratedMessage {
  factory ClipDetail({
    $core.String? text,
    $core.int? textLength,
    $core.Iterable<$core.String>? sourcePaths,
  }) {
    final result = ClipDetail._();
    if (text != null) result.text = text;
    if (textLength != null) result.textLength = textLength;
    if (sourcePaths != null) result.sourcePaths.addAll(sourcePaths);
    return result;
  }

  ClipDetail._();

  factory ClipDetail.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClipDetail()..mergeFromBuffer(data, registry);
  factory ClipDetail.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClipDetail()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClipDetail',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: ClipDetail.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aI(2, _omitFieldNames ? '' : 'textLength')
    ..pPS(3, _omitFieldNames ? '' : 'sourcePaths')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClipDetail clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClipDetail copyWith(void Function(ClipDetail) updates) =>
      super.copyWith((message) => updates(message as ClipDetail)) as ClipDetail;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ClipDetail() / ClipDetail.new instead')
  static ClipDetail create() => ClipDetail._();
  static $pb.GeneratedMessage $_createMessage() => ClipDetail._();
  @$core.override
  ClipDetail createEmptyInstance() => ClipDetail._();
  @$core.pragma('dart2js:noInline')
  static ClipDetail getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClipDetail>(ClipDetail.$_createMessage);
  static ClipDetail? _defaultInstance;

  /// 文字的全文，网页格式给纯文本。最多前 4000 个字，保留换行
  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  /// 全文的字数
  @$pb.TagNumber(2)
  $core.int get textLength => $_getIZ(1);
  @$pb.TagNumber(2)
  set textLength($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTextLength() => $_has(1);
  @$pb.TagNumber(2)
  void clearTextLength() => $_clearField(2);

  /// 本机复制的文件在本机的完整路径
  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get sourcePaths => $_getList(2);
}

class QuickPasteStatus extends $pb.GeneratedMessage {
  factory QuickPasteStatus({
    $core.bool? running,
    $core.String? hotkeyError,
    $core.String? hotkey,
    $core.bool? pasteAvailable,
    $core.String? pasteUnavailableReason,
    $core.String? hotkeySource,
    $core.String? version,
  }) {
    final result = QuickPasteStatus._();
    if (running != null) result.running = running;
    if (hotkeyError != null) result.hotkeyError = hotkeyError;
    if (hotkey != null) result.hotkey = hotkey;
    if (pasteAvailable != null) result.pasteAvailable = pasteAvailable;
    if (pasteUnavailableReason != null)
      result.pasteUnavailableReason = pasteUnavailableReason;
    if (hotkeySource != null) result.hotkeySource = hotkeySource;
    if (version != null) result.version = version;
    return result;
  }

  QuickPasteStatus._();

  factory QuickPasteStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickPasteStatus()..mergeFromBuffer(data, registry);
  factory QuickPasteStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickPasteStatus()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuickPasteStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: QuickPasteStatus.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'running')
    ..aOS(2, _omitFieldNames ? '' : 'hotkeyError')
    ..aOS(3, _omitFieldNames ? '' : 'hotkey')
    ..aOB(4, _omitFieldNames ? '' : 'pasteAvailable')
    ..aOS(5, _omitFieldNames ? '' : 'pasteUnavailableReason')
    ..aOS(6, _omitFieldNames ? '' : 'hotkeySource')
    ..aOS(7, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickPasteStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickPasteStatus copyWith(void Function(QuickPasteStatus) updates) =>
      super.copyWith((message) => updates(message as QuickPasteStatus))
          as QuickPasteStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use QuickPasteStatus() / QuickPasteStatus.new instead')
  static QuickPasteStatus create() => QuickPasteStatus._();
  static $pb.GeneratedMessage $_createMessage() => QuickPasteStatus._();
  @$core.override
  QuickPasteStatus createEmptyInstance() => QuickPasteStatus._();
  @$core.pragma('dart2js:noInline')
  static QuickPasteStatus getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QuickPasteStatus>(
          QuickPasteStatus.$_createMessage);
  static QuickPasteStatus? _defaultInstance;

  /// 快捷窗口进程在运行（QuickPasteSession 连着）
  @$pb.TagNumber(1)
  $core.bool get running => $_getBF(0);
  @$pb.TagNumber(1)
  set running($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunning() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunning() => $_clearField(1);

  /// 快捷键注册失败的原因：空表示成功；in_use（被其他程序占用）、invalid、unsupported，
  /// 或者平台给出的原文
  @$pb.TagNumber(2)
  $core.String get hotkeyError => $_getSZ(1);
  @$pb.TagNumber(2)
  set hotkeyError($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHotkeyError() => $_has(1);
  @$pb.TagNumber(2)
  void clearHotkeyError() => $_clearField(2);

  /// 实际生效的快捷键，与 Config.quick_paste_hotkey 同样的写法。Wayland 上是门户里用户设定的组合
  @$pb.TagNumber(3)
  $core.String get hotkey => $_getSZ(2);
  @$pb.TagNumber(3)
  set hotkey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHotkey() => $_has(2);
  @$pb.TagNumber(3)
  void clearHotkey() => $_clearField(3);

  /// 选中后能自动粘贴
  @$pb.TagNumber(4)
  $core.bool get pasteAvailable => $_getBF(3);
  @$pb.TagNumber(4)
  set pasteAvailable($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPasteAvailable() => $_has(3);
  @$pb.TagNumber(4)
  void clearPasteAvailable() => $_clearField(4);

  /// 不能自动粘贴的原因：not_trusted（Mac 未授予辅助功能）、wayland、copy_only（设置里选了只复制）
  @$pb.TagNumber(5)
  $core.String get pasteUnavailableReason => $_getSZ(4);
  @$pb.TagNumber(5)
  set pasteUnavailableReason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPasteUnavailableReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearPasteUnavailableReason() => $_clearField(5);

  /// 快捷键由谁触发：native（程序自己注册）、portal（Wayland 全局快捷键门户）、
  /// system_shortcut（Wayland 上要用户在系统设置里添加快捷键）
  @$pb.TagNumber(6)
  $core.String get hotkeySource => $_getSZ(5);
  @$pb.TagNumber(6)
  set hotkeySource($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHotkeySource() => $_has(5);
  @$pb.TagNumber(6)
  void clearHotkeySource() => $_clearField(6);

  /// 快捷窗口的版本。App 更新后还在跑旧版的，界面让它按新的程序重新启动
  @$pb.TagNumber(7)
  $core.String get version => $_getSZ(6);
  @$pb.TagNumber(7)
  set version($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVersion() => $_has(6);
  @$pb.TagNumber(7)
  void clearVersion() => $_clearField(7);
}

class QuickPasteCommand extends $pb.GeneratedMessage {
  factory QuickPasteCommand({
    $core.String? command,
  }) {
    final result = QuickPasteCommand._();
    if (command != null) result.command = command;
    return result;
  }

  QuickPasteCommand._();

  factory QuickPasteCommand.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickPasteCommand()..mergeFromBuffer(data, registry);
  factory QuickPasteCommand.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      QuickPasteCommand()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuickPasteCommand',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: QuickPasteCommand.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'command')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickPasteCommand clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuickPasteCommand copyWith(void Function(QuickPasteCommand) updates) =>
      super.copyWith((message) => updates(message as QuickPasteCommand))
          as QuickPasteCommand;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use QuickPasteCommand() / QuickPasteCommand.new instead')
  static QuickPasteCommand create() => QuickPasteCommand._();
  static $pb.GeneratedMessage $_createMessage() => QuickPasteCommand._();
  @$core.override
  QuickPasteCommand createEmptyInstance() => QuickPasteCommand._();
  @$core.pragma('dart2js:noInline')
  static QuickPasteCommand getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QuickPasteCommand>(
          QuickPasteCommand.$_createMessage);
  static QuickPasteCommand? _defaultInstance;

  /// request_permission：Mac 上请求辅助功能权限；
  /// suspend_hotkey / resume_hotkey：设置页录制快捷键期间暂停全局快捷键；
  /// show：呼出快捷窗口
  @$pb.TagNumber(1)
  $core.String get command => $_getSZ(0);
  @$pb.TagNumber(1)
  set command($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCommand() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommand() => $_clearField(1);
}

class ListDevicesResponse extends $pb.GeneratedMessage {
  factory ListDevicesResponse({
    Device? self,
    $core.Iterable<Device>? peers,
  }) {
    final result = ListDevicesResponse._();
    if (self != null) result.self = self;
    if (peers != null) result.peers.addAll(peers);
    return result;
  }

  ListDevicesResponse._();

  factory ListDevicesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDevicesResponse()..mergeFromBuffer(data, registry);
  factory ListDevicesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDevicesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDevicesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: ListDevicesResponse.$_createMessage)
    ..aOM<Device>(1, _omitFieldNames ? '' : 'self',
        subBuilder: Device.$_createMessage)
    ..pPM<Device>(2, _omitFieldNames ? '' : 'peers',
        subBuilder: Device.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDevicesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDevicesResponse copyWith(void Function(ListDevicesResponse) updates) =>
      super.copyWith((message) => updates(message as ListDevicesResponse))
          as ListDevicesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListDevicesResponse() / ListDevicesResponse.new instead')
  static ListDevicesResponse create() => ListDevicesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListDevicesResponse._();
  @$core.override
  ListDevicesResponse createEmptyInstance() => ListDevicesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListDevicesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDevicesResponse>(
          ListDevicesResponse.$_createMessage);
  static ListDevicesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Device get self => $_getN(0);
  @$pb.TagNumber(1)
  set self(Device value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSelf() => $_has(0);
  @$pb.TagNumber(1)
  void clearSelf() => $_clearField(1);
  @$pb.TagNumber(1)
  Device ensureSelf() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Device> get peers => $_getList(1);
}

class CreatePairingCodeResponse extends $pb.GeneratedMessage {
  factory CreatePairingCodeResponse({
    $core.String? code,
    $fixnum.Int64? expiresAtUnix,
    $core.Iterable<$core.String>? lanAddresses,
  }) {
    final result = CreatePairingCodeResponse._();
    if (code != null) result.code = code;
    if (expiresAtUnix != null) result.expiresAtUnix = expiresAtUnix;
    if (lanAddresses != null) result.lanAddresses.addAll(lanAddresses);
    return result;
  }

  CreatePairingCodeResponse._();

  factory CreatePairingCodeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreatePairingCodeResponse()..mergeFromBuffer(data, registry);
  factory CreatePairingCodeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreatePairingCodeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreatePairingCodeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: CreatePairingCodeResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aInt64(2, _omitFieldNames ? '' : 'expiresAtUnix')
    ..pPS(3, _omitFieldNames ? '' : 'lanAddresses')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePairingCodeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePairingCodeResponse copyWith(
          void Function(CreatePairingCodeResponse) updates) =>
      super.copyWith((message) => updates(message as CreatePairingCodeResponse))
          as CreatePairingCodeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreatePairingCodeResponse() / CreatePairingCodeResponse.new instead')
  static CreatePairingCodeResponse create() => CreatePairingCodeResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CreatePairingCodeResponse._();
  @$core.override
  CreatePairingCodeResponse createEmptyInstance() =>
      CreatePairingCodeResponse._();
  @$core.pragma('dart2js:noInline')
  static CreatePairingCodeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreatePairingCodeResponse>(
          CreatePairingCodeResponse.$_createMessage);
  static CreatePairingCodeResponse? _defaultInstance;

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

  /// 本机的局域网地址，默认路由所在的网卡排第一。不在同一网段时，
  /// 另一台要在输入配对码的同时输入其中一个。端口是默认值时省略端口。
  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get lanAddresses => $_getList(2);
}

/// 在局域网和服务器上都找不到这个配对码时返回 NOT_FOUND；
/// 找到了但配对码不对返回 INVALID_ARGUMENT；配对码已失效返回 FAILED_PRECONDITION。
class RedeemPairingCodeRequest extends $pb.GeneratedMessage {
  factory RedeemPairingCodeRequest({
    $core.String? code,
    $core.String? address,
  }) {
    final result = RedeemPairingCodeRequest._();
    if (code != null) result.code = code;
    if (address != null) result.address = address;
    return result;
  }

  RedeemPairingCodeRequest._();

  factory RedeemPairingCodeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RedeemPairingCodeRequest()..mergeFromBuffer(data, registry);
  factory RedeemPairingCodeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RedeemPairingCodeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RedeemPairingCodeRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: RedeemPairingCodeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'address')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RedeemPairingCodeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RedeemPairingCodeRequest copyWith(
          void Function(RedeemPairingCodeRequest) updates) =>
      super.copyWith((message) => updates(message as RedeemPairingCodeRequest))
          as RedeemPairingCodeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RedeemPairingCodeRequest() / RedeemPairingCodeRequest.new instead')
  static RedeemPairingCodeRequest create() => RedeemPairingCodeRequest._();
  static $pb.GeneratedMessage $_createMessage() => RedeemPairingCodeRequest._();
  @$core.override
  RedeemPairingCodeRequest createEmptyInstance() =>
      RedeemPairingCodeRequest._();
  @$core.pragma('dart2js:noInline')
  static RedeemPairingCodeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RedeemPairingCodeRequest>(
          RedeemPairingCodeRequest.$_createMessage);
  static RedeemPairingCodeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  /// 可选：对方配对码下面显示的地址（ip 或 ip:port），不在同一网段时填写
  @$pb.TagNumber(2)
  $core.String get address => $_getSZ(1);
  @$pb.TagNumber(2)
  set address($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAddress() => $_has(1);
  @$pb.TagNumber(2)
  void clearAddress() => $_clearField(2);
}

class RedeemPairingCodeResponse extends $pb.GeneratedMessage {
  factory RedeemPairingCodeResponse({
    Device? peer,
    $core.String? pairingSession,
  }) {
    final result = RedeemPairingCodeResponse._();
    if (peer != null) result.peer = peer;
    if (pairingSession != null) result.pairingSession = pairingSession;
    return result;
  }

  RedeemPairingCodeResponse._();

  factory RedeemPairingCodeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RedeemPairingCodeResponse()..mergeFromBuffer(data, registry);
  factory RedeemPairingCodeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RedeemPairingCodeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RedeemPairingCodeResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: RedeemPairingCodeResponse.$_createMessage)
    ..aOM<Device>(1, _omitFieldNames ? '' : 'peer',
        subBuilder: Device.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'pairingSession')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RedeemPairingCodeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RedeemPairingCodeResponse copyWith(
          void Function(RedeemPairingCodeResponse) updates) =>
      super.copyWith((message) => updates(message as RedeemPairingCodeResponse))
          as RedeemPairingCodeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RedeemPairingCodeResponse() / RedeemPairingCodeResponse.new instead')
  static RedeemPairingCodeResponse create() => RedeemPairingCodeResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RedeemPairingCodeResponse._();
  @$core.override
  RedeemPairingCodeResponse createEmptyInstance() =>
      RedeemPairingCodeResponse._();
  @$core.pragma('dart2js:noInline')
  static RedeemPairingCodeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RedeemPairingCodeResponse>(
          RedeemPairingCodeResponse.$_createMessage);
  static RedeemPairingCodeResponse? _defaultInstance;

  /// 返回对端信息供用户肉眼核对指纹，确认后再调 ConfirmPairing
  @$pb.TagNumber(1)
  Device get peer => $_getN(0);
  @$pb.TagNumber(1)
  set peer(Device value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPeer() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeer() => $_clearField(1);
  @$pb.TagNumber(1)
  Device ensurePeer() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get pairingSession => $_getSZ(1);
  @$pb.TagNumber(2)
  set pairingSession($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPairingSession() => $_has(1);
  @$pb.TagNumber(2)
  void clearPairingSession() => $_clearField(2);
}

class ConfirmPairingRequest extends $pb.GeneratedMessage {
  factory ConfirmPairingRequest({
    $core.String? pairingSession,
    $core.bool? accept,
  }) {
    final result = ConfirmPairingRequest._();
    if (pairingSession != null) result.pairingSession = pairingSession;
    if (accept != null) result.accept = accept;
    return result;
  }

  ConfirmPairingRequest._();

  factory ConfirmPairingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConfirmPairingRequest()..mergeFromBuffer(data, registry);
  factory ConfirmPairingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConfirmPairingRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfirmPairingRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: ConfirmPairingRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'pairingSession')
    ..aOB(2, _omitFieldNames ? '' : 'accept')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmPairingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfirmPairingRequest copyWith(
          void Function(ConfirmPairingRequest) updates) =>
      super.copyWith((message) => updates(message as ConfirmPairingRequest))
          as ConfirmPairingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ConfirmPairingRequest() / ConfirmPairingRequest.new instead')
  static ConfirmPairingRequest create() => ConfirmPairingRequest._();
  static $pb.GeneratedMessage $_createMessage() => ConfirmPairingRequest._();
  @$core.override
  ConfirmPairingRequest createEmptyInstance() => ConfirmPairingRequest._();
  @$core.pragma('dart2js:noInline')
  static ConfirmPairingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfirmPairingRequest>(
          ConfirmPairingRequest.$_createMessage);
  static ConfirmPairingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pairingSession => $_getSZ(0);
  @$pb.TagNumber(1)
  set pairingSession($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPairingSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearPairingSession() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get accept => $_getBF(1);
  @$pb.TagNumber(2)
  set accept($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccept() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccept() => $_clearField(2);
}

/// 附近一台打开了「搜索附近设备」窗口的设备。
class NearbyDevice extends $pb.GeneratedMessage {
  factory NearbyDevice({
    $core.String? id,
    $core.String? name,
    $core.String? platform,
    $core.bool? paired,
  }) {
    final result = NearbyDevice._();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (platform != null) result.platform = platform;
    if (paired != null) result.paired = paired;
    return result;
  }

  NearbyDevice._();

  factory NearbyDevice.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NearbyDevice()..mergeFromBuffer(data, registry);
  factory NearbyDevice.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NearbyDevice()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NearbyDevice',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: NearbyDevice.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'platform')
    ..aOB(4, _omitFieldNames ? '' : 'paired')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NearbyDevice clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NearbyDevice copyWith(void Function(NearbyDevice) updates) =>
      super.copyWith((message) => updates(message as NearbyDevice))
          as NearbyDevice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use NearbyDevice() / NearbyDevice.new instead')
  static NearbyDevice create() => NearbyDevice._();
  static $pb.GeneratedMessage $_createMessage() => NearbyDevice._();
  @$core.override
  NearbyDevice createEmptyInstance() => NearbyDevice._();
  @$core.pragma('dart2js:noInline')
  static NearbyDevice getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NearbyDevice>(
          NearbyDevice.$_createMessage);
  static NearbyDevice? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

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
  $core.bool get paired => $_getBF(3);
  @$pb.TagNumber(4)
  set paired($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPaired() => $_has(3);
  @$pb.TagNumber(4)
  void clearPaired() => $_clearField(4);
}

class NearbyDevices extends $pb.GeneratedMessage {
  factory NearbyDevices({
    $core.Iterable<NearbyDevice>? devices,
  }) {
    final result = NearbyDevices._();
    if (devices != null) result.devices.addAll(devices);
    return result;
  }

  NearbyDevices._();

  factory NearbyDevices.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NearbyDevices()..mergeFromBuffer(data, registry);
  factory NearbyDevices.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NearbyDevices()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NearbyDevices',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: NearbyDevices.$_createMessage)
    ..pPM<NearbyDevice>(1, _omitFieldNames ? '' : 'devices',
        subBuilder: NearbyDevice.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NearbyDevices clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NearbyDevices copyWith(void Function(NearbyDevices) updates) =>
      super.copyWith((message) => updates(message as NearbyDevices))
          as NearbyDevices;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use NearbyDevices() / NearbyDevices.new instead')
  static NearbyDevices create() => NearbyDevices._();
  static $pb.GeneratedMessage $_createMessage() => NearbyDevices._();
  @$core.override
  NearbyDevices createEmptyInstance() => NearbyDevices._();
  @$core.pragma('dart2js:noInline')
  static NearbyDevices getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NearbyDevices>(
          NearbyDevices.$_createMessage);
  static NearbyDevices? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<NearbyDevice> get devices => $_getList(0);
}

class PairNearbyRequest extends $pb.GeneratedMessage {
  factory PairNearbyRequest({
    $core.String? id,
  }) {
    final result = PairNearbyRequest._();
    if (id != null) result.id = id;
    return result;
  }

  PairNearbyRequest._();

  factory PairNearbyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PairNearbyRequest()..mergeFromBuffer(data, registry);
  factory PairNearbyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PairNearbyRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PairNearbyRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: PairNearbyRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PairNearbyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PairNearbyRequest copyWith(void Function(PairNearbyRequest) updates) =>
      super.copyWith((message) => updates(message as PairNearbyRequest))
          as PairNearbyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PairNearbyRequest() / PairNearbyRequest.new instead')
  static PairNearbyRequest create() => PairNearbyRequest._();
  static $pb.GeneratedMessage $_createMessage() => PairNearbyRequest._();
  @$core.override
  PairNearbyRequest createEmptyInstance() => PairNearbyRequest._();
  @$core.pragma('dart2js:noInline')
  static PairNearbyRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PairNearbyRequest>(
          PairNearbyRequest.$_createMessage);
  static PairNearbyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class UnpairRequest extends $pb.GeneratedMessage {
  factory UnpairRequest({
    $core.String? deviceId,
  }) {
    final result = UnpairRequest._();
    if (deviceId != null) result.deviceId = deviceId;
    return result;
  }

  UnpairRequest._();

  factory UnpairRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UnpairRequest()..mergeFromBuffer(data, registry);
  factory UnpairRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UnpairRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnpairRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: UnpairRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnpairRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnpairRequest copyWith(void Function(UnpairRequest) updates) =>
      super.copyWith((message) => updates(message as UnpairRequest))
          as UnpairRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UnpairRequest() / UnpairRequest.new instead')
  static UnpairRequest create() => UnpairRequest._();
  static $pb.GeneratedMessage $_createMessage() => UnpairRequest._();
  @$core.override
  UnpairRequest createEmptyInstance() => UnpairRequest._();
  @$core.pragma('dart2js:noInline')
  static UnpairRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnpairRequest>(
          UnpairRequest.$_createMessage);
  static UnpairRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);
}

class SetDeviceAddressRequest extends $pb.GeneratedMessage {
  factory SetDeviceAddressRequest({
    $core.String? deviceId,
    $core.String? address,
  }) {
    final result = SetDeviceAddressRequest._();
    if (deviceId != null) result.deviceId = deviceId;
    if (address != null) result.address = address;
    return result;
  }

  SetDeviceAddressRequest._();

  factory SetDeviceAddressRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetDeviceAddressRequest()..mergeFromBuffer(data, registry);
  factory SetDeviceAddressRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetDeviceAddressRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetDeviceAddressRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: SetDeviceAddressRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'address')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetDeviceAddressRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetDeviceAddressRequest copyWith(
          void Function(SetDeviceAddressRequest) updates) =>
      super.copyWith((message) => updates(message as SetDeviceAddressRequest))
          as SetDeviceAddressRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetDeviceAddressRequest() / SetDeviceAddressRequest.new instead')
  static SetDeviceAddressRequest create() => SetDeviceAddressRequest._();
  static $pb.GeneratedMessage $_createMessage() => SetDeviceAddressRequest._();
  @$core.override
  SetDeviceAddressRequest createEmptyInstance() => SetDeviceAddressRequest._();
  @$core.pragma('dart2js:noInline')
  static SetDeviceAddressRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetDeviceAddressRequest>(
          SetDeviceAddressRequest.$_createMessage);
  static SetDeviceAddressRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get address => $_getSZ(1);
  @$pb.TagNumber(2)
  set address($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAddress() => $_has(1);
  @$pb.TagNumber(2)
  void clearAddress() => $_clearField(2);
}

class Config extends $pb.GeneratedMessage {
  factory Config({
    $fixnum.Int64? autoSyncThresholdBytes,
    $fixnum.Int64? historyTtlSeconds,
    $fixnum.Int64? cacheTtlSeconds,
    $core.bool? syncText,
    $core.bool? syncHtml,
    $core.bool? syncImage,
    $core.bool? syncFile,
    $core.bool? autoApplyToClipboard,
    $core.bool? launchAtLogin,
    $core.String? deviceName,
    $core.String? signalingUrl,
    $core.bool? onlyOwnStun,
    $core.String? language,
    $core.bool? lanDisabled,
    ServiceMode? serviceMode,
    $core.String? customSignalingUrl,
    $core.String? officialNoticeAck,
    $core.bool? updateCheckDisabled,
    $core.String? updateSkipVersion,
    $core.bool? quickPasteDisabled,
    $core.String? quickPasteHotkey,
    $core.bool? quickPasteCopyOnly,
  }) {
    final result = Config._();
    if (autoSyncThresholdBytes != null)
      result.autoSyncThresholdBytes = autoSyncThresholdBytes;
    if (historyTtlSeconds != null) result.historyTtlSeconds = historyTtlSeconds;
    if (cacheTtlSeconds != null) result.cacheTtlSeconds = cacheTtlSeconds;
    if (syncText != null) result.syncText = syncText;
    if (syncHtml != null) result.syncHtml = syncHtml;
    if (syncImage != null) result.syncImage = syncImage;
    if (syncFile != null) result.syncFile = syncFile;
    if (autoApplyToClipboard != null)
      result.autoApplyToClipboard = autoApplyToClipboard;
    if (launchAtLogin != null) result.launchAtLogin = launchAtLogin;
    if (deviceName != null) result.deviceName = deviceName;
    if (signalingUrl != null) result.signalingUrl = signalingUrl;
    if (onlyOwnStun != null) result.onlyOwnStun = onlyOwnStun;
    if (language != null) result.language = language;
    if (lanDisabled != null) result.lanDisabled = lanDisabled;
    if (serviceMode != null) result.serviceMode = serviceMode;
    if (customSignalingUrl != null)
      result.customSignalingUrl = customSignalingUrl;
    if (officialNoticeAck != null) result.officialNoticeAck = officialNoticeAck;
    if (updateCheckDisabled != null)
      result.updateCheckDisabled = updateCheckDisabled;
    if (updateSkipVersion != null) result.updateSkipVersion = updateSkipVersion;
    if (quickPasteDisabled != null)
      result.quickPasteDisabled = quickPasteDisabled;
    if (quickPasteHotkey != null) result.quickPasteHotkey = quickPasteHotkey;
    if (quickPasteCopyOnly != null)
      result.quickPasteCopyOnly = quickPasteCopyOnly;
    return result;
  }

  Config._();

  factory Config.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Config()..mergeFromBuffer(data, registry);
  factory Config.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Config()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Config',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: Config.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'autoSyncThresholdBytes')
    ..aInt64(2, _omitFieldNames ? '' : 'historyTtlSeconds')
    ..aInt64(3, _omitFieldNames ? '' : 'cacheTtlSeconds')
    ..aOB(4, _omitFieldNames ? '' : 'syncText')
    ..aOB(5, _omitFieldNames ? '' : 'syncHtml')
    ..aOB(6, _omitFieldNames ? '' : 'syncImage')
    ..aOB(7, _omitFieldNames ? '' : 'syncFile')
    ..aOB(8, _omitFieldNames ? '' : 'autoApplyToClipboard')
    ..aOB(9, _omitFieldNames ? '' : 'launchAtLogin')
    ..aOS(10, _omitFieldNames ? '' : 'deviceName')
    ..aOS(11, _omitFieldNames ? '' : 'signalingUrl')
    ..aOB(12, _omitFieldNames ? '' : 'onlyOwnStun')
    ..aOS(13, _omitFieldNames ? '' : 'language')
    ..aOB(14, _omitFieldNames ? '' : 'lanDisabled')
    ..aE<ServiceMode>(15, _omitFieldNames ? '' : 'serviceMode',
        enumValues: ServiceMode.values)
    ..aOS(16, _omitFieldNames ? '' : 'customSignalingUrl')
    ..aOS(17, _omitFieldNames ? '' : 'officialNoticeAck')
    ..aOB(18, _omitFieldNames ? '' : 'updateCheckDisabled')
    ..aOS(19, _omitFieldNames ? '' : 'updateSkipVersion')
    ..aOB(20, _omitFieldNames ? '' : 'quickPasteDisabled')
    ..aOS(21, _omitFieldNames ? '' : 'quickPasteHotkey')
    ..aOB(22, _omitFieldNames ? '' : 'quickPasteCopyOnly')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Config clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Config copyWith(void Function(Config) updates) =>
      super.copyWith((message) => updates(message as Config)) as Config;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Config() / Config.new instead')
  static Config create() => Config._();
  static $pb.GeneratedMessage $_createMessage() => Config._();
  @$core.override
  Config createEmptyInstance() => Config._();
  @$core.pragma('dart2js:noInline')
  static Config getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Config>(Config.$_createMessage);
  static Config? _defaultInstance;

  /// 小于此值自动预取，大于此值只同步元数据等用户手动拉取
  @$pb.TagNumber(1)
  $fixnum.Int64 get autoSyncThresholdBytes => $_getI64(0);
  @$pb.TagNumber(1)
  set autoSyncThresholdBytes($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAutoSyncThresholdBytes() => $_has(0);
  @$pb.TagNumber(1)
  void clearAutoSyncThresholdBytes() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get historyTtlSeconds => $_getI64(1);
  @$pb.TagNumber(2)
  set historyTtlSeconds($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHistoryTtlSeconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearHistoryTtlSeconds() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get cacheTtlSeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set cacheTtlSeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCacheTtlSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearCacheTtlSeconds() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get syncText => $_getBF(3);
  @$pb.TagNumber(4)
  set syncText($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSyncText() => $_has(3);
  @$pb.TagNumber(4)
  void clearSyncText() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get syncHtml => $_getBF(4);
  @$pb.TagNumber(5)
  set syncHtml($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSyncHtml() => $_has(4);
  @$pb.TagNumber(5)
  void clearSyncHtml() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get syncImage => $_getBF(5);
  @$pb.TagNumber(6)
  set syncImage($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSyncImage() => $_has(5);
  @$pb.TagNumber(6)
  void clearSyncImage() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get syncFile => $_getBF(6);
  @$pb.TagNumber(7)
  set syncFile($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSyncFile() => $_has(6);
  @$pb.TagNumber(7)
  void clearSyncFile() => $_clearField(7);

  /// 收到对端内容后是否自动覆盖本机剪贴板
  @$pb.TagNumber(8)
  $core.bool get autoApplyToClipboard => $_getBF(7);
  @$pb.TagNumber(8)
  set autoApplyToClipboard($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAutoApplyToClipboard() => $_has(7);
  @$pb.TagNumber(8)
  void clearAutoApplyToClipboard() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get launchAtLogin => $_getBF(8);
  @$pb.TagNumber(9)
  set launchAtLogin($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLaunchAtLogin() => $_has(8);
  @$pb.TagNumber(9)
  void clearLaunchAtLogin() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get deviceName => $_getSZ(9);
  @$pb.TagNumber(10)
  set deviceName($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDeviceName() => $_has(9);
  @$pb.TagNumber(10)
  void clearDeviceName() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get signalingUrl => $_getSZ(10);
  @$pb.TagNumber(11)
  set signalingUrl($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSignalingUrl() => $_has(10);
  @$pb.TagNumber(11)
  void clearSignalingUrl() => $_clearField(11);

  /// 只用自己的服务器探测网络出口，不用公共 STUN 服务器。
  /// 默认 false（即允许公共服务器）：旧版界面不发这个字段时，不会被误关掉。
  @$pb.TagNumber(12)
  $core.bool get onlyOwnStun => $_getBF(11);
  @$pb.TagNumber(12)
  set onlyOwnStun($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasOnlyOwnStun() => $_has(11);
  @$pb.TagNumber(12)
  void clearOnlyOwnStun() => $_clearField(12);

  /// 界面语言：空字符串表示跟随系统；否则是 "zh-Hans"、"zh-Hant-TW"、"zh-Hant-HK"、"en"、"ja" 之一。
  /// 存在后台服务这里而不是界面里：Windows 的托盘菜单由后台服务画，也要跟着变。
  @$pb.TagNumber(13)
  $core.String get language => $_getSZ(12);
  @$pb.TagNumber(13)
  set language($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasLanguage() => $_has(12);
  @$pb.TagNumber(13)
  void clearLanguage() => $_clearField(13);

  /// 不在局域网里查找设备、也不接受局域网里的配对请求。
  /// 默认 false（即开启）：写成反向的，旧配置不用迁移。
  @$pb.TagNumber(14)
  $core.bool get lanDisabled => $_getBF(13);
  @$pb.TagNumber(14)
  set lanDisabled($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasLanDisabled() => $_has(13);
  @$pb.TagNumber(14)
  void clearLanDisabled() => $_clearField(14);

  /// Official service is opt-in; remembered custom URLs are inactive otherwise.
  @$pb.TagNumber(15)
  ServiceMode get serviceMode => $_getN(14);
  @$pb.TagNumber(15)
  set serviceMode(ServiceMode value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasServiceMode() => $_has(14);
  @$pb.TagNumber(15)
  void clearServiceMode() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get customSignalingUrl => $_getSZ(15);
  @$pb.TagNumber(16)
  set customSignalingUrl($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasCustomSignalingUrl() => $_has(15);
  @$pb.TagNumber(16)
  void clearCustomSignalingUrl() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get officialNoticeAck => $_getSZ(16);
  @$pb.TagNumber(17)
  set officialNoticeAck($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasOfficialNoticeAck() => $_has(16);
  @$pb.TagNumber(17)
  void clearOfficialNoticeAck() => $_clearField(17);

  /// 不自动检查更新。写成反向的：旧配置没有这一项时就是开启
  @$pb.TagNumber(18)
  $core.bool get updateCheckDisabled => $_getBF(17);
  @$pb.TagNumber(18)
  set updateCheckDisabled($core.bool value) => $_setBool(17, value);
  @$pb.TagNumber(18)
  $core.bool hasUpdateCheckDisabled() => $_has(17);
  @$pb.TagNumber(18)
  void clearUpdateCheckDisabled() => $_clearField(18);

  /// 用户选择跳过的版本，自动检查不再提示它；手动检查照常显示
  @$pb.TagNumber(19)
  $core.String get updateSkipVersion => $_getSZ(18);
  @$pb.TagNumber(19)
  set updateSkipVersion($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasUpdateSkipVersion() => $_has(18);
  @$pb.TagNumber(19)
  void clearUpdateSkipVersion() => $_clearField(19);

  /// 关掉快捷粘贴窗口。写成反向的：旧配置没有这一项时就是开启
  @$pb.TagNumber(20)
  $core.bool get quickPasteDisabled => $_getBF(19);
  @$pb.TagNumber(20)
  set quickPasteDisabled($core.bool value) => $_setBool(19, value);
  @$pb.TagNumber(20)
  $core.bool hasQuickPasteDisabled() => $_has(19);
  @$pb.TagNumber(20)
  void clearQuickPasteDisabled() => $_clearField(20);

  /// 快捷键，如 "alt+v"、"ctrl+alt+v"，修饰键按 ctrl、alt、shift、meta 的顺序。
  /// 空字符串表示默认：Mac 上 ⌥V，其他平台 Alt+V
  @$pb.TagNumber(21)
  $core.String get quickPasteHotkey => $_getSZ(20);
  @$pb.TagNumber(21)
  set quickPasteHotkey($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasQuickPasteHotkey() => $_has(20);
  @$pb.TagNumber(21)
  void clearQuickPasteHotkey() => $_clearField(21);

  /// 选中后只放进剪贴板，不模拟粘贴
  @$pb.TagNumber(22)
  $core.bool get quickPasteCopyOnly => $_getBF(21);
  @$pb.TagNumber(22)
  set quickPasteCopyOnly($core.bool value) => $_setBool(21, value);
  @$pb.TagNumber(22)
  $core.bool hasQuickPasteCopyOnly() => $_has(21);
  @$pb.TagNumber(22)
  void clearQuickPasteCopyOnly() => $_clearField(22);
}

class OfficialUsage extends $pb.GeneratedMessage {
  factory OfficialUsage({
    $core.bool? available,
    $core.String? day,
    $core.String? quotaGroup,
    $fixnum.Int64? uploadBytes,
    $fixnum.Int64? downloadBytes,
    $fixnum.Int64? limitBytes,
    $fixnum.Int64? remainingBytes,
    $fixnum.Int64? resetAtUnix,
    $fixnum.Int64? updatedAtUnix,
    $core.String? reason,
  }) {
    final result = OfficialUsage._();
    if (available != null) result.available = available;
    if (day != null) result.day = day;
    if (quotaGroup != null) result.quotaGroup = quotaGroup;
    if (uploadBytes != null) result.uploadBytes = uploadBytes;
    if (downloadBytes != null) result.downloadBytes = downloadBytes;
    if (limitBytes != null) result.limitBytes = limitBytes;
    if (remainingBytes != null) result.remainingBytes = remainingBytes;
    if (resetAtUnix != null) result.resetAtUnix = resetAtUnix;
    if (updatedAtUnix != null) result.updatedAtUnix = updatedAtUnix;
    if (reason != null) result.reason = reason;
    return result;
  }

  OfficialUsage._();

  factory OfficialUsage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfficialUsage()..mergeFromBuffer(data, registry);
  factory OfficialUsage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfficialUsage()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfficialUsage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: OfficialUsage.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'available')
    ..aOS(2, _omitFieldNames ? '' : 'day')
    ..aOS(3, _omitFieldNames ? '' : 'quotaGroup')
    ..aInt64(4, _omitFieldNames ? '' : 'uploadBytes')
    ..aInt64(5, _omitFieldNames ? '' : 'downloadBytes')
    ..aInt64(6, _omitFieldNames ? '' : 'limitBytes')
    ..aInt64(7, _omitFieldNames ? '' : 'remainingBytes')
    ..aInt64(8, _omitFieldNames ? '' : 'resetAtUnix')
    ..aInt64(9, _omitFieldNames ? '' : 'updatedAtUnix')
    ..aOS(10, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfficialUsage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfficialUsage copyWith(void Function(OfficialUsage) updates) =>
      super.copyWith((message) => updates(message as OfficialUsage))
          as OfficialUsage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OfficialUsage() / OfficialUsage.new instead')
  static OfficialUsage create() => OfficialUsage._();
  static $pb.GeneratedMessage $_createMessage() => OfficialUsage._();
  @$core.override
  OfficialUsage createEmptyInstance() => OfficialUsage._();
  @$core.pragma('dart2js:noInline')
  static OfficialUsage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OfficialUsage>(
          OfficialUsage.$_createMessage);
  static OfficialUsage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get available => $_getBF(0);
  @$pb.TagNumber(1)
  set available($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAvailable() => $_has(0);
  @$pb.TagNumber(1)
  void clearAvailable() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get day => $_getSZ(1);
  @$pb.TagNumber(2)
  set day($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDay() => $_has(1);
  @$pb.TagNumber(2)
  void clearDay() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get quotaGroup => $_getSZ(2);
  @$pb.TagNumber(3)
  set quotaGroup($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuotaGroup() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuotaGroup() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get uploadBytes => $_getI64(3);
  @$pb.TagNumber(4)
  set uploadBytes($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUploadBytes() => $_has(3);
  @$pb.TagNumber(4)
  void clearUploadBytes() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get downloadBytes => $_getI64(4);
  @$pb.TagNumber(5)
  set downloadBytes($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDownloadBytes() => $_has(4);
  @$pb.TagNumber(5)
  void clearDownloadBytes() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get limitBytes => $_getI64(5);
  @$pb.TagNumber(6)
  set limitBytes($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLimitBytes() => $_has(5);
  @$pb.TagNumber(6)
  void clearLimitBytes() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get remainingBytes => $_getI64(6);
  @$pb.TagNumber(7)
  set remainingBytes($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRemainingBytes() => $_has(6);
  @$pb.TagNumber(7)
  void clearRemainingBytes() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get resetAtUnix => $_getI64(7);
  @$pb.TagNumber(8)
  set resetAtUnix($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasResetAtUnix() => $_has(7);
  @$pb.TagNumber(8)
  void clearResetAtUnix() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get updatedAtUnix => $_getI64(8);
  @$pb.TagNumber(9)
  set updatedAtUnix($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUpdatedAtUnix() => $_has(8);
  @$pb.TagNumber(9)
  void clearUpdatedAtUnix() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get reason => $_getSZ(9);
  @$pb.TagNumber(10)
  set reason($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearReason() => $_clearField(10);
}

/// 最近一轮网络出口探测的结果。
class NetworkInfo extends $pb.GeneratedMessage {
  factory NetworkInfo({
    $core.int? localPort,
    $core.Iterable<NetworkEgress>? egresses,
    $core.int? probed,
    $core.int? answered,
    $fixnum.Int64? probedAtUnix,
    LanInfo? lan,
  }) {
    final result = NetworkInfo._();
    if (localPort != null) result.localPort = localPort;
    if (egresses != null) result.egresses.addAll(egresses);
    if (probed != null) result.probed = probed;
    if (answered != null) result.answered = answered;
    if (probedAtUnix != null) result.probedAtUnix = probedAtUnix;
    if (lan != null) result.lan = lan;
    return result;
  }

  NetworkInfo._();

  factory NetworkInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NetworkInfo()..mergeFromBuffer(data, registry);
  factory NetworkInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NetworkInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NetworkInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: NetworkInfo.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'localPort')
    ..pPM<NetworkEgress>(2, _omitFieldNames ? '' : 'egresses',
        subBuilder: NetworkEgress.$_createMessage)
    ..aI(3, _omitFieldNames ? '' : 'probed')
    ..aI(4, _omitFieldNames ? '' : 'answered')
    ..aInt64(5, _omitFieldNames ? '' : 'probedAtUnix')
    ..aOM<LanInfo>(6, _omitFieldNames ? '' : 'lan',
        subBuilder: LanInfo.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NetworkInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NetworkInfo copyWith(void Function(NetworkInfo) updates) =>
      super.copyWith((message) => updates(message as NetworkInfo))
          as NetworkInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use NetworkInfo() / NetworkInfo.new instead')
  static NetworkInfo create() => NetworkInfo._();
  static $pb.GeneratedMessage $_createMessage() => NetworkInfo._();
  @$core.override
  NetworkInfo createEmptyInstance() => NetworkInfo._();
  @$core.pragma('dart2js:noInline')
  static NetworkInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NetworkInfo>(
          NetworkInfo.$_createMessage);
  static NetworkInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get localPort => $_getIZ(0);
  @$pb.TagNumber(1)
  set localPort($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocalPort() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocalPort() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<NetworkEgress> get egresses => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get probed => $_getIZ(2);
  @$pb.TagNumber(3)
  set probed($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProbed() => $_has(2);
  @$pb.TagNumber(3)
  void clearProbed() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get answered => $_getIZ(3);
  @$pb.TagNumber(4)
  set answered($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAnswered() => $_has(3);
  @$pb.TagNumber(4)
  void clearAnswered() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get probedAtUnix => $_getI64(4);
  @$pb.TagNumber(5)
  set probedAtUnix($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProbedAtUnix() => $_has(4);
  @$pb.TagNumber(5)
  void clearProbedAtUnix() => $_clearField(5);

  @$pb.TagNumber(6)
  LanInfo get lan => $_getN(5);
  @$pb.TagNumber(6)
  set lan(LanInfo value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasLan() => $_has(5);
  @$pb.TagNumber(6)
  void clearLan() => $_clearField(6);
  @$pb.TagNumber(6)
  LanInfo ensureLan() => $_ensure(5);
}

/// 局域网直连的诊断信息，见 pasteferry-cli nat。
class LanInfo extends $pb.GeneratedMessage {
  factory LanInfo({
    $core.bool? enabled,
    $core.int? port,
    $core.Iterable<$core.String>? localAddresses,
    $core.int? discovered,
    $core.Iterable<LanPeer>? peers,
    $core.bool? blocked,
  }) {
    final result = LanInfo._();
    if (enabled != null) result.enabled = enabled;
    if (port != null) result.port = port;
    if (localAddresses != null) result.localAddresses.addAll(localAddresses);
    if (discovered != null) result.discovered = discovered;
    if (peers != null) result.peers.addAll(peers);
    if (blocked != null) result.blocked = blocked;
    return result;
  }

  LanInfo._();

  factory LanInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LanInfo()..mergeFromBuffer(data, registry);
  factory LanInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LanInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LanInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: LanInfo.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'enabled')
    ..aI(2, _omitFieldNames ? '' : 'port')
    ..pPS(3, _omitFieldNames ? '' : 'localAddresses')
    ..aI(4, _omitFieldNames ? '' : 'discovered')
    ..pPM<LanPeer>(5, _omitFieldNames ? '' : 'peers',
        subBuilder: LanPeer.$_createMessage)
    ..aOB(6, _omitFieldNames ? '' : 'blocked')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LanInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LanInfo copyWith(void Function(LanInfo) updates) =>
      super.copyWith((message) => updates(message as LanInfo)) as LanInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LanInfo() / LanInfo.new instead')
  static LanInfo create() => LanInfo._();
  static $pb.GeneratedMessage $_createMessage() => LanInfo._();
  @$core.override
  LanInfo createEmptyInstance() => LanInfo._();
  @$core.pragma('dart2js:noInline')
  static LanInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LanInfo>(LanInfo.$_createMessage);
  static LanInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get port => $_getIZ(1);
  @$pb.TagNumber(2)
  set port($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPort() => $_has(1);
  @$pb.TagNumber(2)
  void clearPort() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get localAddresses => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get discovered => $_getIZ(3);
  @$pb.TagNumber(4)
  set discovered($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDiscovered() => $_has(3);
  @$pb.TagNumber(4)
  void clearDiscovered() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<LanPeer> get peers => $_getList(4);

  @$pb.TagNumber(6)
  $core.bool get blocked => $_getBF(5);
  @$pb.TagNumber(6)
  set blocked($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBlocked() => $_has(5);
  @$pb.TagNumber(6)
  void clearBlocked() => $_clearField(6);
}

class LanPeer extends $pb.GeneratedMessage {
  factory LanPeer({
    $core.String? deviceId,
    $core.String? deviceName,
    $core.bool? reachable,
    $core.String? address,
    $core.Iterable<$core.String>? knownAddresses,
    $fixnum.Int64? lastSeenUnix,
  }) {
    final result = LanPeer._();
    if (deviceId != null) result.deviceId = deviceId;
    if (deviceName != null) result.deviceName = deviceName;
    if (reachable != null) result.reachable = reachable;
    if (address != null) result.address = address;
    if (knownAddresses != null) result.knownAddresses.addAll(knownAddresses);
    if (lastSeenUnix != null) result.lastSeenUnix = lastSeenUnix;
    return result;
  }

  LanPeer._();

  factory LanPeer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LanPeer()..mergeFromBuffer(data, registry);
  factory LanPeer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LanPeer()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LanPeer',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: LanPeer.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'deviceName')
    ..aOB(3, _omitFieldNames ? '' : 'reachable')
    ..aOS(4, _omitFieldNames ? '' : 'address')
    ..pPS(5, _omitFieldNames ? '' : 'knownAddresses')
    ..aInt64(6, _omitFieldNames ? '' : 'lastSeenUnix')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LanPeer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LanPeer copyWith(void Function(LanPeer) updates) =>
      super.copyWith((message) => updates(message as LanPeer)) as LanPeer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LanPeer() / LanPeer.new instead')
  static LanPeer create() => LanPeer._();
  static $pb.GeneratedMessage $_createMessage() => LanPeer._();
  @$core.override
  LanPeer createEmptyInstance() => LanPeer._();
  @$core.pragma('dart2js:noInline')
  static LanPeer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LanPeer>(LanPeer.$_createMessage);
  static LanPeer? _defaultInstance;

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
  $core.bool get reachable => $_getBF(2);
  @$pb.TagNumber(3)
  set reachable($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReachable() => $_has(2);
  @$pb.TagNumber(3)
  void clearReachable() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get address => $_getSZ(3);
  @$pb.TagNumber(4)
  set address($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAddress() => $_has(3);
  @$pb.TagNumber(4)
  void clearAddress() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get knownAddresses => $_getList(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get lastSeenUnix => $_getI64(5);
  @$pb.TagNumber(6)
  set lastSeenUnix($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLastSeenUnix() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastSeenUnix() => $_clearField(6);
}

class NetworkEgress extends $pb.GeneratedMessage {
  factory NetworkEgress({
    $core.String? address,
    $core.bool? portPreserved,
    $core.bool? guessed,
    $core.Iterable<$core.String>? via,
  }) {
    final result = NetworkEgress._();
    if (address != null) result.address = address;
    if (portPreserved != null) result.portPreserved = portPreserved;
    if (guessed != null) result.guessed = guessed;
    if (via != null) result.via.addAll(via);
    return result;
  }

  NetworkEgress._();

  factory NetworkEgress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NetworkEgress()..mergeFromBuffer(data, registry);
  factory NetworkEgress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      NetworkEgress()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NetworkEgress',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: NetworkEgress.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'address')
    ..aOB(2, _omitFieldNames ? '' : 'portPreserved')
    ..aOB(3, _omitFieldNames ? '' : 'guessed')
    ..pPS(4, _omitFieldNames ? '' : 'via')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NetworkEgress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NetworkEgress copyWith(void Function(NetworkEgress) updates) =>
      super.copyWith((message) => updates(message as NetworkEgress))
          as NetworkEgress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use NetworkEgress() / NetworkEgress.new instead')
  static NetworkEgress create() => NetworkEgress._();
  static $pb.GeneratedMessage $_createMessage() => NetworkEgress._();
  @$core.override
  NetworkEgress createEmptyInstance() => NetworkEgress._();
  @$core.pragma('dart2js:noInline')
  static NetworkEgress getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NetworkEgress>(
          NetworkEgress.$_createMessage);
  static NetworkEgress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get portPreserved => $_getBF(1);
  @$pb.TagNumber(2)
  set portPreserved($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPortPreserved() => $_has(1);
  @$pb.TagNumber(2)
  void clearPortPreserved() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get guessed => $_getBF(2);
  @$pb.TagNumber(3)
  set guessed($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGuessed() => $_has(2);
  @$pb.TagNumber(3)
  void clearGuessed() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get via => $_getList(3);
}

class Status extends $pb.GeneratedMessage {
  factory Status({
    $core.String? deviceId,
    $core.String? deviceName,
    $core.bool? signalingConnected,
    ClipboardPermission? clipboardPermission,
    $fixnum.Int64? cacheBytesUsed,
    $core.int? peersOnline,
    $core.String? version,
    $core.bool? serverConfigured,
    $core.bool? lanEnabled,
    $core.bool? lanBlocked,
    $fixnum.Int64? verboseLogUntilUnix,
    OfficialUsage? officialUsage,
    $core.String? updateAvailable,
    UpdateResult? lastUpdate,
  }) {
    final result = Status._();
    if (deviceId != null) result.deviceId = deviceId;
    if (deviceName != null) result.deviceName = deviceName;
    if (signalingConnected != null)
      result.signalingConnected = signalingConnected;
    if (clipboardPermission != null)
      result.clipboardPermission = clipboardPermission;
    if (cacheBytesUsed != null) result.cacheBytesUsed = cacheBytesUsed;
    if (peersOnline != null) result.peersOnline = peersOnline;
    if (version != null) result.version = version;
    if (serverConfigured != null) result.serverConfigured = serverConfigured;
    if (lanEnabled != null) result.lanEnabled = lanEnabled;
    if (lanBlocked != null) result.lanBlocked = lanBlocked;
    if (verboseLogUntilUnix != null)
      result.verboseLogUntilUnix = verboseLogUntilUnix;
    if (officialUsage != null) result.officialUsage = officialUsage;
    if (updateAvailable != null) result.updateAvailable = updateAvailable;
    if (lastUpdate != null) result.lastUpdate = lastUpdate;
    return result;
  }

  Status._();

  factory Status.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Status()..mergeFromBuffer(data, registry);
  factory Status.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Status()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Status',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: Status.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'deviceName')
    ..aOB(3, _omitFieldNames ? '' : 'signalingConnected')
    ..aE<ClipboardPermission>(4, _omitFieldNames ? '' : 'clipboardPermission',
        enumValues: ClipboardPermission.values)
    ..aInt64(5, _omitFieldNames ? '' : 'cacheBytesUsed')
    ..aI(6, _omitFieldNames ? '' : 'peersOnline')
    ..aOS(7, _omitFieldNames ? '' : 'version')
    ..aOB(8, _omitFieldNames ? '' : 'serverConfigured')
    ..aOB(9, _omitFieldNames ? '' : 'lanEnabled')
    ..aOB(10, _omitFieldNames ? '' : 'lanBlocked')
    ..aInt64(11, _omitFieldNames ? '' : 'verboseLogUntilUnix')
    ..aOM<OfficialUsage>(12, _omitFieldNames ? '' : 'officialUsage',
        subBuilder: OfficialUsage.$_createMessage)
    ..aOS(13, _omitFieldNames ? '' : 'updateAvailable')
    ..aOM<UpdateResult>(14, _omitFieldNames ? '' : 'lastUpdate',
        subBuilder: UpdateResult.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Status clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Status copyWith(void Function(Status) updates) =>
      super.copyWith((message) => updates(message as Status)) as Status;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Status() / Status.new instead')
  static Status create() => Status._();
  static $pb.GeneratedMessage $_createMessage() => Status._();
  @$core.override
  Status createEmptyInstance() => Status._();
  @$core.pragma('dart2js:noInline')
  static Status getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Status>(Status.$_createMessage);
  static Status? _defaultInstance;

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
  $core.bool get signalingConnected => $_getBF(2);
  @$pb.TagNumber(3)
  set signalingConnected($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSignalingConnected() => $_has(2);
  @$pb.TagNumber(3)
  void clearSignalingConnected() => $_clearField(3);

  @$pb.TagNumber(4)
  ClipboardPermission get clipboardPermission => $_getN(3);
  @$pb.TagNumber(4)
  set clipboardPermission(ClipboardPermission value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasClipboardPermission() => $_has(3);
  @$pb.TagNumber(4)
  void clearClipboardPermission() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get cacheBytesUsed => $_getI64(4);
  @$pb.TagNumber(5)
  set cacheBytesUsed($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCacheBytesUsed() => $_has(4);
  @$pb.TagNumber(5)
  void clearCacheBytesUsed() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get peersOnline => $_getIZ(5);
  @$pb.TagNumber(6)
  set peersOnline($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPeersOnline() => $_has(5);
  @$pb.TagNumber(6)
  void clearPeersOnline() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get version => $_getSZ(6);
  @$pb.TagNumber(7)
  set version($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVersion() => $_has(6);
  @$pb.TagNumber(7)
  void clearVersion() => $_clearField(7);

  /// 设置里填了服务器地址。没填时只在局域网里同步，不算异常。
  @$pb.TagNumber(8)
  $core.bool get serverConfigured => $_getBF(7);
  @$pb.TagNumber(8)
  set serverConfigured($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasServerConfigured() => $_has(7);
  @$pb.TagNumber(8)
  void clearServerConfigured() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get lanEnabled => $_getBF(8);
  @$pb.TagNumber(9)
  set lanEnabled($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLanEnabled() => $_has(8);
  @$pb.TagNumber(9)
  void clearLanEnabled() => $_clearField(9);

  /// 系统拦下了本机发往局域网的包：macOS 上是没允许「本地网络」权限
  @$pb.TagNumber(10)
  $core.bool get lanBlocked => $_getBF(9);
  @$pb.TagNumber(10)
  set lanBlocked($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasLanBlocked() => $_has(9);
  @$pb.TagNumber(10)
  void clearLanBlocked() => $_clearField(10);

  /// 详细日志打开到什么时候；0 表示没打开
  @$pb.TagNumber(11)
  $fixnum.Int64 get verboseLogUntilUnix => $_getI64(10);
  @$pb.TagNumber(11)
  set verboseLogUntilUnix($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasVerboseLogUntilUnix() => $_has(10);
  @$pb.TagNumber(11)
  void clearVerboseLogUntilUnix() => $_clearField(11);

  @$pb.TagNumber(12)
  OfficialUsage get officialUsage => $_getN(11);
  @$pb.TagNumber(12)
  set officialUsage(OfficialUsage value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasOfficialUsage() => $_has(11);
  @$pb.TagNumber(12)
  void clearOfficialUsage() => $_clearField(12);
  @$pb.TagNumber(12)
  OfficialUsage ensureOfficialUsage() => $_ensure(11);

  /// 自动检查发现的新版本（没被跳过）；空表示没有要提示的
  @$pb.TagNumber(13)
  $core.String get updateAvailable => $_getSZ(12);
  @$pb.TagNumber(13)
  set updateAvailable($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasUpdateAvailable() => $_has(12);
  @$pb.TagNumber(13)
  void clearUpdateAvailable() => $_clearField(13);

  /// 刚完成的一次自动更新，界面据此提示「已更新到 X」；过一会儿就不再带
  @$pb.TagNumber(14)
  UpdateResult get lastUpdate => $_getN(13);
  @$pb.TagNumber(14)
  set lastUpdate(UpdateResult value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasLastUpdate() => $_has(13);
  @$pb.TagNumber(14)
  void clearLastUpdate() => $_clearField(14);
  @$pb.TagNumber(14)
  UpdateResult ensureLastUpdate() => $_ensure(13);
}

class CheckForUpdateRequest extends $pb.GeneratedMessage {
  factory CheckForUpdateRequest({
    $core.String? language,
  }) {
    final result = CheckForUpdateRequest._();
    if (language != null) result.language = language;
    return result;
  }

  CheckForUpdateRequest._();

  factory CheckForUpdateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CheckForUpdateRequest()..mergeFromBuffer(data, registry);
  factory CheckForUpdateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CheckForUpdateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckForUpdateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: CheckForUpdateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'language')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckForUpdateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckForUpdateRequest copyWith(
          void Function(CheckForUpdateRequest) updates) =>
      super.copyWith((message) => updates(message as CheckForUpdateRequest))
          as CheckForUpdateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CheckForUpdateRequest() / CheckForUpdateRequest.new instead')
  static CheckForUpdateRequest create() => CheckForUpdateRequest._();
  static $pb.GeneratedMessage $_createMessage() => CheckForUpdateRequest._();
  @$core.override
  CheckForUpdateRequest createEmptyInstance() => CheckForUpdateRequest._();
  @$core.pragma('dart2js:noInline')
  static CheckForUpdateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckForUpdateRequest>(
          CheckForUpdateRequest.$_createMessage);
  static CheckForUpdateRequest? _defaultInstance;

  /// 界面语言，用来挑更新日志："en"、"zh-Hans"、"zh-Hant-TW"、"zh-Hant-HK"、"ja"
  @$pb.TagNumber(1)
  $core.String get language => $_getSZ(0);
  @$pb.TagNumber(1)
  set language($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLanguage() => $_has(0);
  @$pb.TagNumber(1)
  void clearLanguage() => $_clearField(1);
}

class UpdateRelease extends $pb.GeneratedMessage {
  factory UpdateRelease({
    $core.String? version,
    $core.String? date,
    $core.Iterable<$core.String>? changes,
    $core.Iterable<$core.String>? fixes,
  }) {
    final result = UpdateRelease._();
    if (version != null) result.version = version;
    if (date != null) result.date = date;
    if (changes != null) result.changes.addAll(changes);
    if (fixes != null) result.fixes.addAll(fixes);
    return result;
  }

  UpdateRelease._();

  factory UpdateRelease.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateRelease()..mergeFromBuffer(data, registry);
  factory UpdateRelease.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateRelease()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateRelease',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: UpdateRelease.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'date')
    ..pPS(3, _omitFieldNames ? '' : 'changes')
    ..pPS(4, _omitFieldNames ? '' : 'fixes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRelease clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRelease copyWith(void Function(UpdateRelease) updates) =>
      super.copyWith((message) => updates(message as UpdateRelease))
          as UpdateRelease;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UpdateRelease() / UpdateRelease.new instead')
  static UpdateRelease create() => UpdateRelease._();
  static $pb.GeneratedMessage $_createMessage() => UpdateRelease._();
  @$core.override
  UpdateRelease createEmptyInstance() => UpdateRelease._();
  @$core.pragma('dart2js:noInline')
  static UpdateRelease getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateRelease>(
          UpdateRelease.$_createMessage);
  static UpdateRelease? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get date => $_getSZ(1);
  @$pb.TagNumber(2)
  set date($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearDate() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get changes => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get fixes => $_getList(3);
}

class UpdateInfo extends $pb.GeneratedMessage {
  factory UpdateInfo({
    $core.String? currentVersion,
    $core.String? latestVersion,
    $core.bool? available,
    $core.Iterable<UpdateRelease>? releases,
    $fixnum.Int64? downloadBytes,
    $core.String? installBlocker,
    $core.String? source,
    $fixnum.Int64? checkedAtUnix,
    $core.String? installKind,
  }) {
    final result = UpdateInfo._();
    if (currentVersion != null) result.currentVersion = currentVersion;
    if (latestVersion != null) result.latestVersion = latestVersion;
    if (available != null) result.available = available;
    if (releases != null) result.releases.addAll(releases);
    if (downloadBytes != null) result.downloadBytes = downloadBytes;
    if (installBlocker != null) result.installBlocker = installBlocker;
    if (source != null) result.source = source;
    if (checkedAtUnix != null) result.checkedAtUnix = checkedAtUnix;
    if (installKind != null) result.installKind = installKind;
    return result;
  }

  UpdateInfo._();

  factory UpdateInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateInfo()..mergeFromBuffer(data, registry);
  factory UpdateInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateInfo()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: UpdateInfo.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'currentVersion')
    ..aOS(2, _omitFieldNames ? '' : 'latestVersion')
    ..aOB(3, _omitFieldNames ? '' : 'available')
    ..pPM<UpdateRelease>(4, _omitFieldNames ? '' : 'releases',
        subBuilder: UpdateRelease.$_createMessage)
    ..aInt64(5, _omitFieldNames ? '' : 'downloadBytes')
    ..aOS(6, _omitFieldNames ? '' : 'installBlocker')
    ..aOS(7, _omitFieldNames ? '' : 'source')
    ..aInt64(8, _omitFieldNames ? '' : 'checkedAtUnix')
    ..aOS(9, _omitFieldNames ? '' : 'installKind')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateInfo copyWith(void Function(UpdateInfo) updates) =>
      super.copyWith((message) => updates(message as UpdateInfo)) as UpdateInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UpdateInfo() / UpdateInfo.new instead')
  static UpdateInfo create() => UpdateInfo._();
  static $pb.GeneratedMessage $_createMessage() => UpdateInfo._();
  @$core.override
  UpdateInfo createEmptyInstance() => UpdateInfo._();
  @$core.pragma('dart2js:noInline')
  static UpdateInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateInfo>(UpdateInfo.$_createMessage);
  static UpdateInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get currentVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set currentVersion($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrentVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get latestVersion => $_getSZ(1);
  @$pb.TagNumber(2)
  set latestVersion($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLatestVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearLatestVersion() => $_clearField(2);

  /// latest_version 比当前新
  @$pb.TagNumber(3)
  $core.bool get available => $_getBF(2);
  @$pb.TagNumber(3)
  set available($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAvailable() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvailable() => $_clearField(3);

  /// 比当前新的各版更新日志，从新到旧，已按语言挑好
  @$pb.TagNumber(4)
  $pb.PbList<UpdateRelease> get releases => $_getList(3);

  /// 这台电脑要下载的安装包大小
  @$pb.TagNumber(5)
  $fixnum.Int64 get downloadBytes => $_getI64(4);
  @$pb.TagNumber(5)
  set downloadBytes($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDownloadBytes() => $_has(4);
  @$pb.TagNumber(5)
  void clearDownloadBytes() => $_clearField(5);

  /// 为空表示可以自动安装；否则是不能的原因：dev、must_move、read_only、unsupported
  @$pb.TagNumber(6)
  $core.String get installBlocker => $_getSZ(5);
  @$pb.TagNumber(6)
  set installBlocker($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasInstallBlocker() => $_has(5);
  @$pb.TagNumber(6)
  void clearInstallBlocker() => $_clearField(6);

  /// 清单来自哪里：github 或 gitee
  @$pb.TagNumber(7)
  $core.String get source => $_getSZ(6);
  @$pb.TagNumber(7)
  set source($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSource() => $_has(6);
  @$pb.TagNumber(7)
  void clearSource() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get checkedAtUnix => $_getI64(7);
  @$pb.TagNumber(8)
  set checkedAtUnix($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCheckedAtUnix() => $_has(7);
  @$pb.TagNumber(8)
  void clearCheckedAtUnix() => $_clearField(8);

  /// 本机的安装方式：mac-app、windows-setup、windows-portable、linux-deb、linux-tar。
  /// linux-deb 安装时系统会要求输入密码，界面提前说明
  @$pb.TagNumber(9)
  $core.String get installKind => $_getSZ(8);
  @$pb.TagNumber(9)
  set installKind($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasInstallKind() => $_has(8);
  @$pb.TagNumber(9)
  void clearInstallKind() => $_clearField(9);
}

class DownloadUpdateRequest extends $pb.GeneratedMessage {
  factory DownloadUpdateRequest({
    $core.String? version,
  }) {
    final result = DownloadUpdateRequest._();
    if (version != null) result.version = version;
    return result;
  }

  DownloadUpdateRequest._();

  factory DownloadUpdateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DownloadUpdateRequest()..mergeFromBuffer(data, registry);
  factory DownloadUpdateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DownloadUpdateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DownloadUpdateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: DownloadUpdateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadUpdateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadUpdateRequest copyWith(
          void Function(DownloadUpdateRequest) updates) =>
      super.copyWith((message) => updates(message as DownloadUpdateRequest))
          as DownloadUpdateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DownloadUpdateRequest() / DownloadUpdateRequest.new instead')
  static DownloadUpdateRequest create() => DownloadUpdateRequest._();
  static $pb.GeneratedMessage $_createMessage() => DownloadUpdateRequest._();
  @$core.override
  DownloadUpdateRequest createEmptyInstance() => DownloadUpdateRequest._();
  @$core.pragma('dart2js:noInline')
  static DownloadUpdateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DownloadUpdateRequest>(
          DownloadUpdateRequest.$_createMessage);
  static DownloadUpdateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);
}

class UpdateProgress extends $pb.GeneratedMessage {
  factory UpdateProgress({
    $fixnum.Int64? downloaded,
    $fixnum.Int64? total,
    $core.bool? done,
  }) {
    final result = UpdateProgress._();
    if (downloaded != null) result.downloaded = downloaded;
    if (total != null) result.total = total;
    if (done != null) result.done = done;
    return result;
  }

  UpdateProgress._();

  factory UpdateProgress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateProgress()..mergeFromBuffer(data, registry);
  factory UpdateProgress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateProgress()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateProgress',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: UpdateProgress.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'downloaded')
    ..aInt64(2, _omitFieldNames ? '' : 'total')
    ..aOB(3, _omitFieldNames ? '' : 'done')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProgress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateProgress copyWith(void Function(UpdateProgress) updates) =>
      super.copyWith((message) => updates(message as UpdateProgress))
          as UpdateProgress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UpdateProgress() / UpdateProgress.new instead')
  static UpdateProgress create() => UpdateProgress._();
  static $pb.GeneratedMessage $_createMessage() => UpdateProgress._();
  @$core.override
  UpdateProgress createEmptyInstance() => UpdateProgress._();
  @$core.pragma('dart2js:noInline')
  static UpdateProgress getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateProgress>(
          UpdateProgress.$_createMessage);
  static UpdateProgress? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get downloaded => $_getI64(0);
  @$pb.TagNumber(1)
  set downloaded($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDownloaded() => $_has(0);
  @$pb.TagNumber(1)
  void clearDownloaded() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get total => $_getI64(1);
  @$pb.TagNumber(2)
  set total($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);

  /// 下载完并通过校验
  @$pb.TagNumber(3)
  $core.bool get done => $_getBF(2);
  @$pb.TagNumber(3)
  set done($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDone() => $_has(2);
  @$pb.TagNumber(3)
  void clearDone() => $_clearField(3);
}

class InstallUpdateRequest extends $pb.GeneratedMessage {
  factory InstallUpdateRequest({
    $core.String? version,
    $core.int? uiPid,
  }) {
    final result = InstallUpdateRequest._();
    if (version != null) result.version = version;
    if (uiPid != null) result.uiPid = uiPid;
    return result;
  }

  InstallUpdateRequest._();

  factory InstallUpdateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InstallUpdateRequest()..mergeFromBuffer(data, registry);
  factory InstallUpdateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InstallUpdateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InstallUpdateRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: InstallUpdateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aI(2, _omitFieldNames ? '' : 'uiPid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InstallUpdateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InstallUpdateRequest copyWith(void Function(InstallUpdateRequest) updates) =>
      super.copyWith((message) => updates(message as InstallUpdateRequest))
          as InstallUpdateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use InstallUpdateRequest() / InstallUpdateRequest.new instead')
  static InstallUpdateRequest create() => InstallUpdateRequest._();
  static $pb.GeneratedMessage $_createMessage() => InstallUpdateRequest._();
  @$core.override
  InstallUpdateRequest createEmptyInstance() => InstallUpdateRequest._();
  @$core.pragma('dart2js:noInline')
  static InstallUpdateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InstallUpdateRequest>(
          InstallUpdateRequest.$_createMessage);
  static InstallUpdateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  /// 界面的进程号：更新助手等它退出后再替换文件
  @$pb.TagNumber(2)
  $core.int get uiPid => $_getIZ(1);
  @$pb.TagNumber(2)
  set uiPid($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUiPid() => $_has(1);
  @$pb.TagNumber(2)
  void clearUiPid() => $_clearField(2);
}

class UpdateResult extends $pb.GeneratedMessage {
  factory UpdateResult({
    $core.String? fromVersion,
    $core.String? toVersion,
    $core.bool? ok,
    $core.String? error,
    $fixnum.Int64? atUnix,
  }) {
    final result = UpdateResult._();
    if (fromVersion != null) result.fromVersion = fromVersion;
    if (toVersion != null) result.toVersion = toVersion;
    if (ok != null) result.ok = ok;
    if (error != null) result.error = error;
    if (atUnix != null) result.atUnix = atUnix;
    return result;
  }

  UpdateResult._();

  factory UpdateResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateResult()..mergeFromBuffer(data, registry);
  factory UpdateResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateResult()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: UpdateResult.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'fromVersion')
    ..aOS(2, _omitFieldNames ? '' : 'toVersion')
    ..aOB(3, _omitFieldNames ? '' : 'ok')
    ..aOS(4, _omitFieldNames ? '' : 'error')
    ..aInt64(5, _omitFieldNames ? '' : 'atUnix')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateResult copyWith(void Function(UpdateResult) updates) =>
      super.copyWith((message) => updates(message as UpdateResult))
          as UpdateResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UpdateResult() / UpdateResult.new instead')
  static UpdateResult create() => UpdateResult._();
  static $pb.GeneratedMessage $_createMessage() => UpdateResult._();
  @$core.override
  UpdateResult createEmptyInstance() => UpdateResult._();
  @$core.pragma('dart2js:noInline')
  static UpdateResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateResult>(
          UpdateResult.$_createMessage);
  static UpdateResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fromVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set fromVersion($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFromVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toVersion => $_getSZ(1);
  @$pb.TagNumber(2)
  set toVersion($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearToVersion() => $_clearField(2);

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
  $fixnum.Int64 get atUnix => $_getI64(4);
  @$pb.TagNumber(5)
  set atUnix($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAtUnix() => $_has(4);
  @$pb.TagNumber(5)
  void clearAtUnix() => $_clearField(5);
}

class ExportDiagnosticsRequest extends $pb.GeneratedMessage {
  factory ExportDiagnosticsRequest({
    $core.int? logLines,
    $core.String? uiVersion,
  }) {
    final result = ExportDiagnosticsRequest._();
    if (logLines != null) result.logLines = logLines;
    if (uiVersion != null) result.uiVersion = uiVersion;
    return result;
  }

  ExportDiagnosticsRequest._();

  factory ExportDiagnosticsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExportDiagnosticsRequest()..mergeFromBuffer(data, registry);
  factory ExportDiagnosticsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExportDiagnosticsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExportDiagnosticsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: ExportDiagnosticsRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'logLines')
    ..aOS(2, _omitFieldNames ? '' : 'uiVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportDiagnosticsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportDiagnosticsRequest copyWith(
          void Function(ExportDiagnosticsRequest) updates) =>
      super.copyWith((message) => updates(message as ExportDiagnosticsRequest))
          as ExportDiagnosticsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExportDiagnosticsRequest() / ExportDiagnosticsRequest.new instead')
  static ExportDiagnosticsRequest create() => ExportDiagnosticsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ExportDiagnosticsRequest._();
  @$core.override
  ExportDiagnosticsRequest createEmptyInstance() =>
      ExportDiagnosticsRequest._();
  @$core.pragma('dart2js:noInline')
  static ExportDiagnosticsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExportDiagnosticsRequest>(
          ExportDiagnosticsRequest.$_createMessage);
  static ExportDiagnosticsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get logLines => $_getIZ(0);
  @$pb.TagNumber(1)
  set logLines($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLogLines() => $_has(0);
  @$pb.TagNumber(1)
  void clearLogLines() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get uiVersion => $_getSZ(1);
  @$pb.TagNumber(2)
  set uiVersion($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUiVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearUiVersion() => $_clearField(2);
}

class Diagnostics extends $pb.GeneratedMessage {
  factory Diagnostics({
    $core.String? report,
  }) {
    final result = Diagnostics._();
    if (report != null) result.report = report;
    return result;
  }

  Diagnostics._();

  factory Diagnostics.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Diagnostics()..mergeFromBuffer(data, registry);
  factory Diagnostics.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Diagnostics()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Diagnostics',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: Diagnostics.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'report')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Diagnostics clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Diagnostics copyWith(void Function(Diagnostics) updates) =>
      super.copyWith((message) => updates(message as Diagnostics))
          as Diagnostics;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Diagnostics() / Diagnostics.new instead')
  static Diagnostics create() => Diagnostics._();
  static $pb.GeneratedMessage $_createMessage() => Diagnostics._();
  @$core.override
  Diagnostics createEmptyInstance() => Diagnostics._();
  @$core.pragma('dart2js:noInline')
  static Diagnostics getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Diagnostics>(
          Diagnostics.$_createMessage);
  static Diagnostics? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get report => $_getSZ(0);
  @$pb.TagNumber(1)
  set report($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReport() => $_has(0);
  @$pb.TagNumber(1)
  void clearReport() => $_clearField(1);
}

class SetVerboseLogRequest extends $pb.GeneratedMessage {
  factory SetVerboseLogRequest({
    $core.int? minutes,
  }) {
    final result = SetVerboseLogRequest._();
    if (minutes != null) result.minutes = minutes;
    return result;
  }

  SetVerboseLogRequest._();

  factory SetVerboseLogRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetVerboseLogRequest()..mergeFromBuffer(data, registry);
  factory SetVerboseLogRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetVerboseLogRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetVerboseLogRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: SetVerboseLogRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'minutes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetVerboseLogRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetVerboseLogRequest copyWith(void Function(SetVerboseLogRequest) updates) =>
      super.copyWith((message) => updates(message as SetVerboseLogRequest))
          as SetVerboseLogRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetVerboseLogRequest() / SetVerboseLogRequest.new instead')
  static SetVerboseLogRequest create() => SetVerboseLogRequest._();
  static $pb.GeneratedMessage $_createMessage() => SetVerboseLogRequest._();
  @$core.override
  SetVerboseLogRequest createEmptyInstance() => SetVerboseLogRequest._();
  @$core.pragma('dart2js:noInline')
  static SetVerboseLogRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetVerboseLogRequest>(
          SetVerboseLogRequest.$_createMessage);
  static SetVerboseLogRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get minutes => $_getIZ(0);
  @$pb.TagNumber(1)
  set minutes($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMinutes() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinutes() => $_clearField(1);
}

class GetImagePreviewRequest extends $pb.GeneratedMessage {
  factory GetImagePreviewRequest({
    $core.String? clipId,
    $core.int? index,
  }) {
    final result = GetImagePreviewRequest._();
    if (clipId != null) result.clipId = clipId;
    if (index != null) result.index = index;
    return result;
  }

  GetImagePreviewRequest._();

  factory GetImagePreviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetImagePreviewRequest()..mergeFromBuffer(data, registry);
  factory GetImagePreviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetImagePreviewRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetImagePreviewRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: GetImagePreviewRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'clipId')
    ..aI(2, _omitFieldNames ? '' : 'index')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetImagePreviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetImagePreviewRequest copyWith(
          void Function(GetImagePreviewRequest) updates) =>
      super.copyWith((message) => updates(message as GetImagePreviewRequest))
          as GetImagePreviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetImagePreviewRequest() / GetImagePreviewRequest.new instead')
  static GetImagePreviewRequest create() => GetImagePreviewRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetImagePreviewRequest._();
  @$core.override
  GetImagePreviewRequest createEmptyInstance() => GetImagePreviewRequest._();
  @$core.pragma('dart2js:noInline')
  static GetImagePreviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetImagePreviewRequest>(
          GetImagePreviewRequest.$_createMessage);
  static GetImagePreviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClipId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get index => $_getIZ(1);
  @$pb.TagNumber(2)
  set index($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIndex() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndex() => $_clearField(2);
}

class GetImagePreviewResponse extends $pb.GeneratedMessage {
  factory GetImagePreviewResponse({
    $core.String? path,
    $core.int? count,
    $core.String? name,
  }) {
    final result = GetImagePreviewResponse._();
    if (path != null) result.path = path;
    if (count != null) result.count = count;
    if (name != null) result.name = name;
    return result;
  }

  GetImagePreviewResponse._();

  factory GetImagePreviewResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetImagePreviewResponse()..mergeFromBuffer(data, registry);
  factory GetImagePreviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetImagePreviewResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetImagePreviewResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pasteferry.v1'),
      createEmptyInstance: GetImagePreviewResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aI(2, _omitFieldNames ? '' : 'count')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetImagePreviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetImagePreviewResponse copyWith(
          void Function(GetImagePreviewResponse) updates) =>
      super.copyWith((message) => updates(message as GetImagePreviewResponse))
          as GetImagePreviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetImagePreviewResponse() / GetImagePreviewResponse.new instead')
  static GetImagePreviewResponse create() => GetImagePreviewResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetImagePreviewResponse._();
  @$core.override
  GetImagePreviewResponse createEmptyInstance() => GetImagePreviewResponse._();
  @$core.pragma('dart2js:noInline')
  static GetImagePreviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetImagePreviewResponse>(
          GetImagePreviewResponse.$_createMessage);
  static GetImagePreviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get count => $_getIZ(1);
  @$pb.TagNumber(2)
  set count($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
