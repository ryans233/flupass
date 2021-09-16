import 'dart:io';

import 'package:flupass/model/app_settings_model.dart';
import 'package:flutter/foundation.dart';
import 'package:openpgp/openpgp.dart';

class PassDetailModel with ChangeNotifier {
  String selectedPassPath;

  AppSettingsModel appSettingsModel;

  String passphrase = "";

  String privateKey = "";

  List<String> decryptedLines = List.empty();

  DetailViewMode mode;

  bool obscurePassword = true;

  toggleObscurePassword() => obscurePassword = !obscurePassword;

  PassDetailModel(
    this.appSettingsModel,
    this.selectedPassPath, {
    this.mode = DetailViewMode.readOnly,
  }) {
    passphrase = appSettingsModel.passphrase;
    privateKey = appSettingsModel.privateKey;
    decrypt(selectedPassPath);
  }

  onAppSettingsChanged() {
    if (privateKey == appSettingsModel.privateKey &&
        passphrase == appSettingsModel.passphrase) return;
    debugPrint("PassDetailModel: onAppSettingsChanged");
    passphrase = appSettingsModel.passphrase;
    privateKey = appSettingsModel.privateKey;
    decrypt(selectedPassPath);
  }

  decrypt(String path) async {
    debugPrint("decrypt: path=$path");
    clear();
    selectedPassPath = path;
    if (path.isEmpty) return;
    final file = File(path);
    try {
      var readAsBytesSync = await file.readAsBytes();
      final result =
          await OpenPGP.decryptBytes(readAsBytesSync, privateKey, passphrase);
      decryptedLines = String.fromCharCodes(result).split("\n");
      notifyListeners();
    } catch (e, s) {
      debugPrint(e.toString());
    }
  }

  clear() {
    decryptedLines = List.empty();
    notifyListeners();
  }
}

enum DetailViewMode {
  create, // Create a new password.
  modify, // Modify an existing password.
  readOnly, // Read only mode.
}
