import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:take_your_meds/utils/days_of_the_week.dart';
import 'package:take_your_meds/utils/how_to_take.dart';
import 'package:take_your_meds/widgets/alert_dialog.dart';

part 'schedule.g.dart';

@HiveType(typeId: 1, adapterName: "ScheduleAdapter")
class Schedule extends HiveObject {
  @HiveField(0)
  String medName = "";

  @HiveField(1)
  Map<TimeOfDay, bool> timesToTake = {};

  @HiveField(2)
  HowToTake? howToTake;

  @HiveField(3)
  Map<DaysOfTheWeek, bool> daysToTake = {
    DaysOfTheWeek.sunday: false,
    DaysOfTheWeek.monday: false,
    DaysOfTheWeek.tuesday: false,
    DaysOfTheWeek.wednesday: false,
    DaysOfTheWeek.thursday: false,
    DaysOfTheWeek.friday: false,
    DaysOfTheWeek.saturday: false,
  };

  @HiveField(4)
  int dose = 1;
}

class ScheduleNotifier extends StateNotifier<Schedule> {
  ScheduleNotifier() : super(Schedule());

  Schedule get copySchedule {
    Schedule newSchedule = Schedule();
    newSchedule.medName = state.medName;
    newSchedule.timesToTake = state.timesToTake;
    newSchedule.howToTake = state.howToTake;
    newSchedule.daysToTake = state.daysToTake;
    newSchedule.dose = state.dose;
    return newSchedule;
  }

  void addTimeToTake(TimeOfDay time, BuildContext context) {
    if (state.timesToTake.keys.contains(time)) {
      showDialog(
        context: context,
        builder: (context) => TheAlertDialog(
            errorDescription: AppLocalizations.of(context)!.timeTaken),
      );
      return;
    }
    if (state.timesToTake.length >= 3) {
      showDialog(
        context: context,
        builder: (context) => TheAlertDialog(
            errorDescription: AppLocalizations.of(context)!.timeExceed),
      );
      return;
    }

    Schedule newSchedule = copySchedule;

    newSchedule.timesToTake[time] = false;

    state = newSchedule;
  }

  void removeTimeToTake(TimeOfDay time) {
    if (!state.timesToTake.keys.contains(time)) return;

    Schedule newSchedule = copySchedule;
    newSchedule.timesToTake.remove(time);

    state = newSchedule;
  }

  void pickHowToTake(HowToTake howToTake) {
    Schedule newSchedule = copySchedule;
    newSchedule.howToTake = howToTake;

    state = newSchedule;
  }

  void toggleDayToTake(DaysOfTheWeek day) {
    Schedule newSchedule = copySchedule;
    newSchedule.daysToTake[day] = !newSchedule.daysToTake[day]!;

    state = newSchedule;
  }

  void incrDose() {
    Schedule newSchedule = copySchedule;
    newSchedule.dose++;

    state = newSchedule;
  }

  void decrDose() {
    if (state.dose <= 1) return;
    Schedule newSchedule = copySchedule;
    newSchedule.dose--;

    state = newSchedule;
  }

  void setName(String newName) {
    Schedule newSchedule = copySchedule;
    newSchedule.medName = newName;

    state = newSchedule;
  }
}

final newScheduleProvider =
    StateNotifierProvider.autoDispose<ScheduleNotifier, Schedule>((ref) {
  return ScheduleNotifier();
});

DateFormat timeFormat = DateFormat.Hm();

DateFormat dateFormat(String localeName) => DateFormat.MMMMd(localeName);

DateTime getDateTime(TimeOfDay t) {
  final dt = DateTime.now();
  return DateTime(dt.year, dt.month, dt.day, t.hour, t.minute);
}

String tdStr = DateFormat.yMd().format(DateTime.now());
