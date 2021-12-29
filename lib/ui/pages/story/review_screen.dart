import 'package:flutter/material.dart';
import 'package:jamii_check/models/story_model.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jamii_check/global/globals.dart' as globals;
import 'package:jamii_check/ui/widgets/basewidgets/loader/custom_loader.dart';
import 'package:jamii_check/ui/widgets/home/story_card.dart';
import 'package:jamii_check/ui/widgets/home/unreviewed_card.dart';

class ReviewScreen extends StatefulWidget {
  final bool? isReview;
  final bool? notReviewd;
  const ReviewScreen({ Key? key,@required this.isReview,@required this.notReviewd  }) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final CollectionReference stories = firestore.collection('stories');
    final CollectionReference rejectedWalls =
        firestore.collection('stories');
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation:0,
          flexibleSpace: AppBar(
            title: Row(
              children: const [
                Text(
                  "Review Status",
                )],
            ),
            leading: IconButton(
                icon: const Icon(JamIcons.chevron_left),
                onPressed: ()=>Navigator.pop(context)),
            backgroundColor: globals.JAMII_PRIMARY_COLOR,
          )),
          body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /* StreamBuilder<QuerySnapshot>(
              stream: rejectedWalls
                  .where("userEmail", isEqualTo: globals.jamiiUser.email)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  return Column(
                    children: List.generate(
                      snapshot.data!.docs.length,
                      (int index) =>
                          RejectedWallTile(snapshot.data!.docs[index]),
                    ),
                  );
                }
              }), */
          widget.isReview!?StreamBuilder<QuerySnapshot>(
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
                  return Column(
                    children: List.generate(
                      snapshot.data!.docs.length,
                      (int index) => StoryCard(story:Story.fromDocumentSnapshot(snapshot.data!.docs[index] ))
                    ),
                  );
                }
              }):const SizedBox.shrink(),
          widget.notReviewd!?StreamBuilder<QuerySnapshot>(
              stream: stories
                  .where("userEmail", isEqualTo: globals.jamiiUser.email)
                  .where("review", isEqualTo: false)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CustomLoader(color: globals.JAMII_PRIMARY_COLOR),
                  );
                } else {
                  return Column(
                    children: List.generate(
                      snapshot.data!.docs.length,
                      (int index) => UnreviewedCard(story:Story.fromDocumentSnapshot(snapshot.data!.docs[index] ))
                    ),
                  );
                }
              }):const SizedBox.shrink()
        ],
      ),
    ),
    );
  }
}