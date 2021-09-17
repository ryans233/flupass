import 'dart:async';
import 'dart:io';

import 'package:flupass/model/app_settings_model.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

class PassStoreListModel with ChangeNotifier {
  final AppSettingsModel appSettingsModel;

  String _passStorePath = "";

  String _relativePath = "";

  String get relativePath => _relativePath;

  List<FileSystemEntity> root = List.empty();

  PassStoreListModel(this.appSettingsModel);

  String details = "";

  StreamSubscription<FileSystemEvent>? watcher;

  onAppSettingsChanged() {
    var oldPath = _passStorePath;
    var newPath = appSettingsModel.path;
    debugPrint(
        "PassStoreListModel: onAppSettingsChanged old=$oldPath new=$newPath");
    if (oldPath == newPath) return;
    _passStorePath = newPath;
    updatePassStore();
  }

  updatePassStore() async {
    var directory = Directory(_passStorePath + _relativePath);
    watcher?.cancel();
    watcher = directory.watch().listen((event) {
      updatePassStore();
    });
    root = await directory.list(recursive: false).where((event) {
      final basename = p.basename(event.path);
      return !basename.startsWith(".") &&
          (event is Directory ||
              (event is File && p.extension(event.path) == ".gpg"));
    }).toList();
    notifyListeners();
  }

  navigateToFolder(String name) {
    _relativePath = "${Platform.pathSeparator}$name";
    updatePassStore();
  }

  navigateToParentFolder() {
    final uri = Uri.parse(_relativePath);
    final pathSegments = uri.pathSegments.toList();
    pathSegments.removeLast();
    final name = pathSegments.join(Platform.pathSeparator);
    navigateToFolder(name);
  }

  @override
  void dispose() {
    watcher?.cancel();
    super.dispose();
  }
}
