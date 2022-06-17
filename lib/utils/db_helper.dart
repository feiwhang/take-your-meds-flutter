import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:take_your_meds/utils/date_time_helper.dart';
import 'package:take_your_meds/utils/days_of_the_week.dart';
import 'package:take_your_meds/utils/schedule.dart';
import 'package:take_your_meds/widgets/alert_dialog.dart';
import 'package:take_your_meds/widgets/success_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper();

  static final Box _schedulesBox = Hive.box<Schedule>("schedules");

  // add new schedule to the schedules Box
  Future<void> addNewMedSchedule(
      Schedule schedule, BuildContext context) async {
    try {
      await _schedulesBox.add(schedule).then((_) {
        Navigator.of(context).pop(true);
      });

      await showDialog(
          context: context,
          builder: (context) {
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });

            return SuccessDialog(
                successDescription: AppLocalizations.of(context)!.addedMed);
          });
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) => TheAlertDialog(errorDescription: e.toString()),
      );
    }
  }

  // get all today's schedule
  // schedule that consist of today's day of the week
  List<Schedule> getSchedulesToday() {
    List<Schedule> allSchedules =
        _schedulesBox.values.toList() as List<Schedule>;

    return allSchedules
        .where((Schedule schedule) => schedule
            .daysToTake[DaysOfTheWeek.values[DateTime.now().weekday - 1]]!)
        .toList();
  }
}
