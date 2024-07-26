import 'package:flutter/material.dart';
import 'package:mi_wallet/utils/values/colors.dart';

class LoadingWidget extends StatelessWidget {
  final Color? color;

  const LoadingWidget({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.green),
      ),
    );
  }
}
