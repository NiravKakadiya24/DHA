// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:jamii_check/models/story_model.dart';
import 'package:jamii_check/ui/pages/story/story_detail_screen.dart';
import 'package:share/share.dart';

class TopStoryCard extends StatefulWidget {
  final Story? story;
  const TopStoryCard({Key? key, @required this.story}) : super(key: key);

  @override
  _TopStoryCardState createState() => _TopStoryCardState();
}

class _TopStoryCardState extends State<TopStoryCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
         Navigator.push(context, PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (context, anim1, anim2) => StoryDetailScreen(story: widget.story),
                ));
      },
      child: Container(
        height: 240,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
                image: NetworkImage(widget.story!.photoUrl!), fit: BoxFit.cover),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: Stack(
          children: [
            const Positioned(
                bottom: 90,
                left: 8,
                child: Text(
                  "JUST IN",
                  style: TextStyle(color:  Color(0xFFFFF8E6), fontSize: 12),
                )),
             Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 15),
                child: Text(
                  widget.story!.title!,
                  style: const TextStyle(color: Colors.white, fontSize: 25,fontFamily: "Ubuntu"),
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ),
            Positioned(
                bottom: -5,
                right: -5,
                child: IconButton(
                    onPressed: () async {
                      await Share.share(
                          "${widget.story!.title!} \n Find this article in Jamii App",
                          subject: widget.story!.title!);
                    },
                    icon: const Icon(
                      Icons.share,
                      color: Colors.white,
                    )))
          ],
        ),
      ),
    );
  }
}
