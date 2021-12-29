import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:jamii_check/models/story_model.dart';
part 'in_app_notif_model.g.dart';

@HiveType(typeId: 9)
class InAppNotif {
  @HiveField(0)
  final String? author;
  @HiveField(1)
  final String? title;
  @HiveField(3)
  final String? body;
  @HiveField(4)
  final DateTime? createdAt;
  @HiveField(5)
  final bool? read;
  @HiveField(6)
  final String? type;
  @HiveField(7)
  final Story? story;

  InAppNotif({
    required this.author,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.read,
    required this.type,
    this.story
  });

  factory InAppNotif.fromSnapshot(Map<String, dynamic> data) {
    return data['data']['story']!=null?InAppNotif(
        author: data['data']['author'].toString(),
        title: data['notification']['title'].toString(),
        body: data['notification']['body'].toString(),
        type: data['notification']['type'].toString(),
        createdAt: data['createdAt'].toDate() as DateTime,
        story:Story.fromJson(data['data']['story']),
        read: false,
      ):InAppNotif(
        author: data['data']['author'].toString(),
        title: data['notification']['title'].toString(),
        body: data['notification']['body'].toString(),
        type: data['notification']['type'].toString(),
        createdAt: data['createdAt'].toDate() as DateTime,
        read: false,
      );
  }
}
