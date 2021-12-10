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

  List<String> get passContent => List.unmodifiable(_passContent);

  List<String> _passContent = List.empty();

  DetailViewMode mode;

  final TextEditingController newEntryKeyController = TextEditingController();
  final TextEditingController newEntryValueController = TextEditingController();

  bool _isWysiwyg = true;
  bool get isWysiwyg => _isWysiwyg;

  toggleObscurePassword() {
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
      _passContent = List.empty(growable: true);
      notifyListeners();
    } else {
      try {
        var readAsBytesSync = await file.readAsBytes();
        final result =
            await OpenPGP.decryptBytes(readAsBytesSync, privateKey, passphrase);
        _passContent = String.fromCharCodes(result).trimRight().split("\n");
        notifyListeners();
      } catch (e, s) {
        debugPrint(e.toString());
      }
    }
  }

  clear() {
    selectedPassPath = null;
    _isWysiwyg = true;
    _passContent = List.empty();
    mode = DetailViewMode.readOnly;
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
    final path = selectedPassPath;
    if (path == null) return;
    try {
      String output = passContent.fold<String>(
          "", (previousValue, element) => previousValue + element + "\n");
      final encrypted = await OpenPGP.encryptBytes(
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

  addExtraInfo() {
    List<String> tmp = List.from(_passContent);
    tmp.add(
        "${newEntryKeyController.text.toString()}: ${newEntryValueController.text.toString()}");
    _passContent = tmp;
    notifyListeners();
    newEntryKeyController.clear();
    newEntryValueController.clear();
  }

  updatePassByLine(int index, String? value) {
    if ((passContent.length) <= index) return;
    List<String> tmp = List.from(_passContent);
    if (value == null) {
      tmp.removeAt(index);
    } else {
      tmp[index] = value;
    }
    _passContent = tmp;
    notifyListeners();
  }

  updatePass(String? value) {
    final tmp = value ?? "";
    _passContent = tmp.split("\n");
    notifyListeners();
  }

  toggleWysiwyg() {
    _isWysiwyg = !_isWysiwyg;
    notifyListeners();
  }
}

enum DetailViewMode {
  modify, // Modify an existing password.
  readOnly, // Read only mode.
}
