import 'dart:convert';

import 'package:mi_wallet/models/credit_card.dart';
import 'package:mi_wallet/services/datasources/storage/local_storage_data_source.dart';
import 'package:mi_wallet/services/repositories/storage/local_storage_repository.dart';

class LocalStorageRepositoryImpl implements LocalStorageRepository {
  final LocalStorageDataSource localStorageDataSource;

  LocalStorageRepositoryImpl({required this.localStorageDataSource});

  @override
  Future<List<CreditCard>> getCreditCards() async {
    String? encodedCards = await localStorageDataSource.getCreditCards();
    if (encodedCards == null || encodedCards.isEmpty) {
      return [];
    }
    List<dynamic> cardList = json.decode(encodedCards);
    return cardList.map((card) => CreditCard.fromMap(card)).toList();
  }

  @override
  Future<void> saveCreditCard(CreditCard card) async {
    List<CreditCard> cards = await getCreditCards();
    cards.add(card);
    String encodedCards = jsonEncode(cards.map((card) => card.toMap()).toList());
    await localStorageDataSource.saveCreditCard(encodedCards);
  }

  @override
  Future<List<String>> getBannedCountries() async {
    final result = await localStorageDataSource.getBannedCountries();
    if (result == null || result.isEmpty) {
      return [];
    }
    final List<dynamic> jsonList = json.decode(result);
    final List<String> bannedCountriesList = List<String>.from(jsonList);
    return bannedCountriesList;
  }

  @override
  Future<void> saveBannedCountries(List<String> countries) async {
    final String jsonString = json.encode(countries.map((location) => location).toList());
    return localStorageDataSource.saveBannedCountries(jsonString);
  }

  @override
  Future<void> deleteAll() async {
    await localStorageDataSource.saveCreditCard("");
  }
}
