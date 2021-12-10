import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flupass/generated/l10n.dart';
import 'package:flupass/model/pass_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp/otp.dart';
import 'package:provider/provider.dart';

import 'field_parser.dart';

class OtpFieldParser extends FieldParser {
  static const fieldKey = "otpauth";

  @override
  String getFieldKey() => fieldKey;

  @override
  Widget parse(int index, String line, DetailViewMode mode) {
    return OtpFieldWidget(index, line, mode);
  }
}

class OtpFieldWidget extends StatefulWidget {
  const OtpFieldWidget(this.index, this.line, this.mode, {Key? key})
      : super(key: key);

  final int index;
  final String line;
  final DetailViewMode mode;

  @override
  _OtpFieldWidgetState createState() => _OtpFieldWidgetState();
}

class _OtpFieldWidgetState extends State<OtpFieldWidget> {
  bool _obscure = true;
  final _countDownController = CountDownController();
  final _otpCodeController = TextEditingController();

  @override
  void didUpdateWidget(covariant OtpFieldWidget oldWidget) {
    if (widget.mode == DetailViewMode.readOnly) {
      setState(() {
        _obscure = true;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final uri = Uri.parse(widget.line);
      final scheme = uri.scheme;
      final type = uri.host;
      final name = uri.path.replaceFirst('/', '');
      final secret = uri.queryParameters["secret"];
      final issuer = uri.queryParameters["issuer"];

      return secret != null && secret.isNotEmpty
          ? FutureBuilder<int>(
              future: Future.value(OTP.generateTOTPCode(
                secret,
                DateTime.now().millisecondsSinceEpoch,
                interval: 30,
                length: 6,
                isGoogle: true,
                algorithm: Algorithm.SHA1,
              )),
              builder: (context, snapshot) {
                return buildOtpWidget(
                    snapshot.data?.toString().padLeft(6, '0'));
              },
            )
          : const SizedBox.shrink();
    });
  }

  Widget buildOtpWidget(String? code) {
    if (code == null) {
      return const SizedBox.shrink();
    } else {
      _otpCodeController.text =
          widget.mode == DetailViewMode.readOnly ? code : widget.line;
      return ListTile(
        leading: widget.mode == DetailViewMode.readOnly
            ? null
            : IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => context
                    .read<PassDetailModel>()
                    .updatePass(widget.index, null),
              ),
        title: TextField(
          controller: _otpCodeController,
          obscureText: _obscure,
          decoration: InputDecoration(
            labelText: S.of(context).pagePassDetailOtpFieldLabel,
            border: InputBorder.none,
          ),
          readOnly: widget.mode == DetailViewMode.readOnly,
          onChanged: (value) =>
              context.read<PassDetailModel>().updatePass(widget.index, value),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.mode == DetailViewMode.modify
                ? const SizedBox.shrink()
                : CircularCountDownTimer(
                    controller: _countDownController,
                    initialDuration: DateTime.now().second % 30,
                    duration: 30,
                    width: 30,
                    height: 30,
                    fillColor: Colors.white,
                    ringColor: Colors.blue,
                    textStyle: const TextStyle(
                      color: Colors.blue,
                    ),
                    isReverse: true,
                    onComplete: () =>
                        setState(() => _countDownController.restart()),
                  ),
            widget.mode == DetailViewMode.modify
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () =>
                        Clipboard.setData(ClipboardData(text: code.toString())),
                  ),
            IconButton(
              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ],
        ),
      );
    }
  }
}
