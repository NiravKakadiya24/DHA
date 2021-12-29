import 'package:flutter/material.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({ Key? key }) : super(key: key);

  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: const Text(
              "Help center",
            ),
            centerTitle: true,
            leading: IconButton(
                icon: const Icon(JamIcons.chevron_left),
                onPressed: ()=>Navigator.pop(context)),
            backgroundColor:JAMII_PRIMARY_COLOR,
          ),
          body: ListView(
            padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            children:  [
              const SizedBox(height: 20,),
               const Text("How do I verify facts on JamiiCheck?",style: TextStyle(fontSize: 20),),
               const SizedBox(height: 30,),
               const Text("Select the plus(my article) on the nav-bar"),
               const SizedBox(height: 20,),
               Image.asset("assets/images/tooltip.jpg"),
               const SizedBox(height: 20,),
               const Text("That takes you to a screen where you input article details as the image below."),
               Image.asset("assets/images/publish.jpg",height: 400,),
               const SizedBox(height: 20,),
               const Text("You will receive a factcheck report from Team AI verifying the aithencity and notifying the status of the article or post."),
               const SizedBox(height: 20,),
               Image.asset("assets/images/notif.jpg"),

            ],
          ),
    );
  }
}