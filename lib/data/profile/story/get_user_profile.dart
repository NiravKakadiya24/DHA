import 'package:jamii_check/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamii_check/data/auth/provider/auth_provider.dart';
import 'package:jamii_check/global/globals.dart' as globals;

class UserProfileProvider extends ChangeNotifier {
  final FirebaseFirestore databaseReference = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot>? userProfileStories;

  Future<void> getuserProfileStories(String? email) async {
    debugPrint("Fetching first 12 profile stories");
    userProfileStories = [];
    await databaseReference
        .collection("stories")
        .where('review', isEqualTo: true)
        .where('email', isEqualTo: email)
        .orderBy("createdAt", descending: true)
        .limit(12)
        .get()
        .then((value) {
      userProfileStories = value.docs;
    }).catchError((e) {
      debugPrint(e.toString());
      debugPrint("data done with error");
    });
    notifyListeners();
  }

  Future<void> seeMoreUserProfileStories(String? email) async {
    debugPrint("Fetching more profile stories");
    await databaseReference
        .collection("walls")
        .where('review', isEqualTo: true)
        .where('email', isEqualTo: email)
        .orderBy("createdAt", descending: true)
        .startAfterDocument(userProfileStories![userProfileStories!.length - 1])
        .limit(12)
        .get()
        .then((value) {
      for (final doc in value.docs) {
        userProfileStories!.add(doc);
      }
    });
    notifyListeners();
  }
}

final FirebaseFirestore databaseReference = FirebaseFirestore.instance;
Stream<QuerySnapshot> getUserProfile(String email) {
  return databaseReference
      .collection(USER_COLLECTION)
      .where('email', isEqualTo: email)
      .snapshots()
      .asyncMap((event) {
    if (event.docs.isEmpty) {
      return databaseReference
          .collection(USER_COLLECTION)
          .where('email', isEqualTo: email)
          .get();
    } else {
      return event;
    }
  });
}
