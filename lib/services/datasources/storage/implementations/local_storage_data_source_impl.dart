import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mi_wallet/services/core/storage/local_storage.dart';
import 'package:mi_wallet/services/core/storage/secure_storage.dart';
import 'package:mi_wallet/services/datasources/storage/local_storage_data_source.dart';

class LocalStorageDataSourceImpl extends LocalStorageDataSource {
  static const String _creditCardKey = "CREDIT_CARDS";
  static const String _bannedCountryListKey = "BANNED_COUNTRIES";

  final LocalStorage localStorage;
  final SecureStorage secureStorage;
  LocalStorageDataSourceImpl({
    required this.localStorage,
    required this.secureStorage,
  });

  @override
  Future<String?> getCreditCards() async {
    return await secureStorage.get(_creditCardKey);
  }

  @override
  Future<void> saveCreditCard(String encodedCards) async {
    await secureStorage.put(_creditCardKey, encodedCards);
  }

  @override
  Future<List<String>> getIssueingCountriesList() async {
    final String response = await rootBundle.loadString('assets/countries.json');
    final List<dynamic> data = json.decode(response);
    return data.map((item) => item as String).toList();
  }

  @override
  Future<String?> getBannedCountries() async {
    return await localStorage.get<String?>(_bannedCountryListKey);
  }

  @override
  Future<void> saveBannedCountries(String jsonString) async {
    return await localStorage.put<String?>(_bannedCountryListKey, jsonString);
  }

  @override
  Future<void> deleteAll() async {
    await secureStorage.clear();
  }
}
