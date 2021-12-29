import 'package:flutter/material.dart';
import 'package:jamii_check/data/profile/provider/profile_provider.dart';
import 'package:jamii_check/models/story_model.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jamii_check/global/globals.dart' as globals;
import 'package:jamii_check/ui/widgets/basewidgets/loader/custom_loader.dart';
import 'package:jamii_check/ui/widgets/home/story_card.dart';
import 'package:provider/provider.dart';

class MyStoriesScreen extends StatefulWidget {
  const MyStoriesScreen({ Key? key}) : super(key: key);

  @override
  _MyStoriesScreenState createState() => _MyStoriesScreenState();
}

class _MyStoriesScreenState extends State<MyStoriesScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool imageNotFound=false;
  @override
  Widget build(BuildContext context) {
    final CollectionReference stories = firestore.collection('stories');
    return Scaffold(
      appBar: AppBar(
            title: const Text(
              "Publish History",
            ),
            centerTitle: true,
            actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Consumer<ProfileProvider>(
                  builder: (_, profileProvider, child) {
                return imageNotFound
                    ? CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 15,
                        child: Center(
                          child: Text(
                            profileProvider.jamiiUser.name![0],
                            style: const TextStyle(
                                color: globals.JAMII_PRIMARY_COLOR,
                                fontSize: 30),
                          ),
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 15,
                        backgroundImage: NetworkImage(
                          profileProvider.jamiiUser.profilePhoto!,
                        ),
                        onBackgroundImageError: (_, st) {
                          setState(() {
                            imageNotFound = true;
                          });
                        },
                      );
              }),
            )
          ],
          elevation: 0,
          automaticallyImplyLeading: true,
            leading: IconButton(
                icon: const Icon(JamIcons.chevron_left),
                onPressed: ()=>Navigator.pop(context)),
            backgroundColor: globals.JAMII_PRIMARY_COLOR,
          ),
          body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: stories
                  .where("userEmail", isEqualTo: globals.jamiiUser.email)
                  .where("review", isEqualTo: true)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CustomLoader(color: globals.JAMII_PRIMARY_COLOR),
                  );
                } else {
                  return snapshot.data!.docs.isEmpty?
                  Center(
        child: Padding(
          padding: const EdgeInsets.only(top:25.0),
          child: CircleAvatar(
            radius: 110,
            backgroundColor: const Color(0xFFE1E1E1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:const [
                Icon(JamIcons.plus_circle,size: 150,color: Color(0xFF65676A),),
                Text("No Published",style: TextStyle(color: Color(0xFF65676A)),)
              ] ,
            ),
          ),
        )
    )
                  : Column(
                    children: List.generate(
                      snapshot.data!.docs.length,
                      (int index) => StoryCard(story:Story.fromDocumentSnapshot(snapshot.data!.docs[index] ))
                    ),
                  );
                }
              })
        ])
    ),
    );
  }
}