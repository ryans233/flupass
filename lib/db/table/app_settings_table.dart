class AppSettingsTable {
  static const tableName = "app_settings";
  static const columnAppLanguage = "app_language";
  static const columnKey = "key";
  static const columnPath = "path";
  static const columnPrivateKey = "private_key";
  static const columnPublicKey = "public_key";
  static const columnPassphrase = "passphrase";

  int key = 0;
  String appLanguage = "en";
  String path = "";
  String privateKey = "";
  String publicKey = "";
  String passphrase = "";

  AppSettingsTable([
    this.key = 0,
    this.appLanguage = "en",
    this.path = "",
    this.privateKey = "",
    this.publicKey = "",
    this.passphrase = "",
  ]);

  AppSettingsTable.fromJson(Map<String, dynamic> json) {
    key = json[columnKey] ?? 0;
    appLanguage = json[columnAppLanguage] ?? "en";
    path = json[columnPath] ?? "";
    privateKey = json[columnPrivateKey] ?? "";
    publicKey = json[columnPublicKey] ?? "";
    passphrase = json[columnPassphrase] ?? "";
  }

  Map<String, dynamic> toJson() => {
        columnKey: key,
        columnAppLanguage: appLanguage,
        columnPath: path,
        columnPrivateKey: privateKey,
        columnPublicKey: publicKey,
        columnPassphrase: passphrase,
      };

  @override
  String toString() {
    return 'AppSettingsTable(key: $key, appLanguage: $appLanguage, path: $path, privateKey: $privateKey, publicKey: $publicKey, passphrase: $passphrase)';
  }
}
