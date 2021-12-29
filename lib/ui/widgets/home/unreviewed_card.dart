import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:jamii_check/data/profile/provider/profile_provider.dart';
import 'package:jamii_check/data/profile/story/story_provider.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jamii_check/utils/dimensions.dart';
import 'package:jamii_check/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:jamii_check/models/story_model.dart';
import 'package:jamii_check/theme/toasts.dart' as toasts;

class UnreviewedCard extends StatefulWidget {
  final Story? story;
  const UnreviewedCard({Key? key, @required this.story}) : super(key: key);
  @override
  _UnreviewedCardState createState() => _UnreviewedCardState();
}

class _UnreviewedCardState extends State<UnreviewedCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: null,
      height: 150,
      padding: const EdgeInsets.only(left: 8, top: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 1)
          ]),
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          flex: 4,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: Dimensions.PADDING_SIZE_SMALL,
                    right: Dimensions.PADDING_SIZE_SMALL,
                    top: Dimensions.PADDING_SIZE_SMALL),
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(widget.story!.photoUrl!),
                  ),
                  //borderRadius:const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                ),
                /* child: FadeInImage.assetNetwork(
                      placeholder: "assets/images/placeholder.jpg", fit: BoxFit.cover,
                      image: widget.story!.photoUrl!,
                      imageErrorBuilder: (c, o, s) => Image.asset("assets/images/placeholder.jpg", fit: BoxFit.cover),
                    ), */
              ),
              Container(
                // margin: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                height: 20,
                width: MediaQuery.of(context).size.width,
                color: const Color(0xFFF9E2AC),
                child: const Center(child: Text("UNDER REVIEW")),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.story!.title!,
                  style: robotoRegular,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Row(children: [
                  Expanded(
                    child: Text(
                      timeago.format(widget.story!.createdAt!),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        final AlertDialog deleteStoryPopUp = AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: const Text(
                            'Delete this story?',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                          content: const Text(
                            "This is permanent, and this action can't be undone!",
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 14),
                          ),
                          actions: [
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              color: Theme.of(context).hintColor,
                              onPressed: () async {
                                Navigator.pop(context);
                                final snapshot = await FirebaseFirestore
                                    .instance
                                    .collection(STORY_COLLECTION)
                                    .where("id", isEqualTo: widget.story!.id!)
                                    .limit(1)
                                    .get();
                                await snapshot.docs[0].reference.delete();
                                await Provider.of<ProfileProvider>(context, listen: false)
              .decrementUnderReview();
                                toasts.codeSend(
                                    "Story successfully deleted from server!");
                              },
                              child: const Text(
                                'DELETE',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              color: Theme.of(context).errorColor,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'CANCEL',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                          backgroundColor: Colors.white,
                          actionsPadding:
                              const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        );

                        showModal(
                            context: context,
                            configuration:
                                const FadeScaleTransitionConfiguration(),
                            builder: (BuildContext context) =>
                                deleteStoryPopUp);
                      },
                      icon: const Icon(JamIcons.trash, color: Colors.red))
                ]),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
