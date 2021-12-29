import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:jamii_check/models/user_model.dart';
import 'package:jamii_check/global/globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:jamii_check/main.dart" as main;
import 'package:jamii_check/ui/pages/auth/login_screen.dart';

String USER_COLLECTION="users";
class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;
  bool _isRemember = false;
  late Box prefs;
  int _selectedIndex = 0;
  int get selectedIndex =>_selectedIndex;

  updateSelectedIndex(int index){
    _selectedIndex = index;
    notifyListeners();
  }


  bool get isLoading => _isLoading;
  bool get isRemember => _isRemember;

  void updateRemember(bool value) {
    _isRemember = value;
    notifyListeners();
  }
Future resetPassword(String email) async{
  _isLoading=true;
  notifyListeners();
  try {
    await _auth.sendPasswordResetEmail(email: email);
    _isLoading=false;
    notifyListeners();
    return true;
  } catch (e) {
    _isLoading=false;
   notifyListeners();
   return e.toString();
  }
}
Future signUp(String email, String password,String username,String picUrl, Function callback) async {
    try {
      _isLoading = true;
      notifyListeners();
      prefs = await Hive.openBox('prefs');
      UserCredential userCredential=await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user=userCredential.user!;
        globals.jamiiUser = JamiiUser(
          name: user.email!.split("@")[0],
          createdAt: DateTime.now().toUtc().toIso8601String(),
          email: user.email,
          username: username,
          coins: 0,
          id: user.uid,
          lastLoginAt: DateTime.now().toUtc().toIso8601String(),
          loggedIn: true,
          profilePhoto:picUrl,
          method: "email",
          restricted: false
        );
        FirebaseFirestore.instance
            .collection(USER_COLLECTION)
            .doc(globals.jamiiUser.id)
            .set(globals.jamiiUser.toJson());
      _isLoading = false;
      notifyListeners();
      await prefs.put(main.userHiveKey, globals.jamiiUser);
      callback(true, "signup okay");
      notifyListeners();
      debugPrint("Accoutn created");
      return user.uid;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      callback(false, e.message);
      debugPrint(e.message);
      return e.message;
    }
  }
Future checkUsername(String username) async {
    try {
      _isLoading = true;
      notifyListeners();
        final QuerySnapshot snapshot=await FirebaseFirestore.instance
            .collection(USER_COLLECTION)
            .where("username",isEqualTo: username)
            .get();
      if(snapshot.docs.isEmpty){
        _isLoading=false;
        notifyListeners();
        debugPrint("username available");
        return true;
      }else{
        debugPrint("username not available");
        List<String> suggested=getSuggestedUserNames(username);
        final QuerySnapshot suggestions=await FirebaseFirestore.instance
            .collection(USER_COLLECTION)
            .where("username",whereIn: suggested)
            .get();
        _isLoading=false;
        notifyListeners();
        return suggestions.docs.isEmpty?suggested:[];
      }
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint(e.message);
      return e.message;
    }
  }
