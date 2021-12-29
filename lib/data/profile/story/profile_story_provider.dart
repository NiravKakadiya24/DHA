import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jamii_check/global/globals.dart' as globals;

class ProfileStoryProvider extends ChangeNotifier {
  final FirebaseFirestore databaseReference = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot>? profileStories;

  Future<void> getProfileStories() async {
    debugPrint("Fetching first 12 profile walls");
    profileStories = [];
    await databaseReference
        .collection("walls")
        .where('review', isEqualTo: true)
        .where('email', isEqualTo: globals.jamiiUser.email)
        .orderBy("createdAt", descending: true)
        .limit(12)
        .get()
        .then((value) {
      profileStories = value.docs;
    });
    notifyListeners();
  }

  Future<void> seeMoreProfileStories() async {
    debugPrint("Fetching more profile walls");
    await databaseReference
        .collection("walls")
        .where('review', isEqualTo: true)
        .where('email', isEqualTo: globals.jamiiUser.email)
        .orderBy("createdAt", descending: true)
        .startAfterDocument(profileStories![profileStories!.length - 1])
        .limit(12)
        .get()
        .then((value) {
      for (final doc in value.docs) {
        profileStories!.add(doc);
      }
    });
    notifyListeners();
  }
}
