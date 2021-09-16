import 'dart:io';

import 'package:flupass/model/app_settings_model.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

class PassStoreListModel with ChangeNotifier {
  final AppSettingsModel appSettingsModel;

  String _passStorePath = "";

  String _relativePath = "";

  String get relativePath => _relativePath;

  List<FileSystemEntity> root = List.empty();

  PassStoreListModel(this.appSettingsModel);

  String details = "";

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
    root = await Directory(_passStorePath + _relativePath)
        .list(recursive: false)
        .where((event) => !basename(event.path).startsWith("."))
        .toList();
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
}
