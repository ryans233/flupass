class AppSettingsTable {
  static const tableName = "app_settings";
  static const columnKey = "key";

  int key = 0;

  AppSettingsTable.fromJson(Map<String, dynamic> json) {
    key = json[columnKey];
  }

  Map<String, dynamic> toJson() => {
        columnKey: key,
      };

  @override
  String toString() => 'AppSettings(key: $key)';
}
