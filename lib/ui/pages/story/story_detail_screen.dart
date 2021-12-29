import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jamii_check/data/favourites/provider/bookmark_provider.dart';
import 'package:jamii_check/data/profile/provider/profile_provider.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/helper/utils.dart';
import 'package:jamii_check/models/comment_model.dart';
import 'package:jamii_check/models/story_model.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:jamii_check/ui/pages/home/title_row.dart';
import 'package:jamii_check/ui/pages/story/read_more_widget.dart';
import 'package:jamii_check/ui/widgets/story/comment_card.dart';
import 'package:jamii_check/utils/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:jamii_check/ui/widgets/story/fact_mark.dart';
import 'package:readmore/readmore.dart';
import 'package:jamii_check/theme/toasts.dart' as toasts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jamii_check/global/globals.dart' as globals;

class StoryDetailScreen extends StatefulWidget {
  final Story? story;
  const StoryDetailScreen({Key? key, @required this.story}) : super(key: key);

  @override
  _StoryDetailScreenState createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  final FocusNode _commentFocus = FocusNode();
  final TextEditingController _commentController = TextEditingController();
  final ScrollController commentsScrollController = ScrollController();
  String? repliedCommentId;
  List<Comment> comments = [];
  List<Comment> noneRepliedComments = [];
  bool isMarked = false;
  bool imageNotFound = false;
  StreamController<QuerySnapshot>? _streamController;
  late QuerySnapshot finalQuery;
  List<DocumentSnapshot> finalDocs = [];
  final FirebaseFirestore databaseReference = FirebaseFirestore.instance;
  CollectionReference? walls;
  @override
  void initState() {
    checkBookmark();
    _streamController = StreamController.broadcast();
    if (!_streamController!.isClosed) {
      _streamController!.stream.listen((p) {
        setState(() {
          finalQuery = p;
          finalDocs = [];
          comments = [];
          noneRepliedComments = [];
          for (final doc in finalQuery.docs) {
            finalDocs.add(doc);
            debugPrint(doc.data().toString());
            Comment cmt = Comment.fromDocumentSnapshot(doc);
            comments.add(cmt);
            if (cmt.repliedCommentId == "") {
              noneRepliedComments.add(cmt);
            }
            debugPrint(comments.toString());
          }
        });
      });
    }
    load(_streamController!);
    super.initState();
  }

  Future<void> load(StreamController<QuerySnapshot> sc) async {
    databaseReference
        .collection("comments")
        .where("storyId", isEqualTo: widget.story!.id!)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .pipe(sc);
  }

