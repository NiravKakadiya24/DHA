
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story_model.g.dart';

@HiveType(typeId: 16)
@JsonSerializable(
  explicitToJson: true,
)
class Story {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? sourceUrl;
  @HiveField(3)
  String? supportingInformation;
  @HiveField(4)
  String? content;
  @HiveField(5)
  String? photoUrl;
  @HiveField(6)
  String? userEmail;
  @HiveField(7)
  String? userName;
  @HiveField(8)
  bool? isFaked;
  @HiveField(9)
  bool? review;
  @HiveField(10)
  DateTime? createdAt;
  @HiveField(11)
  bool? isAnonymous;
  @HiveField(12)
  List<String>? tags;
  @HiveField(13)
  bool inHeadlines;

  Story({
    required this.id,
    required this.title,
    required this.sourceUrl,
    required this.supportingInformation,
    required this.content,
    required this.photoUrl,
    required this.userEmail,
    required this.userName,
    required this.isFaked,
    required this.review,
    required this.isAnonymous,
    required this.tags,
    required this.inHeadlines,
    required this.createdAt
  });

  factory Story.fromJson(Map<String, dynamic> json) =>
      _$StoryFromJson(json);
  factory Story.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Story(
        id: (doc.data()!["id"]).toString(),
        title: (doc.data()!["title"]).toString(),
        sourceUrl: doc.data()!["sourceUrl"],
        supportingInformation: (doc.data()!["supportingInformation"] ?? ""),
        content: doc.data()!["content"].toString(),
        photoUrl:doc.data()!["photoUrl"].toString(),
        userEmail:doc.data()!["userEmail"].toString(),
        userName:doc.data()!["userName"].toString(),
        isFaked: doc.data()!["isFaked"] as bool,
        review: doc.data()!["review"] as bool,
        isAnonymous: doc.data()!["isAnonymous"] as bool,
        createdAt: DateTime.parse(doc.data()!["createdAt"]),
        tags: ((doc.data()!["tags"] ?? []) as List).map((item) => item as String).toList(),
        inHeadlines: doc.data()!["inHeadlines"] as bool,
      );
  }

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
