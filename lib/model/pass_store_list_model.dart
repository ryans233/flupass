import 'dart:async';
import 'dart:io';

import 'package:flupass/generated/l10n.dart';
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
    if (_passStorePath.isEmpty) {
      root = List.empty();
      notifyListeners();
      return;
    }
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
    root.sort((a, b) {
      if (a is Directory && b is Directory) {
        return a.path.compareTo(b.path);
      }
      if (a is Directory) return -1;
      if (b is Directory) return 1;
      return a.path.compareTo(b.path);
    });
    notifyListeners();
  }

  navigateToFolder(String path) {
    _relativePath = path.replaceFirst(_passStorePath, "");
    if (_relativePath.endsWith(Platform.pathSeparator)) {
      _relativePath = _relativePath.substring(0, _relativePath.length - 1);
    }
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

  Future<File> createPassFile(String filename) {
    debugPrint("PassStoreListModel: createPassFile $filename");
    if (_passStorePath.isEmpty) {
      return Future.error(
          S.current.errorMessageYouShouldSettingUpPassStorePathFirst);
    } else {
      return File(_passStorePath +
              _relativePath +
              Platform.pathSeparator +
              filename +
              "." +
              extensionNameGpg)
          .create(recursive: true);
    }
  }

  Future<Directory> createFolder(String filename) {
    debugPrint("PassStoreListModel: createFolder $filename");
    if (_passStorePath.isEmpty) {
      return Future.error(
          S.current.errorMessageYouShouldSettingUpPassStorePathFirst);
    } else {
      return Directory(_passStorePath +
              _relativePath +
              Platform.pathSeparator +
              filename)
          .create(recursive: true);
    }
  }
}
