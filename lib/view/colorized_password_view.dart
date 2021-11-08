import 'package:flupass/util/text_utils.dart';
import 'package:flutter/material.dart';

class ColorizedPasswordView extends StatelessWidget {
  final double fontSize;

  final TextAlign textAlign;

  const ColorizedPasswordView(
    this.password, {
    this.fontSize = 24.0,
    this.textAlign = TextAlign.center,
    Key? key,
  }) : super(key: key);

  final String password;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        RichText(
          text: TextSpan(
            children:
                password.split("").map((e) => colorizePassword(e)).toList(),
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black,
            ),
          ),
          textAlign: textAlign,
        ),
        SelectableText(
          password,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.transparent,
          ),
          textAlign: textAlign,
        ),
      ],
    );
  }

  TextSpan colorizePassword(String e) {
    return TextSpan(
      text: e,
      style: TextStyle(
        color: TextUtils.isNumberOnly(e)
            ? Colors.blue
            : TextUtils.isAlphebeticOnly(e)
                ? Colors.black
                : Colors.red,
      ),
    );
  }
}
