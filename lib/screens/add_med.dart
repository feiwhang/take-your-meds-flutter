import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:take_your_meds/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:take_your_meds/utils/days_of_the_week.dart';
import 'package:take_your_meds/utils/schedule.dart';
import 'package:take_your_meds/widgets/alert_dialog.dart';
import 'package:take_your_meds/widgets/base_card.dart';
import 'package:take_your_meds/widgets/gradient_pill.dart';
import 'package:take_your_meds/widgets/success_dialog.dart';

class AddMed extends StatelessWidget {
  const AddMed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              AppLocalizations.of(context)!.addmedTitle,
              style: titleTextStyle,
            ),
            const SizedBox(height: 42),
            Row(
              children: [
                const Icon(
                  Icons.medication_outlined,
                  color: normalRedColor,
                ),
                const SizedBox(width: 6),
                Text(
                  AppLocalizations.of(context)!.addmedNameTitle,
                  style: subtitleTextStyle,
                ),
              ],
            ),
            const SizedBox(height: 14),
            const SelectNameCard(),
            const SizedBox(height: 42),
            Row(
              children: [
                const Icon(
                  Icons.schedule_outlined,
                  color: normalRedColor,
                ),
                const SizedBox(width: 6),
                Text(
                  AppLocalizations.of(context)!.addmedTimeTitle,
                  style: subtitleTextStyle,
                ),
              ],
            ),
            const SizedBox(height: 14),
            const SelectTimeCard(),
            const SizedBox(height: 42),
            Row(
              children: [
                const Icon(
                  Icons.date_range_outlined,
                  color: normalRedColor,
                ),
                const SizedBox(width: 6),
                Text(
                  AppLocalizations.of(context)!.addmedFrequencyTitle,
                  style: subtitleTextStyle,
                ),
              ],
            ),
            const SizedBox(height: 14),
            const SelectFreqCard(),
            const SizedBox(height: 42),
            Row(
              children: [
                const Icon(
                  Icons.numbers_outlined,
                  color: normalRedColor,
                ),
                const SizedBox(width: 6),
                Text(
                  AppLocalizations.of(context)!.addmedQuantityTitle,
                  style: subtitleTextStyle,
                ),
              ],
            ),
            const SizedBox(height: 14),
            const SelectDoseCard(),
            const Expanded(child: SizedBox()),
            const ConfirmButton(),
          ],
        ),
      ),
    );
  }
}

class SelectNameCard extends ConsumerWidget {
  const SelectNameCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseCard(
      cardChild: TextField(
        onChanged: (newName) =>
            ref.read(newScheduleProvider.notifier).setName(newName),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: AppLocalizations.of(context)!.tabToTypeName,
            hintStyle: normalTextStyle),
        style: subtitleTextStyle,
      ),
    );
  }
}

class SelectTimeCard extends ConsumerWidget {
  const SelectTimeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Schedule schedule = ref.watch(newScheduleProvider);

