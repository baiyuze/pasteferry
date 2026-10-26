import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../app_state.dart';
import '../i18n.dart';
import '../main.dart';
import '../theme.dart';
import 'common.dart';

// 头像：好友看到的本机头像、好友的头像，见 design/friends-send.md 第 4.4 节。
// 没有设置头像时是圆形色块加名字的第一个字，颜色由设备 ID 算出，固定不变。

/// 默认头像的颜色：柔和、在亮暗两种外观下都看得清白字
const _avatarColors = [
  Color(0xFF5B8DEF),
  Color(0xFF4FA88A),
  Color(0xFFD98B4B),
  Color(0xFFA77BD3),
  Color(0xFFD9707A),
  Color(0xFF4FA3B5),
  Color(0xFF7D8590),
];

Color avatarColor(String seed) {
  var h = 0;
  for (final c in seed.codeUnits) {
    h = (h * 31 + c) & 0x7fffffff;
  }
  return _avatarColors[h % _avatarColors.length];
}

/// 名字的第一个字；英文取首字母大写
String avatarInitial(String name) {
  final t = name.trim();
  if (t.isEmpty) return '?';
  final first = String.fromCharCodes(t.runes.take(1));
  return first.toUpperCase();
}

/// 圆形头像。[deviceId] 为空字符串表示本机；[hash] 为空表示用默认头像。
/// [dashed] 是「所有人」模式下的陌生设备：虚线圈、不显示图片。
class PersonAvatar extends StatelessWidget {
  const PersonAvatar({
    super.key,
    required this.deviceId,
    required this.name,
    this.hash = const [],
    this.size = 40,
    this.dashed = false,
  });

