import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  final String message;
  final TextStyle textStyle;

  const NoDataWidget({super.key, message, textStyle})
      : message = message ?? 'No Feedback info found!',
        textStyle = textStyle ??
            const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w700,
            );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          message,
          style: textStyle,
        ),
      ),
    );
  }
}
