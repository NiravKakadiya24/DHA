import 'package:flutter/material.dart';
import 'package:jamii_check/data/profile/story/story_provider.dart';
import 'package:jamii_check/models/story_model.dart';
import 'package:jamii_check/ui/widgets/home/home_story_card.dart';
import 'package:provider/provider.dart';

enum StoryType {
  FAKE,
  CONFIRMED,
  ALL
}
class FeaturedFactsCheckScreen extends StatefulWidget {
  final StoryType? storyType;
  final ScrollController? scroller;
  const FeaturedFactsCheckScreen({ Key? key ,@required this.scroller,this.storyType}) : super(key: key);

  @override
  _FeaturedFactsCheckScreenState createState() => _FeaturedFactsCheckScreenState();
}

class _FeaturedFactsCheckScreenState extends State<FeaturedFactsCheckScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
      
      builder: (context, storyProvider, child) {
        List<Story> storyList=[];
        if(widget.storyType == StoryType.CONFIRMED) {
          storyList = storyProvider.confirmedStories;
        }else if(widget.storyType == StoryType.FAKE) {
          storyList = storyProvider.fakeStories;
        }else{
          storyList = storyProvider.stories;
        }
        return storyList.isNotEmpty ?
        SizedBox(
          height: 350,
          child: ListView.separated(
                                    padding: const EdgeInsets.all(0),
                                    controller:widget.scroller,
                                    separatorBuilder: (ctx,i){
                                        return const Divider(color: Colors.black38,);
                                    },
                                    scrollDirection: Axis.vertical,
                                    itemCount: storyList.length>=5?5:storyList.length,
                                    itemBuilder: (context, index) {
                                      return HomeStoryCard(story: storyList[index]);
                                      },
                                  ),
        ):const SizedBox.shrink();
      }
    );
  }
}