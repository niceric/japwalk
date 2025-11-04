// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walking_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalkingSessionAdapter extends TypeAdapter<WalkingSession> {
  @override
  final int typeId = 1;

  @override
  WalkingSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalkingSession(
      id: fields[0] as String,
      startTime: fields[1] as DateTime,
      endTime: fields[2] as DateTime?,
      fastIntervalDuration: fields[3] as int,
      slowIntervalDuration: fields[4] as int,
      completedCycles: fields[5] as int,
      totalCycles: fields[6] as int,
      completed: fields[7] as bool,
      caloriesBurned: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, WalkingSession obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime)
      ..writeByte(3)
      ..write(obj.fastIntervalDuration)
      ..writeByte(4)
      ..write(obj.slowIntervalDuration)
      ..writeByte(5)
      ..write(obj.completedCycles)
      ..writeByte(6)
      ..write(obj.totalCycles)
      ..writeByte(7)
      ..write(obj.completed)
      ..writeByte(8)
      ..write(obj.caloriesBurned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalkingSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
