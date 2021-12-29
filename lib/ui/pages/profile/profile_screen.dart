import 'package:flutter/material.dart';
import 'package:jamii_check/global/globals.dart' as globals;
import 'package:jamii_check/ui/pages/profile/connected_user_screen.dart';
import 'package:jamii_check/ui/pages/profile/not_connected_user_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    if (globals.jamiiUser.loggedIn == false) {
      return const NotCoonectedUserScreen();
    } else {
      return const ConnectedUserScreen();
    }
  }
}
