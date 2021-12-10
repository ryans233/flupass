import 'package:flupass/model/pass_detail_model.dart';
import 'package:flupass/view/parsers/basic_field_parser.dart';
import 'package:flupass/view/parsers/field_parser.dart';
import 'package:flupass/view/parsers/otp_field_parser.dart';
import 'package:flupass/view/parsers/password_field_parser.dart';
import 'package:flutter/widgets.dart';

class PassFieldBuilder {
  static final PassFieldBuilder _singleton = PassFieldBuilder._internal();

  factory PassFieldBuilder() {
    return _singleton;
  }

  PassFieldBuilder._internal() {
    _map.clear();
    _map[PasswordFieldParser.fieldKey] = _passwordFieldParser;
    _map.addAll(
        Map.fromIterable(_extraParsers, key: (parser) => parser.getFieldKey()));
  }

  static final _basicFieldParser = BasicFieldParser();
  static final _passwordFieldParser = PasswordFieldParser();
  static final _extraParsers = [OtpFieldParser()];
  static final _map = <String, FieldParser>{};
  static const fieldSeparator = ':';

  Widget buildFromLine(int index, String line, DetailViewMode mode) {
    if (index == 0) {
      return _passwordFieldParser.parse(index, line, mode);
    } else {
      final split = line.split(fieldSeparator);
      final key = split[0].trim();
      return _map[key]?.parse(index, line, mode) ??
          _basicFieldParser.parse(index, line, mode);
    }
  }
}
