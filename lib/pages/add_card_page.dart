import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:mi_wallet/components/loading_widget.dart';
import 'package:mi_wallet/models/credit_card.dart';
import 'package:mi_wallet/utils/values/colors.dart';
import 'package:mi_wallet/utils/values/enums.dart';
import 'package:payment_card/payment_card.dart';
import 'package:provider/provider.dart';
import '../viewmodels/credit_card_viewmodel.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _holderController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _validityController = TextEditingController();
  final TextEditingController _issuingCountryController = TextEditingController();
  CardNetwork _cardType = CardNetwork.visa;
  String? _selectedCountry;

  @override
  void initState() {
    super.initState();
    openScanner();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _holderController.dispose();
    _cvvController.dispose();
    _validityController.dispose();
    _issuingCountryController.dispose();
    super.dispose();
  }

  openScanner() async {
    var cardDetails = await CardScanner.scanCard();
    if (cardDetails != null) {
      _cardNumberController.text = cardDetails.cardNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.green,
        title: const Text(
          "Add Card to Mi'Wallet",
          style: TextStyle(color: AppColors.white),
        ),
      ),
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
            LoadingStatus.failed: (BuildContext context) => addCartViiew(creditCardViewModel: creditCardViewModel),
            LoadingStatus.idle: (BuildContext context) => addCartViiew(creditCardViewModel: creditCardViewModel),
            LoadingStatus.completed: (BuildContext context) => addCartViiew(creditCardViewModel: creditCardViewModel),
          },
          fallbackBuilder: (BuildContext context) => const SizedBox(),
        );
      }),
    );
  }

  Widget addCartViiew({required CreditCardViewModel creditCardViewModel}) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FormBuilder(
                key: _formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'cardNumber',
                      controller: _cardNumberController,
                      decoration: const InputDecoration(labelText: 'Card Number'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CardNumberInputFormatter(),
                        LengthLimitingTextInputFormatter(19),
                      ],
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required(), FormBuilderValidators.minLength(19), FormBuilderValidators.maxLength(19)]),
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                      },
                    ),
                    FormBuilderDropdown<CardNetwork>(
                      name: 'cardType',
                      decoration: const InputDecoration(labelText: 'Card Type'),
                      initialValue: _cardType,
                      items: CardNetwork.values.map((CardNetwork type) {
                        return DropdownMenuItem<CardNetwork>(
                          value: type,
                          child: Text(type.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (CardNetwork? newValue) {
                        setState(() {
                          _cardType = newValue!;
                        });
                      },
                    ),
                    FormBuilderTextField(
                      name: 'holder',
                      controller: _holderController,
                      decoration: const InputDecoration(labelText: 'Holder Name'),
                      validator: FormBuilderValidators.required(),
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                      },
                    ),
                    FormBuilderTextField(
                      name: 'cvv',
                      controller: _cvvController,
                      decoration: const InputDecoration(labelText: 'CVV'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(3),
                        FormBuilderValidators.maxLength(3),
                      ]),
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                      },
                    ),
                    FormBuilderTextField(
                      name: 'validity',
                      controller: _validityController,
                      decoration: const InputDecoration(labelText: 'Expiry (MM/YY)'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ValidityInputFormatter(),
                      ],
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        (value) {
                          if (value?.length != 5 || !RegExp(r'^\d{2}/\d{2}$').hasMatch(value!)) {
                            return 'Enter a valid expiry date (MM/YY)';
                          }
                          return null;
                        },
                      ]),
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                      },
                    ),
                    FormBuilderDropdown<String>(
                      name: 'issuingCountry',
                      decoration: const InputDecoration(labelText: 'Issuing Country'),
                      items: creditCardViewModel.issueingCountries.map((country) {
                        return DropdownMenuItem<String>(
                          value: country,
                          child: Text(country),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCountry = value;
                        });
                        _formKey.currentState?.validate();
                      },
                      validator: FormBuilderValidators.required(),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                          _cardType = creditCardViewModel.getCardType(_cardNumberController.text);
                          creditCardViewModel.addCreditCard(CreditCard(
                              cardType: creditCardViewModel.getCardType(_cardNumberController.text),
                              cardNumber: int.tryParse(_cardNumberController.text.replaceAll(' ', '')) ?? 0,
                              cvv: int.tryParse(_cvvController.text) ?? 22,
                              issuingCountry: _selectedCountry ?? creditCardViewModel.issueingCountries[0],
                              holder: _holderController.text,
                              validity: _validityController.text));
                          GoRouter.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Add Card',
                      ),
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

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(RegExp(r'\s+'), '');
    final newText = _formatCardNumber(text);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  String _formatCardNumber(String cardNumber) {
    final buffer = StringBuffer();
    for (int i = 0; i < cardNumber.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(cardNumber[i]);
    }
    return buffer.toString();
  }
}

class ValidityInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');
    final newText = _formatValidity(text);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  String _formatValidity(String validity) {
    if (validity.length > 4) validity = validity.substring(0, 4);
    final buffer = StringBuffer();
    for (int i = 0; i < validity.length; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(validity[i]);
    }
    return buffer.toString();
  }
}
