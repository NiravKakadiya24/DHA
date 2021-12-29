// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommentAdapter extends TypeAdapter<Comment> {
  @override
  final int typeId = 18;

  @override
  Comment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Comment(
      id: fields[0] as String?,
      storyId: fields[1] as String?,
      userEmail: fields[2] as String?,
      userName: fields[3] as String?,
      content: fields[4] as String?,
      moderated: fields[5] as bool?,
      createdAt: fields[6] as DateTime?,
      userPic: fields[8] as String?,
      repliedCommentId: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Comment obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.storyId)
      ..writeByte(2)
      ..write(obj.userEmail)
      ..writeByte(3)
      ..write(obj.userName)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.moderated)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.repliedCommentId)
      ..writeByte(8)
      ..write(obj.userPic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
    id: json['id'] as String?,
    storyId: json['storyId'] as String?,
    userEmail: json['userEmail'] as String?,
    userName: json['userName'] as String?,
    content: json['content'] as String?,
    moderated: json['moderated'] as bool?,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    userPic: json['userPic'] as String?,
    repliedCommentId: json['repliedCommentId'] as String?,
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'storyId': instance.storyId,
      'userEmail': instance.userEmail,
      'userName': instance.userName,
      'content': instance.content,
      'moderated': instance.moderated,
      'createdAt': instance.createdAt?.toIso8601String(),
      'repliedCommentId': instance.repliedCommentId,
      'userPic': instance.userPic,
    };
