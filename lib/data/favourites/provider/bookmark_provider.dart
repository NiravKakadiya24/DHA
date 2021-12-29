import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jamii_check/data/auth/provider/auth_provider.dart';
import 'package:jamii_check/data/profile/story/story_provider.dart';
import 'package:jamii_check/global/globals.dart' as globals;
import 'package:hive/hive.dart';
import 'package:jamii_check/models/story_model.dart';

String BOOKMARK_COLLECTION = "bookmarks";

class BookmarkProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Story>? _bookmarkList = [];
  List<Story> get bookmarkList => _bookmarkList!;
  bool _bookmark = false;
  Future addBookmarkList(String storyID) async {
    try {
      _bookmark = true;
      notifyListeners();
      await _firestore
          .collection(BOOKMARK_COLLECTION)
          .add({"storyId": storyID, "email": globals.jamiiUser.email});
      await _firestore
          .collection(STORY_COLLECTION)
          .where("id", isEqualTo: storyID)
          .limit(1)
          .get()
          .then((value) {
        Story story = Story.fromDocumentSnapshot(value.docs[0]);
        _bookmarkList!.add(story);
        _bookmark = false;
        notifyListeners();
      });
    } catch (e) {
      _bookmark = false;
      notifyListeners();
      debugPrint(e.toString());
    }
  }

  Future deleteBookmarkList(String storyID) async {
    try {
      _bookmarkList!.removeWhere((s) => s.id == storyID);
      _bookmark = true;
      notifyListeners();
      final shot=await _firestore
          .collection(STORY_COLLECTION)
          .where("id", isEqualTo: storyID)
          .where("email", isEqualTo: globals.jamiiUser.email).limit(1).get();
       await shot.docs[0].reference.delete();
      _bookmarkList!.removeWhere((s) => s.id == storyID);
      _bookmark = false;
      notifyListeners();
    } catch (e) {
      _bookmark = false;
      notifyListeners();
      debugPrint(e.toString());
    }
  }
  Future removeOlderThan(int days) async{
    try {
       _bookmarkList!.removeWhere((s) => s.createdAt!.isBefore(DateTime.now().toUtc().subtract( Duration(days:days))) );
      _bookmark = true;
      notifyListeners();
      final shot=await _firestore
          .collection(STORY_COLLECTION)
          .where("created_At",isGreaterThan:
              DateTime.now().toUtc().subtract( Duration(days:days)) )
          .where("email", isEqualTo: globals.jamiiUser.email).get();
      for(QueryDocumentSnapshot shot in shot.docs){
          await shot.reference.delete();
      }
      _bookmark = false;
      notifyListeners();
    } catch (e) {
      _bookmark = false;
      notifyListeners();
      debugPrint(e.toString());
    }
  }
  Future removeAll() async{
    try {
       _bookmarkList=[];
      _bookmark = true;
      notifyListeners();
      final shot=await _firestore
          .collection(STORY_COLLECTION)
          .where("email", isEqualTo: globals.jamiiUser.email).get();
      for(QueryDocumentSnapshot shot in shot.docs){
          await shot.reference.delete();
      }
      _bookmark = false;
      notifyListeners();
    } catch (e) {
      _bookmark = false;
      notifyListeners();
      debugPrint(e.toString());
    }
  }

  Future<List<Story>> initBookMarks() async {
    debugPrint("Fetching first 24 confirmed stories!");
    _bookmarkList = [];
    await _firestore
        .collection(BOOKMARK_COLLECTION)
        .where("email", isEqualTo: globals.jamiiUser.email)
        .get()
        .then((value) async {
      final docSnaps = value.docs;
      final ids = docSnaps.map((e) => e.data()['storyId'] as String).toList();
      if(ids.isNotEmpty){
        final bookmarkedSnap = await _firestore
          .collection(STORY_COLLECTION)
          .where('review', isEqualTo: true)
          .where('id', whereIn: ids)
          .get();
          _bookmarkList = bookmarkedSnap.docs
          .map((e) => Story.fromDocumentSnapshot(e))
          .toList();
      }
      if (_bookmarkList != []) {
        debugPrint("${_bookmarkList!.length} bookmarked fetched!");
        _bookmark = false;
        notifyListeners();
      } else {
        debugPrint("Not connected to Internet");
        _bookmarkList = [];
      }
    }).catchError((e) {
      debugPrint(e.toString());
      debugPrint("data done with error");
      _bookmark = false;
      notifyListeners();
      debugPrint("initBookMarks finished with error");
    });
    _bookmark = false;
    notifyListeners();
    debugPrint("initBookMarks finished without error");
    return _bookmarkList!;
  }
}
