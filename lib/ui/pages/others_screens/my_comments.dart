import 'package:flutter/material.dart';
import 'package:jamii_check/models/comment_model.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jamii_check/global/globals.dart' as globals;
import 'package:jamii_check/ui/widgets/basewidgets/loader/custom_loader.dart';
import 'package:jamii_check/ui/widgets/story/my_comment_card.dart';

class MyCommentsScreen extends StatefulWidget {
  const MyCommentsScreen({Key? key}) : super(key: key);

  @override
  _MyCommentsScreenState createState() => _MyCommentsScreenState();
}

class _MyCommentsScreenState extends State<MyCommentsScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final CollectionReference comments = firestore.collection('comments');
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: AppBar(
            title: Row(
              children: const [
                Text(
                  "Comments History",
                )
              ],
            ),
            leading: IconButton(
                icon: const Icon(JamIcons.chevron_left),
                onPressed: () => Navigator.pop(context)),
            backgroundColor: globals.JAMII_PRIMARY_COLOR,
          )),
      body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            StreamBuilder<QuerySnapshot>(
                stream: comments
                    .where("userEmail", isEqualTo: globals.jamiiUser.email)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CustomLoader(color: globals.JAMII_PRIMARY_COLOR),
                    );
                  } else {
                    return snapshot.data!.docs.isEmpty
                        ? Center(
                            child: CircleAvatar(
                            radius: 110,
                            backgroundColor: const Color(0xFFE1E1E1),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.comment,
                                  size: 150,
                                  color: Colors.white,
                                ),
                                Text(
                                  "No comment",
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            ),
                          ))
                        : Column(
                            children: List.generate(
                                snapshot.data!.docs.length,
                                (int index) => MyCommentCard(
                                    comment: Comment.fromDocumentSnapshot(
                                        snapshot.data!.docs[index]))),
                          );
                  }
                })
          ])),
    );
  }
}
