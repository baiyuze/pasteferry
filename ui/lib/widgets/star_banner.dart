import 'package:flutter/material.dart';

import '../i18n.dart';
import '../icons.dart';
import '../main.dart' show AppScope;
import '../star_prompt.dart';
import '../theme.dart';
import 'backdrop.dart';

/// 请用户去 GitHub 点 Star 的小横幅。不弹窗、不挡操作，规则见 star_prompt.dart。
///
/// 放在复制记录列表上方（桌面与手机都是）。宽的时候按钮排在右边，窄的时候排在文字下面。
/// 打开网址的方式两边不同，由调用方给出 [openUrl]。
class StarBanner extends StatelessWidget {
  const StarBanner({super.key, required this.openUrl, this.padding = EdgeInsets.zero});

  final void Function(String url) openUrl;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final prompt = state.starPrompt;
    if (!state.isOnline || !prompt.visible) return const SizedBox.shrink();
    final l = context.l10n;
    final p = context.palette;

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(l.starTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(l.starBody, style: context.text.bodySmall?.copyWith(color: p.textDim)),
      ],
    );
    final buttons = Wrap(
      children: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: p.accent,
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: Insets.sm),
          ),
          onPressed: () {
            prompt.starred();
            openUrl(StarPrompt.url);
          },
          child: Text(l.starAction),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: p.textDim,
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: Insets.sm),
          ),
          onPressed: prompt.later,
          child: Text(l.starLater),
        ),
      ],
    );
    final close = IconButton(
      tooltip: l.starDismiss,
      visualDensity: VisualDensity.compact,
      iconSize: 16,
      color: p.textFaint,
      onPressed: prompt.dismiss,
      icon: Icon(AppIcons.xmark),
    );
    final icon = Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Icon(AppIcons.star, size: 18, color: p.accent),
    );

    return Padding(
      padding: padding,
      child: Container(
        padding: const EdgeInsets.fromLTRB(Insets.lg, Insets.md, Insets.xs, Insets.md),
        decoration: BoxDecoration(
          color: context.panel(p.surface),
          borderRadius: BorderRadius.circular(context.shape.lg),
          border: Border.all(color: p.border),
        ),
        child: LayoutBuilder(
          builder: (context, c) => c.maxWidth >= 480
              ? Row(
                  children: [
                    icon,
                    const SizedBox(width: Insets.md),
                    Expanded(child: text),
                    const SizedBox(width: Insets.sm),
                    buttons,
                    close,
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    icon,
                    const SizedBox(width: Insets.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text,
                          const SizedBox(height: Insets.xs),
                          // 按钮的文字与上面的文字对齐
                          Transform.translate(offset: const Offset(-Insets.sm, 0), child: buttons),
                        ],
                      ),
                    ),
                    close,
                  ],
                ),
        ),
      ),
    );
  }
}
