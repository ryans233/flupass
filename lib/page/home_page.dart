import 'dart:io';

import 'package:flupass/model/app_settings_model.dart';
import 'package:flupass/model/pass_detail_model.dart';
import 'package:flupass/model/pass_store_list_model.dart';
import 'package:flupass/page/pass_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../routes.dart';

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
        builder: (context, constraints) =>
            PassList(singleColumn: constraints.maxWidth < _maxColumnWidth),
      ),
    );
  }
}

class PassList extends StatefulWidget {
  const PassList({
    Key? key,
    this.singleColumn = true,
  }) : super(key: key);

  final bool singleColumn;

  @override
  State<PassList> createState() => _PassListState();
}

class _PassListState extends State<PassList> {
  String selectedPassPath = "";

  @override
  Widget build(BuildContext context) {
    var select = context.select((PassStoreListModel model) => model.root);
    var relativePath =
        context.select((PassStoreListModel model) => model.relativePath);
    var shouldShowTitle =
        (relativePath.isEmpty || relativePath == Platform.pathSeparator);
    var passDetail = DetailView(widget.singleColumn);
    var passStoreList = Builder(
      builder: (context) => Column(
        children: [
          AppBar(
              actions: [
                IconButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(Routes.settings),
                    icon: const Icon(Icons.settings))
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
            flex: 1,
            child: ListView.builder(
              itemCount: select.length,
              itemBuilder: (_, index) {
                var entry = select[index];
                return ListTile(
                    leading: Icon((entry is Directory)
                        ? Icons.folder
                        : Icons.file_present),
                    title: Text(basename(entry.path)),
                    onTap: () {
                      if (entry is File) {
                        if (widget.singleColumn) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Material(
                                child: ChangeNotifierProvider(
                                  child: passDetail,
                                  create: (_) => PassDetailModel(
                                      context.read<AppSettingsModel>(),
                                      entry.path),
                                ),
                              ),
                            ),
                          );
                        } else {
                          context.read<PassDetailModel>().decrypt(entry.path);
                        }
                      } else if (entry is Directory) {
                        context
                            .read<PassStoreListModel>()
                            .navigateToFolder(basename(entry.path));
                      }
                    });
              },
            ),
          ),
        ],
      ),
    );
    return widget.singleColumn
        ? passStoreList
        : ChangeNotifierProxyProvider<AppSettingsModel, PassDetailModel>(
            create: (context) => PassDetailModel(
                context.read<AppSettingsModel>(), selectedPassPath),
            update: (context, model, previous) =>
                previous!..onAppSettingsChanged(),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: passStoreList,
                ),
                Expanded(
                  flex: 3,
                  child: passDetail,
                )
              ],
            ),
          );
  }
}
