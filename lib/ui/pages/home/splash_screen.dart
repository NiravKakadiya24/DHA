import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jamii_check/data/favourites/provider/bookmark_provider.dart';
import 'package:jamii_check/data/notifications/notifications.dart';
import 'package:jamii_check/data/profile/provider/profile_provider.dart';
import 'package:jamii_check/data/profile/story/story_provider.dart';
import 'package:jamii_check/data/search/provider/search_provider.dart';
import 'package:jamii_check/global/globals.dart' as globals;
import 'package:jamii_check/main.dart' as main;
import 'package:jamii_check/ui/pages/auth/login_screen.dart';
import 'package:jamii_check/ui/pages/home/page_manager.dart';
import 'package:provider/provider.dart';

class SplashWidget extends StatefulWidget {
  const SplashWidget({
    Key? key,
  }) : super(key: key);

  @override
  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  Future<List>? _future;

  @override
  void initState() {
    super.initState();
    _future = Future.delayed(const Duration()).then((value) {
      final List<Future> futures = [
        Provider.of<StoryProvider>(context, listen: false).getStories(),
        Provider.of<StoryProvider>(context, listen: false).getFakeStories(),
        Provider.of<StoryProvider>(context, listen: false).getConfirmedStories(),
        Provider.of<StoryProvider>(context, listen: false).getJustInStories()
      ];
      if (globals.jamiiUser.loggedIn == true) {
        futures.add(loadNotifs());
        futures.add(
            Provider.of<ProfileProvider>(context, listen: false).getUserInfo());
        futures.add(Provider.of<ProfileProvider>(context, listen: false)
            .getPublishedCount());
        futures.add(Provider.of<ProfileProvider>(context, listen: false)
            .getCommentsCount());
        futures.add(Provider.of<ProfileProvider>(context, listen: false)
            .getUnderReviewCount());
        futures.add(Provider.of<BookmarkProvider>(context, listen: false)
            .initBookMarks());
        futures.add(Provider.of<SearchProvider>(context, listen: false)
            .initHistoryList());
      }
      return Future.wait(futures);
    });
  }

  Future loadNotifs() async {
    await getNotifs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return globals.jamiiUser.loggedIn==true?const PageManager():const LoginScreen();
        }
        return const SecondarySplash();
      },
    );
  }
}

class SecondarySplash extends StatelessWidget {
  const SecondarySplash({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          stops: const [0, 0.88,  0.4],
          end: Alignment.bottomRight,
          colors: <Color>[
            globals.JAMII_PRIMARY_COLOR.withOpacity(0.4),
            Colors.white,
            //globals.JAMII_PRIMARY_COLOR.withAlpha(23),
            globals.JAMII_PRIMARY_COLOR.withOpacity(0.1)
          ],
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/jamii_splash.png",
              height: 80,
              width: 200,
            ),
            const Text(
              "It's your right to know the facts",
              style:
                  TextStyle(color: globals.JAMII_PRIMARY_COLOR, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
