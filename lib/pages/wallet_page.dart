import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mi_wallet/components/credit_card.dart';
import 'package:mi_wallet/components/loading_widget.dart';
import 'package:mi_wallet/models/credit_card.dart';
import 'package:mi_wallet/utils/values/colors.dart';
import 'package:mi_wallet/utils/values/enums.dart';
import 'package:mi_wallet/viewmodels/credit_card_viewmodel.dart';
import 'package:payment_card/payment_card.dart';
import 'package:provider/provider.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CreditCardViewModel>(builder: (BuildContext context, CreditCardViewModel creditCardViewModel, _) {
        return ConditionalSwitch.single<LoadingStatus>(
          context: context,
          valueBuilder: (BuildContext context) => creditCardViewModel.status,
          caseBuilders: {
            LoadingStatus.busy: (BuildContext context) => const LoadingWidget(),
            LoadingStatus.failed: (BuildContext context) => cardStackList(creditCardViewModel: creditCardViewModel),
            LoadingStatus.idle: (BuildContext context) => cardStackList(creditCardViewModel: creditCardViewModel),
            LoadingStatus.completed: (BuildContext context) => cardStackList(creditCardViewModel: creditCardViewModel),
          },
          fallbackBuilder: (BuildContext context) => const SizedBox(),
        );
      }),
    );
  }

  Widget cardStackList({required CreditCardViewModel creditCardViewModel}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 40.0,
            ),
            Text(
              GlobalConfiguration().getValue<String>('appName'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.green,
                fontSize: 55.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            SizedBox(
              height: 240.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: creditCardViewModel.creditCards.length,
                itemBuilder: (context, index) {
                  CreditCard card = creditCardViewModel.creditCards[index];

                  CardComponent cardWidget;

                  switch (card.cardType) {
                    case CardNetwork.visa:
                      cardWidget = VisaCard(
                        cardNumber: card.cardNumber,
                        validity: card.validity,
                        holder: card.holder,
                        cvv: card.cvv,
                        issuingCountry: card.issuingCountry,
                      );
                      break;
                    case CardNetwork.mastercard:
                      cardWidget = Mastercard(
                        cardNumber: card.cardNumber,
                        validity: card.validity,
                        holder: card.holder,
                        cvv: card.cvv,
                        issuingCountry: card.issuingCountry,
                      );
                      break;
                    case CardNetwork.discover:
                      cardWidget = Discovercard(
                        cardNumber: card.cardNumber,
                        validity: card.validity,
                        holder: card.holder,
                        cvv: card.cvv,
                        issuingCountry: card.issuingCountry,
                      );
                      break;
                    default:
                      cardWidget = UnknownCard(
                        cardNumber: card.cardNumber,
                        validity: card.validity,
                        holder: card.holder,
                        cvv: card.cvv,
                        issuingCountry: card.issuingCountry,
                      );
                  }

                  return cardWidget.buildCard();
                },
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  textColor: AppColors.white,
                  color: AppColors.green,
                  onPressed: () {},
                  child: const Text('Login', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(
                  height: 15.0,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
