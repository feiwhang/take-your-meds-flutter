import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:take_your_meds/constants.dart';
import 'package:take_your_meds/screens/add_med.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:take_your_meds/screens/settings.dart';
import 'package:take_your_meds/utils/date_time_helper.dart';
import 'package:take_your_meds/utils/days_of_the_week.dart';
import 'package:take_your_meds/utils/schedule.dart';
import 'package:take_your_meds/widgets/base_card.dart';
import 'package:take_your_meds/widgets/gradient_pill.dart';

final dashDtProvider = StateProvider<DateTime>((ref) {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: layoutPadding, vertical: 24),
          child: ValueListenableBuilder(
            valueListenable: Hive.box<Schedule>("schedules").listenable(),
            builder: (context, Box<Schedule> schedulesBox, _) {
              return ListView(
                  children: <Widget>[
                        const DashboardHero(),
                        const SizedBox(height: 30),
                      ] +
                      scheduleWidgets(context, schedulesBox));
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => const AddMed(),
          ),
        ),
        elevation: 3,
        child: Container(
          height: 70,
          width: 70,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [lightGreenColor, darkGreenColor]),
          ),
          child: const Icon(Icons.add, size: 30),
        ),
      ),
    );
  }

  List<Widget> scheduleWidgets(
      BuildContext context, Box<Schedule> schedulesBox) {
    final scheduleTd = schedulesBox.values.where((Schedule schedule) =>
        schedule.daysToTake[DaysOfTheWeek.values[DateTime.now().weekday - 1]]!);

    if (scheduleTd.isEmpty) {
      return [
        SizedBox(
          width: double.infinity,
          child: BaseCard(
            cardChild: Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                  child: Text(
                AppLocalizations.of(context)!.noSchedule,
                style: normalTextStyle,
              )),
            ),
          ),
        )
      ];
    }

    return List.generate(
      scheduleTd.length,
      (index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: DashboardSchedule(schedule: scheduleTd.elementAt(index)),
      ),
    );
  }
}

class DashboardHero extends StatelessWidget {
  const DashboardHero({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.dashboardHeroTitle,
                  style: titleTextStyle,
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.dashboardHeroSubtitle,
                  style: subtitleTextStyle,
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const Settings(),
                ),
              ),
              color: darkGreenColor,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DaysOfTheWeek.values[DateTime.now().weekday - 1]
                      .getText(context),
                  style: subtitleTextStyle,
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat(AppLocalizations.of(context)!.localeName)
                      .format(DateTime.now()),
                  style: highlightedTitleTextStyle,
                ),
              ],
            ),
            Image.asset(
              "./assets/pill_illu.jpg",
              width: 156,
            ),
          ],
        )
      ],
    );
  }
}

class DashboardSchedule extends StatelessWidget {
  const DashboardSchedule({Key? key, required this.schedule}) : super(key: key);

  final Schedule schedule;

  @override
  Widget build(BuildContext context) {
    bool isDone = schedule.timesToTake.every(
      (element) => getDateTime(element).compareTo(DateTime.now()) <= 0,
    );

    return SizedBox(
      width: double.infinity,
      child: BaseCard(
          bgColor: isDone ? lightestGreenColor : lightRedColor,
          cardChild: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.medName,
                      style: headerTextStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${schedule.dose} ${schedule.dose > 1 ? AppLocalizations.of(context)!.pills : AppLocalizations.of(context)!.pill} ${schedule.howToTake!.getText(context).toLowerCase()}",
                      style: normalTextStyle,
                    ),
                    const SizedBox(height: 16),
                    timePills()
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      isDone
                          ? Icons.check_circle_outline
                          : Icons.schedule_outlined,
                      color: isDone ? lightGreenColor : normalRedColor,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isDone
                          ? AppLocalizations.of(context)!.done
                          : AppLocalizations.of(context)!.onGoing,
                      style: normalTextStyle,
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }

  Widget timePills() {
    return Row(
      children: List.generate(schedule.timesToTake.length, (index) {
        DateTime dt = getDateTime(schedule.timesToTake[index]);
        bool isDtPassed = dt.compareTo(DateTime.now()) <= 0;

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GradientPill(
            lightGradient: isDtPassed ? Colors.grey.shade400 : normalRedColor,
            darkGradient: isDtPassed ? Colors.grey.shade500 : darkRedColor,
            pillChild: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(timeFormat.format(dt), style: lightNormalTextStyle),
            ),
          ),
        );
      }),
    );
  }
}
