import 'dart:io';

import 'package:flupass/generated/l10n.dart';
import 'package:flupass/model/app_settings_model.dart';
import 'package:flupass/model/pass_detail_model.dart';
import 'package:flupass/model/pass_store_list_model.dart';
import 'package:flupass/view/pass_detail_view.dart';
import 'package:flupass/view/pass_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../routes.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  static const _maxColumnWidth = 600;
  static const _minColumnWidth = 400;
  double width = 400.0;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProxyProvider<AppSettingsModel, PassStoreListModel>(
            create: (BuildContext context) =>
                PassStoreListModel(context.read<AppSettingsModel>()),
            update: (context, value, previous) =>
                previous!..onAppSettingsChanged(),
          ),
          ChangeNotifierProxyProvider<AppSettingsModel, PassDetailModel>(
            create: (context) =>
                PassDetailModel(context.read<AppSettingsModel>()),
            update: (context, model, previous) =>
                previous!..onAppSettingsChanged(),
          ),
        ],
        builder: (context, child) => LayoutBuilder(
          builder: (context, constraints) {
            bool singleColumn = constraints.maxWidth < _maxColumnWidth ||
                constraints.maxWidth < constraints.maxHeight ||
                constraints.maxWidth - width < _minColumnWidth;
            return Scaffold(
              body: singleColumn
                  ? PassListView((File file) {
                      context.read<PassDetailModel>().open(file.path);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: context.read<PassDetailModel>(),
                            builder: (context, child) => PassDetailView(() {
                              Navigator.of(context).pop();
                              context.read<PassDetailModel>().clear();
                            }),
                          ),
                        ),
                      );
                    })
                  : Row(
                      children: [
                        SizedBox(
                          width: width,
                          child: PassListView((File file) {
                            context.read<PassDetailModel>().open(file.path);
                          }),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.resizeColumn,
                          child: GestureDetector(
                            child: Container(
                              height: double.infinity,
                              color: Colors.grey[100],
                              child: const Center(
                                child: Icon(
                                  Icons.drag_indicator,
                                  size: 12,
                                ),
                              ),
                            ),
                            onHorizontalDragUpdate: (details) => setState(() {
                              if (details.globalPosition.dx <=
                                      constraints.maxWidth - _minColumnWidth &&
                                  details.globalPosition.dx >=
                                      _minColumnWidth) {
                                width = details.globalPosition.dx;
                              }
                            }),
                          ),
                        ),
                        Expanded(
                          child: PassDetailView(
                              () => context.read<PassDetailModel>().clear()),
                        )
                      ],
                    ),
              floatingActionButton: SpeedDial(
                icon: Icons.apps,
                tooltip: S.of(context).pageLibraryDialMore,
                children: [
                  SpeedDialChild(
                    child: const Icon(Icons.settings),
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    label: S.of(context).pageLibraryDialActionSettings,
                    onTap: () =>
                        Navigator.of(context).pushNamed(Routes.settings),
                  ),
                ],
              ),
            );
          },
        ),
      );
}
