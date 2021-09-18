import 'dart:io';

import 'package:flupass/model/app_settings_model.dart';
import 'package:flupass/model/pass_detail_model.dart';
import 'package:flupass/model/pass_store_list_model.dart';
import 'package:flupass/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({
    Key? key,
  }) : super(key: key);

  static const _maxColumnWidth = 500;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool singleColumn = constraints.maxWidth < _maxColumnWidth;
      return Scaffold(
        body: singleColumn
            ? PassListView(singleColumn)
            : ChangeNotifierProxyProvider<AppSettingsModel, PassDetailModel>(
                create: (context) =>
                    PassDetailModel(context.read<AppSettingsModel>()),
                update: (context, model, previous) =>
                    previous!..onAppSettingsChanged(),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: PassListView(singleColumn),
                    ),
                    Expanded(
                      flex: 3,
                      child: PassDetailView(singleColumn),
                    )
                  ],
                ),
              ),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          tooltip: "Create",
          children: [
            SpeedDialChild(
              child: Icon(Icons.file_present),
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              label: 'New pass',
            ),
            SpeedDialChild(
              child: Icon(Icons.folder),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              label: 'New folder',
              onTap: () => showCreateFolderDialog(context),
            ),
          ],
        ),
      );
    });
  }

  showCreateFolderDialog(BuildContext context) {
    final textEditingController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('New folder'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Current path: " +
                        context.read<PassStoreListModel>().relativePath),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Folder name'),
                      controller: textEditingController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid folder name';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Create'),
                  onPressed: () {
                    if (formKey.currentState?.validate() == true) {
                      Navigator.of(context).pop();
                      context
                          .read<PassStoreListModel>()
                          .createFolder(textEditingController.text);
                    }
                  },
                ),
              ],
            ));
  }
}

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
  }
}

class PassDetailView extends StatelessWidget {
  const PassDetailView(
    this.singleColumn, {
    Key? key,
  }) : super(key: key);

  final bool singleColumn;

  @override
  Widget build(BuildContext context) {
    final lines =
        context.select((PassDetailModel model) => model.decryptedLines);
    final mode = context.select((PassDetailModel model) => model.mode);
    final obscureText =
        context.select((PassDetailModel model) => model.obscurePassword);
    var entries = transformToWidgets(context, mode, obscureText, lines);
    if (mode == DetailViewMode.modify) {
      entries.add(ListTile(
        leading: const Icon(Icons.delete),
        onTap: () => context.read<PassDetailModel>().delete(),
        title: const Text(
          "Delete",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    }
    return lines.isEmpty
        ? const Center(child: Text("Empty"))
        : Scaffold(
            appBar: AppBar(
              title: Text(
                mode.toString(),
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(
                  mode == DetailViewMode.modify
                      ? Icons.arrow_back
                      : Icons.close,
                  color: Colors.grey,
                ),
                onPressed: () {
                  if (mode == DetailViewMode.modify) {
                    context
                        .read<PassDetailModel>()
                        .setMode(DetailViewMode.readOnly);
                  } else {
                    if (singleColumn) {
                      Navigator.of(context).pop();
                    }
                    context.read<PassDetailModel>().clear();
                  }
                },
              ),
              actions: [
                mode != DetailViewMode.readOnly
                    ? const SizedBox.shrink()
                    : TextButton(
                        onPressed: () => context
                            .read<PassDetailModel>()
                            .setMode(DetailViewMode.modify),
                        child: Text("Edit".toUpperCase())),
                mode == DetailViewMode.readOnly
                    ? const SizedBox.shrink()
                    : TextButton(
                        onPressed: () => context.read<PassDetailModel>().save(),
                        child: Text("Done".toUpperCase())),
              ],
            ),
            body: lines.isEmpty
                ? const Center(child: Text("No result."))
                : ListView(children: entries),
          );
  }

  List<Widget> transformToWidgets(
          context, mode, obscurePassword, List<String> lines) =>
      lines
          .map((line) {
            var index = lines.indexOf(line);
            if (line.isEmpty) {
              return null;
            } else if (index == 0) {
              return Stack(
                children: [
                  TextFormField(
                    obscureText: obscurePassword,
                    initialValue: line,
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                    readOnly: mode == DetailViewMode.readOnly,
                    onChanged: (value) => lines[0] = value,
                  ),
                  Positioned(
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () =>
                              Clipboard.setData(ClipboardData(text: line)),
                        ),
                        IconButton(
                          icon: Icon(obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => context
                              .read<PassDetailModel>()
                              .toggleObscurePassword(),
                        ),
                      ],
                    ),
                    right: 0,
                  ),
                ],
              );
            } else {
              var split = line.split(': ');
              return TextFormField(
                initialValue: split.length == 2 ? split.last : line,
                decoration: InputDecoration(
                  labelText: split.length == 2 ? split.first : "No Label",
                ),
                readOnly: mode == DetailViewMode.readOnly,
                onChanged: (value) => lines[index] = value,
              );
            }
          })
          .where((element) => element != null)
          .map((widget) => ListTile(title: widget))
          .toList();
}
