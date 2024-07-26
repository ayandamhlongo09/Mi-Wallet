import 'package:flutter/material.dart';
import 'package:mi_wallet/pages/manage_wallet_page.dart';
import 'package:mi_wallet/pages/wallet_page.dart';
import 'package:mi_wallet/utils/values/colors.dart';
import 'package:mi_wallet/utils/values/icons.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  static List<BottomNavigationBarItem> bottomNavItems = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
      label: "Wallet",
      icon: AppIcons.wallet,
      activeIcon: AppIcons.wallet,
    ),
    const BottomNavigationBarItem(
      label: "Manage",
      icon: AppIcons.manageWallet,
      activeIcon: AppIcons.manageWallet,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pageList = [
      const WalletPage(),
      const ManageWalletPage(),
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: pageList[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
