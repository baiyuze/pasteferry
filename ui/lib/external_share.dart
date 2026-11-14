import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

import 'daemon_client.dart';
import 'gen/pasteferry/v1/daemon.pb.dart';

class ShareDraft {
  ShareDraft({
    required this.id,
    required this.paths,
    required this.createdAt,
    this.ownedDirectory = '',
    this.error = '',
    this.transferId = '',
  });
  final String id;
  final List<String> paths;
  final DateTime createdAt;
  final String ownedDirectory;
  final String error;
  String transferId;
  Map<String, Object> toJson() => {
    'id': id,
    'paths': paths,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'ownedDirectory': ownedDirectory,
    'error': error,
    'transferId': transferId,
  };
}

/// A private, atomic filesystem inbox is shared by native entry points and the
/// UI. It survives cold starts and never exposes an unauthenticated local port.
class ExternalShares extends ChangeNotifier {
  ExternalShares({this._dataDir});
  final String? _dataDir;
  late Directory _inbox, _drafts;
  final List<ShareDraft> _pending = [];
  final Map<String, ShareDraft> _retained = {};
  final Set<String> _reading = {}, _cleaning = {};
  StreamSubscription<FileSystemEvent>? _watch;
  Timer? _poll;
  Future<void>? _starting;
  Future<void>? _scanning, _closing;
  bool _disposed = false;
  bool importing = false;
  static final _id = RegExp(r'^[a-zA-Z0-9-]{8,64}$');

  List<ShareDraft> get pending => List.unmodifiable(_pending);

  Future<void> start() => _starting ??= _start();

  Future<void> _start() async {
    final data = _dataDir ?? DaemonEndpoint.defaultDataDir();
    _inbox = Directory('$data/share-inbox');
    _drafts = Directory('$data/share-drafts');
    await _inbox.create(recursive: true);
    await _drafts.create(recursive: true);
    if (!Platform.isWindows && !Platform.isAndroid) {
      for (final dir in [_inbox, _drafts]) {
        final result = await Process.run('chmod', ['700', dir.path]);
        if (result.exitCode != 0) {
          throw FileSystemException('Cannot protect share inbox', dir.path);
        }
      }
    }
    await for (final entry in _drafts.list(followLinks: false)) {
      if (entry is! File || !entry.path.endsWith('.json')) continue;
      try {
        final draft = await _read(entry);
        if (draft.transferId.isNotEmpty) {
          _retained[draft.id] = draft;
        } else if (DateTime.now().difference(draft.createdAt) >
            const Duration(hours: 24)) {
          await _remove(draft);
        } else {
          _pending.add(draft);
        }
      } catch (e) {
        debugPrint('Cannot restore share draft: $e');
      }
    }
    _pending.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    if (_disposed) return;
    try {
      _watch = _inbox.watch().listen(
        (_) => unawaited(scan()),
        onError: (Object error) => debugPrint('Share inbox watch: $error'),
      );
    } on FileSystemException {
      /* The bounded polling fallback also handles wake. */
    }
    _poll = Timer.periodic(
      const Duration(seconds: 3),
      (_) => unawaited(scan()),
    );
    await scan();
    if (!_disposed) notifyListeners();
  }

  Future<ShareDraft> _read(File file) async {
    if (await file.length() > 2 << 20) {
      throw const FormatException('Share batch is too large');
    }
    final value = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    final id = value['id'] as String;
    if (!_id.hasMatch(id) || file.uri.pathSegments.last != '$id.json') {
      throw const FormatException('Invalid share request ID');
    }
    final items = (value['paths'] as List? ?? const []).cast<String>();
    if (items.length > 10000 ||
        items.any(
          (p) =>
              p.isEmpty ||
              p.length > 32768 ||
              !File(p).isAbsolute ||
              p.contains('\u0000'),
        )) {
      throw const FormatException('Invalid shared file paths');
    }
    final data = _dataDir ?? DaemonEndpoint.defaultDataDir();
    final owned = value['ownedDirectory'] as String? ?? '';
    final expected = '$data/share-staging/$id';
    if (owned.isNotEmpty && !path.equals(owned, expected)) {
      throw const FormatException('Invalid staging directory');
    }
    return ShareDraft(
      id: id,
      paths: items.toSet().toList(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        value['createdAt'] as int? ??
            (await file.stat()).modified.millisecondsSinceEpoch,
      ),
      ownedDirectory: owned,
      error: value['error'] as String? ?? '',
      transferId: value['transferId'] as String? ?? '',
    );
  }

