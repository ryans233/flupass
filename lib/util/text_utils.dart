import 'dart:math';

class TextUtils {
  static bool hasUppercase(String s) => RegExp(r'[A-Z]').hasMatch(s);

  static bool hasLowercase(String s) => RegExp(r'[a-z]').hasMatch(s);

  static bool hasNumber(String s) => RegExp(r'[0-9]').hasMatch(s);

  static bool isUppercaseOnly(String s) =>
      s.split("").every((element) => hasUppercase(element));

  static bool isLowercaseOnly(String s) =>
      s.split("").every((element) => hasLowercase(element));

  static bool isNumberOnly(String s) =>
      s.split("").every((element) => hasNumber(element));

  static bool isAlphebeticOnly(String s) => s
      .split("")
      .every((element) => isUppercaseOnly(element) || isLowercaseOnly(element));
}
