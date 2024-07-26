import 'package:flutter/material.dart';
import 'package:mi_wallet/models/credit_card.dart';
import 'package:mi_wallet/services/repositories/storage/local_storage_repository.dart';
import 'package:mi_wallet/utils/exceptions/wallet_exceptions.dart';
import 'package:mi_wallet/utils/values/enums.dart';
import 'package:mi_wallet/viewmodels/base_viewmodel.dart';
import 'package:payment_card/payment_card.dart';

class CreditCardViewModel extends ChangeNotifier implements BaseViewModel {
  final LocalStorageRepository _localStorageRepository;

  List<CreditCard> _creditCards = [];
  List<String> _bannedCountries = [];
  LoadingStatus _status = LoadingStatus.idle;
  String? _errorMessage;

  CreditCardViewModel({
    required LocalStorageRepository localStorageRepository,
  }) : _localStorageRepository = localStorageRepository {
    loadCreditCards();
    // addCreditCard(CreditCard(
    //   cardNumber: 9876543210987654,
    //   cardType: CardNetwork.mastercard,
    //   holder: 'Jane Doe',
    //   cvv: 456,
    //   validity: '06/28',
    //   issuingCountry: 'Canada',
    // ));

    // deleteAll();
  }

  void loadCreditCards() async {
    _status = LoadingStatus.busy;
    _creditCards = await _localStorageRepository.getCreditCards();
    _status = LoadingStatus.completed;
    notifyListeners();
  }

  void addCreditCard(CreditCard card) {
    _status = LoadingStatus.busy;
    notifyListeners();
    try {
      loadCreditCards();
      if (!_creditCards.any((c) => c.cardNumber == card.cardNumber)) {
        _localStorageRepository.saveCreditCard(card);
        loadCreditCards();
        _status = LoadingStatus.completed;
        notifyListeners();
      } else {
        _status = LoadingStatus.failed;
        _errorMessage = 'Card number already exists.';
        notifyListeners();
      }
    } on CardRetrievalError catch (_) {
      _status = LoadingStatus.failed;
      notifyListeners();
    } catch (error) {
      _status = LoadingStatus.failed;
      notifyListeners();
    }
  }

  String getCardType(String cardNumber) {
    if (cardNumber.startsWith(RegExp(r'^4'))) {
      return 'Visa';
    } else if (cardNumber.startsWith(RegExp(r'^(5[1-5])'))) {
      return 'MasterCard';
    } else if (cardNumber.startsWith(RegExp(r'^3[47]'))) {
      return 'American Express';
    } else {
      return 'Unknown';
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

  void deleteAll() async {
    _status = LoadingStatus.busy;
    await _localStorageRepository.deleteAll();
    _status = LoadingStatus.completed;
    notifyListeners();
  }

  @override
  void reset() {
    _creditCards = [];
    _bannedCountries = [];
    _errorMessage = null;
    _status = LoadingStatus.idle;
    notifyListeners();
  }

  List<CreditCard> get creditCards => _creditCards;
  List<String> get bannedCountries => _bannedCountries;
  LoadingStatus get status => _status;
  String? get errorMessage => _errorMessage;
}
