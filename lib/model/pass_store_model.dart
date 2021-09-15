import 'dart:io';

import 'package:flupass/model/app_settings_model.dart';
import 'package:flutter/foundation.dart';
import 'package:openpgp/openpgp.dart';

class PassStoreModel with ChangeNotifier {
  final AppSettingsModel appSettingsModel;

  String _passStorePath = "";

  List<FileSystemEntity> root = List.empty();

  PassStoreModel(this.appSettingsModel);

  String details = "";

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

  decrypt(String path) async {
    final file = File(path);
    try {
      var readAsBytesSync = await file.readAsBytes();
      final result = await OpenPGP.decryptBytes(readAsBytesSync,
          appSettingsModel.privateKey, appSettingsModel.passphrase);
      details = String.fromCharCodes(result);
      notifyListeners();
    } catch (e, s) {
      debugPrint(e.toString());
    }
  }
}
