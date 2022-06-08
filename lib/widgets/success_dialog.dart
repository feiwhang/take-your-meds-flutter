import 'package:flutter/material.dart';
import 'package:take_your_meds/constants.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({Key? key, required this.successDescription})
      : super(key: key);

  final String successDescription;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Icon(
          Icons.check_circle_outline,
          color: lightGreenColor,
          size: 64,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
        child: Text(
          successDescription,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
