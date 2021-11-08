import 'dart:io';

import 'package:flupass/model/app_settings_model.dart';
import 'package:flupass/model/pass_detail_model.dart';
import 'package:flupass/model/pass_store_list_model.dart';
import 'package:flupass/page/page.dart';
import 'package:flupass/routes.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'pass_detail_view.dart';

class PassListView extends StatelessWidget {
  const PassListView(
    this.singleColumn, {
    Key? key,
  }) : super(key: key);

  final bool singleColumn;

  @override
  Widget build(BuildContext context) {
    var root = context.select((PassStoreListModel model) => model.root);
    var relativePath =
        context.select((PassStoreListModel model) => model.relativePath);
    var shouldShowTitle =
        (relativePath.isEmpty || relativePath == Platform.pathSeparator);
    return Builder(
      builder: (context) => Column(
        children: [
          AppBar(
              actions: [
                IconButton(
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const PasswordGeneratorPage(
                                  needResult: false,
                                ))),
                    icon: const Icon(Icons.autorenew)),
                IconButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(Routes.settings),
                    icon: const Icon(Icons.settings)),
              ],
              title: Text(shouldShowTitle ? 'flupass' : relativePath),
              leading: shouldShowTitle
                  ? const SizedBox.shrink()
                  : IconButton(
                      onPressed: () => context
                          .read<PassStoreListModel>()
                          .navigateToParentFolder(),
                      icon: const Icon(Icons.arrow_upward))),
          Expanded(
            child: ListView.builder(
              itemCount: root.length,
              itemBuilder: (_, index) {
                var entry = root[index];
                return ListTile(
                    leading: Icon((entry is Directory)
                        ? Icons.folder
                        : Icons.file_present),
                    title: Text(basename(entry.path)),
                    onTap: () {
                      if (entry is File) {
                        if (singleColumn) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Material(
                                child: ChangeNotifierProvider(
                                  child: PassDetailView(singleColumn),
                                  create: (_) => PassDetailModel(
                                      context.read<AppSettingsModel>(),
                                      selectedPassPath: entry.path),
                                ),
                              ),
                            ),
                          );
                        } else {
                          context.read<PassDetailModel>().open(entry.path);
                        }
                      } else if (entry is Directory) {
                        context
                            .read<PassStoreListModel>()
                            .navigateToFolder(entry.path);
                      }
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
