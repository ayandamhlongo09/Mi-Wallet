import 'package:flutter/material.dart';
import 'package:mi_wallet/models/credit_card.dart';
import 'package:mi_wallet/services/repositories/storage/local_storage_repository.dart';
import 'package:mi_wallet/utils/exceptions/wallet_exceptions.dart';
import 'package:mi_wallet/utils/values/enums.dart';
import 'package:mi_wallet/viewmodels/base_viewmodel.dart';
import 'package:payment_card/payment_card.dart';

class CreditCardViewModel extends ChangeNotifier implements BaseViewModel {
  final LocalStorageRepository _localStorageRepository;

  List<CreditCard> _creditCards = [
    // CreditCard(
    //   cardNumber: 1234567890123456,
    //   cardType: CardNetwork.visa,
    //   holder: 'John Doe',
    //   cvv: 123,
    //   validity: '12/25',
    //   issuingCountry: 'USA',
    // ),
    // CreditCard(
    //   cardNumber: 9876543210987654,
    //   cardType: CardNetwork.mastercard,
    //   holder: 'Jane Doe',
    //   cvv: 456,
    //   validity: '06/28',
    //   issuingCountry: 'Canada',
    // )
  ];
  List<String> _issueingCountries = [];
  List<String> _bannedCountries = [];
  LoadingStatus _status = LoadingStatus.idle;
  String? _errorMessage;

  CreditCardViewModel({
    required LocalStorageRepository localStorageRepository,
  }) : _localStorageRepository = localStorageRepository {
    loadCreditCards();
    getIssueingCountries();
    getBannedCountries();
  }

  void loadCreditCards() async {
    _status = LoadingStatus.busy;
    notifyListeners();

    try {
      _creditCards = await _localStorageRepository.getCreditCards();
      _status = LoadingStatus.completed;
      _errorMessage = null;
    } catch (error) {
      _status = LoadingStatus.failed;
      _errorMessage = 'Failed to load credit cards.';
    } finally {
      notifyListeners();
    }
  }

  void addCreditCard(CreditCard card) {
    _status = LoadingStatus.busy;
    notifyListeners();

    try {
      if (!_creditCards.any((c) => c.cardNumber == card.cardNumber)) {
        _creditCards.add(card);
        // Call save method after adding the card
        _saveAllCards();
      } else {
        _status = LoadingStatus.failed;
        _errorMessage = 'Card number already exists.';
        notifyListeners();
      }
    } on CardRetrievalError catch (_) {
      _status = LoadingStatus.failed;
      _errorMessage = 'Error retrieving card.';
      notifyListeners();
    } catch (error) {
      _status = LoadingStatus.failed;
      _errorMessage = 'An unexpected error occurred.';
      notifyListeners();
    }
  }

  void _saveAllCards() {
    _status = LoadingStatus.busy;
    notifyListeners();

    _localStorageRepository.saveCreditCards(_creditCards).then((_) {
      loadCreditCards();
      _status = LoadingStatus.completed;
      _errorMessage = null; // Clear any previous error message
      notifyListeners();
    }).catchError((error) {
      _status = LoadingStatus.failed;
      _errorMessage = 'Failed to save credit cards.';
      notifyListeners();
    });
  }

  CardNetwork getCardType(String cardNumber) {
    if (cardNumber.startsWith(RegExp(r'^4'))) {
      return CardNetwork.visa;
    } else if (cardNumber.startsWith(RegExp(r'^(5[1-5])'))) {
      return CardNetwork.mastercard;
    } else if (cardNumber.startsWith(RegExp(r'^3[47]'))) {
      return CardNetwork.americanExpress;
    } else {
      return CardNetwork.other;
    }
  }

  bool isCountryBanned(String country) {
    return _bannedCountries.contains(country);
  }

  Future<void> getBannedCountries() async {
    try {
      _status = LoadingStatus.busy;
      notifyListeners();
      _bannedCountries = await _localStorageRepository.getBannedCountries();
      _status = LoadingStatus.completed;
      notifyListeners();
    } on BannedCountryRetrievalError catch (_) {
      _status = LoadingStatus.failed;
      notifyListeners();
    } catch (error) {
      _status = LoadingStatus.failed;
      notifyListeners();
    }
  }

  Future<void> getIssueingCountries() async {
    try {
      _status = LoadingStatus.busy;
      notifyListeners();
      _issueingCountries = await _localStorageRepository.getIssueingCountriesList();
      _status = LoadingStatus.completed;
      notifyListeners();
    } on BannedCountryRetrievalError catch (_) {
      _status = LoadingStatus.failed;
      notifyListeners();
    } catch (error) {
      _status = LoadingStatus.failed;
      notifyListeners();
    }
  }

  void deleteAllCards() async {
    _status = LoadingStatus.busy;
    await _localStorageRepository.deleteAllCards();
    _status = LoadingStatus.completed;
    notifyListeners();
  }

  void removeCardByNumber(int cardNumber) {
    _status = LoadingStatus.busy;
    notifyListeners();

    try {
      _creditCards.removeWhere((card) => card.cardNumber == cardNumber);

      _saveAllCards();
      _status = LoadingStatus.completed;
      _errorMessage = null;
      notifyListeners();
    } catch (error) {
      _status = LoadingStatus.failed;
      _errorMessage = 'An unexpected error occurred.';
      notifyListeners();
    }
  }

  @override
  void reset() {
    _creditCards = [];
    _bannedCountries = [];
    _issueingCountries = [];
    _errorMessage = null;
    _status = LoadingStatus.idle;
    notifyListeners();
  }

  List<CreditCard> get creditCards => _creditCards;
  List<String> get issueingCountries => _issueingCountries;
  List<String> get bannedCountries => _bannedCountries;
  LoadingStatus get status => _status;
  String? get errorMessage => _errorMessage;
}
