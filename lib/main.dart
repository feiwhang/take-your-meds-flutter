import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:take_your_meds/screens/dashboard.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:take_your_meds/utils/days_of_the_week.dart';
import 'package:take_your_meds/utils/how_to_take.dart';
import 'package:take_your_meds/utils/schedule.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ScheduleAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(HowToTakeAdapter());
  Hive.registerAdapter(DaysOfTheWeekAdapter());

  Box settingBox = await Hive.openBox('settings');
  await Hive.openBox<Schedule>('schedules');
  await Hive.openBox('todaySchedules');

  // setup default locale based on device
  if (settingBox.get('localeName') == null) {
    await settingBox.put('localeName', Platform.localeName.substring(0, 2));
  }

  runApp(
    const ProviderScope(
      child: TakeYourMeds(),
    ),
  );
}

class TakeYourMeds extends StatelessWidget {
  const TakeYourMeds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (BuildContext context, Box box, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Take your meds',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme:
                  GoogleFonts.rubikTextTheme(Theme.of(context).textTheme)),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('th', ''),
          ],
          locale: Locale(box.get('localeName'), ''),
          home: const Dashboard(),
        );
      },
    );
  }
}
