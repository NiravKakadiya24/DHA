import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamii_check/global/globals.dart';

class NotCoonectedUserScreen extends StatelessWidget {
  const NotCoonectedUserScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text("Profile",style: TextStyle(color: JAMII_PRIMARY_COLOR),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Create a jamiiForums Account"),
            Divider(),
            Text("Log into an existing jamiiForums Account"),
          ],
        ),
      ),
    );
  }
}