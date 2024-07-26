import 'package:payment_card/payment_card.dart';

class CreditCard {
  int cardNumber;
  CardNetwork cardType;
  String holder;
  int cvv;
  String validity;
  String issuingCountry;

  CreditCard({
    required this.cardNumber,
    required this.cardType,
    required this.holder,
    required this.cvv,
    required this.validity,
    required this.issuingCountry,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'cardNumber': cardNumber,
      'cardType': cardType.name,
      'holder': holder,
      'cvv': cvv,
      'issuingCountry': issuingCountry,
      'validity': validity
    };
  }


  factory CreditCard.fromMap(Map<String, dynamic> map) {
    return CreditCard(
      cardNumber: map['cardNumber'],
      cardType: CardNetwork.values.firstWhere((e) => e.name == map['cardType']),
      holder: map['holder'],
      cvv: map['cvv'],
      validity: map['validity'],
      issuingCountry: map['issuingCountry'],
    );
  }
}
