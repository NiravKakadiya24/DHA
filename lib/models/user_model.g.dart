// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JamiiUserAdapter extends TypeAdapter<JamiiUser> {
  @override
  final int typeId = 15;

  @override
  JamiiUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JamiiUser(
      name: fields[7] as String?,
      username: fields[0] as String?,
      email: fields[1] as String?,
      method: fields[8] as String?,
      id: fields[2] as String?,
      createdAt: fields[3] as String?,
      lastLoginAt: fields[4] as String?,
      profilePhoto: fields[5] as String?,
      loggedIn: fields[6] as bool?,
      coins: fields[9] as int?,
      restricted: fields[10] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, JamiiUser obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.lastLoginAt)
      ..writeByte(5)
      ..write(obj.profilePhoto)
      ..writeByte(6)
      ..write(obj.loggedIn)
      ..writeByte(7)
      ..write(obj.name)
      ..writeByte(8)
      ..write(obj.method)
      ..writeByte(9)
      ..write(obj.coins)
      ..writeByte(10)
      ..write(obj.restricted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JamiiUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JamiiUser _$JamiiUserFromJson(Map<String, dynamic> json) {
  return JamiiUser(
    name: json['name'] as String?,
    username: json['username'] as String?,
    email: json['email'] as String?,
    method: json['method'] as String?,
    id: json['id'] as String?,
    createdAt: json['createdAt'] as String?,
    lastLoginAt: json['lastLoginAt'] as String?,
    profilePhoto: json['profilePhoto'] as String?,
    loggedIn: json['loggedIn'] as bool?,
    coins: json['coins'] as int?,
    restricted: json['restricted'] as bool?,
  );
}

Map<String, dynamic> _$JamiiUserToJson(JamiiUser instance) => <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'id': instance.id,
      'createdAt': instance.createdAt,
      'lastLoginAt': instance.lastLoginAt,
      'profilePhoto': instance.profilePhoto,
      'loggedIn': instance.loggedIn,
      'name': instance.name,
      'method': instance.method,
      'coins': instance.coins,
      'restricted': instance.restricted,
    };
