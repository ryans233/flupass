import 'package:flupass/model/app_settings_model.dart';
import 'package:flupass/model/pass_detail_model.dart';
import 'package:flupass/model/pass_store_list_model.dart';
import 'package:flupass/view/pass_detail_view.dart';
import 'package:flupass/view/pass_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
              onTap: () => showCreatePassDialog(context),
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

  showCreatePassDialog(BuildContext context) {
    final textEditingController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('New pass'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Pass name',
                        helperText: 'Filename would be end up with .gpg',
                      ),
                      controller: textEditingController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid pass name';
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
                          .createPassFile(textEditingController.text);
                    }
                  },
                ),
              ],
            ));
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
                          .createPassFile(textEditingController.text);
                    }
                  },
                ),
              ],
            ));
  }
}
