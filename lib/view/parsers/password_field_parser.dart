import 'package:flupass/generated/l10n.dart';
import 'package:flupass/model/pass_detail_model.dart';
import 'package:flupass/page/password_generator_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'field_parser.dart';

class PasswordFieldParser extends FieldParser {
  static const fieldKey = "password";

  @override
  String getFieldKey() => fieldKey;

  @override
  Widget parse(int index, String line, DetailViewMode mode) {
    return PasswordFieldWidget(index, line, mode);
  }
}

class PasswordFieldWidget extends StatefulWidget {
  const PasswordFieldWidget(this.index, this.line, this.mode, {Key? key})
      : super(key: key);

  final int index;
  final String line;
  final DetailViewMode mode;

  @override
  _PasswordFieldWidgetState createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => ListTile(
        title: TextFormField(
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: S.of(context).pagePassDetailPasswordFieldLabel,
          ),
          readOnly: widget.mode == DetailViewMode.readOnly,
          onChanged: (value) =>
              context.read<PassDetailModel>().updatePass(widget.index, value),
          initialValue: widget.line,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.mode == DetailViewMode.readOnly
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.autorenew),
                    onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const PasswordGeneratorPage(needResult: true),
                            ))
                        .then((value) => context
                            .read<PassDetailModel>()
                            .updatePass(widget.index, value)),
                  ),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () =>
                  Clipboard.setData(ClipboardData(text: widget.line)),
            ),
            IconButton(
              icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ],
        ),
      ),
    );
  }
}
