import 'package:flupass/db/db_manager.dart';
import 'package:flupass/model/pass_store_model.dart';
import 'package:flupass/page/page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/app_settings_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbManager.instance.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppSettingsModel(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<AppSettingsModel, PassStoreModel>(
          create: (BuildContext context) =>
              PassStoreModel(context.read<AppSettingsModel>()),
          update: (context, value, previous) =>
              previous!..onAppSettingsChanged(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'flupass',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
