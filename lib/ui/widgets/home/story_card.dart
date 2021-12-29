import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jamii_check/data/favourites/provider/bookmark_provider.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:jamii_check/ui/pages/story/story_detail_screen.dart';
import 'package:jamii_check/utils/dimensions.dart';
import 'package:jamii_check/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:jamii_check/models/story_model.dart';
import 'package:jamii_check/theme/toasts.dart' as toasts;

class StoryCard extends StatefulWidget {
  final Story? story;
  const StoryCard({ Key? key,@required this.story }) : super(key: key);
  @override
  _StoryCardState createState() => _StoryCardState();
}
class  _StoryCardState extends State<StoryCard> {
  bool isMarked=false;

  @override
  void initState() {
    checkBookmark();
    super.initState();
  }
  checkBookmark(){
  final bookedIds=Provider.of<BookmarkProvider>(context, listen: false).bookmarkList
  .map((book) => book.id);
  if(bookedIds.contains(widget.story!.id!)){
    setState(() {
      isMarked=true;
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
                width: null,
                height: 150,
                padding: const EdgeInsets.only(left:8,top: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 1)]),
                child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.only(left:Dimensions.PADDING_SIZE_SMALL,right:Dimensions.PADDING_SIZE_SMALL,top:Dimensions.PADDING_SIZE_SMALL),
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
                                color:widget.story!.isFaked==true? JAMII_RED_COLOR:JAMII_GREEN_COLOR,
                                child: Center(child: Text(widget.story!.isFaked==true?"FAKE":"VERIFIED")),
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
                                IconButton(onPressed: ()async{
                                  
                                  if(isMarked){
                                    setState(() {
                                      isMarked=!isMarked;
                                    });
                                    await Provider.of<BookmarkProvider>(context, listen: false).deleteBookmarkList(widget.story!.id!);
                                    toasts.error("removed");
                                  }else{
                                      setState(() {
                                      isMarked=!isMarked;
                                    });
                                    await Provider.of<BookmarkProvider>(context, listen: false).addBookmarkList(widget.story!.id!);
                                    toasts.codeSend("bookmarked");
                                  }
                                },
                                icon: isMarked?
                                const Icon(JamIcons.bookmark_f,color:JAMII_PRIMARY_COLOR,)
                                :const Icon(JamIcons.bookmark,color: Colors.black,))
                              ]),
                            ],
                        ),
                      ),
                    ),
                  ]),
              ),
            );
  }
}