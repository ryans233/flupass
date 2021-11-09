import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flupass/model/app_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:openpgp/openpgp.dart';

class PassDetailModel with ChangeNotifier {
  String? selectedPassPath;

  AppSettingsModel appSettingsModel;

  String passphrase = "";

  String privateKey = "";

  String publicKey = "";

  List<String>? extraInfos;

  DetailViewMode mode;

  bool obscurePassword = true;

  final TextEditingController passwordInputController = TextEditingController();

  toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  PassDetailModel(
    this.appSettingsModel, {
    this.mode = DetailViewMode.readOnly,
    this.selectedPassPath,
  }) {
    passphrase = appSettingsModel.passphrase;
    privateKey = appSettingsModel.privateKey;
    publicKey = appSettingsModel.publicKey;
    open(selectedPassPath);
  }

  @override
  dispose() {
    passwordInputController.dispose();
    super.dispose();
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

  open(String? path) async {
    clear();
    if (path == null) return;
    selectedPassPath = path;
    if (path.isEmpty) return;
    final file = File(path);
    if ((await file.length() == 0)) {
      setPassword("");
      extraInfos = List.empty(growable: true);
      notifyListeners();
    } else {
      try {
        var readAsBytesSync = await file.readAsBytes();
        final result =
            await OpenPGP.decryptBytes(readAsBytesSync, privateKey, passphrase);
        extraInfos = String.fromCharCodes(result).trimRight().split("\n");
        passwordInputController.text = extraInfos?.first ?? "";
        if (extraInfos?.first != null) extraInfos?.removeAt(0);
        notifyListeners();
      } catch (e, s) {
        debugPrint(e.toString());
      }
    }
  }

  clear() {
    setPassword("");
    selectedPassPath = null;
    extraInfos = null;
    obscurePassword = true;
    mode = DetailViewMode.readOnly;
    notifyListeners();
  }

  setMode(DetailViewMode mode) {
    this.mode = mode;
    notifyListeners();
    if (mode == DetailViewMode.readOnly) {
      open(selectedPassPath);
    }
  }

  save() async {
    if (publicKey.isEmpty) return;
    if (extraInfos == null) return;
    final path = selectedPassPath;
    if (path == null) return;
    try {
      String extra = extraInfos?.fold<String>(
              "", (previousValue, element) => previousValue + element + "\n") ??
          "";
      String output =
          passwordInputController.text.toString().trim() + "\n" + extra;
      var encrypted = await OpenPGP.encryptBytes(
          Uint8List.fromList(utf8.encode(output)), publicKey);
      File passFile = File(path);
      await passFile.writeAsBytes(encrypted);
      mode = DetailViewMode.readOnly;
      notifyListeners();
    } catch (e, s) {
      debugPrint(e.toString());
    } finally {}
  }

  delete() async {
    try {
      final path = selectedPassPath;
      if (path == null) return;
      File passFile = File(path);
      await passFile.delete();
      clear();
    } catch (e, s) {
      debugPrint(e.toString());
    }
  }

  setPassword(String password) {
    passwordInputController.text = password;
  }
}

enum DetailViewMode {
  create, // Create a new password.
  modify, // Modify an existing password.
  readOnly, // Read only mode.
}
