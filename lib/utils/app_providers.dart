import 'package:mi_wallet/services/repositories/storage/local_storage_repository.dart';
import 'package:mi_wallet/utils/service_locator.dart';
import 'package:mi_wallet/viewmodels/credit_card_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> appProviders = [
  ...viewModelProviders,
];

List<SingleChildWidget> viewModelProviders = [
  ChangeNotifierProvider(
    create: (context) => CreditCardViewModel(
      localStorageRepository: serviceLocator<LocalStorageRepository>(),
    ),
  ),
];
