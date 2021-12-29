import 'package:flutter/material.dart';
import 'package:jamii_check/data/profile/story/story_provider.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/ui/pages/home/featured_facts_check_view.dart';
import 'package:jamii_check/ui/pages/home/just_in_view.dart';
import 'package:jamii_check/utils/dimensions.dart';
import 'package:provider/provider.dart';

class StoryScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  StoryScreen({Key? key}) : super(key: key);

  Future<void> _loadData(BuildContext context) async {
    Provider.of<StoryProvider>(context, listen: false).initArrays();
    await Provider.of<StoryProvider>(context, listen: false).getStories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: JAMII_PRIMARY_COLOR,
          color: Colors.white,
          onRefresh: () async {
            await _loadData(context);
            return;
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                     Padding(
                        padding:const EdgeInsets.all(0), child: JustInView(scroller: _scrollController,)),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(
                            Dimensions.PADDING_SIZE_SMALL,
                            0,
                            Dimensions.PADDING_SIZE_SMALL,
                            0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Featured Facts-checked",
                                  style: TextStyle(
                                    color: Color(0xFF3E2151),
                                    fontFamily: "Ubuntu",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  )),
                              InkWell(
                                onTap: () {},
                                child: Padding(
                                    padding: const EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_SMALL),
                                    child: PopupMenuButton(
                                      icon: Image.asset(
                                        "assets/images/filter.png",
                                        height: 20,
                                        width: 20,
                                        color: const Color(0xFF3E2151),
                                      ),
                                      onSelected: (newValue) async {
                                        if (newValue == 0) {
                                          Provider.of<StoryProvider>(context,
                                                  listen: false)
                                              .changeStoryType(
                                                  StoryType.CONFIRMED);
                                        } else if (newValue == 1) {
                                          Provider.of<StoryProvider>(context,
                                                  listen: false)
                                              .changeStoryType(StoryType.FAKE);
                                        } else {
                                          Provider.of<StoryProvider>(context,
                                                  listen: false)
                                              .changeStoryType(StoryType.ALL);
                                        }
                                      },
                                      itemBuilder: (context) => const [
                                        PopupMenuItem(
                                          child: Text("VERIFIED"),
                                          value: 0,
                                        ),
                                        PopupMenuItem(
                                          child: Text("FAKE"),
                                          value: 1,
                                        ),
                                        PopupMenuItem(
                                          child: Text("ALL"),
                                          value: 2,
                                        ),
                                      ],
                                    )),
                              ),
                            ])),
                    const Divider(color: Colors.black38,),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_SMALL),
                      child: Consumer<StoryProvider>(
                          builder: (context, storyProvider, child) {
                        return FeaturedFactsCheckScreen(
                          scroller: _scrollController,
                          storyType: storyProvider.storyType,
                        );
                      }),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget? child;
  SliverDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child!;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}
