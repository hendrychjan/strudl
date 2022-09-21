// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionTypeAdapter extends TypeAdapter<SessionType> {
  @override
  final int typeId = 2;

  @override
  SessionType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionType(
      id: fields[0] as int,
      title: fields[1] as String,
      color: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SessionType obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
