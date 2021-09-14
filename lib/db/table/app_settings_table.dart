class AppSettingsTable {
  static const tableName = "app_settings";
  static const columnKey = "key";
  static const columnPath = "path";

  int key = 0;
  String path = "";

  AppSettingsTable([
    this.key = 0,
    this.path = "",
  ]);

  AppSettingsTable.fromJson(Map<String, dynamic> json) {
    key = json[columnKey];
    path = json[columnPath];
  }

  Map<String, dynamic> toJson() => {
        columnKey: key,
        columnPath: path,
      };

  @override
  String toString() => 'AppSettings(key: $key, path: $path)';
}
