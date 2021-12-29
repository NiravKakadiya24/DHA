
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@HiveType(typeId: 18)
@JsonSerializable(
  explicitToJson: true,
)
class Comment {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? storyId;
  @HiveField(2)
  String? userEmail;
  @HiveField(3)
  String? userName;
  @HiveField(4)
  String? content;
  @HiveField(5)
  bool? moderated;
  @HiveField(6)
  DateTime? createdAt;
  @HiveField(7)
  String? repliedCommentId;
  @HiveField(8)
  String? userPic;

  Comment({
    required this.id,
    required this.storyId,
    required this.userEmail,
    required this.userName,
    required this.content,
    required this.moderated,
    required this.createdAt,
    required this.userPic,
    this.repliedCommentId
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
  factory Comment.fromDocumentSnapshot(DocumentSnapshot doc) =>
      Comment(
        id: (doc.data()!["id"]).toString(),
        storyId: (doc.data()!["storyId"]).toString(),
        userEmail:doc.data()!["userEmail"].toString(),
        userName:doc.data()!["userName"].toString(),
        userPic:doc.data()!["userPic"].toString(),
        content: doc.data()!["content"],
        moderated: doc.data()!["moderated"] as bool,
        createdAt:  DateTime.parse(doc.data()!["createdAt"]),
        repliedCommentId: (doc.data()!["repliedCommentId"] ?? "")as String,
      );

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
