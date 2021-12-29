import 'package:flutter/material.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/models/comment_model.dart';
import 'package:jamii_check/ui/widgets/story/comment_card.dart';

class AllCommentsScreen extends StatelessWidget {
  final List<Comment>? noneRepliedComments;
  final List<Comment>? comments;
  AllCommentsScreen({ Key? key,@required this.comments,@required this.noneRepliedComments }) : super(key: key);

  final ScrollController commentsScrollController=ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All comments"),
        backgroundColor: JAMII_PRIMARY_COLOR,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top:8.0),
        child:noneRepliedComments!.isEmpty?
        const Center(child: Text("No comment for this story."),)
         :ListView.builder(
              itemCount: noneRepliedComments!.length,
              controller: commentsScrollController,
              itemBuilder: (context, index) {
                final replies=comments!.where((com) => com.repliedCommentId == noneRepliedComments![index].id).toList();
                return CommentCard(comment:noneRepliedComments![index],replies: replies,onReply:null,onDelete:null,onDeleteReply: null,isAllComments: true,);
              },
            ),
      ),
    );
  }
}