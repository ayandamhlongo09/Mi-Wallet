import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mi_wallet/router/router.dart';
import 'package:mi_wallet/utils/app_providers.dart';
import 'package:mi_wallet/utils/service_locator.dart';
import 'package:mi_wallet/utils/values/colors.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("app_settings_dev");
  registerServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp.router(
        title: GlobalConfiguration().getValue<String>('appName'),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.green),
          useMaterial3: true,
        ),
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
