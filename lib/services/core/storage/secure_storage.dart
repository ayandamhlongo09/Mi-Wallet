/// String only key value secure storage
abstract class SecureStorage {
  /// Shortcut for get which allows to call without a method name
  Future<String?> call(String key);

  /// Get stored value
  Future<String?> get(String key);

  /// Get stored value
  Future<bool> containsKey(String key);

  /// Store a value
  Future<void> put(String key, String value);

  /// Remove stored value
  Future<void> remove(String key);

  /// Remove all stored values
  Future<void> clear();
}
