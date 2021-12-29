import 'package:flutter/material.dart';
import 'package:jamii_check/data/profile/story/story_provider.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:jamii_check/ui/widgets/home/home_story_card.dart';
import 'package:provider/provider.dart';

class FullJustInFactsCheckScreen extends StatefulWidget {
  const FullJustInFactsCheckScreen({Key? key}) : super(key: key);

  @override
  _FullJustInFactsCheckScreenState createState() =>
      _FullJustInFactsCheckScreenState();
}

class _FullJustInFactsCheckScreenState
    extends State<FullJustInFactsCheckScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: AppBar(
            title: Row(
              children: const [
                Text(
                  "Just In news",
                )
              ],
            ),
            leading: IconButton(
                icon: const Icon(JamIcons.chevron_left),
                onPressed: () => Navigator.pop(context)),
            backgroundColor: JAMII_PRIMARY_COLOR,
          )),
      backgroundColor: Colors.white,
      body: Consumer<StoryProvider>(builder: (context, storyProvider, child) {
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          separatorBuilder: (ctx, i) {
            return const Divider(
              color: Colors.black38,
            );
          },
          scrollDirection: Axis.vertical,
          itemCount: storyProvider.justInStories.length,
          itemBuilder: (context, index) {
            return HomeStoryCard(story: storyProvider.justInStories[index]);
          },
        );
      }),
    );
  }
}
