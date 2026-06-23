import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nike_ecommerce/core/utils/logger.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      log.e('SecureStorage write error', error: e);
    }
  }

  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      log.e('SecureStorage read error', error: e);
      return null;
    }
  }

  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      log.e('SecureStorage delete error', error: e);
    }
  }
}