  Future<void> commentStory() async {
    try {
      FocusScope.of(context).unfocus();
      String repliedContent = _commentController.text;
      if (repliedContent.trim().contains("reply to ") &&
          repliedCommentId != null) {
        List splits = repliedContent.split(":");
        splits.removeAt(0);
        repliedContent = splits.join(":");
      } else {
        setState(() {
          repliedCommentId = null;
        });
      }
      Comment comment = Comment(
          content: repliedContent,
          storyId: widget.story!.id,
          createdAt: DateTime.now().toUtc(),
          moderated: true,
          userEmail: globals.jamiiUser.email,
          userName: globals.jamiiUser.username,
          userPic: globals.jamiiUser.profilePhoto,
          repliedCommentId: repliedCommentId ?? "",
          id: randomId());
      await databaseReference.collection("comments").add(comment.toJson());
      _commentController.clear();
      await Provider.of<ProfileProvider>(context, listen: false)
          .incrementComments();
      setState(() {
        repliedCommentId = null;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void onReplyComment(Comment comment) async {
    setState(() {
      repliedCommentId = comment.id!;
    });
    _commentController.text = "reply to ${comment.userName}:";
    FocusScope.of(context).requestFocus(_commentFocus);
    _commentController.selection = TextSelection.fromPosition(
        TextPosition(offset: _commentController.text.length));
  }

  void onDelete(Comment comment) async {
    final snapshot = await databaseReference
        .collection("comments")
        .where("id", isEqualTo: comment.id)
        .where("userEmail", isEqualTo: comment.userEmail)
        .where("storyId", isEqualTo: comment.storyId)
        .limit(1)
        .get();
    await snapshot.docs[0].reference.delete();
  }

  checkBookmark() {
    final bookedIds = Provider.of<BookmarkProvider>(context, listen: false)
        .bookmarkList
        .map((book) => book.id);
    if (bookedIds.contains(widget.story!.id!)) {
      setState(() {
        isMarked = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _streamController = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: AppBar(
            centerTitle: true,
            elevation: 0,
            title: Image.asset(
              'assets/images/jamii_logo.png',
              height: 150,
            ),
            leading: IconButton(
                icon: const Icon(
                  JamIcons.chevron_left,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.pop(context)),
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                  icon: const Icon(
                    Icons.share,
                    color: Color(0xFF65676A),
                    size: 20,
                  ),
                  onPressed: () async {
                    await Share.share(
                        "${widget.story!.title!} \n Find this article in Jamii App",
                        subject: widget.story!.title!);
                  }),
            ],
          )),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              children: [
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 1,
                              color: widget.story!.inHeadlines?
                              const Color(0xFFFFD500):
                              widget.story!.isFaked!
                                  ? JAMII_RED_COLOR
                                  : JAMII_GREEN_COLOR)),
                      child: Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: FadeInImage.assetNetwork(
                                height: 250,
                                width: 400,
                                placeholder: "assets/images/placeholder.jpg",
                                image: widget.story!.photoUrl!,
                                fit: BoxFit.cover,
                                imageErrorBuilder: (c, o, s) => Image.asset(
                                  "assets/images/placeholder.jpg",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                              onPressed: () async {
                                if (isMarked) {
                                  setState(() {
                                    isMarked = !isMarked;
                                  });
                                  await Provider.of<BookmarkProvider>(context,
                                          listen: false)
                                      .deleteBookmarkList(widget.story!.id!);
                                  toasts.error("removed");
                                } else {
                                  setState(() {
                                    isMarked = !isMarked;
                                  });
                                  await Provider.of<BookmarkProvider>(context,
                                          listen: false)
                                      .addBookmarkList(widget.story!.id!);
                                  toasts.codeSend("bookmarked");
                                }
                              },
                              icon: isMarked
                                  ? const Icon(
                                      JamIcons.bookmark_f,
                                      color: JAMII_PRIMARY_COLOR,
                                    )
                                  : const Icon(
                                      JamIcons.bookmark,
                                      color: Colors.white,
                                    ))),
                    )
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 20, top: 5,right: 20),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 90,
                                    width: 2,
                                    color: widget.story!.inHeadlines?
                                  const Color(0xFFF9E2AC):
                                    widget.story!.isFaked!
                                        ? JAMII_RED_COLOR
                                        : JAMII_GREEN_COLOR,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.story!.title!,
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(color: Color(0xFF65676A),fontFamily: "Ubuntu",fontSize: 18)),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        widget.story!.isAnonymous!
                                            ? const SizedBox.shrink()
                                            : Text(
                                                "Story by ${widget.story!.userName}",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,fontFamily: "Ubuntu"),
                                              ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(DateFormat('yyyy-MM-dd')
                                            .format(widget.story!.createdAt!),style: const TextStyle(color: Color(0xFFC4C4C4)),),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.link,
                                              color: Color(0xFFE5E5E5),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15.0),
                                                child: Text(
                                                    widget.story!.sourceUrl!,
                                                    textAlign: TextAlign.start,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                            right: 20,
                            bottom: 30,
                            child: FactMark(
                              story: widget.story,
                            ))
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 20, top: 5,right: 20),
                    child: ReadMore(
                      story: widget.story!,
                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20,right: 20),
                    child: ReadMoreText(
                      widget.story!.content!,
                      style: const TextStyle(
                          color: Color(0xFF65676A),
                          height: 2.09,
                          fontFamily: "Ubuntu",
                          fontWeight: FontWeight.w400),
                      trimLines: 6,
                      colorClickableText: Colors.red,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'See More',
                      trimExpandedText: 'See Less',
                      lessStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: JAMII_PRIMARY_COLOR),
                      moreStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: JAMII_PRIMARY_COLOR),
                    )),
                Container(
                  margin:
                      const EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  color: Colors.white,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleRow(
                            title: 'comments(${comments.length})',
                            type: "comments",
                            comments: comments,
                            noneRepliedComments: noneRepliedComments),
                      ]),
                ),
                noneRepliedComments.isEmpty
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom),
                          itemCount: noneRepliedComments.length > 5
                              ? 5
                              : noneRepliedComments.length,
                          controller: commentsScrollController,
                          itemBuilder: (context, index) {
                            final replies = comments
                                .where((com) =>
                                    com.repliedCommentId ==
                                    noneRepliedComments[index].id)
                                .toList();
                            return CommentCard(
                              comment: noneRepliedComments[index],
                              replies: replies,
                              onReply: () =>
                                  onReplyComment(noneRepliedComments[index]),
                              onDelete: () =>
                                  onDelete(noneRepliedComments[index]),
                              onDeleteReply: onDelete,
                              isAllComments: false,
                            );
                          },
                        ),
                      )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
            child: TextFormField(
                controller: _commentController,
                focusNode: _commentFocus,
                cursorColor: Colors.black,
                maxLines: 5,
                minLines: 1,
                autofocus: false,
                keyboardType: TextInputType.text,
                onSaved: (value) {
                  debugPrint(value);
                },
                onFieldSubmitted: (value) async {
                  if (value.trim().isNotEmpty) {
                    await commentStory();
                  }
                },
                decoration: InputDecoration(
                  icon: imageNotFound
                      ? const Icon(
                          JamIcons.user_circle,
                          color: JAMII_PRIMARY_COLOR,
                        )
                      : Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(500),
                              color: JAMII_PRIMARY_COLOR),
                          child: CircleAvatar(
                            backgroundColor: JAMII_PRIMARY_COLOR,
                            radius: 16,
                            backgroundImage: NetworkImage(
                              globals.jamiiUser.profilePhoto!,
                            ),
                            onBackgroundImageError: (_, st) {
                              setState(() {
                                imageNotFound = true;
                              });
                            },
                          ),
                        ),
                  fillColor: const Color(0xFFF6F4FF),
                  focusColor: JAMII_PRIMARY_COLOR,
                  hintText: "Leave a comment...",
                  filled: true,
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Colors.transparent)),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: JAMII_PRIMARY_COLOR)),
                )),
          )
        ],
      ),
    );
  }
}
