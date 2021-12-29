import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jamii_check/data/profile/story/story_provider.dart';
import 'package:jamii_check/helper/utils.dart';
import 'package:jamii_check/models/user_model.dart';
import 'package:jamii_check/data/auth/provider/auth_provider.dart';
import 'package:jamii_check/global/globals.dart' as globals;
import 'package:jamii_check/main.dart' as main;

class ProfileProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  JamiiUser? _jamiiUser;
  int? _published;
  int? _underReview;
  int? _comments;
  bool _isLoading = false;
  late Box prefs;
  JamiiUser get jamiiUser => _jamiiUser!;
  int get published => _published!;
  int get underReview => _underReview!;
  int get comments => _comments!;
  bool get isLoading => _isLoading;

  Future<String> getUserInfo() async {
    _isLoading = true;
    notifyListeners();
    prefs = await Hive.openBox('prefs');
    final DocumentSnapshot? usersData =
        await getUsersDataFromId(globals.jamiiUser.id);
    if (usersData != null) {
      final doc = usersData;
      final user = JamiiUser.fromJson(doc.data() as Map<String, dynamic>);
      _jamiiUser = user;
      globals.jamiiUser = user;
      await prefs.put(main.userHiveKey, globals.jamiiUser);
      _isLoading = false;
      notifyListeners();
    } else {
      _isLoading = false;
      notifyListeners();
    }
    return '';
  }

  Future getPublishedCount() async {
    _isLoading = true;
    notifyListeners();
    await _firestore
        .collection(STORY_COLLECTION)
        .where('userEmail', isEqualTo: globals.jamiiUser.email)
        .get()
        .then((value) {
      _published = value.docs.length;
    }).catchError((e) {
      debugPrint(e.toString());
      _isLoading = false;
      notifyListeners();
    });
    _isLoading = false;
    notifyListeners();
    debugPrint("getPublishedCount finished");
  }

  Future getCommentsCount() async {
    _isLoading = true;
    notifyListeners();
    await _firestore
        .collection("comments")
        .where('userEmail', isEqualTo: globals.jamiiUser.email)
        .get()
        .then((value) {
      _comments = value.docs.length;
      debugPrint("getPublishedCount finished without error");
    }).catchError((e) {
      debugPrint(e.toString());
      _isLoading = false;
      notifyListeners();
      debugPrint("getPublishedCount error");
    });
    _isLoading = false;
    notifyListeners();
    debugPrint("getPublishedCount finished without error");
  }

  Future getUnderReviewCount() async {
    _isLoading = true;
    notifyListeners();
    await _firestore
        .collection(STORY_COLLECTION)
        .where('review', isEqualTo: false)
        .where('userEmail', isEqualTo: globals.jamiiUser.email)
        .get()
        .then((value) {
      _underReview = value.docs.length;
      debugPrint("getUnderReviewCount finished without error");
    }).catchError((e) {
      debugPrint(e.toString());
      _isLoading = false;
      notifyListeners();
      debugPrint("getUnderReviewCount finished with error");
    });
    _isLoading = false;
    notifyListeners();
    debugPrint("getUnderReviewCount finished without error");
  }

  Future incrementPublished() async {
    _isLoading = true;
    notifyListeners();
    _published = _published! + 1;
    _isLoading = false;
    notifyListeners();
  }

  Future incrementComments() async {
    _isLoading = true;
    notifyListeners();
    _comments = _comments! + 1;
    _isLoading = false;
    notifyListeners();
  }

  Future decrementComments() async {
    _isLoading = true;
    notifyListeners();
    _comments = _comments! - 1;
    _isLoading = false;
    notifyListeners();
  }

  Future incrementUnderReview() async {
    _isLoading = true;
    notifyListeners();
    _underReview = _underReview! + 1;
    _isLoading = false;
    notifyListeners();
  }

  Future decrementUnderReview() async {
    _isLoading = true;
    notifyListeners();
    _underReview = _underReview! - 1;
    _isLoading = false;
    notifyListeners();
  }

  Future uploadProfileImage(String filePath, String id) async {
    String userPhotoPath = "profiles/$id";
    try {
      _isLoading = true;
      notifyListeners();
      await _storage.ref(userPhotoPath).putFile(File(filePath));
      String downloadUrl = await _storage.ref(userPhotoPath).getDownloadURL();
      _isLoading = true;
      notifyListeners();
      return downloadUrl;
    } catch (e) {
      debugPrint(e.toString());
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future /* <JamiiUser> */ updateUserInfo(JamiiUser updateUserModel) async {
    _isLoading = true;
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection(USER_COLLECTION)
          .doc(globals.jamiiUser.id)
          .update(updateUserModel.toJson());
      globals.jamiiUser = updateUserModel;
      _isLoading = false;
      notifyListeners();
      return "success";
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint(e.toString());
      return e;
    }
  }

  Future changePassword(String currentPassword, String newPassword) async {
    try {
      _isLoading = true;
      notifyListeners();
      final user = FirebaseAuth.instance.currentUser;
      final cred = EmailAuthProvider.credential(
          email: user!.email!, password: currentPassword);
          await user.reauthenticateWithCredential(cred);
      user.updatePassword(newPassword).then((_)async {
        
          _isLoading = false;
          notifyListeners();
          return "success";
        }).catchError((error) {
          _isLoading = false;
          notifyListeners();
          debugPrint(error.toString());
          return error;
        });
        return "success";
    }on FirebaseException  catch (error) {
       _isLoading = false;
        notifyListeners();
        debugPrint(error.toString());
        return error;
    }
  }
}
