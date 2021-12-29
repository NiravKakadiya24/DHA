import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/utils/dimensions.dart';
import 'package:jamii_check/utils/theme.dart';

class NoSearchResult extends StatelessWidget {
  const NoSearchResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircleAvatar(
          radius: 110,
          backgroundColor: const Color(0xFFE1E1E1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:const [
              Icon(Icons.bookmark,size: 150,color: Colors.white,),
              Text("No data",style: TextStyle(color: Colors.black),)
            ] ,
          ),
        )
    );
  }
}
