import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'how_to_take.g.dart';

@HiveType(typeId: 3)
enum HowToTake {
  @HiveField(0)
  beforeMeal,

  @HiveField(1)
  afterMeal,

  @HiveField(2)
  withMeal;

  String getText(BuildContext context) {
    switch (index) {
      case 0:
        return AppLocalizations.of(context)!.beforeMeal;
      case 1:
        return AppLocalizations.of(context)!.afterMeal;
      case 2:
        return AppLocalizations.of(context)!.withMeal;
      default:
        return "ERROR";
    }
  }
}
