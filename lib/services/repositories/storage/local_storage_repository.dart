import 'package:mi_wallet/models/credit_card.dart';

abstract class LocalStorageRepository {
  Future<List<CreditCard>> getCreditCards();
  Future<void> saveCreditCards(List<CreditCard> creditCards);
  Future<List<String>> getIssueingCountriesList();
  Future<List<String>> getBannedCountries();
  Future<void> saveBannedCountries(List<String> countries);
  Future<void> deleteAllCards();
}
