import 'dart:async';
import 'dart:io';

import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:jamii_check/data/search/provider/search_provider.dart';
import 'package:jamii_check/models/in_app_notif_model.dart';
import 'package:jamii_check/models/search_model.dart';
import 'package:jamii_check/models/user_model.dart';
import 'package:jamii_check/models/story_model.dart';
import 'package:jamii_check/models/comment_model.dart';
import 'package:jamii_check/data/auth/provider/auth_provider.dart';
import 'package:jamii_check/data/favourites/provider/bookmark_provider.dart';
import 'package:jamii_check/data/page_manager/provider/page_provider.dart';
import 'package:jamii_check/data/profile/provider/profile_provider.dart';
import 'package:jamii_check/data/profile/story/get_user_profile.dart';
import 'package:jamii_check/data/profile/story/profile_story_provider.dart';
import 'package:jamii_check/data/profile/story/story_provider.dart';
import 'package:jamii_check/notifications/local_notification.dart';
import 'package:jamii_check/ui/pages/home/splash_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:jamii_check/global/globals.dart' as globals;
import 'package:firebase_core/firebase_core.dart';

String userHiveKey = "jamiiUser";
late Box prefs;
Directory? dir;
LocalNotification localNotification = LocalNotification();
Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseInAppMessaging.instance.setMessagesSuppressed(false);
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details, forceReport: true);
  };
  localNotification = LocalNotification();
  Firebase.initializeApp().then((_) {
  getApplicationDocumentsDirectory().then(
      (dir) async {
        Hive
        ..init(dir.path)
        ..registerAdapter(JamiiUserAdapter())
        ..registerAdapter(StoryAdapter())
        ..registerAdapter(CommentAdapter())
        ..registerAdapter(SearchAdapter())
        ..registerAdapter<InAppNotif>(InAppNotifAdapter());
        prefs = await Hive.openBox('prefs');
        await Hive.openBox('localFav');
        await Hive.openBox('appsCache');
        await Hive.openBox<InAppNotif>('inAppNotifs');
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
            .then(
          (value) => runZonedGuarded<Future<void>>(
            () {
              runApp(
                MultiProvider(
                    providers: [
                      ChangeNotifierProvider<UserProfileProvider>(
                        create: (context) => UserProfileProvider(),
                      ),
                      ChangeNotifierProvider<BookmarkProvider>(
                        create: (context) => BookmarkProvider(),
                      ),
                      ChangeNotifierProvider<ProfileStoryProvider>(
                        create: (context) => ProfileStoryProvider(),
                      ),
                      ChangeNotifierProvider<AuthProvider>(
                      create: (context) => AuthProvider()),
                      ChangeNotifierProvider<PageManagerProvider>(
                      create: (context) => PageManagerProvider()),
                      ChangeNotifierProvider<ProfileProvider>(
                      create: (context) => ProfileProvider()),
                      ChangeNotifierProvider<StoryProvider>(
                      create: (context) => StoryProvider()),
                      ChangeNotifierProvider<SearchProvider>(
                      create: (context) => SearchProvider()),
                    ],
                    child: const MyApp(),
                  ),
              );
            } as Future<void> Function(),
            (obj, stacktrace) {
              debugPrint(obj.toString()+" "+ obj.toString()+" "+stacktrace.toString());
            },
          ),
        );
      },
    );
  
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> getLoginStatus() async {
    await Provider.of<AuthProvider>(context, listen: false).isSignedIn().then((value) {
      globals.jamiiUser.loggedIn = value;
      prefs.put(userHiveKey, globals.jamiiUser);
      return value;
    });
    return false;
  }

  @override
  void initState() {
  localNotification.createNotificationChannel(
        "stories", "Stories", "Get notifications for new stories.", true);
    localNotification.createNotificationChannel(
        "recommendations",
        "Recommendations",
        "Get notifications for recommendations from Jamii Check.",
        true);
    localNotification.createNotificationChannel("reviews", "Reviews",
        "Get notifications for review status.", true);
    localNotification.createNotificationChannel("rewards", "Rewards",
        "Get notifications for rewards.", true);
    localNotification.fetchNotificationData(context);
    getLoginStatus();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashWidget() /* ((prefs!.get('onboarded_new') as bool?) ?? false)
          ? const SplashWidget()
          : const OnboardingScreen(), */
    );
  }
}