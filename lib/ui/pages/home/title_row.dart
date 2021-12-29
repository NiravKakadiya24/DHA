
import 'package:flutter/material.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/models/comment_model.dart';
import 'package:jamii_check/ui/pages/home/all_comments_screens.dart';
import 'package:jamii_check/ui/pages/home/full_facts_check_view.dart';
import 'package:jamii_check/utils/dimensions.dart';
import 'package:jamii_check/utils/theme.dart';

class TitleRow extends StatelessWidget {
  final String? title;
  final Duration? eventDuration;
  final bool? isDetailsPage;
  final String? type;
  final List<Comment>? noneRepliedComments;
  final List<Comment>? comments;
  const TitleRow({Key? key,@required this.type, @required this.title, this.eventDuration, this.isDetailsPage,this.comments,this.noneRepliedComments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int? days, hours, minutes, seconds;
    if (eventDuration != null) {
      days = eventDuration!.inDays;
      hours = eventDuration!.inHours - days * 24;
      minutes = eventDuration!.inMinutes - (24 * days * 60) - (hours * 60);
      seconds = eventDuration!.inSeconds - (24 * days * 60 * 60) - (hours * 60 * 60) - (minutes * 60);
    }

    return Row(children: [
      Text(title!, style: robotoBold),
      eventDuration == null
          ? Expanded(child: SizedBox.shrink())
          : Expanded(
              child: Row(children: [
              SizedBox(width: 5),
              TimerBox(time: days!),
              Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
              TimerBox(time: hours!),
              Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
              TimerBox(time: minutes!),
              Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
              TimerBox(time: seconds!, isBorder: true),
            ])),
            InkWell(
              onTap: ()=>type=="Facts-checked"?Navigator.push(context, MaterialPageRoute(builder: (_) => const FullJustInFactsCheckScreen())):
              Navigator.push(context, MaterialPageRoute(builder: (_) =>  AllCommentsScreen(comments: comments,noneRepliedComments: noneRepliedComments,))),
              child: Row(children: [
                isDetailsPage == null
                    ? Text("View all",
                        style: titilliumRegular.copyWith(
                          color: JAMII_PRIMARY_COLOR,
                          fontSize: Dimensions.FONT_SIZE_SMALL,
                        ))
                    : const SizedBox.shrink(),
                Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: isDetailsPage == null ? JAMII_PRIMARY_COLOR : Theme.of(context).hintColor,
                    size: Dimensions.FONT_SIZE_SMALL,
                  ),
                ),
              ]),
            )
    ]);
  }
}

class TimerBox extends StatelessWidget {
  final int? time;
  final bool isBorder;

  TimerBox({@required this.time, this.isBorder = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1),
      padding: EdgeInsets.all(isBorder ? 0 : 2),
      decoration: BoxDecoration(
        color: isBorder ? null : JAMII_PRIMARY_COLOR,
        border: isBorder ? Border.all(width: 2, color: JAMII_PRIMARY_COLOR) : null,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: Text(time! < 10 ? '0$time' : time.toString(),
          style: robotoBold.copyWith(
            color: isBorder ? JAMII_PRIMARY_COLOR : Theme.of(context).accentColor,
            fontSize: Dimensions.FONT_SIZE_SMALL,
          ),
        ),
      ),
    );
  }
}
