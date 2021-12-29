import 'package:flutter/material.dart';
import 'package:jamii_check/data/profile/story/story_provider.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/models/story_model.dart';
import 'package:jamii_check/ui/widgets/basewidgets/loader/custom_loader.dart';
import 'package:jamii_check/ui/widgets/home/home_story_card.dart';
import 'package:jamii_check/ui/widgets/home/story_card.dart';
import 'package:jamii_check/ui/widgets/home/top_story_card.dart';
import 'package:provider/provider.dart';

class TrueFakeScreen extends StatefulWidget {
  final String? tabName;
  const TrueFakeScreen({Key? key, @required this.tabName}) : super(key: key);

  @override
  _TrueFakeScreenState createState() => _TrueFakeScreenState();
}

class _TrueFakeScreenState extends State<TrueFakeScreen>
    with SingleTickerProviderStateMixin {
  Future<List<Story>>? _future;
  @override
  void initState() {
    super.initState();
    if (widget.tabName == "just_in") {
      _future = Future.delayed(const Duration()).then((value) =>
          Provider.of<StoryProvider>(context, listen: false).getStories());
    } else if (widget.tabName == "fake") {
      _future = Future.delayed(const Duration()).then((value) =>
          Provider.of<StoryProvider>(context, listen: false).getFakeStories());
    } else {
      _future = Future.delayed(const Duration()).then((value) =>
          Provider.of<StoryProvider>(context, listen: false)
              .getConfirmedStories());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List?>(
      future: _future, // async work
      builder: (BuildContext context, AsyncSnapshot<List?> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
                child: CustomLoader(color: JAMII_PRIMARY_COLOR));
          case ConnectionState.none:
            return const Center(
                child: CustomLoader(color: JAMII_PRIMARY_COLOR));
          default:
            if (snapshot.hasError) {
              return RefreshIndicator(
                  onRefresh: () async {
                    _future;
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Spacer(),
                      Center(child: Text("Can't connect to the Servers!")),
                      Spacer(),
                    ],
                  ));
            } else if (snapshot.data!.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/empty.png"),
                  const Text("No data")
                ],
              );
            } else {
              return StoryGrid(tabName: widget.tabName);
            }
        }
      },
    );
  }
}

class StoryGrid extends StatefulWidget {
  final String? tabName;
  const StoryGrid({Key? key, @required this.tabName}) : super(key: key);

  @override
  _StoryGridState createState() => _StoryGridState();
}

class _StoryGridState extends State<StoryGrid> {
  final GlobalKey<RefreshIndicatorState> refreshHomeKey =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController scrollController = ScrollController();
  int _current = 0;
  final ScrollController _scrollController = ScrollController();
  bool seeMoreLoader = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> refreshList() async {
    refreshHomeKey.currentState?.show();
    if (widget.tabName == "just_in") {
      Provider.of<StoryProvider>(context, listen: false).initArrays();
      await Provider.of<StoryProvider>(context, listen: false).getStories();
    } else if (widget.tabName == "fake") {
      Provider.of<StoryProvider>(context, listen: false)
          .initFakeStoriesArrays();
      await Provider.of<StoryProvider>(context, listen: false).getFakeStories();
    } else {
      Provider.of<StoryProvider>(context, listen: false)
          .initConfirmedStoriesArrays();
      await Provider.of<StoryProvider>(context, listen: false)
          .getConfirmedStories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: CustomScrollView(controller: _scrollController, slivers: [
          SliverToBoxAdapter(
            child: RefreshIndicator(
              backgroundColor: JAMII_PRIMARY_COLOR,
              color: Colors.white,
              key: refreshHomeKey,
              onRefresh: refreshList,
              child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  if (!seeMoreLoader) {
                    setState(() {
                      seeMoreLoader = true;
                    });
                    //Data.seeMorePrism();
                    setState(() {
                      Future.delayed(const Duration(seconds: 1))
                          .then((value) => seeMoreLoader = false);
                    });
                  }
                }
                return false;
              }, child: Consumer<StoryProvider>(
                builder: (context, storyProvider, child) {
                  final subs = widget.tabName == "just_in"
                      ? storyProvider.subStories
                      : widget.tabName == "fake"
                          ? storyProvider.fakeSubStories
                          : storyProvider.confirmedSubStories;
                  return subs.isNotEmpty
                      ? Row(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                        padding: const EdgeInsets.all(0),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: subs.length,
                                        itemBuilder: (context, index) {
                                          return StoryCard(story: subs[index]);
                                        },
                                      ),
                          ),
                        ],
                      )
                      : const Text("nothing");
                },
              )),
            ),
          )
        ]),
      ),
    );
  }
}
