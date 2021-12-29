// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoryAdapter extends TypeAdapter<Story> {
  @override
  final int typeId = 16;

  @override
  Story read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Story(
      id: fields[0] as String?,
      title: fields[1] as String?,
      sourceUrl: fields[2] as String?,
      supportingInformation: fields[3] as String?,
      content: fields[4] as String?,
      photoUrl: fields[5] as String?,
      userEmail: fields[6] as String?,
      userName: fields[7] as String?,
      isFaked: fields[8] as bool?,
      review: fields[9] as bool?,
      isAnonymous: fields[11] as bool?,
      tags: (fields[12] as List?)?.cast<String>(),
      inHeadlines: fields[13] as bool,
      createdAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Story obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.sourceUrl)
      ..writeByte(3)
      ..write(obj.supportingInformation)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.photoUrl)
      ..writeByte(6)
      ..write(obj.userEmail)
      ..writeByte(7)
      ..write(obj.userName)
      ..writeByte(8)
      ..write(obj.isFaked)
      ..writeByte(9)
      ..write(obj.review)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.isAnonymous)
      ..writeByte(12)
      ..write(obj.tags)
      ..writeByte(13)
      ..write(obj.inHeadlines);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) {
  return Story(
    id: json['id'] as String?,
    title: json['title'] as String?,
    sourceUrl: json['sourceUrl'] as String?,
    supportingInformation: json['supportingInformation'] as String?,
    content: json['content'] as String?,
    photoUrl: json['photoUrl'] as String?,
    userEmail: json['userEmail'] as String?,
    userName: json['userName'] as String?,
    isFaked: json['isFaked'] as bool?,
    review: json['review'] as bool?,
    isAnonymous: json['isAnonymous'] as bool?,
    tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    inHeadlines: json['inHeadlines'] as bool,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
  );
}

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'sourceUrl': instance.sourceUrl,
      'supportingInformation': instance.supportingInformation,
      'content': instance.content,
      'photoUrl': instance.photoUrl,
      'userEmail': instance.userEmail,
      'userName': instance.userName,
      'isFaked': instance.isFaked,
      'review': instance.review,
      'createdAt': instance.createdAt?.toIso8601String(),
      'isAnonymous': instance.isAnonymous,
      'tags': instance.tags,
      'inHeadlines': instance.inHeadlines,
    };
