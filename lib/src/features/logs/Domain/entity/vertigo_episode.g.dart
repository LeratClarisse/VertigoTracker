// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vertigo_episode.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VertigoEpisodeAdapter extends TypeAdapter<VertigoEpisode> {
  @override
  final int typeId = 0;

  @override
  VertigoEpisode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VertigoEpisode(
      date: fields[0] as DateTime,
      time: fields[1] as DateTime,
      durationHours: fields[2] as int,
      durationMinutes: fields[3] as int,
      nausea: fields[4] as bool,
      throwUp: fields[5] as bool,
      acouphene: fields[6] as bool,
      earObstructed: fields[7] as bool,
      comment: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VertigoEpisode obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.durationHours)
      ..writeByte(3)
      ..write(obj.durationMinutes)
      ..writeByte(4)
      ..write(obj.nausea)
      ..writeByte(5)
      ..write(obj.throwUp)
      ..writeByte(6)
      ..write(obj.acouphene)
      ..writeByte(7)
      ..write(obj.earObstructed)
      ..writeByte(8)
      ..write(obj.comment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VertigoEpisodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
