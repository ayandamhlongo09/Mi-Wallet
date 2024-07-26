class CardRetrievalError implements Exception {
  final String responseBody;
  CardRetrievalError([this.responseBody = "Failed to retrieve loaded cards!"]);

  @override
  String toString() => responseBody;
}

class BannedCountryRetrievalError implements Exception {
  final String responseBody;
  BannedCountryRetrievalError([this.responseBody = "Failed to retrieve banned countries!"]);

  @override
  String toString() => responseBody;
}
