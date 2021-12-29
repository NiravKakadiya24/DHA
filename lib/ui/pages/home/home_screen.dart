import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/ui/pages/home/story_screen.dart';
import 'package:jamii_check/ui/pages/home/true_fake_view.dart';
import 'package:jamii_check/ui/widgets/home/categories_bar.dart';

final FirebaseMessaging f = FirebaseMessaging.instance;
class HomeScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? pageManagerKey;
  const HomeScreen({Key? key,@required this.pageManagerKey}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    super.initState();
    _updateToken();
    tabController = TabController(length: 3, vsync: this);
  }
  void _updateToken() {
    f.requestPermission();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace:  PreferredSize(
            preferredSize: const Size(double.infinity, 55),
            child: CategoriesBar(
              pageManagerKey:widget.pageManagerKey!
            ),
          ),
          bottom: TabBar(
                controller: tabController,
                indicatorColor: JAMII_PRIMARY_COLOR,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: JAMII_PRIMARY_COLOR,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(
                    text: "JUST IN",
                  ),
                  Tab(text: "VERIFIED"),
                  Tab(
                    text: "FAKE",
                  )
                ])),
      backgroundColor: Colors.white,
      
      body: TabBarView(
        controller: tabController,
        children:  [
          StoryScreen(),
          const TrueFakeScreen(tabName: "confirmed"),
          const TrueFakeScreen(tabName: "fake"),
        ],
      ),
    );
  }
}
