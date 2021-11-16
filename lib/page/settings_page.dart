import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flupass/generated/l10n.dart';
import 'package:flupass/model/app_settings_model.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).pageSettingsTitle),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(S.of(context).pageSettingsSettingEntryAppLanguageTitle),
            trailing: DropdownButton<String>(
              value:
                  context.select((AppSettingsModel model) => model.appLanguage),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  context.read<AppSettingsModel>().setAppLanguage(newValue);
                }
              },
              items: [
                DropdownMenuItem(
                  value: "en",
                  child: Text(S
                      .of(context)
                      .pageSettingsSettingEntryAppLanguageValueEnglish),
                ),
                DropdownMenuItem(
                  value: "zh_Hans_CN",
                  child: Text(S
                      .of(context)
                      .pageSettingsSettingEntryAppLanguageValueSimplifiedChinese),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(S
                .of(context)
                .pageSettingsSettingEntryPassStoreLibraryLocationTitle),
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
            title: Text(S.of(context).pageSettingsSettingEntryPrivateKeyTitle),
            subtitle: Text(context
                    .select((AppSettingsModel model) => model.privateKey)
                    .isEmpty
                ? S.of(context).pageSettingsSettingEntryValueUnset
                : S.of(context).pageSettingsSettingEntryValueSet),
            onTap: () async {
              final result = await FilePicker.platform
                  .pickFiles(allowedExtensions: ["asc"]);
              if (result != null) {
                final path = result.files.first.path;
                if (path == null) return;
                context.read<AppSettingsModel>().privateKey =
                    await File(path).readAsString();
              } else {
                // User canceled the picker
              }
            },
          ),
          ListTile(
            title: Text(S.of(context).pageSettingsSettingEntryPublicKeyTitle),
            subtitle: Text(context
                    .select((AppSettingsModel model) => model.publicKey)
                    .isEmpty
                ? S.of(context).pageSettingsSettingEntryValueUnset
                : S.of(context).pageSettingsSettingEntryValueSet),
            onTap: () async {
              final result = await FilePicker.platform
                  .pickFiles(allowedExtensions: ["asc"]);
              if (result != null) {
                final path = result.files.first.path;
                if (path == null) return;
                context.read<AppSettingsModel>().publicKey =
                    await File(path).readAsString();
              } else {
                // User canceled the picker
              }
            },
          ),
          ListTile(
            title: Text(S.of(context).pageSettingsSettingEntryPassphraseTitle),
            subtitle: Text(context
                    .select((AppSettingsModel model) => model.passphrase)
                    .isEmpty
                ? S.of(context).pageSettingsSettingEntryValueUnset
                : S.of(context).pageSettingsSettingEntryValueSet),
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) {
                  final controller = TextEditingController();
                  return AlertDialog(
                    title: Text(S.of(context).dialogEnterPassphraseTitle),
                    content: (TextField(
                      controller: controller,
                    )),
                    actions: [
                      TextButton(
                        child:
                            Text(S.of(context).dialogEnterPassphraseButtonOk),
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
          FutureBuilder<PackageInfo>(
            builder: (context, snapshot) => snapshot.hasData
                ? ListTile(
                    title: Text(
                        S.of(context).pageSettingsSettingEntryVersionTitle),
                    subtitle: Text(snapshot.data?.version.toString() ?? ""),
                    onTap: () => showAboutDialog(
                      context: context,
                      applicationVersion: snapshot.data?.version.toString(),
                    ),
                  )
                : const SizedBox.shrink(),
            future: PackageInfo.fromPlatform(),
          )
        ],
      ),
    );
  }
}
