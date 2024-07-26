import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mi_wallet/services/core/storage/secure_storage.dart';

class SecureStorageImpl implements SecureStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<String?> call(String key) {
    return get(key);
  }

  @override
  Future<void> clear() {
    return _secureStorage.deleteAll();
  }

  @override
  Future<String?> get(String key) {
    return _secureStorage.read(key: key);
  }

  @override
  Future<bool> containsKey(String key) {
    return _secureStorage.containsKey(key: key);
  }

  @override
  Future<void> put(String key, String value) {
    return _secureStorage.write(key: key, value: value);
  }

  @override
  Future<void> remove(String key) {
    return _secureStorage.delete(key: key);
  }
}
