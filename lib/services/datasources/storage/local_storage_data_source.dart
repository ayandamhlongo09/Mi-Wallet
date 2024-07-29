abstract class LocalStorageDataSource {
  Future<String?> getCreditCards();
  Future<void> saveCreditCard(String encodedCards);
  Future<List<String>> getIssueingCountriesList();
  Future<String?> getBannedCountries();
  Future<void> saveBannedCountries(String jsonString);
  Future<void> deleteAllCards();
}
