// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'how_to_take.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HowToTakeAdapter extends TypeAdapter<HowToTake> {
  @override
  final int typeId = 3;

  @override
  HowToTake read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HowToTake.beforeMeal;
      case 1:
        return HowToTake.afterMeal;
      case 2:
        return HowToTake.withMeal;
      default:
        return HowToTake.beforeMeal;
    }
  }

  @override
  void write(BinaryWriter writer, HowToTake obj) {
    switch (obj) {
      case HowToTake.beforeMeal:
        writer.writeByte(0);
        break;
      case HowToTake.afterMeal:
        writer.writeByte(1);
        break;
      case HowToTake.withMeal:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HowToTakeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
