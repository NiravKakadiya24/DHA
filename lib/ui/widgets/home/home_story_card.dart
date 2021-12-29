import 'package:flutter/material.dart';
import 'package:jamii_check/data/favourites/provider/bookmark_provider.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:jamii_check/ui/pages/story/story_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:jamii_check/models/story_model.dart';
import 'package:jamii_check/theme/toasts.dart' as toasts;

class HomeStoryCard extends StatefulWidget {
  final Story? story;
  const HomeStoryCard({Key? key, @required this.story}) : super(key: key);

  @override
  _HomeStoryCardState createState() => _HomeStoryCardState();
}

class _HomeStoryCardState extends State<HomeStoryCard> {
  bool isMarked = false;

  @override
  void initState() {
    checkBookmark();
    super.initState();
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
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (context, anim1, anim2) => StoryDetailScreen(story: widget.story),
                ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
        width: null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    widget.story!.inHeadlines?
                                  "JUST IN":widget.story!.isFaked == true ? "FAKE" : "VERIFIED",
                    style: TextStyle(
                        color:widget.story!.inHeadlines?
                                  const Color(0xFFFDB917) :widget.story!.isFaked == true
                            ? JAMII_RED_COLOR
                            : JAMII_GREEN_COLOR),
                  ),
                  Text(widget.story!.title!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Ubuntu"
                      ),
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  Row(children: [
                    Expanded(
                      child: Text(
                        timeago.format(widget.story!.createdAt!),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    IconButton(
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
                                color: Colors.black,
                              ))
                  ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
