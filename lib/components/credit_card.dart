import 'package:flutter/material.dart';
import 'package:payment_card/payment_card.dart';

abstract class CardComponent {
  final int cardNumber;
  final CardNetwork cardType;
  final String holder;
  final int cvv;
  final String validity;
  final String issuingCountry;

  CardComponent(
      {required this.cardNumber,
      required this.cardType,
      required this.holder,
      required this.cvv,
      required this.validity,
      required this.issuingCountry});

  Widget buildCard();
}

class VisaCard extends CardComponent {
  VisaCard({required cardNumber, required validity, required holder, required cvv, required issuingCountry})
      : super(
          cardNumber: cardNumber,
          cardType: CardNetwork.visa,
          holder: holder,
          cvv: cvv,
          validity: validity,
          issuingCountry: issuingCountry,
        );

  @override
  Widget buildCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PaymentCard(
        cardIssuerIcon: const CardIcon(icon: Icons.credit_card),
        backgroundColor: Colors.blue,
        backgroundGradient: const LinearGradient(
          colors: [Colors.purple, Colors.indigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        currency: const Text('EUR'),
        cardNumber: cardNumber.toString(),
        validity: validity,
        holder: holder,
        isStrict: false,
        cardNetwork: CardNetwork.visa,
        cardTypeTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        cardNumberStyles: CardNumberStyles.darkStyle4,
        backgroundImage: null,
      ),
    );
  }
}

class Mastercard extends CardComponent {
  Mastercard({required cardNumber, required validity, required holder, required cvv, required issuingCountry})
      : super(
          cardNumber: cardNumber,
          cardType: CardNetwork.mastercard,
          holder: holder,
          cvv: cvv,
          validity: validity,
          issuingCountry: issuingCountry,
        );

  @override
  Widget buildCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PaymentCard(
        cardIssuerIcon: const CardIcon(icon: Icons.credit_card),
        backgroundColor: Colors.red,
        backgroundGradient: const LinearGradient(
          colors: [Colors.orange, Colors.yellow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        currency: const Text('EUR'),
        cardNumber: cardNumber.toString(),
        validity: validity,
        holder: holder,
        isStrict: false,
        cardNetwork: CardNetwork.mastercard,
        cardTypeTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        cardNumberStyles: CardNumberStyles.darkStyle4,
        backgroundImage: null,
      ),
    );
  }
}

class Discovercard extends CardComponent {
  Discovercard({required cardNumber, required validity, required holder, required cvv, required issuingCountry})
      : super(
          cardNumber: cardNumber,
          cardType: CardNetwork.discover,
          holder: holder,
          cvv: cvv,
          validity: validity,
          issuingCountry: issuingCountry,
        );

  @override
  Widget buildCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PaymentCard(
        cardIssuerIcon: const CardIcon(icon: Icons.credit_card),
        backgroundColor: Colors.red,
        backgroundGradient: const LinearGradient(
          colors: [Colors.orange, Colors.yellow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        currency: const Text('EUR'),
        cardNumber: cardNumber.toString(),
        validity: validity,
        holder: holder,
        isStrict: false,
        cardNetwork: CardNetwork.discover,
        cardTypeTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        cardNumberStyles: CardNumberStyles.darkStyle4,
        backgroundImage: null,
      ),
    );
  }
}

class UnknownCard extends CardComponent {
  UnknownCard({required cardNumber, required validity, required holder, required cvv, required issuingCountry})
      : super(
          cardNumber: cardNumber,
          cardType: CardNetwork.other,
          holder: holder,
          cvv: cvv,
          validity: validity,
          issuingCountry: issuingCountry,
        );

  @override
  Widget buildCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PaymentCard(
        cardIssuerIcon: const CardIcon(icon: Icons.credit_card),
        backgroundColor: Colors.grey,
        backgroundGradient: null,
        currency: const Text('EUR'),
        cardNumber: cardNumber.toString(),
        validity: validity,
        holder: holder,
        isStrict: false,
        cardNetwork: CardNetwork.other,
        cardTypeTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        cardNumberStyles: CardNumberStyles.darkStyle4,
        backgroundImage: null,
      ),
    );
  }
}
