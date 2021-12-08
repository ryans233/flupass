import 'package:flupass/model/pass_detail_model.dart';
import 'package:flutter/widgets.dart';

abstract class FieldParser {
  Widget parse(int index, String line, DetailViewMode mode);

  String getFieldKey();
}
