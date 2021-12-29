import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamii_check/global/globals.dart' as globals;
import 'package:jamii_check/models/comment_model.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:jamii_check/ui/pages/story/story_detail_screen_from_comments.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyCommentCard extends StatefulWidget {
  final Comment? comment;

  const MyCommentCard({
    Key? key,
    @required this.comment,
  }) : super(key: key);

  @override
  _MyCommentCardState createState() => _MyCommentCardState();
}

class _MyCommentCardState extends State<MyCommentCard> {
  bool imageNotFound = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: imageNotFound
            ? const Icon(
                JamIcons.user_circle,
                size: 30,
                color: globals.JAMII_PRIMARY_COLOR,
              )
            : Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500),
                    color: globals.JAMII_PRIMARY_COLOR),
                child: CircleAvatar(
                  backgroundColor: globals.JAMII_PRIMARY_COLOR,
                  radius: 16,
                  backgroundImage: NetworkImage(
                    widget.comment!.userPic!,
                  ),
                  onBackgroundImageError: (_, st) {
                    setState(() {
                      imageNotFound = true;
                    });
                  },
                ),
              ),
        title: RichText(
            text: TextSpan(children: [
          TextSpan(
              text: widget.comment!.userName!,
              style: const TextStyle(color: globals.JAMII_PRIMARY_COLOR)),
          TextSpan(
              text: " " + timeago.format(widget.comment!.createdAt!),
              style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ])),
        trailing: IconButton(
          icon: const Icon(
            JamIcons.arrow_square_up_right,
            color: globals.JAMII_PRIMARY_COLOR,
          ),
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => StoryDetailScreenFromComments(
                          storyId: widget.comment!.storyId,
                        )));
          },
        ),
        subtitle: Expanded(child: Text(widget.comment!.content!)),
        tileColor: Colors.white);
  }
}
