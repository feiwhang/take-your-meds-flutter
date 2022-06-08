import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:take_your_meds/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:take_your_meds/main.dart';
import 'package:take_your_meds/widgets/success_dialog.dart';

class Settings extends ConsumerWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(
          color: normalTextColor,
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: layoutPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.setting,
              style: titleTextStyle,
            ),
            const SizedBox(height: 18),
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.language),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.lang,
                          style: subtitleTextStyle,
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        langTextButton(
                            "English", const Locale('en', ''), ref, context),
                        const SizedBox(width: 8),
                        const Text("|", style: normalTextStyle),
                        const SizedBox(width: 8),
                        langTextButton(
                            "ภาษาไทย", const Locale('th', ''), ref, context),
                      ],
                    ),
                  ),
                ],
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget langTextButton(
      String langTitle, Locale locale, WidgetRef ref, BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (BuildContext context, Box box, Widget? child) {
        return TextButton(
          onPressed: () {
            box.put('localeName', locale.languageCode);

            showDialog(
                context: context,
                builder: (context) {
                  Future.delayed(const Duration(seconds: 1, milliseconds: 500),
                      () {
                    Navigator.of(context).pop(true);
                  });
                  return SuccessDialog(
                      successDescription:
                          AppLocalizations.of(context)!.changedLang);
                });
          },
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
              minimumSize: MaterialStateProperty.all<Size>(Size.zero),
              overlayColor:
                  MaterialStateProperty.all<Color>(Colors.transparent)),
          child: Text(
            langTitle,
            style: TextStyle.lerp(normalTextStyle, highlightedNormalTextStyle,
                box.get('localeName') == locale.languageCode ? 1.0 : 0.0),
          ),
        );
      },
    );
  }
}
