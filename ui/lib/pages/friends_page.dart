import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

import '../gen/pasteferry/v1/daemon.pb.dart';
import '../i18n.dart';
import '../icons.dart';
import '../main.dart';
import '../theme.dart';
import '../widgets/avatar.dart';
import '../widgets/common.dart';
import '../widgets/friends_dialog.dart';
import '../widgets/send_dialog.dart';
import 'send_page.dart';

/// 侧边栏的「好友」：左边是好友列表，右边是选中好友的状态、发送与传输记录。
/// 底部是「允许这些人给我发文件」和本机显示的名字、头像。
class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final _search = TextEditingController();
  String _query = '';
  String? _selected;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final p = context.palette;
    final all = sortedFriends(state);
    final q = _query.trim().toLowerCase();
    final friends = q.isEmpty
        ? all
        : all
              .where(
                (f) => f.displayName.toLowerCase().contains(q) || f.deviceName.toLowerCase().contains(q),
              )
              .toList();
    // 选中的好友被删掉了就选第一个
    final selected = all.where((f) => f.id == _selected).firstOrNull ?? all.firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: l.friendsTitle,
          subtitle: l.friendsSubtitle,
          actions: [
            FilledButton.icon(
              onPressed: () => showAddFriendDialog(context),
              icon: Icon(AppIcons.personAdd, size: 16),
              label: Text(l.addFriend),
            ),
          ],
        ),
        Expanded(
          child: all.isEmpty
              ? EmptyState(
                  icon: AppIcons.people,
                  title: l.friendsEmpty,
                  description: l.friendsEmptyBody,
                  action: FilledButton.icon(
                    onPressed: () => showAddFriendDialog(context),
                    icon: Icon(AppIcons.personAdd, size: 16),
                    label: Text(l.addFriend),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(Insets.xl, 0, Insets.xl, Insets.lg),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: 248,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SearchField(
                              controller: _search,
                              hint: l.friendsSearch,
                              clearTooltip: l.searchClear,
                              onChanged: (v) => setState(() => _query = v),
                            ),
                            const SizedBox(height: Insets.sm),
                            Expanded(
                              child: friends.isEmpty
                                  ? Center(child: Text(l.friendsNoMatch, style: context.text.bodySmall))
                                  : ListView.builder(
                                      itemCount: friends.length,
                                      itemBuilder: (_, i) => _FriendListRow(
                                        friend: friends[i],
                                        selected: friends[i].id == selected?.id,
                                        onTap: () => setState(() => _selected = friends[i].id),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: Insets.lg),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: p.surface,
                            borderRadius: BorderRadius.circular(Radii.md),
                            border: Border.all(color: p.border),
                          ),
                          padding: const EdgeInsets.fromLTRB(Insets.xl, Insets.lg, Insets.md, Insets.md),
                          child: selected == null
                              ? Center(child: Text(l.friendsPick, style: context.text.bodySmall))
                              : _DropToFriend(
                                  friend: selected,
                                  child: FriendDetail(key: ValueKey(selected.id), friendId: selected.id),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        const ReceiveFromBar(trailing: ProfileChip()),
      ],
    );
  }
}

class _FriendListRow extends StatefulWidget {
  const _FriendListRow({required this.friend, required this.selected, required this.onTap});

  final Friend friend;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_FriendListRow> createState() => _FriendListRowState();
}

class _FriendListRowState extends State<_FriendListRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l = context.l10n;
    final p = context.palette;
    final f = widget.friend;
    final asking = state.askingIncoming.where((t) => t.deviceId == f.id).length;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onSecondaryTapUp: (d) => showFriendMenu(context, f, d.globalPosition),
        child: Container(
          margin: const EdgeInsets.only(bottom: 2),
          padding: const EdgeInsets.symmetric(horizontal: Insets.sm, vertical: 7),
          decoration: BoxDecoration(
            color: widget.selected ? p.selection : (_hover ? p.hover : Colors.transparent),
            borderRadius: BorderRadius.circular(Radii.sm),
          ),
          child: Row(
            children: [
              Opacity(
                opacity: f.online ? 1 : 0.55,
                child: PersonAvatar(deviceId: f.id, name: f.displayName, hash: f.avatarHash, size: 34),
              ),
              const SizedBox(width: Insets.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      f.displayName,
                      style: context.text.labelLarge?.copyWith(
                        fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      friendStatus(l, state, f),
                      style: context.text.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (asking > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(color: p.accent, borderRadius: BorderRadius.circular(9)),
                  child: Text('$asking', style: context.text.labelSmall?.copyWith(color: Colors.white)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 把文件拖到好友详情上，直接发给他。
class _DropToFriend extends StatefulWidget {
  const _DropToFriend({required this.friend, required this.child});

  final Friend friend;
  final Widget child;

  @override
  State<_DropToFriend> createState() => _DropToFriendState();
}

class _DropToFriendState extends State<_DropToFriend> {
  bool _dropping = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.palette;
    final f = widget.friend;
    final can = friendCanSend(f);
    return DropTarget(
      enable: can,
      onDragEntered: (_) => setState(() => _dropping = true),
      onDragExited: (_) => setState(() => _dropping = false),
      onDragDone: (details) {
        setState(() => _dropping = false);
        sendFilesById(context, f.id, f.displayName, droppedPaths(details));
      },
      child: Stack(
        children: [
          widget.child,
          if (_dropping)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: p.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(Radii.md),
                  border: Border.all(color: p.accent, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(l.friendDropHint(f.displayName), style: context.text.titleSmall?.copyWith(color: p.accent)),
              ),
            ),
        ],
      ),
    );
  }
}
