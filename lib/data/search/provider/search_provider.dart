import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jamii_check/data/profile/story/story_provider.dart';
import 'package:jamii_check/models/search_model.dart';
import 'package:jamii_check/models/story_model.dart';
import 'package:jamii_check/global/globals.dart' as globals;

String SEARCH_COLLECTION = "searches";

class SearchProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _filterIndex = 0;
  List<Search> _historyList = [];
  int get filterIndex => _filterIndex;
  List<Search> get historyList => _historyList;

  void setFilterIndex(int index) {
    _filterIndex = index;
    notifyListeners();
  }

  void sortSearchList() {
    _searchStoryList = [];
    _searchStoryList!.addAll(_filterStoryList!);
    if (_filterIndex == 0) {
      _searchStoryList!.sort(
          (a, b) => a.title!.toLowerCase().compareTo(b.title!.toLowerCase()));
    } else if (_filterIndex == 1) {
      _searchStoryList!.sort(
          (a, b) => a.title!.toLowerCase().compareTo(b.title!.toLowerCase()));
      Iterable<Story> iterable = _searchStoryList!.reversed;
      _searchStoryList = iterable.toList();
    } else if (_filterIndex == 2) {
      _searchStoryList!.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    } else if (_filterIndex == 3) {
      _searchStoryList!.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
      Iterable<Story> iterable = _searchStoryList!.reversed;
      _searchStoryList = iterable.toList();
    }

    notifyListeners();
  }

  late List<Story>? _searchStoryList;
  late List<Story>? _filterStoryList;
  bool _isClear = true;
  String _searchText = '';

  List<Story>? get searchStoryList => _searchStoryList;
  List<Story>? get filterStoryList => _filterStoryList;
  bool get isClear => _isClear;
  String get searchText => _searchText;
  void setSearchText(String text) {
    _searchText = text;
    notifyListeners();
  }

  void cleanSearchStory() {
    _searchStoryList = [];
    _isClear = true;
    _searchText = '';
    notifyListeners();
  }

  void saveSearch(Search search) async {
    if (!_historyList.map((h) => h.value).contains(search.value)) {
      _historyList.add(search);
      _firestore.collection(SEARCH_COLLECTION).add(search.toJson());
    } else {
      var snapshot = await _firestore
          .collection(SEARCH_COLLECTION)
          .where("value", isEqualTo: search.value)
          .limit(1)
          .get();
      if(snapshot.docs.isNotEmpty){
          snapshot.docs[0].reference.update(Search(
              id: search.id,
              userEmail: search.userEmail,
              value: search.value,
              createdAt: DateTime.now().toUtc())
          .toJson());
      }
      
    }
    notifyListeners();
  }

  void searchStory(Search query, BuildContext context) async {
    _searchText = query.value!;
    _isClear = false;
    _searchStoryList = null;
    _filterStoryList = null;
    notifyListeners();
    final snapshot = await _firestore
        .collection(STORY_COLLECTION)
        .where("review", isEqualTo: true)
        .orderBy("title")
        .startAt([query.value])
        .endAt([query.value! + '\uf8ff'])
        .get();
    if (snapshot.docs.isNotEmpty) {
      if (query.value!.isEmpty) {
        _searchStoryList = [];
      } else {
        _searchStoryList = [];
        _searchStoryList!.addAll(
            snapshot.docs.map((e) => Story.fromDocumentSnapshot(e)).toList());
        _filterStoryList = [];
        _filterStoryList!.addAll(
            snapshot.docs.map((e) => Story.fromDocumentSnapshot(e)).toList());
      }
    } else {
     _searchStoryList = [];
     _filterStoryList = [];
    }
    notifyListeners();
  }

  Future initHistoryList() async {
    _historyList = [];
    try {
      final snapshot = await _firestore
          .collection(SEARCH_COLLECTION)
          .where('userEmail', isEqualTo: globals.jamiiUser.email)
          .orderBy("createdAt", descending: true)
          .get();
      _historyList.addAll(
          snapshot.docs.map((e) => Search.fromDocumentSnapshot(e)).toList());
    } on Exception catch (e) {
      debugPrint("initSearch finished without error");
      debugPrint("init search history errors" + e.toString());
    }
    notifyListeners();
    debugPrint("initSearch finished without error");
  }

  void clearSearchAddress() async {
    _historyList = [];
    notifyListeners();
    final snapshot = await _firestore
        .collection(SEARCH_COLLECTION)
        .where("userEmail", isEqualTo: globals.jamiiUser.email)
        .get();
    for (QueryDocumentSnapshot snap in snapshot.docs) {
      await snap.reference.delete();
    }
    notifyListeners();
  }
}
