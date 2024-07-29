import 'package:flutter/material.dart';
import 'package:mi_wallet/models/credit_card.dart';
import 'package:mi_wallet/utils/values/colors.dart';
import 'package:mi_wallet/viewmodels/credit_card_viewmodel.dart';
import 'package:provider/provider.dart';

class ManageWalletPage extends StatelessWidget {
  ManageWalletPage({super.key});

  final TextEditingController _countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String? _selectedCountry;

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Manage Your Wallet',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.green,
        ),
        body: Consumer<CreditCardViewModel>(builder: (context, creditCardViewModel, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "All Cards",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: creditCardViewModel.creditCards.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: creditCardViewModel.creditCards.length,
                            itemBuilder: (context, index) {
                              CreditCard card = creditCardViewModel.creditCards[index];
                              return CardListItem(
                                card: card,
                                onDelete: () {
                                  creditCardViewModel.removeCardByNumber(card.cardNumber);
                                },
                                onDeactivate: () {
                                  // creditCardViewModel.deactivateCreditCard(card);
                                },
                              );
                            },
                          )
                        : const Text(
                            "No Cards To Show",
                            style: TextStyle(color: Colors.grey),
                          ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Delete All Cards'),
                            content: const Text('Are you sure you want to delete all credit cards? This action cannot be undone.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('No'),
                              ),
                            ],
                          );
                        },
                      );

                      if (shouldDelete == true) {
                        creditCardViewModel.deleteAllCards();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Delete All Cards'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Disclaimer: Deleting all cards is irreversible and will remove all credit card information from the app.',
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1.0,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Banned Countries',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Consumer<CreditCardViewModel>(
                  //   builder: (context, creditCardViewModel, _) {
                  //     return ListView.builder(
                  //       shrinkWrap: true, // Use this to prevent overflow
                  //       itemCount: creditCardViewModel.bannedCountries.length,
                  //       itemBuilder: (context, index) {
                  //         final country = creditCardViewModel.bannedCountries[index];
                  //         return ListTile(
                  //           title: Text(country),
                  //           trailing: IconButton(
                  //             icon: const Icon(Icons.delete),
                  //             onPressed: () {
                  //               // creditCardViewModel.removeBannedCountry(country);
                  //             },
                  //           ),
                  //         );
                  //       },
                  //     );
                  //   },
                  // )

                  DropdownButtonFormField<String>(
                    value: _selectedCountry,
                    hint: const Text('Select Country'),
                    items: creditCardViewModel.issueingCountries.map((country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // setState(() {
                      //   _selectedCountry = value;
                      // });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedCountry != null) {
                        // creditCardViewModel.addBannedCountry(_selectedCountry!);
                        // setState(() {
                        //   _selectedCountry = null; // Clear selection after adding
                        // });
                      }
                    },
                    child: const Text('Add Country'),
                  ),
                  const SizedBox(height: 16),
                  Consumer<CreditCardViewModel>(
                    builder: (context, creditCardViewModel, _) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: creditCardViewModel.bannedCountries.length,
                        itemBuilder: (context, index) {
                          final country = creditCardViewModel.bannedCountries[index];
                          return ListTile(
                            title: Text(country),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // creditCardViewModel.removeBannedCountry(country);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }));
  }
}

class CardListItem extends StatelessWidget {
  final CreditCard card;
  final VoidCallback onDelete;
  final VoidCallback onDeactivate;

  const CardListItem({
    super.key,
    required this.card,
    required this.onDelete,
    required this.onDeactivate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text('Card: ${card.cardNumber}'),
        subtitle: Text('Type: ${card.cardType.name.toUpperCase()}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
            IconButton(
              icon: const Icon(Icons.block, color: Colors.grey),
              onPressed: onDeactivate,
            ),
          ],
        ),
      ),
    );
  }
}
