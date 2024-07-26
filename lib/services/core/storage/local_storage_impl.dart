import 'dart:async';
import 'package:mi_wallet/services/core/storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageImpl implements LocalStorage {
  SharedPreferences? _prefs;

  Future<SharedPreferences?> _getFreshSharedPreferences() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    } else {
      await _prefs!.reload();
    }
    return _prefs;
  }

  @override
  get<T>(String key) async {
    assert(isTypeSupported<T>(), "Type ${T.toString()} is is not supported, try a different type.");

    SharedPreferences? prefs = await (_getFreshSharedPreferences());
    if (_typesEqual<T, double?>()) {
      return prefs!.getDouble(key) as T;
    } else if (_typesEqual<T, bool?>()) {
      return prefs!.getBool(key) as T;
    } else if (_typesEqual<T, int?>()) {
      return prefs!.getInt(key) as T;
    } else if (_typesEqual<T, String?>()) {
      return prefs!.getString(key) as T;
    } else if (_typesEqual<T, List<String>?>()) {
      prefs!.getStringList(key);
    }
    return prefs!.get(key) as T;
  }

  @override
  Future<void> put<T>(String key, T value) async {
    assert(isTypeSupported<T>(), "Type ${T.toString()} is is not supported, try a different type.");

    SharedPreferences? prefs = await _getFreshSharedPreferences();
    if (_typesEqual<T, bool?>()) {
      await prefs!.setBool(key, value as bool);
    } else if (_typesEqual<T, double?>()) {
      await prefs!.setDouble(key, value as double);
    } else if (_typesEqual<T, int?>()) {
      await prefs!.setInt(key, value as int);
    } else if (_typesEqual<T, String?>()) {
      await prefs!.setString(key, value as String);
    } else if (_typesEqual<T, List<String>?>()) {
      await prefs!.setStringList(key, value as List<String>);
    }
    return;
  }

  bool _typesEqual<T1, T2>() => T1 == T2;

  @override
  bool isTypeSupported<T>() {
    return _typesEqual<T, bool?>() ||
        _typesEqual<T, double?>() ||
        _typesEqual<T, int?>() ||
        _typesEqual<T, String?>() ||
        _typesEqual<T, List<String>?>();
  }

  @override
  Future<bool> remove(String key) async {
    SharedPreferences? prefs = await (_getFreshSharedPreferences());
    return prefs!.remove(key);
  }

  @override
  Future<bool> clear() async {
    SharedPreferences? prefs = await (_getFreshSharedPreferences());
    return prefs!.clear();
  }

  @override
  Future<bool> contains(String key) async {
    SharedPreferences? prefs = await (_getFreshSharedPreferences());
    return prefs!.containsKey(key);
  }
}
