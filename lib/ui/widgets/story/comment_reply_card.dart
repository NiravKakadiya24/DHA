import 'package:flutter/material.dart';
import 'package:jamii_check/data/profile/provider/profile_provider.dart';
import 'package:jamii_check/global/globals.dart' as globals;
import 'package:jamii_check/models/comment_model.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentReplyCard extends StatefulWidget {
  final Comment? comment;
  final Function? onDelete;
  final bool? isAllComments;
  const CommentReplyCard({ Key? key ,@required this.comment,@required this.onDelete,this.isAllComments}) : super(key: key);

  @override
  _CommentReplyCardState createState() => _CommentReplyCardState();
}

class _CommentReplyCardState extends State<CommentReplyCard> {
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
                  onPressed: () async{
                    await widget.onDelete!();
                    Navigator.of(context).pop();
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
                      size: 25,
                      color: globals.JAMII_PRIMARY_COLOR,
                    )
                  : Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                          color: globals.JAMII_PRIMARY_COLOR),
                      child: CircleAvatar(
                        backgroundColor: globals.JAMII_PRIMARY_COLOR,
                        radius: 12,
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
           TextSpan(text: widget.comment!.userName!, style: const TextStyle(color: globals.JAMII_PRIMARY_COLOR,fontSize: 12)),
           TextSpan(text: " "+timeago.format(widget.comment!.createdAt!), style:const TextStyle(fontSize: 10,color: Colors.grey)),
        ]
      )),
      subtitle: Text(widget.comment!.content!),
      tileColor: Colors.white,
      onLongPress: (){
        if(!widget.isAllComments! && globals.jamiiUser.email==widget.comment!.userEmail!){
           _delete(context);
        }
      },
    );
  }
}