Future uploadProfileImage(String filePath,String id) async {
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
Future logIn(String email, String password, Function callback) async {
    try {
      _isLoading = true;
      notifyListeners();
      prefs = await Hive.openBox('prefs');
      UserCredential userCredential=await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user=userCredential.user!;
      final DocumentSnapshot? usersData = await getUsersData(user);
      if(usersData!=null){
        final doc = usersData;
        globals.jamiiUser = JamiiUser.fromDocumentSnapshot(doc, user);
        FirebaseFirestore.instance
            .collection(USER_COLLECTION)
            .doc(globals.jamiiUser.id)
            .update({
          'lastLoginAt': DateTime.now().toUtc().toIso8601String(),
          'loggedIn': true,
        });
        await prefs.put(main.userHiveKey, globals.jamiiUser);
        callback(true, "signin okay");
        _isLoading=false;
        notifyListeners();
        debugPrint("User connected");
      }else{
        _isLoading = false;
        notifyListeners();
        callback(false, "Error retrieving user information");
      }
      _isLoading = false;
        notifyListeners();
      return user.uid;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      callback(false, e.message);
      debugPrint(e.message);
      return e.message;
    }

  }
Future<bool> isSignedIn() async {
    User? user= _auth.currentUser;
    if (user != null) {
        return true;
    } else {
        return false;
    }
  }
Future signInWithGoogle(Function callback) async {
    try {
      _isLoading = true;
    notifyListeners();
    prefs = await Hive.openBox('prefs');
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User? user = authResult.user;
    assert(user!.email != null);
    assert(user!.displayName != null);
    assert(user!.photoURL != null);
    if (user != null) {
      final DocumentSnapshot? usersData = await getUsersData(user);
      if (usersData!=null) {
        final doc = usersData;
        globals.jamiiUser = JamiiUser.fromDocumentSnapshot(doc, user);
        FirebaseFirestore.instance
            .collection(USER_COLLECTION)
            .doc(globals.jamiiUser.id)
            .update({
          'lastLoginAt': DateTime.now().toUtc().toIso8601String(),
          'loggedIn': true,
        });
        await prefs.put(main.userHiveKey, globals.jamiiUser);
        await callback(true, "google signin okay");
        _isLoading=false;
        notifyListeners();
        debugPrint("User connected");
      }
      // User not exists . Create new data in  db and sign him in.
      else {
        globals.jamiiUser = JamiiUser(
          name: user.displayName!,
          createdAt: DateTime.now().toUtc().toIso8601String(),
          email: user.email!,
          username: (user.email!.split("@"))[0],
          coins: 0,
          id: user.uid,
          lastLoginAt: DateTime.now().toUtc().toIso8601String(),
          loggedIn: true,
          profilePhoto: user.photoURL!,
          method: "google",
          restricted: false
        );
        FirebaseFirestore.instance
            .collection(USER_COLLECTION)
            .doc(globals.jamiiUser.id)
            .set(globals.jamiiUser.toJson());
        await prefs.put(main.userHiveKey, globals.jamiiUser);
        await callback(true, "google signup okay");
        _isLoading=false;
        notifyListeners();
        debugPrint("User created and connected");
      }
    }
    } catch (e) {
      _isLoading=false;
      callback(false, "Error connecting with google");
      notifyListeners();
      debugPrint("Error connecting with google $e");
    }
  }
Future<bool> signOut(BuildContext context) async {
    _isLoading=true;
    notifyListeners();
    try {
      await _auth.signOut();
    if(globals.jamiiUser.method=="google"){
      await _googleSignIn.signOut();
    }
      await FirebaseFirestore.instance
          .collection(USER_COLLECTION)
          .doc(globals.jamiiUser.id)
          .update({
        'loggedIn': false,
      });
      globals.jamiiUser = JamiiUser(
      name: "",
      method: "",
      createdAt: DateTime.now().toUtc().toIso8601String(),
      email: "",
      username: "",
      id: "",
      lastLoginAt: DateTime.now().toUtc().toIso8601String(),
      loggedIn: false,
      profilePhoto: "",
      coins: 0,
      restricted: false
    );
    Hive.openBox('prefs').then((value) {
      value.put(main.userHiveKey, globals.jamiiUser);
    });
      _isLoading=false;
      notifyListeners();
      return true;
    } catch (e, st) {
      _isLoading=false;
      notifyListeners();
      debugPrint(e.toString());
      debugPrint(st.toString());
    }
    return false;
  }





  /* Future<ResponseModel> forgetPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo.forgetPassword(email);
    _isLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      responseModel = ResponseModel(apiResponse.response.data["message"], true);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(errorMessage, false);
    }
    return responseModel;
  }
 */}

Future<DocumentSnapshot?> getUsersData(User? user) async {
    late final DocumentSnapshot? output;
    await getUser(user)
        .then((value) => output = value);
    return output;
  }
Future<DocumentSnapshot?> getUsersDataFromId(String? id) async {
    late final DocumentSnapshot? output;
    await getUserFromId(id)
        .then((value) => output = value);
    return output;
  }
Future<DocumentSnapshot?> getUserFromId(String? id) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(USER_COLLECTION)
        .where('id', isEqualTo: id)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.isNotEmpty ? documents.first : null;
  }
Future<DocumentSnapshot?> getUser(User? user) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(USER_COLLECTION)
        .where('id', isEqualTo: user!.uid)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.isNotEmpty ? documents.first : null;
  }
List<String> getSuggestedUserNames(String baseUsername) {
  final username1 = baseUsername + "" + generatateNumber();
  final username2 = baseUsername + "" + generatateNumber();
  final username3 = baseUsername + "" + generatateNumber();
  final username4 = baseUsername + "" + generatateNumber();
  final username5 = baseUsername + "" + generatateNumber();
  return [username1, username2, username3, username4, username5];
}
generatateNumber(){
 String  rndnumber="";
  final rnd= Random();
  for (var i = 0; i < 4; i++) {
  rndnumber = rndnumber + rnd.nextInt(9).toString();
  }
  return rndnumber;
}