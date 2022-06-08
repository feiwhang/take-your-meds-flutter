// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'days_of_the_week.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DaysOfTheWeekAdapter extends TypeAdapter<DaysOfTheWeek> {
  @override
  final int typeId = 2;

  @override
  DaysOfTheWeek read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DaysOfTheWeek.monday;
      case 1:
        return DaysOfTheWeek.tuesday;
      case 2:
        return DaysOfTheWeek.wednesday;
      case 3:
        return DaysOfTheWeek.thursday;
      case 4:
        return DaysOfTheWeek.friday;
      case 5:
        return DaysOfTheWeek.saturday;
      case 6:
        return DaysOfTheWeek.sunday;
      default:
        return DaysOfTheWeek.monday;
    }
  }

  @override
  void write(BinaryWriter writer, DaysOfTheWeek obj) {
    switch (obj) {
      case DaysOfTheWeek.monday:
        writer.writeByte(0);
        break;
      case DaysOfTheWeek.tuesday:
        writer.writeByte(1);
        break;
      case DaysOfTheWeek.wednesday:
        writer.writeByte(2);
        break;
      case DaysOfTheWeek.thursday:
        writer.writeByte(3);
        break;
      case DaysOfTheWeek.friday:
        writer.writeByte(4);
        break;
      case DaysOfTheWeek.saturday:
        writer.writeByte(5);
        break;
      case DaysOfTheWeek.sunday:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DaysOfTheWeekAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
