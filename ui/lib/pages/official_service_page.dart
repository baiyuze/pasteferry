import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../i18n.dart';
import '../main.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'devices_page.dart' show connectionLabel, platformIcon;

/// 官方服务：今日中转额度、各设备走直连还是中转、本机设备 ID。
/// 额度一开启就由后台查询，没用过中转的设备也显示默认额度。
class OfficialServicePage extends StatelessWidget {
  const OfficialServicePage({super.key});

  // 后台空闲时 60 秒刷新一次；超过两个半周期没更新才算过期
  static const _freshSeconds = 150;
  static const _paused = {'global_exhausted', 'global_paused', 'relay_blocked', 'device_banned'};

  String _mb(int bytes) => '${(bytes / 1000000).toStringAsFixed(2)} MB';
  String _time(int seconds, {bool beijing = false}) {
    var d = DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
    d = beijing ? d.add(const Duration(hours: 8)) : d.toLocal();
    String pad(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${pad(d.month)}-${pad(d.day)} ${pad(d.hour)}:${pad(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context), l = context.l10n, p = context.palette;
    final connected = state.status?.signalingConnected == true;
    final peers = state.peers;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: l.officialService,
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: StatusDot(
                color: connected ? p.online : p.textFaint,
                label: connected ? l.connected : l.notConnected,
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(Insets.xl, 0, Insets.xl, Insets.xxl),
            children: [
              GroupSection(
                title: l.officialToday,
                footnote: l.officialAccounting,
                child: _allowance(context),
              ),
              if (peers.isNotEmpty)
                GroupSection(
                  title: l.officialRoutes,
                  footnote: l.officialRoutesFootnote,
                  child: GroupBox(
                    dividerIndent: 52,
                    children: [
                      for (final d in peers)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
                          child: Row(
                            children: [
                              Icon(platformIcon(d.platform), size: 20, color: p.textDim),
                              const SizedBox(width: Insets.md + 4),
                              Expanded(
                                child: Text(d.name, style: context.text.labelLarge, overflow: TextOverflow.ellipsis),
                              ),
                              const SizedBox(width: Insets.md),
                              StatusDot(
                                color: d.online ? p.online : p.textFaint,
                                label: d.online ? connectionLabel(d) : l.offline,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              GroupSection(
                title: l.officialDeviceID,
                child: GroupBox(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(Insets.lg, Insets.sm, Insets.sm, Insets.sm),
                      child: Row(
                        children: [
                          Expanded(
                            child: SelectableText(
                              state.status?.deviceId ?? state.self?.id ?? '',
                              style: context.text.bodyMedium?.copyWith(fontFamily: monoFamily),
                            ),
                          ),
                          IconButton(
                            tooltip: MaterialLocalizations.of(context).copyButtonLabel,
                            onPressed: () => Clipboard.setData(
                              ClipboardData(text: state.status?.deviceId ?? state.self?.id ?? ''),
                            ),
                            icon: const Icon(Icons.copy_outlined, size: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(l.officialPrivacy, style: context.text.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _allowance(BuildContext context) {
    final state = AppScope.of(context), l = context.l10n, p = context.palette;
    final u = state.officialUsage;
    final reason = u?.reason ?? '';
    final known = u != null && u.updatedAtUnix.toInt() > 0;
    if (!known) {
      // 刚开启或刚启动时还没查到；查询失败时后台会自动重试
      final failed = reason.isNotEmpty;
      return GroupBox(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.xl),
            child: Text(
              _paused.contains(reason)
                  ? l.officialPaused
                  : failed
                  ? l.officialFetchFailed
                  : l.officialLoading,
              style: context.text.bodyMedium?.copyWith(color: failed ? p.warning : p.textDim),
            ),
          ),
        ],
      );
    }
    final fresh =
        u.available && DateTime.now().millisecondsSinceEpoch ~/ 1000 - u.updatedAtUnix.toInt() < _freshSeconds;
    final upload = u.uploadBytes.toInt(), download = u.downloadBytes.toInt();
    final used = upload + download;
    final limit = u.limitBytes.toInt();
    final remaining = u.remainingBytes.toInt();
    final low = limit <= 0 || remaining <= limit * .1;
    final notice = switch (reason) {
      'quota_exhausted' => l.officialQuotaTitle,
      'peer_quota_exhausted' => l.officialPeerQuota,
      _ when _paused.contains(reason) => l.officialPaused,
      _ when !fresh => l.officialUnavailable,
      _ when limit > 0 && used >= limit * .9 => l.officialWarning,
      _ => null,
    };
    const figures = [FontFeature.tabularFigures()];
    Widget info(String title, String value) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text(title, style: context.text.bodyMedium?.copyWith(color: p.textDim))),
          SelectableText(value, style: context.text.bodyMedium?.copyWith(fontFeatures: figures)),
        ],
      ),
    );
    return GroupBox(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Insets.lg, Insets.lg, Insets.lg, Insets.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (notice != null) ...[
                Text(notice, style: context.text.bodyMedium?.copyWith(color: p.warning)),
                const SizedBox(height: Insets.md),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.officialRemaining, style: context.text.bodySmall),
                        const SizedBox(height: 2),
                        Text(
                          _mb(remaining),
                          style: context.text.headlineSmall?.copyWith(
                            fontFeatures: figures,
                            color: fresh ? p.text : p.textDim,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(l.officialDailyLimit, style: context.text.bodySmall),
                      const SizedBox(height: 2),
                      Text(_mb(limit), style: context.text.bodyMedium?.copyWith(fontFeatures: figures)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: Insets.md),
              // 条的长度是剩余额度：满格表示今天还没用
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: limit > 0 ? (remaining / limit).clamp(0.0, 1.0) : 0,
                  minHeight: 6,
                  color: low ? p.warning : p.accent,
                  backgroundColor: p.fill,
                ),
              ),
            ],
          ),
        ),
        info(l.officialUsed, _mb(used)),
        info(l.officialUpload, _mb(upload)),
        info(l.officialDownload, _mb(download)),
        info(l.officialReset, _time(u.resetAtUnix.toInt(), beijing: true)),
        info(l.officialUpdated, _time(u.updatedAtUnix.toInt())),
      ],
    );
  }
}
