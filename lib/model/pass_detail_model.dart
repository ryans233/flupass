import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flupass/model/app_settings_model.dart';
import 'package:flutter/foundation.dart';
import 'package:openpgp/openpgp.dart';

class PassDetailModel with ChangeNotifier {
  String selectedPassPath;

  AppSettingsModel appSettingsModel;

  String passphrase = "";

  String privateKey = "";

  String publicKey = "";

  List<String> decryptedLines = List.empty();

  DetailViewMode mode;

  bool obscurePassword = true;

  toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  PassDetailModel(
    this.appSettingsModel, {
    this.mode = DetailViewMode.readOnly,
    this.selectedPassPath = "",
  }) {
    passphrase = appSettingsModel.passphrase;
    privateKey = appSettingsModel.privateKey;
    publicKey = appSettingsModel.publicKey;
    decrypt(selectedPassPath);
  }

  onAppSettingsChanged() {
    if (privateKey == appSettingsModel.privateKey &&
        publicKey == appSettingsModel.publicKey &&
        passphrase == appSettingsModel.passphrase) return;
    debugPrint("PassDetailModel: onAppSettingsChanged");
    passphrase = appSettingsModel.passphrase;
    privateKey = appSettingsModel.privateKey;
    publicKey = appSettingsModel.publicKey;
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
      decryptedLines = String.fromCharCodes(result).trimRight().split("\n");
      notifyListeners();
    } catch (e, s) {
      debugPrint(e.toString());
    }
  }

  clear() {
    decryptedLines = List.empty();
    notifyListeners();
  }

  setMode(DetailViewMode mode) {
    this.mode = mode;
    notifyListeners();
  }

  save() async {
    if (publicKey.isEmpty) return;
    try {
      String s = decryptedLines.fold<String>(
          "", (previousValue, element) => previousValue + element + "\n");
      var encrypted = await OpenPGP.encryptBytes(
          Uint8List.fromList(utf8.encode(s)), publicKey);
      File passFile = File(selectedPassPath);
      await passFile.writeAsBytes(encrypted);
      mode = DetailViewMode.readOnly;
      notifyListeners();
    } catch (e, s) {
      debugPrint(e.toString());
    } finally {}
  }

  delete() async {
    try {
      File passFile = File(selectedPassPath);
      await passFile.delete();
      clear();
    } catch (e, s) {
      debugPrint(e.toString());
    }
  }
}

enum DetailViewMode {
  create, // Create a new password.
  modify, // Modify an existing password.
  readOnly, // Read only mode.
}
