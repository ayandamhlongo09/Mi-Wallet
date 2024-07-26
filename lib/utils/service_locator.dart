import 'package:get_it/get_it.dart';
import 'package:mi_wallet/services/core/storage/local_storage.dart';
import 'package:mi_wallet/services/core/storage/local_storage_impl.dart';
import 'package:mi_wallet/services/core/storage/secure_storage.dart';
import 'package:mi_wallet/services/core/storage/secure_storage_impl.dart';
import 'package:mi_wallet/services/datasources/storage/implementations/local_storage_data_source_impl.dart';
import 'package:mi_wallet/services/datasources/storage/local_storage_data_source.dart';
import 'package:mi_wallet/services/repositories/storage/implementations/local_storage_repository_impl.dart';
import 'package:mi_wallet/services/repositories/storage/local_storage_repository.dart';

final GetIt serviceLocator = GetIt.instance;

void registerServices() {
  //independent services
  final LocalStorage localStorage = LocalStorageImpl();

  final SecureStorage secureStorage = SecureStorageImpl();

  // datasources
  final LocalStorageDataSource localStorageDataSource = LocalStorageDataSourceImpl(localStorage: localStorage, secureStorage: secureStorage);

  //repositories
  final LocalStorageRepository localStorageRepository = LocalStorageRepositoryImpl(localStorageDataSource: localStorageDataSource);

  // START REGISTRATION

  // datasources
  serviceLocator.registerSingleton<LocalStorageDataSource>(localStorageDataSource);

  // repositories
  serviceLocator.registerSingleton<LocalStorageRepository>(localStorageRepository);
}
