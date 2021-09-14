import 'dart:io';

import 'package:flupass/model/app_settings_model.dart';
import 'package:flutter/foundation.dart';

class PassStoreModel with ChangeNotifier {
  final AppSettingsModel appSettingsModel;

  String _passStorePath = "";

  List<FileSystemEntity> root = List.empty();

  PassStoreModel(this.appSettingsModel);

  onAppSettingsChanged() {
    var oldPath = _passStorePath;
    var newPath = appSettingsModel.path;
    debugPrint("onAppSettingsChanged: old=$oldPath new=$newPath");
    if (oldPath == newPath) return;
    _passStorePath = newPath;
    updatePassStore();
  }

  updatePassStore() async {
    root = await Directory(_passStorePath).list(recursive: false).toList();
    notifyListeners();
  }
}