    return BaseCard(
      cardChild: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: schedule.timesToTake.isNotEmpty
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  schedule.timesToTake.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: selectedTimePill(
                      context,
                      schedule.timesToTake[index],
                      ref,
                    ),
                  ),
                ),
              )
            : Text(AppLocalizations.of(context)!.noTimeSelected,
                style: normalTextStyle),
        trailing: ElevatedButton(
          onPressed: () {
            showCupertinoModalPopup(
                context: context, builder: (context) => SelectTimeModal());
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            shadowColor: Colors.transparent,
            primary: lightestGreenColor,
            padding: EdgeInsets.zero,
          ),
          child: const Icon(
            Icons.add,
            color: darkGreenColor,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget selectedTimePill(BuildContext context, TimeOfDay time, WidgetRef ref) {
    return GradientPill(
      lightGradient: normalRedColor,
      darkGradient: darkRedColor,
      pillChild: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Text(timeFormat.format(getDateTime(time)),
                style: lightNormalTextStyle),
            const SizedBox(width: 6),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.circular(32)),
              child: IconButton(
                onPressed: () {
                  ref.read(newScheduleProvider.notifier).removeTimeToTake(time);
                },
                padding: const EdgeInsets.all(2),
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.clear),
                color: Colors.white,
                iconSize: 12,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SelectTimeModal extends ConsumerWidget {
  SelectTimeModal({Key? key}) : super(key: key);

  final dtProvider = StateProvider<DateTime>((ref) => DateTime.now());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime dt = ref.watch(dtProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      height: 284,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              CupertinoButton(
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: normalTextStyle,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              Text(AppLocalizations.of(context)!.selectTime,
                  style: subtitleTextStyle),
              CupertinoButton(
                child: Text(
                  AppLocalizations.of(context)!.done,
                  style: highlightedNormalTextStyle,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ref
                      .read(newScheduleProvider.notifier)
                      .addTimeToTake(TimeOfDay.fromDateTime(dt), context);
                },
              )
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 222,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: DateTime.now(),
              use24hFormat: true,
              onDateTimeChanged: (DateTime newDt) {
                ref.read(dtProvider.state).state = newDt;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SelectFreqCard extends ConsumerWidget {
  const SelectFreqCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Schedule scheduleValue = ref.watch(newScheduleProvider);
    return BaseCard(
      cardChild: ListTile(
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 0,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            7,
            (index) => scheduleValue.daysToTake[DaysOfTheWeek.values[index]]!
                ? Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: GradientPill(
                      lightGradient: normalRedColor,
                      darkGradient: darkRedColor,
                      pillChild: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                            DaysOfTheWeek.values[index].getAbbrev(context),
                            style: lightNormalTextStyle),
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            showCupertinoModalPopup(
                context: context,
                builder: (context) => const SelectFreqModal());
          },
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.unfold_more),
        ),
      ),
    );
  }
}

class SelectFreqModal extends ConsumerWidget {
  const SelectFreqModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Schedule scheduleValue = ref.watch(newScheduleProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      height: 464,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              CupertinoButton(
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: normalTextStyle,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              Text(AppLocalizations.of(context)!.selectDays,
                  style: subtitleTextStyle),
              CupertinoButton(
                child: Text(
                  AppLocalizations.of(context)!.done,
                  style: highlightedNormalTextStyle,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
          Material(
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: ListTile.divideTiles(
                context: context,
                tiles: List.generate(
                  7,
                  (index) => GestureDetector(
                    onTap: () {
                      ref
                          .read(newScheduleProvider.notifier)
                          .toggleDayToTake(DaysOfTheWeek.values[index]);
                    },
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      title: Text(
                        DaysOfTheWeek.values[index].getText(context),
                        style: scheduleValue
                                .daysToTake[DaysOfTheWeek.values[index]]!
                            ? highlightedSubtitleTextStyle
                            : subtitleTextStyle,
                      ),
                      trailing:
                          scheduleValue.daysToTake[DaysOfTheWeek.values[index]]!
                              ? const Icon(
                                  Icons.check,
                                  color: darkGreenColor,
                                  size: 24,
                                )
                              : const SizedBox(),
                    ),
                  ),
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectDoseCard extends ConsumerWidget {
  const SelectDoseCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Schedule scheduleValue = ref.watch(newScheduleProvider);

    return BaseCard(
        cardChild: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            ref.read(newScheduleProvider.notifier).decrDose();
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            shadowColor: Colors.transparent,
            primary:
                scheduleValue.dose <= 1 ? Colors.grey.shade100 : lightRedColor,
            padding: EdgeInsets.zero,
          ),
          child: Icon(
            Icons.remove,
            color: scheduleValue.dose <= 1 ? normalTextColor : darkRedColor,
            size: 18,
          ),
        ),
        Text(
          scheduleValue.dose.toString(),
          style: subtitleTextStyle,
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(newScheduleProvider.notifier).incrDose();
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            shadowColor: Colors.transparent,
            primary: lightestGreenColor,
            padding: EdgeInsets.zero,
          ),
          child: const Icon(
            Icons.add,
            color: darkGreenColor,
            size: 18,
          ),
        ),
      ],
    ));
  }
}

class ConfirmButton extends ConsumerWidget {
  const ConfirmButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Schedule scheduleValue = ref.watch(newScheduleProvider);

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient:
              const LinearGradient(colors: [lightGreenColor, darkGreenColor]),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            onSurface: Colors.transparent,
            shadowColor: Colors.transparent,
            minimumSize: const Size.fromHeight(50),
            textStyle: lightSubtitleTextStyle,
          ),
          onPressed: () async {
            String errorMsg = validateSchedule(context, ref);

            if (errorMsg.isEmpty) {
              final schedulesBox = Hive.box<Schedule>("schedules");

              try {
                schedulesBox.add(scheduleValue).then((_) {
                  Navigator.of(context).pop(true);

                  showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.of(context).pop(true);
                        });

                        return SuccessDialog(
                            successDescription:
                                AppLocalizations.of(context)!.addedMed);
                      });
                });
              } catch (e) {
                showDialog(
                  context: context,
                  builder: (context) =>
                      TheAlertDialog(errorDescription: e.toString()),
                );
              }
            } else {
              showDialog(
                context: context,
                builder: (context) =>
                    TheAlertDialog(errorDescription: errorMsg),
              );
            }
          },
          child: Text(
            AppLocalizations.of(context)!.confirm,
          ),
        ),
      ),
    );
  }

  // return error string else empty
  String validateSchedule(BuildContext context, WidgetRef ref) {
    Schedule scheduleValue = ref.watch(newScheduleProvider);
    String errorMsg = "";

    if (scheduleValue.medName.isEmpty) {
      errorMsg += "* ";
      errorMsg += AppLocalizations.of(context)!.errorNoName;
    }

    if (scheduleValue.timesToTake.isEmpty) {
      errorMsg += "\n* ";
      errorMsg += AppLocalizations.of(context)!.errorNoTime;
    }

    if (!scheduleValue.daysToTake.containsValue(true)) {
      errorMsg += "\n* ";
      errorMsg += AppLocalizations.of(context)!.errorNoDay;
    }

    return errorMsg;
  }
}
