import 'package:flupass/db/db_manager.dart';
import 'package:flupass/db/table/app_settings_table.dart';
import 'package:sqflite/sqflite.dart';

class PreferencesRepository {
  PreferencesRepository._privateConstructor();

  static final PreferencesRepository _instance =
      PreferencesRepository._privateConstructor();

  static PreferencesRepository get instance => _instance;

  Future<AppSettingsTable> getSettings() async {
    final data = await db?.query(
      AppSettingsTable.tableName,
      where: '${AppSettingsTable.columnKey} = ?',
      whereArgs: [0],
    );
    return data?.isNotEmpty == true
        ? AppSettingsTable.fromJson(data![0])
        : AppSettingsTable();
  }

  Future<void> set(String key, dynamic value) async {
    final appSettings = await getSettings();
    await db?.insert(
        AppSettingsTable.tableName, appSettings.toJson()..[key] = value,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
