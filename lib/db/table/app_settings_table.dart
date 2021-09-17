class AppSettingsTable {
  static const tableName = "app_settings";
  static const columnKey = "key";
  static const columnPath = "path";
  static const columnPrivateKey = "private_key";
  static const columnPublicKey = "public_key";
  static const columnPassphrase = "passphrase";

  int key = 0;
  String path = "";
  String privateKey = "";
  String publicKey = "";
  String passphrase = "";

  AppSettingsTable([
    this.key = 0,
    this.path = "",
    this.privateKey = "",
    this.publicKey = "",
    this.passphrase = "",
  ]);

  AppSettingsTable.fromJson(Map<String, dynamic> json) {
    key = json[columnKey] ?? 0;
    path = json[columnPath] ?? "";
    privateKey = json[columnPrivateKey] ?? "";
    publicKey = json[columnPublicKey] ?? "";
    passphrase = json[columnPassphrase] ?? "";
  }

  Map<String, dynamic> toJson() => {
        columnKey: key,
        columnPath: path,
        columnPrivateKey: privateKey,
        columnPublicKey: publicKey,
        columnPassphrase: passphrase,
      };

  @override
  String toString() {
    return 'AppSettingsTable(key: $key, path: $path, privateKey: $privateKey, publicKey: $publicKey, passphrase: $passphrase)';
  }
}
