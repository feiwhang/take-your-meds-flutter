import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:take_your_meds/constants.dart';

class TheAlertDialog extends StatelessWidget {
  const TheAlertDialog({Key? key, required this.errorDescription})
      : super(key: key);

  final String errorDescription;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.error,
        style: const TextStyle(color: darkRedColor),
      ),
      content: Text(errorDescription),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.pop(context, AppLocalizations.of(context)!.ok),
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all<TextStyle>(
                highlightedSubtitleTextStyle),
          ),
          child: const Text(
            'OK',
            style: highlightedSubtitleTextStyle,
          ),
        ),
      ],
    );
  }
}
