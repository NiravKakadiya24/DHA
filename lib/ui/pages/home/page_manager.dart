import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamii_check/data/page_manager/provider/page_provider.dart';
import 'package:jamii_check/global/globals.dart' as globals;
import 'package:jamii_check/helper/network_info.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:jamii_check/ui/pages/bookmark/bookmark_screen.dart';
import 'package:jamii_check/ui/pages/home/home_screen.dart';
import 'package:jamii_check/ui/pages/others_screens/jf_support.dart';
import 'package:jamii_check/ui/pages/others_screens/my_stories.dart';
import 'package:jamii_check/ui/pages/others_screens/settings.dart';
import 'package:jamii_check/ui/pages/profile/profile_screen.dart';
import 'package:jamii_check/ui/pages/search/search_screen.dart';
import 'package:jamii_check/ui/pages/story/upload_story_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jamii_check/main.dart' as main;

class PageManager extends StatefulWidget {
  const PageManager({Key? key}) : super(key: key);

  @override
  _PageManagerState createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager> {
  final PageController _pageController = PageController(initialPage: 2);
  List<Widget>? _screens;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool showToolTip = false;
  bool imageNotFound = false;

  @override
  void initState() {
    super.initState();

    _screens = [
      const UploadStoryScreen(),
      const SearchScreen(),
      HomeScreen(pageManagerKey: _scaffoldKey),
      const BookmarkScreen(),
      const ProfileScreen()
    ];
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      bool hasSeen = (main.prefs.get('hasSeenTooltip') as bool?) ?? false;
      if (!hasSeen) {
        showToolTip = true;
      }
    });
    NetworkInfo.checkConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      bool hasSeen = (main.prefs.get('hasSeenTooltip') as bool?) ?? false;
      if (!hasSeen) {
        setState(() {
          showToolTip = true;
        });
      }
    });
    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
              child: Container(
            color: const Color(0xFF3E2151),
            child: ListView(
              children: [
                const SizedBox(
                  height: 50,
                ),
                ListTile(
                  title: const Text("Settings",
                      style: TextStyle(
                          color: Colors.white70,
                          fontFamily: "Ubuntu",
                          fontWeight: FontWeight.w200)),
                  trailing: const Icon(
                    JamIcons.chevron_down,
                    color: Colors.white70,
                    size: 17,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const SettingsScreen(
                                  isFromMenu: true,
                                )));
                  },
                ),
                const Divider(color: Colors.white70),
                ListTile(
                  title: const Text("My Stories",
                      style: TextStyle(
                          color: Colors.white70,
                          fontFamily: "Ubuntu",
                          fontWeight: FontWeight.w200)),
                  trailing: const Icon(JamIcons.chevron_down,
                      color: Colors.white70, size: 17),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const MyStoriesScreen()));
                  },
                ),
                const Divider(color: Colors.white70),
                ListTile(
                  title: const Text("Saved Stories",
                      style: TextStyle(
                          color: Colors.white70,
                          fontFamily: "Ubuntu",
                          fontWeight: FontWeight.w200)),
                  trailing: const Icon(JamIcons.chevron_down,
                      color: Colors.white70, size: 17),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                const BookmarkScreen(isFromMenu: true)));
                  },
                ),
                const Divider(color: Colors.white70),
                ListTile(
                  title: const Text("JamiiForums",
                      style: TextStyle(
                          color: Colors.white70,
                          fontFamily: "Ubuntu",
                          fontWeight: FontWeight.w200)),
                  trailing: const Icon(JamIcons.chevron_down,
                      color: Colors.white70, size: 17),
                  onTap: () {
                    Navigator.pop(context);
                    launch("https://jamiiforums.com/");
                  },
                ),
                const Divider(color: Colors.white70),
                ListTile(
                  title: const Text(
                    "JF Support",
                    style: TextStyle(
                        color: Colors.white70,
                        fontFamily: "Ubuntu",
                        fontWeight: FontWeight.w200),
                  ),
                  trailing: const Icon(JamIcons.chevron_down,
                      color: Colors.white70, size: 17),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const JfSupportScreen()));
                  },
                ),
                const Divider(color: Colors.white70),
              ],
            ),
          )),
          backgroundColor: const Color(0xFFf7f7f7),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: Provider.of<PageManagerProvider>(
              context,
            ).selectedIndex,
            items: const [
              BottomNavigationBarItem(
                  title: Text(
                    'story',
                    style: TextStyle(color: globals.JAMII_PRIMARY_COLOR),
                  ),
                  activeIcon: Icon(
                    JamIcons.plus_circle,
                    color: globals.JAMII_PRIMARY_COLOR,
                  ),
                  icon: Icon(JamIcons.plus_circle, color: Colors.grey)),
              BottomNavigationBarItem(
                  title: Text('search',
                      style: TextStyle(color: globals.JAMII_PRIMARY_COLOR)),
                  activeIcon: Icon(
                    JamIcons.search,
                    color: globals.JAMII_PRIMARY_COLOR,
                  ),
                  icon: Icon(JamIcons.search, color: Colors.grey)),
              BottomNavigationBarItem(
                  title: Text('home',
                      style: TextStyle(color: globals.JAMII_PRIMARY_COLOR)),
                  activeIcon: Icon(
                    JamIcons.home_f,
                    color: globals.JAMII_PRIMARY_COLOR,
                  ),
                  icon: Icon(JamIcons.home, color: Colors.grey)),
              BottomNavigationBarItem(
                  title: Text('bookmarks',
                      style: TextStyle(color: globals.JAMII_PRIMARY_COLOR)),
                  activeIcon: Icon(
                    JamIcons.bookmark_f,
                    color: globals.JAMII_PRIMARY_COLOR,
                  ),
                  icon: Icon(JamIcons.bookmark, color: Colors.grey)),
              BottomNavigationBarItem(
                  title: Text('profile',
                      style: TextStyle(color: globals.JAMII_PRIMARY_COLOR)),
                  activeIcon: Icon(
                    JamIcons.user_circle,
                    color: globals.JAMII_PRIMARY_COLOR,
                  ),
                  icon: Icon(JamIcons.user_circle, color: Colors.grey)),
            ],
            onTap: (int index) {
              Provider.of<PageManagerProvider>(context, listen: false)
                  .changeTab(index);
              _pageController.jumpToPage(index);
            },
          ),
          body: DoubleBackToCloseApp(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _screens!.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _screens![index];
              },
            ),
            snackBar: const SnackBar(
              content: Text('Tap back again to leave'),
            ),
          ),
        ),
        showToolTip
            ? Positioned(
                left: -100,
                bottom: -20,
                child: Container(
                  height: 500,
                  width: 500,
                  decoration: BoxDecoration(
                      color: globals.JAMII_PRIMARY_COLOR.withOpacity(0.9),
                      shape: BoxShape.circle),
                  child: GestureDetector(
                    onTap: ()async{
                      setState(() {
                                        showToolTip = false;
                                      });
                                      await main.prefs
                                          .put('hasSeenTooltip', true);
                    },
                    child: Center(
                      child: Material(
                        color: Colors.transparent,
                        child: Stack(
                          children: [
                            const Positioned(
                              left: 130,
                              bottom: 250,
                              child: Text(
                                "Verify facts and publish newsworthy stories.",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                            const Positioned(
                              left: 130,
                              bottom: 225,
                              child: Text(
                                "Tell the world stories you care about",
                                style: TextStyle(color: Colors.white60),
                              ),
                            ),
                            const Positioned(
                                left: 130,
                                bottom: 90,
                                child: Text("My article",
                                    style: TextStyle(color: Colors.white))),
                            Positioned(
                                left: 110,
                                bottom: 28,
                                child: IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        showToolTip = false;
                                      });
                                      await main.prefs
                                          .put('hasSeenTooltip', true);
                                      Provider.of<PageManagerProvider>(context,
                                              listen: false)
                                          .changeTab(0);
                                      _pageController.jumpToPage(0);
                                    },
                                    icon: const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        JamIcons.plus_circle,
                                        color: globals.JAMII_PRIMARY_COLOR,
                                      ),
                                    )))
                            ,Positioned(
                              right: 130,
                              top: 50,
                              child: IconButton(
                                  onPressed: () async{
                                    setState(() {
                                      showToolTip = false;
                                    });
                                    await main.prefs.put('hasSeenTooltip', true);
                                  },
                                  icon: const Icon(
                                    JamIcons.close,
                                    color: Colors.white,
                                    size: 80,
                                  )),
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
