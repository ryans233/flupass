import 'package:flupass/db/table/app_settings_table.dart';
import 'package:flupass/generated/l10n.dart';
import 'package:flupass/repo/local/preferences_repository.dart';
import 'package:flutter/widgets.dart';

class AppSettingsModel with ChangeNotifier {
  AppSettingsModel(this.settings);

  PreferencesRepository prefRepo = PreferencesRepository.instance;
  AppSettingsTable settings;

  String get appLanguage => settings.appLanguage;

  set appLanguage(String appLanguage) =>
      setSettings(AppSettingsTable.columnAppLanguage, appLanguage);

  String get path => settings.path;

  set path(String path) => setSettings(AppSettingsTable.columnPath, path);

  String get publicKey => settings.publicKey;

  set publicKey(String publicKey) =>
      setSettings(AppSettingsTable.columnPublicKey, publicKey);

  String get privateKey => settings.privateKey;

  set privateKey(String privateKey) =>
      setSettings(AppSettingsTable.columnPrivateKey, privateKey);

  String get passphrase => settings.passphrase;

  set passphrase(String passphrase) =>
      setSettings(AppSettingsTable.columnPassphrase, passphrase);

  setSettings(String key, dynamic value) {
    prefRepo.set(key, value).then((_) => refreshAppSettings());
  }

  refreshAppSettings() async {
    settings = await prefRepo.getSettings();
    notifyListeners();
  }

  setAppLanguage(String newValue) {
    S.load(Locale(newValue));
    appLanguage = newValue;
    notifyListeners();
  }
}
