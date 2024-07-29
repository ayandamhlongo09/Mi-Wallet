import 'package:go_router/go_router.dart';
import 'package:mi_wallet/components/bottom_nav_bar.dart';
import 'package:mi_wallet/pages/add_card_page.dart';
import 'package:mi_wallet/pages/wallet_page.dart';

class AppRoutes {
  static const String wallet = "wallet";
  static const String bottomNav = "bottomNav";
  static const String addCard = "addCard";

  static GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: bottomNav,
        path: "/",
        builder: (context, state) => const BottomNavBar(),
      ),
      GoRoute(
        name: wallet,
        path: "/wallet",
        builder: (context, state) => const WalletPage(),
      ),
      GoRoute(
        name: addCard,
        path: "/addCard",
        builder: (context, state) => const AddCard(),
      ),
    ],
  );
}
