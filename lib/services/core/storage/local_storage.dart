abstract class LocalStorage {
  /// Get stored value
  Future<T> get<T>(String key);

  /// Store a value
  Future<void> put<T>(String key, T value);

  /// Remove stored value
  Future<bool> remove(String key);

  /// Is a certain value stored
  Future<bool> contains(String key);

  /// Check if a specific type is supported
  bool isTypeSupported<T>();

  /// Remove all stored values
  Future<bool> clear();
}
