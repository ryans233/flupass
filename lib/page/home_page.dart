import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flupass/model/app_settings_model.dart';
import 'package:flupass/model/pass_store_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class PassList extends StatelessWidget {
  const PassList({
    Key? key,
    this.singleColumn = true,
  }) : super(key: key);

  final bool singleColumn;

  @override
  Widget build(BuildContext context) {
    var select = context.select((PassStoreModel model) => model.root);
    var relativePath =
        context.select((PassStoreModel model) => model.relativePath);
    var shouldShowTitle =
        (relativePath.isEmpty || relativePath == Platform.pathSeparator);
    var passStoreList = Column(
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
                    onPressed: () =>
                        context.read<PassStoreModel>().navigateToParentFolder(),
                    icon: const Icon(Icons.arrow_upward))),
        Expanded(
          flex: 1,
          child: ListView.builder(
            itemCount: select.length,
            itemBuilder: (_, index) {
              var entry = select[index];
              return ListTile(
                  leading: Icon(
                      (entry is Directory) ? Icons.folder : Icons.file_present),
                  title: Text(basename(entry.path)),
                  onTap: () {
                    if (entry is File) {
                      context.read<PassStoreModel>().decrypt(entry.path);
                      if (singleColumn) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              body: DetailsView(
                                singleColumn,
                              ),
                            ),
                          ),
                        );
                      }
                    } else if (entry is Directory) {
                      context
                          .read<PassStoreModel>()
                          .navigateToFolder(basename(entry.path));
                    }
                  });
            },
          ),
        ),
      ],
    );
    var passStoreDetails = DetailsView(singleColumn);
    return singleColumn
        ? passStoreList
        : Row(
            children: [
              Expanded(
                flex: 2,
                child: passStoreList,
              ),
              Expanded(
                flex: 3,
                child: passStoreDetails,
              )
            ],
          );
  }
}

class DetailsView extends StatefulWidget {
  const DetailsView(
    this.singleColumn, {
    Key? key,
    this.mode = DetailsViewMode.readOnly,
  }) : super(key: key);

  final bool singleColumn;
  final DetailsViewMode mode;

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

enum DetailsViewMode {
  create, // Create a new password.
  modify, // Modify an existing password.
  readOnly, // Read only mode.
}

class _DetailsViewState extends State<DetailsView> {
  bool _obscureText = true;
  late DetailsViewMode mode;

  @override
  void initState() {
    super.initState();
    mode = widget.mode;
  }

  @override
  Widget build(BuildContext context) {
    final text = context.select((PassStoreModel model) => model.details);
    final lines = text.split('\n');
    return text.isEmpty
        ? const Center(child: Text("Empty"))
        : Scaffold(
            appBar: AppBar(
              title: Text(mode.toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                  )),
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
                onPressed: () {
                  if (widget.singleColumn) Navigator.of(context).pop();
                  context.read<PassStoreModel>().clear();
                },
              ),
            ),
            body: lines.isEmpty
                ? const Center(child: Text("No result."))
                : ListView(
                    children: transformToWidgets(lines),
                  ),
          );
  }

  List<Widget> transformToWidgets(List<String> lines) {
    return lines
        .map((line) {
          if (line.isEmpty) {
            return null;
          } else if (lines.indexOf(line) == 0) {
            return Stack(
              children: [
                TextFormField(
                  obscureText: _obscureText,
                  initialValue: line,
                  decoration: const InputDecoration(
                    labelText: "Password",
                  ),
                  readOnly: mode == DetailsViewMode.readOnly,
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
                        icon: Icon(_obscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () =>
                            setState(() => _obscureText = !_obscureText),
                      ),
                    ],
                  ),
                  right: 0,
                ),
              ],
            );
          } else {
            var split = line.split(': ');
            if (split.length == 2) {
              return TextFormField(
                initialValue: split.last,
                decoration: InputDecoration(
                  labelText: split.first,
                ),
                readOnly: mode == DetailsViewMode.readOnly,
              );
            } else {
              return SelectableText(line);
            }
          }
        })
        .where((element) => element != null)
        .map((widget) => ListTile(title: widget))
        .toList();
  }
}
