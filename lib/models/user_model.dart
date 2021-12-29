
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@HiveType(typeId: 15)
@JsonSerializable(
  explicitToJson: true,
)
class JamiiUser {
  @HiveField(0)
  String? username;
  @HiveField(1)
  String? email;
  @HiveField(2)
  String? id;
  @HiveField(3)
  String? createdAt;
  @HiveField(4)
  String? lastLoginAt;
  @HiveField(5)
  String? profilePhoto;
  @HiveField(6)
  bool? loggedIn;
  @HiveField(7)
  String? name;
  @HiveField(8)
  String? method;
  @HiveField(9)
  int? coins;
  @HiveField(10)
  bool? restricted;

  JamiiUser({
    required this.name,
    required this.username,
    required this.email,
    required this.method,
    required this.id,
    required this.createdAt,
    required this.lastLoginAt,
    required this.profilePhoto,
    required this.loggedIn,
    required this.coins,
    required this.restricted,
  });

  factory JamiiUser.fromJson(Map<String, dynamic> json) =>
      _$JamiiUserFromJson(json);
  factory JamiiUser.fromDocumentSnapshot(DocumentSnapshot doc, User user) =>
      JamiiUser(
        name: (doc.data()!["name"] ?? user.displayName).toString(),
        method: (doc.data()!["method"]).toString(),
        username: (doc.data()!["username"] ?? user.displayName)
            .toString()
            .replaceAll(RegExp(r"(?: |[^\w\s])+"), ""),
        email: (doc.data()!["email"] ?? user.email).toString(),
        id: doc.data()!["id"].toString(),
        createdAt: doc.data()!["createdAt"].toString(),
        lastLoginAt: doc.data()!["lastLoginAt"]?.toString() ??
            DateTime.now().toUtc().toIso8601String(),
        coins: doc.data()!["coins"] as int,
        profilePhoto: (doc.data()!["profilePhoto"] ?? user.photoURL).toString(),
        loggedIn: true,
        restricted: doc.data()!["restricted"] as bool
      );

  factory JamiiUser.fromDocumentSnapshotWithoutUser(DocumentSnapshot doc) =>
      JamiiUser(
        name: (doc.data()!["name"] ?? "").toString(),
        method: (doc.data()!["method"] ?? "").toString(),
        username: (doc.data()!["username"] ?? "")
            .toString()
            .replaceAll(RegExp(r"(?: |[^\w\s])+"), ""),
        email: (doc.data()!["email"] ?? "").toString(),
        id: doc.data()!["id"].toString(),
        createdAt: DateTime.parse(doc.data()!["createdAt"] as String)
            .toUtc()
            .toIso8601String(),
        lastLoginAt: doc.data()!["lastLoginAt"]?.toString() ??
            DateTime.now().toUtc().toIso8601String(),
        coins: doc.data()!["coins"] as int ?? 0,
        profilePhoto: (doc.data()!["profilePhoto"] ?? "").toString(),
        loggedIn: true,
        restricted: (doc.data()!["restricted"] ?? false) as bool
      );
  Map<String, dynamic> toJson() => _$JamiiUserToJson(this);
}
