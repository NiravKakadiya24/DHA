import 'package:flutter/material.dart';
import 'package:jamii_check/data/profile/provider/profile_provider.dart';
import 'package:jamii_check/global/globals.dart' as globals;
import 'package:jamii_check/models/comment_model.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:jamii_check/ui/widgets/story/comment_reply_card.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentCard extends StatefulWidget {
  final Comment? comment;
  final List<Comment>? replies;
  final Function? onReply;
  final Function? onDelete;
  final Function? onDeleteReply;
  final bool? isAllComments;
  const CommentCard({ Key? key ,@required this.comment,@required this.replies,@required this.onReply,required this.onDelete,@required this.onDeleteReply,this.isAllComments}) : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool imageNotFound=false;
  void _delete(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Comment deletion'),
            content: const Text('Are you sure to remove your comment?'),
            actions: [
              TextButton(
                  onPressed: () async {
                    await widget.onDelete!();
                    Navigator.pop(context);
                    await Provider.of<ProfileProvider>(context, listen: false).decrementComments();
                  },
                  child: const Text('Yes',style: TextStyle(color: Colors.green),)),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No',style: TextStyle(color: Colors.red),))
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:imageNotFound
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
                    ) ,
      title:
      RichText(text: TextSpan(
        children: [
           TextSpan(text: widget.comment!.userName!, style: const TextStyle(color: globals.JAMII_PRIMARY_COLOR)),
           TextSpan(text: " "+timeago.format(widget.comment!.createdAt!), style:const TextStyle(fontSize: 10,color: Colors.grey)),
        ]
      )),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          widget.isAllComments!? const SizedBox.shrink():Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: [
          Expanded(child: Text(widget.comment!.content!)),
          GestureDetector(
            child: const Text("reply",style: TextStyle(color: globals.JAMII_PRIMARY_COLOR),),
            onTap:()=> widget.onReply!(),)
        ],
      ),
        for (Comment c in widget.replies!) CommentReplyCard(comment: c,onDelete:  ()=>widget.onDeleteReply!(c),isAllComments: widget.isAllComments)
        
        ],
      ),
      tileColor: Colors.white,
      onLongPress: ()async{
        
        if(!widget.isAllComments! && globals.jamiiUser.email==widget.comment!.userEmail!){
           _delete(context);
        }
      },
      /* trailing: IconButton(
        icon: const Icon(Icons.more_vert,size: 15,),
        onPressed: (){

        },
      ), */

    );
  }
}