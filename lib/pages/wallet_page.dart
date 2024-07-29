import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:go_router/go_router.dart';
import 'package:mi_wallet/components/credit_card.dart';
import 'package:mi_wallet/components/loading_widget.dart';
import 'package:mi_wallet/models/credit_card.dart';
import 'package:mi_wallet/models/transaction.dart';
import 'package:mi_wallet/router/router.dart';
import 'package:mi_wallet/utils/values/colors.dart';
import 'package:mi_wallet/utils/values/enums.dart';
import 'package:mi_wallet/viewmodels/credit_card_viewmodel.dart';
import 'package:payment_card/payment_card.dart';
import 'package:provider/provider.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    return Scaffold(
      body: Consumer<CreditCardViewModel>(builder: (BuildContext context, CreditCardViewModel creditCardViewModel, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (creditCardViewModel.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(creditCardViewModel.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
        return ConditionalSwitch.single<LoadingStatus>(
          context: context,
          valueBuilder: (BuildContext context) => creditCardViewModel.status,
          caseBuilders: {
            LoadingStatus.busy: (BuildContext context) => const LoadingWidget(),
            LoadingStatus.failed: (BuildContext context) => cardStackList(creditCardViewModel: creditCardViewModel, context: context),
            LoadingStatus.idle: (BuildContext context) => cardStackList(creditCardViewModel: creditCardViewModel, context: context),
            LoadingStatus.completed: (BuildContext context) => cardStackList(creditCardViewModel: creditCardViewModel, context: context),
          },
          fallbackBuilder: (BuildContext context) => const SizedBox(),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).pushNamed(AppRoutes.addCard);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget cardStackList({required CreditCardViewModel creditCardViewModel, required BuildContext context}) {
    List<Transaction> transactions = [
      Transaction(date: "2024-07-01", description: "Grocery Store", amount: -50.25),
      Transaction(date: "2024-07-02", description: "Online Shopping", amount: -120.75),
      Transaction(date: "2024-07-03", description: "Salary", amount: 1500.00),
      Transaction(date: "2024-07-04", description: "Restaurant", amount: -45.50),
    ];

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                height: 50.0,
              ),
              creditCardViewModel.creditCards.isNotEmpty
                  ? SizedBox(
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
                      ))
                  : const Text(
                      "No Cards To Show",
                      style: TextStyle(color: Colors.grey),
                    ),
              const SizedBox(
                height: 30.0,
              ),
              MaterialButton(
                textColor: AppColors.white,
                color: AppColors.green,
                onPressed: () {
                  creditCardViewModel.addCreditCard(CreditCard(
                    cardNumber: 9876543210987654,
                    cardType: CardNetwork.mastercard,
                    holder: 'Jane Doe',
                    cvv: 456,
                    validity: '06/28',
                    issuingCountry: 'Canada',
                  ));
                },
                child: const Text('Add New Card +', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Recent Transactions",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        return TransactionWidget(transaction: transactions[index]);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionWidget extends StatelessWidget {
  final Transaction transaction;

  const TransactionWidget({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          transaction.amount < 0 ? Icons.arrow_downward : Icons.arrow_upward,
          color: transaction.amount < 0 ? Colors.red : Colors.green,
        ),
        title: Text(transaction.description),
        subtitle: Text(transaction.date),
        trailing: Text(
          "${transaction.amount < 0 ? "-" : "+"}\$${transaction.amount.abs().toStringAsFixed(2)}",
          style: TextStyle(
            color: transaction.amount < 0 ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
