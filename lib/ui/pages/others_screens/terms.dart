import 'package:flutter/material.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({ Key? key }) : super(key: key);

  @override
  _TermsScreenState createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: JAMII_PRIMARY_COLOR,
        elevation: 0,
        title: const Text("Terms and Privacy Policy",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: const SizedBox.shrink()
      ),
      backgroundColor: Colors.white,
    );
  }
}