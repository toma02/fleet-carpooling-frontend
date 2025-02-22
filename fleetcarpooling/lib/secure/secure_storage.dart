import 'package:flutter_secure_storage/flutter_secure_storage.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

class SecureStorage {
  final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

  Future<void> addPasswordAndEmail(String password, String email) async {
    await storage.write(key: "password", value: password);
    await storage.write(key: "email", value: email);
  }

  Future<String?> readPassword() async {
    return await storage.read(key: "password");
  }

  Future<String?> readEmail() async {
    return await storage.read(key: "email");
  }
}
