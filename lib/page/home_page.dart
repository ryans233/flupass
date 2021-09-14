import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flupass/model/app_settings_model.dart';
import 'package:flupass/model/pass_store_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _maxColumnWidth = 500;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => PassList(
            singleColumn: constraints.maxWidth < _maxColumnWidth + 300),
      ),
    );
  }
}

class PassList extends StatelessWidget {
  static const _maxColumnWidth = 500.0;

  const PassList({
    Key? key,
    this.singleColumn = true,
  }) : super(key: key);

  final bool singleColumn;

  @override
  Widget build(BuildContext context) {
    var select = context.select((PassStoreModel model) => model.root);
    var sizedBox = SizedBox(
      width: singleColumn ? double.infinity : _maxColumnWidth,
      height: double.infinity,
      child: Column(
        children: [
          AppBar(
            actions: [
              IconButton(
                  onPressed: () async {
                    final result = await FilePicker.platform.getDirectoryPath();
                    if (result != null) {
                      context.read<AppSettingsModel>().path = result;
                    } else {
                      // User canceled the picker
                    }
                  },
                  icon: const Icon(Icons.settings))
            ],
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: select.length,
              itemBuilder: (_, index) => ListTile(
                title: Text("[${select[index] is File}]${select[index].path}"),
              ),
            ),
          ),
        ],
      ),
    );
    return singleColumn
        ? sizedBox
        : Row(
            children: [sizedBox, Text("Detail")],
          );
  }
}
