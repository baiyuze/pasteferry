import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../app_state.dart';
import '../gen/pasteferry/v1/daemon.pb.dart';
import '../i18n.dart';
import '../main.dart';
import '../platform.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/send_dialog.dart' show revealLabel;

/// 设置页里的「隔空传送」一组：接不接收、存到哪里、收到时通知。见 design/send-files.md 第 3 节。
class SendSection extends StatefulWidget {
  const SendSection({super.key, required this.config, required this.onUpdate});

  final Config config;
  final Future<void> Function(Config next) onUpdate;

  @override
  State<SendSection> createState() => _SendSectionState();
}

class _SendSectionState extends State<SendSection> {
  /// 选好的保存位置不能用时的说明
  String? _dirError;

  Future<void> _choose() async {
    final l = context.l10n;
    final state = AppScope.read(context);
    final dir = await getDirectoryPath(initialDirectory: _current(widget.config));
    if (dir == null || !mounted) return;
    try {
      // 先试写一次：不能写入的位置不保存。macOS 上系统的文件夹授权也在这时弹出
      final r = await state.checkReceiveDir(dir);
      if (!mounted) return;
      if (!r.ok) {
        setState(() => _dirError = switch (r.error) {
              'not_found' => l.saveDirNotFound,
              'permission_denied' => l.saveDirPermission,
              _ => l.saveDirNotWritable,
            });
        return;
      }
      setState(() => _dirError = null);
      await widget.onUpdate(widget.config.deepCopy()..receiveDir = dir);
    } catch (e) {
      if (mounted) showToast(context, AppState.describeError(e), error: true);
    }
  }

  /// 现在的保存位置；没设置时是系统的「下载」文件夹
  static String _current(Config c) => c.receiveDir.isNotEmpty ? c.receiveDir : downloadsDir();

  /// 用户目录写成 ~，路径短一些
  static String _short(String path) {
    final home = Platform.environment[Platform.isWindows ? 'USERPROFILE' : 'HOME'];
    if (home != null && home.isNotEmpty && path.startsWith(home)) return '~${path.substring(home.length)}';
    return path;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cfg = widget.config;
    final custom = cfg.receiveDir.isNotEmpty;
    final p = context.palette;
    return GroupSection(
      title: l.navSend,
      footnote: l.receiveFootnote(Wording.thisDeviceInText),
      child: GroupBox(
        children: [
          SettingRow(
            title: l.receiveFiles,
            child: SmallSwitch(
              value: !cfg.receiveDisabled,
              onChanged: (v) => widget.onUpdate(cfg.deepCopy()..receiveDisabled = !v),
            ),
          ),
          SettingRow(
            title: l.saveTo,
            description: _dirError ?? (custom ? _short(cfg.receiveDir) : '${l.saveToDefault} · ${_short(downloadsDir())}'),
            descriptionColor: _dirError != null ? p.danger : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (custom)
                  TextButton(
                    onPressed: () => widget.onUpdate(cfg.deepCopy()..receiveDir = ''),
                    child: Text(l.saveToUseDefault),
                  ),
                TextButton(onPressed: () => revealFile(_current(cfg)), child: Text(revealLabel(l))),
                OutlinedButton(onPressed: _choose, child: Text(l.saveToChange)),
              ],
            ),
          ),
          SettingRow(
            title: l.sendLayout,
            child: Segmented<bool>(
              value: cfg.sendLayoutStacked,
              segments: [(false, l.sendLayoutSide), (true, l.sendLayoutBelow)],
              onChanged: (v) => widget.onUpdate(cfg.deepCopy()..sendLayoutStacked = v),
            ),
          ),
          SettingRow(
            title: l.receiveNotify,
            child: SmallSwitch(
              value: !cfg.receiveNotifyDisabled,
              onChanged: (v) => widget.onUpdate(cfg.deepCopy()..receiveNotifyDisabled = !v),
            ),
          ),
        ],
      ),
    );
  }
}
