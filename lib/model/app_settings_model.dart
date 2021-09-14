import 'package:flupass/db/table/app_settings_table.dart';
import 'package:flupass/repo/local/preferences_repository.dart';
import 'package:flutter/foundation.dart';

class AppSettingsModel with ChangeNotifier {
  AppSettingsModel() {
    refreshAppSettings();
  }

  PreferencesRepository prefRepo = PreferencesRepository.instance;
  AppSettingsTable settings = AppSettingsTable();

  String get path => settings.path;

  set path(String path) => setSettings(AppSettingsTable.columnPath, path);

  setSettings(String key, dynamic value) {
    prefRepo.set(key, value).then((_) => refreshAppSettings());
  }

  refreshAppSettings() async {
    settings = await prefRepo.getSettings();
    notifyListeners();
  }
}
