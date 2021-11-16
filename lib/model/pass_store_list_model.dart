import 'dart:async';
import 'dart:io';

import 'package:flupass/model/app_settings_model.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

class PassStoreListModel with ChangeNotifier {
  static const String extensionNameGpg = 'gpg';

  final AppSettingsModel appSettingsModel;

  String _passStorePath = "";

  String _relativePath = Platform.pathSeparator;

  String get relativePath => _relativePath;

  List<FileSystemEntity> root = List.empty();

  PassStoreListModel(this.appSettingsModel) {
    _passStorePath = appSettingsModel.path;
    updatePassStore();
  }

  String details = "";

  StreamSubscription<FileSystemEvent>? watcher;

  onAppSettingsChanged() {
    var oldPath = _passStorePath;
    var newPath = appSettingsModel.path;
    if (oldPath == newPath) return;
    debugPrint(
        "PassStoreListModel: onAppSettingsChanged old=$oldPath new=$newPath");
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
              (event is File &&
                  p.extension(event.path) == "." + extensionNameGpg));
    }).toList();
    notifyListeners();
  }

  navigateToFolder(String path) {
    _relativePath = path.replaceFirst(_passStorePath, "");
    updatePassStore();
  }

  navigateToParentFolder() {
    final list = _relativePath.split(Platform.pathSeparator);
    list.removeLast();
    final name = list.join(Platform.pathSeparator);
    navigateToFolder(name);
  }

  @override
  void dispose() {
    watcher?.cancel();
    super.dispose();
  }

  createPassFile(String text) {
    debugPrint("PassStoreListModel: createPassFile $text");
    File(_passStorePath +
            _relativePath +
            Platform.pathSeparator +
            text +
            "." +
            extensionNameGpg)
        .create(recursive: true);
  }

  createFolder(String text) {
    debugPrint("PassStoreListModel: createFolder $text");
    Directory(_passStorePath + _relativePath + Platform.pathSeparator + text)
        .create(recursive: true);
  }
}
