import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamii_check/data/profile/story/story_provider.dart';
import 'package:jamii_check/ui/pages/home/featured_facts_check_view.dart';
import 'package:jamii_check/ui/pages/home/full_facts_check_view.dart';
import 'package:jamii_check/ui/widgets/home/home_story_card.dart';
import 'package:jamii_check/ui/widgets/home/top_story_card.dart';
import 'package:jamii_check/utils/dimensions.dart';
import 'package:provider/provider.dart';

class JustInView extends StatefulWidget {
  final ScrollController? scroller;
  const JustInView({Key? key, @required this.scroller}) : super(key: key);

  @override
  _JustInViewState createState() => _JustInViewState();
}

class _JustInViewState extends State<JustInView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(builder: (context, storyProvider, child) {
      return storyProvider.justInStories.isNotEmpty
          ? ListView(
              shrinkWrap: true,
              controller: widget.scroller,
              children: [
                TopStoryCard(story: storyProvider.justInStories[0]),
                storyProvider.justInStories.length > 1
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_SMALL),
                        child: HomeStoryCard(
                            story: storyProvider.justInStories[0]),
                      )
                    : const SizedBox.shrink(),
                const Divider(color: Colors.black38,),
                storyProvider.justInStories.length > 1
                    ? InkWell(
                      onTap: (){
                        Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      const FullJustInFactsCheckScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const[
                           Padding(
                             padding: EdgeInsets.only(right:30.0),
                             child: Text("View all"),
                           ),
                        ],
                      ),
                    )
                    : const SizedBox.shrink()
              ])
          : const SizedBox.shrink();
    });
  }
}
