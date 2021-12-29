// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_app_notif_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InAppNotifAdapter extends TypeAdapter<InAppNotif> {
  @override
  final int typeId = 9;

  @override
  InAppNotif read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InAppNotif(
      author: fields[0] as String?,
      title: fields[1] as String?,
      body: fields[3] as String?,
      createdAt: fields[4] as DateTime?,
      read: fields[5] as bool?,
      type: fields[6] as String?,
      story: fields[7] as Story?,
    );
  }

  @override
  void write(BinaryWriter writer, InAppNotif obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.author)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.body)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.read)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.story);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InAppNotifAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
