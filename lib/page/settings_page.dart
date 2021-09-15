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
        ],
      ),
    );
  }
}
