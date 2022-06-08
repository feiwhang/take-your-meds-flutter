import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'days_of_the_week.g.dart';

@HiveType(typeId: 2)
enum DaysOfTheWeek {
  @HiveField(0)
  monday,

  @HiveField(1)
  tuesday,

  @HiveField(2)
  wednesday,

  @HiveField(3)
  thursday,

  @HiveField(4)
  friday,

  @HiveField(5)
  saturday,

  @HiveField(6)
  sunday;

  String getText(BuildContext context) {
    switch (index) {
      case 0:
        return AppLocalizations.of(context)!.monday;
      case 1:
        return AppLocalizations.of(context)!.tuesday;
      case 2:
        return AppLocalizations.of(context)!.wednesday;
      case 3:
        return AppLocalizations.of(context)!.thursday;
      case 4:
        return AppLocalizations.of(context)!.friday;
      case 5:
        return AppLocalizations.of(context)!.saturday;
      case 6:
        return AppLocalizations.of(context)!.sunday;
      default:
        return "ERROR";
    }
  }

  String getAbbrev(BuildContext context) {
    switch (index) {
      case 0:
        return AppLocalizations.of(context)!.mondayAbbrev;
      case 1:
        return AppLocalizations.of(context)!.tuesdayAbbrev;
      case 2:
        return AppLocalizations.of(context)!.wednesdayAbbrev;
      case 3:
        return AppLocalizations.of(context)!.thursdayAbbrev;
      case 4:
        return AppLocalizations.of(context)!.fridayAbbrev;
      case 5:
        return AppLocalizations.of(context)!.saturdayAbbrev;
      case 6:
        return AppLocalizations.of(context)!.sundayAbbrev;
      default:
        return "ERROR";
    }
  }
}
