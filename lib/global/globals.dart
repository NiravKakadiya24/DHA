import 'package:flutter/material.dart';
import 'package:jamii_check/models/user_model.dart';
import 'package:jamii_check/main.dart' as main;

//GoogleAuth gAuth = GoogleAuth();
JamiiUser jamiiUser = main.prefs.get(
  main.userHiveKey,
  defaultValue: JamiiUser(
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
    restricted: false,
  ),
) as JamiiUser;

String topImageLink =
    'https://firebasestorage.googleapis.com/v0/b/prism-wallpapers.appspot.com/o/Replacement%20Thumbnails%2Fpost%20bg.png?alt=media&token=d708b5e3-a7ee-421b-beae-3b10946678c4';




String bannerTextOn = "true";
const JAMII_PRIMARY_COLOR= Color(0xff815AF2);
const JAMII_GREEN_COLOR=Color(0xFF12B347);
const JAMII_RED_COLOR=Colors.red;

bool tooltipShown = false;
extension CapExtension on String {
  String get inCaps =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
  String get allInCaps => toUpperCase();
  String get capitalizeFirstofEach => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.inCaps)
      .join(" ");
}
