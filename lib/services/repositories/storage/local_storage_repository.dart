import 'package:mi_wallet/models/credit_card.dart';

abstract class LocalStorageRepository {
  Future<List<CreditCard>> getCreditCards();
  Future<void> saveCreditCard(CreditCard card);
  Future<List<String>> getBannedCountries();
  Future<void> saveBannedCountries(List<String> countries);
  Future<void> deleteAll();
}
