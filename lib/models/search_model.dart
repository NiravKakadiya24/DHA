
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_model.g.dart';

@HiveType(typeId: 19)
@JsonSerializable(
  explicitToJson: true,
)
class Search {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? userEmail;
  @HiveField(2)
  String? value;
  @HiveField(3)
  DateTime? createdAt;

  Search({
    required this.id,
    required this.userEmail,
    required this.value,
    required this.createdAt
  });

  factory Search.fromJson(Map<String, dynamic> json) =>
      _$SearchFromJson(json);
  factory Search.fromDocumentSnapshot(DocumentSnapshot doc) =>
      Search(
        id: (doc.data()!["id"]).toString(),
        userEmail:doc.data()!["userEmail"].toString(),
        value: doc.data()!["value"],
        createdAt:  DateTime.parse(doc.data()!["createdAt"]),
      );

  Map<String, dynamic> toJson() => _$SearchToJson(this);
}
