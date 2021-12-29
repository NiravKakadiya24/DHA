import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jamii_check/data/auth/provider/auth_provider.dart';
import 'package:jamii_check/global/globals.dart' as globals;
import 'package:jamii_check/models/story_model.dart';
import 'package:jamii_check/ui/pages/home/featured_facts_check_view.dart';

String STORY_COLLECTION = "stories";

class StoryProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  StoryType? _storyType=StoryType.ALL;
  bool _isLoading = false;
  List<Story>? _stories=[];
  List<QueryDocumentSnapshot>? storiesDocSnaps;
  List<Story>? _subStories=[];
  List<Story>? _confirmedStories=[];
  List<QueryDocumentSnapshot>? confirmedStoriesDocSnaps;
  List<Story>? _confirmedSubStories=[];
  List<Story>? _justInStories=[];
  List<QueryDocumentSnapshot>? justInStoriesDocSnaps;
  List<Story>? _justInSubStories=[];
  List<Story>? _fakeStories=[];
  List<QueryDocumentSnapshot>? fakeStoriesDocSnaps;
  List<Story>? _fakeSubStories=[];
  bool get isLoading => _isLoading;
  List<Story> get stories  => _stories!;
  List<Story> get subStories  => _subStories!;
  List<Story> get fakeStories  => _fakeStories!;
  List<Story> get fakeSubStories  => _fakeSubStories!;
  List<Story> get confirmedStories  => _confirmedStories!;
  List<Story> get confirmedSubStories  => _confirmedSubStories!;
  List<Story> get justInStories  => _justInStories!;
  List<Story> get justInSubStories  => _justInSubStories!;
  StoryType get storyType =>_storyType!;
  Future submitStory(Story story) async {
    _isLoading = true;
    notifyListeners();
    try {
      _firestore.collection(STORY_COLLECTION).add(story.toJson());
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  void initArrays(){
    _subStories=[];
    _stories=[];
  }
  void initFakeStoriesArrays(){
    _fakeSubStories=[];
    _fakeStories=[];
  }
  void initConfirmedStoriesArrays(){
    _confirmedSubStories=[];
    _confirmedStories=[];
  }
  void initJustInStoriesArrays(){
    _justInSubStories=[];
    _justInStories=[];
  }
  void changeStoryType(StoryType st){
    _storyType=st;
    notifyListeners();
  }
  Future<List<Story>> getStories() async {
    _isLoading=true;
    notifyListeners();
    debugPrint("Fetching first 24 stories!");
    _stories = [];
    _subStories = [];
    await _firestore
        .collection(STORY_COLLECTION)
        .where('review', isEqualTo: true)
        .where("inHeadlines",isEqualTo:false)
        .orderBy("createdAt", descending: true)
        .limit(24)
        .get()
        .then((value) {
      _stories = [];
      storiesDocSnaps = value.docs;
      _stories=storiesDocSnaps!.map((e) => Story.fromDocumentSnapshot(e)).toList();
      if (_stories != []) {
        debugPrint("${_stories!.length} stories fetched!");
        _subStories = _stories;
        notifyListeners();
      } else {
        debugPrint("Not connected to Internet");
        _subStories = [];
      }
    }).catchError((e) {
      debugPrint(e.toString());
      debugPrint("data done with error");
      _isLoading=false;
      notifyListeners();
    });
    _isLoading=false;
    notifyListeners();
    return _subStories!;
  }
  Future<List<Story>> getFakeStories() async {
    _isLoading=true;
    notifyListeners();
    debugPrint("Fetching first 24 fake stories!");
    _fakeStories = [];
    _fakeSubStories = [];
    await _firestore
        .collection(STORY_COLLECTION)
        .where('review', isEqualTo: true)
        .where("isFaked",isEqualTo:true)
        .where("inHeadlines",isEqualTo:false)
        .orderBy("createdAt", descending: true)
        .limit(24)
        .get()
        .then((value) {
      _fakeStories = [];
      fakeStoriesDocSnaps = value.docs;
      _fakeStories=fakeStoriesDocSnaps!.map((e) => Story.fromDocumentSnapshot(e)).toList();
      if (_fakeStories != []) {
        debugPrint("${_fakeStories!.length} fakeStories fetched!");
        _fakeSubStories = _fakeStories;
        notifyListeners();
      } else {
        debugPrint("Not connected to Internet");
        _fakeSubStories = [];
      }
    }).catchError((e) {
      debugPrint(e.toString());
      debugPrint("data done with error");
      _isLoading=false;
      notifyListeners();
    });
    _isLoading=false;
    notifyListeners();
    return _fakeSubStories!;
  }
  Future<List<Story>> getConfirmedStories() async {
    _isLoading=true;
    notifyListeners();
    debugPrint("Fetching first 24 confirmed stories!");
    _confirmedStories = [];
    _confirmedSubStories = [];
    await _firestore
        .collection(STORY_COLLECTION)
        .where('review', isEqualTo: true)
        .where("isFaked",isEqualTo:false)
        .where("inHeadlines",isEqualTo:false)
        .orderBy("createdAt", descending: true)
        .limit(24)
        .get()
        .then((value) {
      _confirmedStories = [];
      confirmedStoriesDocSnaps = value.docs;
      _confirmedStories=confirmedStoriesDocSnaps!.map((e) => Story.fromDocumentSnapshot(e)).toList();
      if (_confirmedStories != []) {
        debugPrint("${_confirmedStories!.length} confirmedStories fetched!");
        _confirmedSubStories = _confirmedStories;
        notifyListeners();
      } else {
        debugPrint("Not connected to Internet");
        _confirmedSubStories = [];
      }
    }).catchError((e) {
      debugPrint(e.toString());
      debugPrint("data done with error");
      _isLoading=false;
      notifyListeners();
    });
    _isLoading=false;
    notifyListeners();
    return _confirmedSubStories!;
  }
  Future<List<Story>> getJustInStories() async {
    _isLoading=true;
    notifyListeners();
    debugPrint("Fetching first 24 justIn stories!");
    _justInStories = [];
    _justInSubStories = [];
    await _firestore
        .collection(STORY_COLLECTION)
        .where('review', isEqualTo: true)
        .where("inHeadlines",isEqualTo:true)
        .orderBy("createdAt", descending: true)
        .limit(24)
        .get()
        .then((value) {
      _justInStories = [];
      justInStoriesDocSnaps = value.docs;
      _justInStories=justInStoriesDocSnaps!.map((e) => Story.fromDocumentSnapshot(e)).toList();
      if (_justInStories != []) {
        debugPrint("${_justInStories!.length} justInStories fetched!");
        _justInSubStories = _justInStories;
        notifyListeners();
      } else {
        debugPrint("Not connected to Internet");
        _justInSubStories = [];
      }
    }).catchError((e) {
      debugPrint(e.toString());
      debugPrint("data done with error");
      _isLoading=false;
      notifyListeners();
    });
    _isLoading=false;
    notifyListeners();
    return _justInSubStories!;
  }
  
  Future uploadStoryImage(String filePath,String id) async {
    String userPhotoPath = "stories/$id";
    try {
      _isLoading = true;
      notifyListeners();
      await _storage.ref(userPhotoPath).putFile(File(filePath));
      String downloadUrl = await _storage.ref(userPhotoPath).getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint(e.toString());
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<List?> seeMoreStories() async {
    _isLoading=true;
    notifyListeners();
    debugPrint("Fetching more stories!");
    await _firestore
        .collection(USER_COLLECTION)
        .where('review', isEqualTo: true)
        .orderBy("createdAt", descending: true)
        .startAfterDocument(storiesDocSnaps![storiesDocSnaps!.length - 1])
        .limit(24)
        .get()
        .then((value) {
      for (final doc in value.docs) {
        storiesDocSnaps!.add(doc);
      }
      for (final f in value.docs) {
        Map<String, dynamic> map;
        map = f.data();
        map['createdAt'] = map['createdAt'].toString();
        _stories!.add(Story.fromJson(map));
      }
      if (_stories != []) {
        final int len = _stories!.length;
        final double pageNumber = len / 24;
        debugPrint("${value.docs.length} stories fetched!");
        debugPrint("$len total stories fetched!");
        debugPrint("PageNumber: $pageNumber");
        _subStories!.addAll(_stories!.sublist(_subStories!.length));
      } else {
        debugPrint("Not connected to Internet");
      }
    });
     _isLoading=false;
      notifyListeners();
    return _subStories;
  }
  Future<List?> seeMoreFakeStories() async {
    _isLoading=true;
    notifyListeners();
    debugPrint("Fetching more fake stories!");
    await _firestore
        .collection(USER_COLLECTION)
        .where('review', isEqualTo: true)
        .where('isFaked', isEqualTo: true)
        .orderBy("createdAt", descending: true)
        .startAfterDocument(fakeStoriesDocSnaps![fakeStoriesDocSnaps!.length - 1])
        .limit(24)
        .get()
        .then((value) {
      for (final doc in value.docs) {
        fakeStoriesDocSnaps!.add(doc);
      }
      for (final f in value.docs) {
        Map<String, dynamic> map;
        map = f.data();
        map['createdAt'] = map['createdAt'].toString();
        _fakeStories!.add(Story.fromJson(map));
      }
      if (_fakeStories != []) {
        final int len = _fakeStories!.length;
        final double pageNumber = len / 24;
        debugPrint("${value.docs.length} fake stories fetched!");
        debugPrint("$len total fake stories fetched!");
        debugPrint("PageNumber: $pageNumber");
        _subStories!.addAll(_fakeStories!.sublist(_fakeSubStories!.length));
      } else {
        debugPrint("Not connected to Internet");
      }
    });
     _isLoading=false;
      notifyListeners();
    return _fakeSubStories;
  }
  Future<List?> seeMoreConfirmedStories() async {
    _isLoading=true;
    notifyListeners();
    debugPrint("Fetching more confirmed stories!");
    await _firestore
        .collection(USER_COLLECTION)
        .where('review', isEqualTo: true)
        .where('isFaked', isEqualTo: false)
        .orderBy("createdAt", descending: true)
        .startAfterDocument(confirmedStoriesDocSnaps![confirmedStoriesDocSnaps!.length - 1])
        .limit(24)
        .get()
        .then((value) {
      for (final doc in value.docs) {
        confirmedStoriesDocSnaps!.add(doc);
      }
      for (final f in value.docs) {
        Map<String, dynamic> map;
        map = f.data();
        map['createdAt'] = map['createdAt'].toString();
        _confirmedStories!.add(Story.fromJson(map));
      }
      if (_confirmedStories != []) {
        final int len = _confirmedStories!.length;
        final double pageNumber = len / 24;
        debugPrint("${value.docs.length} confirmed stories fetched!");
        debugPrint("$len total confirmed stories fetched!");
        debugPrint("PageNumber: $pageNumber");
        _subStories!.addAll(_confirmedStories!.sublist(_confirmedSubStories!.length));
      } else {
        debugPrint("Not connected to Internet");
      }
    });
     _isLoading=false;
      notifyListeners();
    return _confirmedSubStories;
  }

  }
