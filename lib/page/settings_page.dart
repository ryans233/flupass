import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flupass/model/app_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Pass store library location'),
            subtitle:
                Text(context.select((AppSettingsModel model) => model.path)),
            onTap: () async {
              final result = await FilePicker.platform.getDirectoryPath();
              if (result != null) {
                context.read<AppSettingsModel>().path = result;
              } else {
                // User canceled the picker
              }
            },
          ),
          ListTile(
            title: const Text('Private key'),
            subtitle: Text(context
                    .select((AppSettingsModel model) => model.privateKey)
                    .isEmpty
                ? "Unset"
                : "Set"),
            onTap: () async {
              final result = await FilePicker.platform
                  .pickFiles(allowedExtensions: ["asc"]);
              if (result != null) {
                context.read<AppSettingsModel>().privateKey =
                    await File(result.files.first.path).readAsString();
              } else {
                // User canceled the picker
              }
            },
          ),
          ListTile(
            title: const Text('Passphrase'),
            subtitle: Text(context
                    .select((AppSettingsModel model) => model.passphrase)
                    .isEmpty
                ? "Unset"
                : "Set"),
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) {
                  final controller = TextEditingController();
                  return AlertDialog(
                    title: const Text("Input your passphrase"),
                    content: (TextField(
                      controller: controller,
                    )),
                    actions: [
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () {
                          context.read<AppSettingsModel>().passphrase =
                              controller.text;
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
