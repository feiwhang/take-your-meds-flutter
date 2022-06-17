import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateFormat timeFormat = DateFormat.Hm();

DateFormat dateFormat(String localeName) => DateFormat.MMMMd(localeName);

DateTime getDateTime(TimeOfDay t) {
  final dt = DateTime.now();
  return DateTime(dt.year, dt.month, dt.day, t.hour, t.minute);
}

String tdStr = DateFormat.yMd().format(DateTime.now());
