import 'dart:collection';
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

  List<String>? get extraInfos =>
      List.unmodifiable(_extraInfos ?? List.empty());

  List<String>? _extraInfos;

  DetailViewMode mode;

  bool obscurePassword = true;

  final TextEditingController passwordInputController = TextEditingController();
  final TextEditingController newEntryKeyController = TextEditingController();
  final TextEditingController newEntryValueController = TextEditingController();

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
    newEntryKeyController.dispose();
    newEntryValueController.dispose();
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
      _extraInfos = List.empty(growable: true);
      notifyListeners();
    } else {
      try {
        var readAsBytesSync = await file.readAsBytes();
        final result =
            await OpenPGP.decryptBytes(readAsBytesSync, privateKey, passphrase);
        _extraInfos = String.fromCharCodes(result).trimRight().split("\n");
        passwordInputController.text = _extraInfos?.first ?? "";
        if (_extraInfos?.first != null) _extraInfos?.removeAt(0);
        notifyListeners();
      } catch (e, s) {
        debugPrint(e.toString());
      }
    }
  }

  clear() {
    setPassword("");
    selectedPassPath = null;
    _extraInfos = null;
    obscurePassword = true;
    mode = DetailViewMode.readOnly;
    passwordInputController.clear();
    newEntryKeyController.clear();
    newEntryValueController.clear();
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
    if (_extraInfos == null) return;
    final path = selectedPassPath;
    if (path == null) return;
    try {
      String extra = _extraInfos?.fold<String>(
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

  addExtraInfo() {
    _extraInfos?.add(
        "${newEntryKeyController.text.toString()}: ${newEntryValueController.text.toString()}");
    newEntryKeyController.clear();
    newEntryValueController.clear();
    notifyListeners();
  }

  updateExtraInfo(int index, String value) {
    _extraInfos?[index] = value;
    notifyListeners();
  }

  deleteExtraInfo(int index) {
    _extraInfos?.removeAt(index);
    notifyListeners();
  }
}

enum DetailViewMode {
  create, // Create a new password.
  modify, // Modify an existing password.
  readOnly, // Read only mode.
}
