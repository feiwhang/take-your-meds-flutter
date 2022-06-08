// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduleAdapter extends TypeAdapter<Schedule> {
  @override
  final int typeId = 1;

  @override
  Schedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Schedule()
      ..medName = fields[0] as String
      ..timesToTake = (fields[1] as List).cast<TimeOfDay>()
      ..howToTake = fields[2] as HowToTake?
      ..daysToTake = (fields[3] as Map).cast<DaysOfTheWeek, bool>()
      ..dose = fields[4] as int;
  }

  @override
  void write(BinaryWriter writer, Schedule obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.medName)
      ..writeByte(1)
      ..write(obj.timesToTake)
      ..writeByte(2)
      ..write(obj.howToTake)
      ..writeByte(3)
      ..write(obj.daysToTake)
      ..writeByte(4)
      ..write(obj.dose);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
