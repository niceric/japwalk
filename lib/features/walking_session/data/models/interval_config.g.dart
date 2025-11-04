// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interval_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IntervalConfigAdapter extends TypeAdapter<IntervalConfig> {
  @override
  final int typeId = 0;

  @override
  IntervalConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IntervalConfig(
      fastDuration: fields[0] as int,
      slowDuration: fields[1] as int,
      cycles: fields[2] as int,
      voiceGuidance: fields[3] as bool,
      musicIntegration: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, IntervalConfig obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.fastDuration)
      ..writeByte(1)
      ..write(obj.slowDuration)
      ..writeByte(2)
      ..write(obj.cycles)
      ..writeByte(3)
      ..write(obj.voiceGuidance)
      ..writeByte(4)
      ..write(obj.musicIntegration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IntervalConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
