import 'package:flupass/generated/l10n.dart';
import 'package:flupass/model/pass_detail_model.dart';
import 'package:flupass/view/pass_field_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'field_parser.dart';

class BasicFieldParser extends FieldParser {
  static const fieldKey = "";

  @override
  String getFieldKey() => fieldKey;

  @override
  Widget parse(int index, String line, DetailViewMode mode) {
    return BasicFieldWidget(index, line, mode);
  }
}

class BasicFieldWidget extends StatefulWidget {
  const BasicFieldWidget(this.index, this.line, this.mode, {Key? key})
      : super(key: key);

  final int index;
  final String line;
  final DetailViewMode mode;

  @override
  _BasicFieldWidgetState createState() => _BasicFieldWidgetState();
}

class _BasicFieldWidgetState extends State<BasicFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final split = widget.line.split(PassFieldBuilder.fieldSeparator);
      return ListTile(
        leading: widget.mode == DetailViewMode.readOnly
            ? null
            : IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => context
                    .read<PassDetailModel>()
                    .updatePass(widget.index, null),
              ),
        title: widget.mode == DetailViewMode.readOnly
            ? TextFormField(
                initialValue: split.length == 2 ? split.last : widget.line,
                decoration: InputDecoration(
                  labelText: split.length == 2 && split.first.isNotEmpty
                      ? split.first
                      : S.current.pagePassDetailExtraInfoFieldNoLabel,
                ),
                readOnly: widget.mode == DetailViewMode.readOnly,
              )
            : Column(
                children: [
                  TextFormField(
                    initialValue: split.length == 2 ? split.first : "",
                    decoration: InputDecoration(
                      labelText:
                          S.of(context).pagePassDetailNewExtraInfoEntryHintKey,
                      border: InputBorder.none,
                    ),
                    readOnly: widget.mode == DetailViewMode.readOnly,
                    onChanged: (value) => context
                        .read<PassDetailModel>()
                        .updatePass(widget.index, "$value: ${split.last}"),
                  ),
                  TextFormField(
                    initialValue: split.length == 2 ? split.last : widget.line,
                    decoration: InputDecoration(
                      labelText: S
                          .of(context)
                          .pagePassDetailNewExtraInfoEntryHintValue,
                    ),
                    readOnly: widget.mode == DetailViewMode.readOnly,
                    onChanged: (value) => context
                        .read<PassDetailModel>()
                        .updatePass(widget.index, "${split.first}: $value"),
                  ),
                ],
              ),
      );
    });
  }
}
