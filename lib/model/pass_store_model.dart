import 'dart:io';

import 'package:flupass/model/app_settings_model.dart';
import 'package:flutter/foundation.dart';
import 'package:openpgp/openpgp.dart';

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

  decrypt(String path) async {
    final file = File(path);
    try {
      var readAsBytesSync = await file.readAsBytes();
      final result = await OpenPGP.decryptBytes(readAsBytesSync,
          appSettingsModel.privateKey, appSettingsModel.passphrase);
      debugPrint(String.fromCharCodes(result));
    } catch (e, s) {
      debugPrint(e.toString());
    }
  }
}
