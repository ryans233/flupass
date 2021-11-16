import 'package:flupass/db/db_manager.dart';
import 'package:flupass/db/table/app_settings_table.dart';
import 'package:flupass/page/page.dart';
import 'package:flupass/repo/local/preferences_repository.dart';
import 'package:flupass/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';
import 'model/app_settings_model.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbManager.instance.initDatabase();
  runApp(MyApp(await PreferencesRepository.instance.getSettings()));
}

class MyApp extends StatelessWidget {
  final AppSettingsTable settings;

  const MyApp(this.settings, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppSettingsModel(settings),
        ),
      ],
      builder: (context, child) => Selector<AppSettingsModel, String>(
        selector: (_, model) => model.appLanguage,
        builder: (context, value, child) {
          final lang = value.split('_');
          Locale locale;
          switch (lang.length) {
            case 1:
              locale = Locale(lang[0]);
              break;
            case 2:
              locale = Locale.fromSubtags(
                  languageCode: lang[0], countryCode: lang[1]);
              break;
            case 3:
              locale = Locale.fromSubtags(
                  languageCode: lang[0],
                  countryCode: lang[1],
                  scriptCode: lang[2]);
              break;
            default:
              locale = const Locale('en');
          }
          return MaterialApp(
            locale: locale,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            title: 'flupass',
            onGenerateTitle: (BuildContext context) => S.of(context).appName,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            navigatorKey: navKey,
            initialRoute: Routes.home,
            routes: {
              Routes.home: (context) => const HomePage(),
              Routes.settings: (context) => const SettingsPage(),
            },
          );
        },
      ),
    );
  }
}
