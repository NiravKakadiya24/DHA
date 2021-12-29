import 'package:flutter/material.dart';
import 'package:jamii_check/data/favourites/provider/bookmark_provider.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:jamii_check/ui/widgets/home/story_card.dart';
import 'package:flutter_boom_menu/flutter_boom_menu.dart';
import 'package:provider/provider.dart';

class BookmarkScreen extends StatefulWidget {
  final bool? isFromMenu;
  const BookmarkScreen({Key? key, this.isFromMenu}) : super(key: key);

  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          title: const Text("Saved News",
              style: TextStyle(color: JAMII_PRIMARY_COLOR)),
          backgroundColor: const Color(0xFFFFFFFF),
          leading: widget.isFromMenu != null
              ? IconButton(
                  icon: const Icon(
                    JamIcons.chevron_left,
                    color: JAMII_PRIMARY_COLOR,
                  ),
                  onPressed: () => Navigator.pop(context))
              : const SizedBox.shrink()),
      floatingActionButton: Consumer<BookmarkProvider>(
          builder: (context, bookmarkProvider, child) {
        return bookmarkProvider.bookmarkList.isNotEmpty
            ? BoomMenu(
                animatedIconTheme: IconThemeData(size: 22.0),
                child: const Icon(Icons.bookmark),
                onOpen: () => print('OPENING DIAL'),
                onClose: () => print('DIAL CLOSED'),
                scrollVisible: true,
                overlayColor: Colors.black,
                overlayOpacity: 0.7,
                backgroundColor: JAMII_PRIMARY_COLOR,
                marginLeft: MediaQuery.of(context).size.width / 3,
                fabAlignment: Alignment.bottomRight,
                children: [
                  MenuItem(
                    title: "Clear all",
                    titleColor: Colors.white,
                    subtitle: "Remove all saved news",
                    subTitleColor: Colors.white,
                    backgroundColor: JAMII_PRIMARY_COLOR,
                    onTap: () async {
                      await Provider.of<BookmarkProvider>(context,
                              listen: false)
                          .removeAll();
                    },
                  ),
                  MenuItem(
                    title: "Older than a week",
                    titleColor: Colors.white,
                    subtitle: "Remove saved news older than a week",
                    subTitleColor: Colors.white,
                    backgroundColor: JAMII_PRIMARY_COLOR,
                    onTap: () async {
                      await Provider.of<BookmarkProvider>(context,
                              listen: false)
                          .removeOlderThan(7);
                    },
                  ),
                  MenuItem(
                    title: "Older than a month",
                    titleColor: Colors.white,
                    subtitle: "Remove saved news older than a month",
                    subTitleColor: Colors.white,
                    backgroundColor: JAMII_PRIMARY_COLOR,
                    onTap: () async {
                      await Provider.of<BookmarkProvider>(context,
                              listen: false)
                          .removeOlderThan(30);
                    },
                  ),
                ],
              )
            : const SizedBox.shrink();
      }),
      backgroundColor: const Color(0xFFF3F2FA),
      body: Consumer<BookmarkProvider>(
        builder: (context, bookmarkProvider, child) {
          return bookmarkProvider.bookmarkList.isNotEmpty
              ? RefreshIndicator(
                  backgroundColor: JAMII_PRIMARY_COLOR,
                  color: Colors.white,
                  onRefresh: () async {
                    await Provider.of<BookmarkProvider>(context, listen: false)
                        .initBookMarks();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: bookmarkProvider.bookmarkList.length,
                    itemBuilder: (context, index) => StoryCard(
                      story: bookmarkProvider.bookmarkList[index],
                    ),
                  ),
                )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:30.0),
                    child: CircleAvatar(
                      radius: 110,
                      backgroundColor: const Color(0xFFF9F8FF),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.bookmark,
                                  size: 150,
                                  color: Colors.white,
                                ),
                                Text(
                                  "No saved news",
                                  style: TextStyle(color: Color(0xFF65676A)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
        },
      ),
    );
  }
}