  final String deviceId;
  final String name;
  final List<int> hash;
  final double size;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = context.palette;
    final image = dashed ? null : state.avatarOf(deviceId, hash);
    if (dashed) {
      return CustomPaint(
        painter: _DashedCircle(color: p.textFaint),
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Text(
              avatarInitial(name),
              style: TextStyle(fontSize: size * 0.42, fontWeight: FontWeight.w600, color: p.textDim, height: 1),
            ),
          ),
        ),
      );
    }
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: image != null
            ? Image.memory(image, fit: BoxFit.cover, gaplessPlayback: true)
            : ColoredBox(
                color: avatarColor(deviceId.isEmpty ? (state.self?.id ?? name) : deviceId),
                child: Center(
                  child: Text(
                    avatarInitial(name),
                    style: TextStyle(
                      fontSize: size * 0.42,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _DashedCircle extends CustomPainter {
  _DashedCircle({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final r = size.width / 2 - 1;
    final c = size.center(Offset.zero);
    const n = 18;
    for (var i = 0; i < n; i++) {
      final a = i * 2 * math.pi / n;
      canvas.drawArc(Rect.fromCircle(center: c, radius: r), a, math.pi / n, false, paint);
    }
  }

  @override
  bool shouldRepaint(_DashedCircle old) => old.color != color;
}

/// 本机的头像：点一下弹出菜单（选择图片、粘贴图片、恢复默认），也可以把图片拖上来。
class SelfAvatarButton extends StatefulWidget {
  const SelfAvatarButton({super.key, this.size = 40});

  final double size;

  @override
  State<SelfAvatarButton> createState() => _SelfAvatarButtonState();
}

class _SelfAvatarButtonState extends State<SelfAvatarButton> {
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final profile = state.profile;
    final avatar = PersonAvatar(
      deviceId: '',
      name: profile?.displayName ?? state.self?.name ?? '',
      hash: profile?.avatarHash ?? const [],
      size: widget.size,
    );
    return DropTarget(
      onDragEntered: (_) => setState(() => _dragging = true),
      onDragExited: (_) => setState(() => _dragging = false),
      onDragDone: (d) {
        setState(() => _dragging = false);
        final path = d.files.where((f) => f.path.isNotEmpty).firstOrNull?.path;
        if (path != null) editAvatarFromFile(context, path);
      },
      child: PopupMenuButton<String>(
        tooltip: l.avatarTitle,
        position: PopupMenuPosition.under,
        onSelected: (v) => switch (v) {
          'choose' => chooseAvatar(context),
          'paste' => pasteAvatar(context),
          _ => _reset(context),
        },
        itemBuilder: (_) => [
          PopupMenuItem(value: 'choose', height: 34, child: Text(l.avatarChoose)),
          PopupMenuItem(value: 'paste', height: 34, child: Text(l.avatarPaste)),
          if (profile?.hasAvatar ?? false) ...[
            const PopupMenuDivider(height: 9),
            PopupMenuItem(value: 'reset', height: 34, child: Text(l.avatarReset)),
          ],
        ],
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _dragging ? context.palette.accent : Colors.transparent, width: 2),
          ),
          child: avatar,
        ),
      ),
    );
  }

  Future<void> _reset(BuildContext context) async {
    try {
      await AppScope.read(context).resetAvatar();
    } catch (e) {
      if (context.mounted) showToast(context, AppState.describeError(e), error: true);
    }
  }
}

Future<void> chooseAvatar(BuildContext context) async {
  final file = await openFile(acceptedTypeGroups: [
    const XTypeGroup(label: 'images', extensions: ['png', 'jpg', 'jpeg', 'gif', 'heic', 'heif', 'webp', 'bmp']),
  ]);
  if (file == null || !context.mounted) return;
  await editAvatarFromFile(context, file.path);
}

Future<void> pasteAvatar(BuildContext context) async {
  final l = context.l10n;
  try {
    final r = await AppScope.read(context).pasteFiles();
    if (!context.mounted) return;
    if (r.paths.isEmpty) {
      showToast(context, l.avatarNoImage, error: true);
      return;
    }
    await editAvatarFromFile(context, r.paths.first);
  } catch (_) {
    if (context.mounted) showToast(context, l.avatarNoImage, error: true);
  }
}

/// 读出图片后弹出裁剪窗口；界面解不了的格式（HEIC 等）交给后台服务，取中间的正方形
Future<void> editAvatarFromFile(BuildContext context, String path) async {
  final l = context.l10n;
  final state = AppScope.read(context);
  Uint8List? bytes;
  ui.Image? decoded;
  try {
    final f = File(path);
    if (await f.length() <= 64 << 20) bytes = await f.readAsBytes();
    if (bytes != null) decoded = await decodeImageFromList(bytes);
  } catch (_) {
    decoded = null;
  }
  if (!context.mounted) return;
  try {
    if (decoded == null || bytes == null) {
      await state.setAvatar(path: path);
      return;
    }
    final crop = await showDialog<Rect>(
      context: context,
      builder: (_) => _CropDialog(bytes: bytes!, width: decoded!.width, height: decoded.height),
    );
    if (crop == null) return;
    await state.setAvatar(path: path, x: crop.left, y: crop.top, size: crop.width);
  } catch (_) {
    if (context.mounted) showToast(context, l.avatarBad, error: true);
  }
}

/// 裁剪：方形取景框，可以拖动、缩放，旁边是圆形的预览。返回裁剪区域（按原图比例：left、top 是位置，width 是边长占长边的比例）
class _CropDialog extends StatefulWidget {
  const _CropDialog({required this.bytes, required this.width, required this.height});

  final Uint8List bytes;
  final int width, height;

  @override
  State<_CropDialog> createState() => _CropDialogState();
}

class _CropDialogState extends State<_CropDialog> {
  static const _view = 240.0;
  double _zoom = 1;
  Offset _offset = Offset.zero; // 图片左上角相对取景框的位置

  double get _scale => _view / math.min(widget.width, widget.height) * _zoom;

  void _clamp() {
    final w = widget.width * _scale, h = widget.height * _scale;
    _offset = Offset(_offset.dx.clamp(_view - w, 0), _offset.dy.clamp(_view - h, 0));
  }

  @override
  void initState() {
    super.initState();
    // 一开始居中
    final w = widget.width * _scale, h = widget.height * _scale;
    _offset = Offset((_view - w) / 2, (_view - h) / 2);
  }

  Rect get _crop {
    final side = _view / _scale;
    final x = -_offset.dx / _scale, y = -_offset.dy / _scale;
    return Rect.fromLTWH(x / widget.width, y / widget.height, side / math.max(widget.width, widget.height), 0);
  }

  Widget _image(double viewSize) {
    final k = viewSize / _view;
    return ClipRect(
      child: SizedBox(
        width: viewSize,
        height: viewSize,
        child: Stack(
          children: [
            Positioned(
              left: _offset.dx * k,
              top: _offset.dy * k,
              width: widget.width * _scale * k,
              height: widget.height * _scale * k,
              child: Image.memory(widget.bytes, fit: BoxFit.fill, gaplessPlayback: true),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    return AlertDialog(
      title: Text(l.avatarTitle),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onPanUpdate: (d) => setState(() {
                  _offset += d.delta;
                  _clamp();
                }),
                child: MouseRegion(
                  cursor: SystemMouseCursors.grab,
                  child: DecoratedBox(
                    decoration: BoxDecoration(border: Border.all(color: p.border)),
                    child: _image(_view),
                  ),
                ),
              ),
              const SizedBox(height: Insets.sm),
              Text(l.avatarDragHint, style: context.text.bodySmall),
              SizedBox(
                width: _view,
                child: Row(
                  children: [
                    Text(l.avatarZoom, style: context.text.bodySmall),
                    Expanded(
                      child: Slider(
                        value: _zoom,
                        min: 1,
                        max: 4,
                        onChanged: (v) => setState(() {
                          // 以取景框中心为准缩放
                          final c = const Offset(_view / 2, _view / 2);
                          final before = _scale;
                          _zoom = v;
                          _offset = c - (c - _offset) * (_scale / before);
                          _clamp();
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: Insets.xl),
          Padding(
            padding: const EdgeInsets.only(top: Insets.xl),
            child: ClipOval(child: _image(96)),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(
          onPressed: () {
            final c = _crop;
            Navigator.pop(context, Rect.fromLTWH(c.left, c.top, c.width, c.width));
          },
          child: Text(l.done),
        ),
      ],
    );
  }
}