  Future<void> scan() =>
      _scanning ??= _scan().whenComplete(() => _scanning = null);

  Future<void> _scan() async {
    if (_disposed) return;
    try {
      var foundImport = false;
      await for (final entry in _inbox.list(followLinks: false)) {
        if (entry is File && entry.path.endsWith('.importing')) {
          foundImport = true;
          continue;
        }
        if (entry is! File ||
            !entry.path.endsWith('.json') ||
            !_reading.add(entry.path)) {
          continue;
        }
        try {
          final draft = await _read(entry);
          if (!_retained.containsKey(draft.id) &&
              !_pending.any((x) => x.id == draft.id)) {
            await _save(draft);
            if (_disposed) return;
            _pending.add(draft);
            notifyListeners();
          }
          await entry.delete();
        } on FileSystemException catch (e) {
          if (e.osError?.errorCode != 2) debugPrint('Share import: $e');
        } catch (e) {
          // Ignore malformed local requests without discarding their evidence.
          debugPrint('Invalid share request: $e');
        } finally {
          _reading.remove(entry.path);
        }
      }
      if (!_disposed && foundImport != importing) {
        importing = foundImport;
        notifyListeners();
      }
    } on FileSystemException catch (e) {
      debugPrint('Share inbox: $e');
    }
  }

  Future<void> cancelImports() async {
    await for (final entry in _inbox.list(followLinks: false)) {
      if (entry is File && entry.path.endsWith('.importing')) {
        await entry.delete();
      }
    }
    await scan();
  }

  Future<void> _save(ShareDraft draft) async {
    final temp = File('${_drafts.path}/${draft.id}.tmp');
    await temp.writeAsString(jsonEncode(draft.toJson()), flush: true);
    final target = File('${_drafts.path}/${draft.id}.json');
    await temp.rename(target.path);
  }

  Future<void> complete(ShareDraft draft, Transfer? transfer) async {
    if (transfer != null) {
      draft.transferId = transfer.id;
      await _save(draft);
      _retained[draft.id] = draft;
    } else {
      await _remove(draft);
    }
    _pending.removeWhere((x) => x.id == draft.id);
    if (!_disposed) notifyListeners();
  }

  /// Retain imported attachments while paused/failed transfers can be resumed.
  /// A UI reload never treats an absent, not-yet-loaded record as completion.
  void transfersChanged(List<Transfer> transfers) {
    final byId = {for (final t in transfers) t.id: t};
    for (final draft in _retained.values.toList()) {
      final transfer = byId[draft.transferId];
      if (transfer == null ||
          !const {
            'done',
            'cancelled',
            'declined',
            'expired',
          }.contains(transfer.status)) {
        continue;
      }
      if (!_cleaning.add(draft.id)) continue;
      unawaited(
        _remove(draft)
            .then((_) => _retained.remove(draft.id))
            .catchError((Object e) {
              debugPrint('Share cleanup: $e');
              return null;
            })
            .whenComplete(() => _cleaning.remove(draft.id)),
      );
    }
  }

  Future<void> _remove(ShareDraft draft) async {
    if (draft.ownedDirectory.isNotEmpty) {
      final dir = Directory(draft.ownedDirectory);
      // Never follow a replaced staging-directory symlink when deleting.
      if (await FileSystemEntity.type(dir.path, followLinks: false) ==
          FileSystemEntityType.directory) {
        await dir.delete(recursive: true);
      }
    }
    final saved = File('${_drafts.path}/${draft.id}.json');
    if (await saved.exists()) await saved.delete();
  }

  @override
  void dispose() {
    unawaited(close());
    super.dispose();
  }

  /// Wait for native directory watches and in-flight reads before removing or
  /// replacing an inbox. Windows keeps the directory open until cancellation.
  Future<void> close() => _closing ??= _close();

  Future<void> _close() async {
    _disposed = true;
    _poll?.cancel();
    await _watch?.cancel();
    await _starting;
    await _scanning;
  }
}
