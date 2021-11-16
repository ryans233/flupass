import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'table/app_settings_table.dart';

Database? db;

class DbManager {
  DbManager._privateConstructor();

  static final DbManager _instance = DbManager._privateConstructor();

  static DbManager get instance => _instance;

  static const int _databaseVersion = 2;
  static const _databaseName = 'main_db';

  Future<String> getDatabasePath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    if (!await Directory(dirname(path)).exists()) {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDatabase() async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    final path = await getDatabasePath(_databaseName);
    db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        var batch = db.batch();
        createAppSettingsTable(batch);
        await batch.commit();
      },
      onDowngrade: onDatabaseDowngradeDelete,
      onUpgrade: (db, oldVersion, newVersion) async {
        var batch = db.batch();
        if (oldVersion == 1) {
          updateTableAppSettingsV1toV2(batch);
        }
        await batch.commit();
      },
    );
  }

  createAppSettingsTable(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS ${AppSettingsTable.tableName}');
    batch.execute('''CREATE TABLE ${AppSettingsTable.tableName}
    (
      ${AppSettingsTable.columnKey} INTEGER PRIMARY KEY,
      ${AppSettingsTable.columnAppLanguage} TEXT,
      ${AppSettingsTable.columnPath} TEXT,
      ${AppSettingsTable.columnPrivateKey} TEXT,
      ${AppSettingsTable.columnPublicKey} TEXT,
      ${AppSettingsTable.columnPassphrase} TEXT
    )''');
  }

  updateTableAppSettingsV1toV2(Batch batch) {
    batch.execute(
        'ALTER TABLE ${AppSettingsTable.tableName} ADD ${AppSettingsTable.columnAppLanguage} TEXT');
  }
}
