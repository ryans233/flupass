import 'dart:math';

import 'package:flupass/util/text_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PasswordGeneratorModel with ChangeNotifier {
  final _random = Random.secure();

  String _password = "password";
  String get password => _password;
  int _length = defaultPasswordLength;
  int get length => _length;
  bool _hasUppercase = true;
  bool get hasUppercase => _hasUppercase;
  bool _hasLowercase = true;
  bool get hasLowercase => _hasLowercase;
  bool _hasNumber = true;
  bool get hasNumber => _hasNumber;
  bool _hasSpecialSymbols = true;
  bool get hasSpecialSymbols => _hasSpecialSymbols;

  static const String _symbols = "!\"#\$%&'()*+,-./:;<=>?@";
  static const int defaultPasswordLength = 16;
  PasswordGeneratorModel() {
    generate();
  }

  generate() {
    _password = "";
    while (!isPasswordValid(_password)) {
      _password = generatePassword();
    }
    notifyListeners();
  }

  String generatePassword() {
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < _length; i++) {
      int charCode = -1;
      bool isValid = false;
      while (!isValid) {
        switch (_random.nextInt(4)) {
          case 0:
            if (_hasLowercase) {
              charCode = _random.nextInt(26) + 97;
            }
            break;
          case 1:
            if (_hasUppercase) {
              charCode = _random.nextInt(26) + 65;
            }
            break;
          case 2:
            if (_hasNumber) {
              charCode = _random.nextInt(10) + 48;
            }
            break;
          case 3:
            if (_hasSpecialSymbols) {
              charCode = _symbols.codeUnitAt(_random.nextInt(_symbols.length));
            }
            break;
        }
        isValid = charCode != -1;
      }
      if (isValid) buffer.writeCharCode(charCode);
    }
    return buffer.toString();
  }

  bool isPasswordValid(String password) {
    if (password.isEmpty) {
      return false;
    }
    if (password.length < _length) {
      return false;
    }
    if (_hasUppercase && !TextUtils.hasUppercase(password)) {
      return false;
    }
    if (_hasLowercase && !TextUtils.hasLowercase(password)) {
      return false;
    }
    if (_hasNumber && !TextUtils.hasNumber(password)) {
      return false;
    }
    if (_hasSpecialSymbols &&
        !_symbols.split("").any((element) => password.contains(element))) {
      return false;
    }
    return true;
  }

  Future<void> copy() {
    return Clipboard.setData(ClipboardData(text: _password));
  }

  setLength(int length) {
    _length = length;
    notifyListeners();
    generate();
  }

  setUppercase(bool value) {
    if (!value && isOnlyOne()) return;
    _hasUppercase = value;
    notifyListeners();
    generate();
  }

  setNumber(bool value) {
    if (!value && isOnlyOne()) return;
    _hasNumber = value;
    notifyListeners();
    generate();
  }

  setSpecialSymbols(bool value) {
    if (!value && isOnlyOne()) return;
    _hasSpecialSymbols = value;
    notifyListeners();
    generate();
  }

  setLowercase(bool value) {
    if (!value && isOnlyOne()) return;
    _hasLowercase = value;
    notifyListeners();
    generate();
  }

  bool isOnlyOne() {
    var result = 0;
    result += _hasLowercase ? 1 : 0;
    result += hasUppercase ? 1 : 0;
    result += hasNumber ? 1 : 0;
    result += hasSpecialSymbols ? 1 : 0;
    return result == 1;
  }
}
