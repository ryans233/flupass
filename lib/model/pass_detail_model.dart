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

  String? password;

  List<String>? extraInfos;

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
    open(selectedPassPath);
  }

  onAppSettingsChanged() {
    if (privateKey == appSettingsModel.privateKey &&
        publicKey == appSettingsModel.publicKey &&
        passphrase == appSettingsModel.passphrase) return;
    debugPrint("PassDetailModel: onAppSettingsChanged");
    passphrase = appSettingsModel.passphrase;
    privateKey = appSettingsModel.privateKey;
    publicKey = appSettingsModel.publicKey;
    open(selectedPassPath);
  }

  open(String path) async {
    debugPrint("decrypt: path=$path");
    clear();
    selectedPassPath = path;
    if (path.isEmpty) return;
    final file = File(path);
    if ((await file.length() == 0)) {
      password = null;
      extraInfos = List.empty(growable: true);
      notifyListeners();
    } else {
      try {
        var readAsBytesSync = await file.readAsBytes();
        final result =
            await OpenPGP.decryptBytes(readAsBytesSync, privateKey, passphrase);
        extraInfos = String.fromCharCodes(result).trimRight().split("\n");
        password = extraInfos?.first;
        if (password != null) extraInfos?.removeAt(0);
        notifyListeners();
      } catch (e, s) {
        debugPrint(e.toString());
      }
    }
  }

  clear() {
    password = null;
    extraInfos = null;
    obscurePassword = true;
    notifyListeners();
  }

  setMode(DetailViewMode mode) {
    this.mode = mode;
    notifyListeners();
  }

  save() async {
    if (publicKey.isEmpty) return;
    if (extraInfos == null) return;
    try {
      String extra = extraInfos?.fold<String>(
              "", (previousValue, element) => previousValue + element + "\n") ??
          "";
      String output = (password ?? "") + "\n" + extra;
      var encrypted = await OpenPGP.encryptBytes(
          Uint8List.fromList(utf8.encode(output)), publicKey);
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
