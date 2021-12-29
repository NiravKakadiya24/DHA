import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jamii_check/data/auth/provider/auth_provider.dart';
import 'package:jamii_check/data/profile/provider/profile_provider.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:jamii_check/ui/pages/auth/login_screen.dart';
import 'package:jamii_check/ui/pages/others_screens/my_comments.dart';
import 'package:jamii_check/ui/pages/others_screens/my_stories.dart';
import 'package:jamii_check/ui/pages/others_screens/notification_screen.dart';
import 'package:jamii_check/ui/pages/others_screens/settings.dart';
import 'package:jamii_check/ui/pages/others_screens/terms.dart';
import 'package:jamii_check/ui/pages/story/review_screen.dart';
import 'package:jamii_check/utils/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:jamii_check/global/globals.dart' as globals;

class ConnectedUserScreen extends StatefulWidget {
  const ConnectedUserScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ConnectedUserScreen> {

  File? file;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  void _choose() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _signOutSheet() {
    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height,
      margin: const EdgeInsets.only(bottom: 20  ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Are you sure you want to log out of your account?",
            style: TextStyle(color: Colors.white),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  const Icon(
                    Icons.logout_outlined,
                    color: Colors.white,
                  ),
                  TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        bool res = await Provider.of<AuthProvider>(context,
                                listen: false)
                            .signOut(context);
                        if (res == true) {
                          await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (con) => const LoginScreen()));
                        }
                      },
                      child: const Text("Log Out",
                          style: TextStyle(color: Colors.white)))
                ],
              )),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
  String today() {
    final DateTime now = DateTime.now();
    String suffix = 'th';
    final int digit = now.day % 10;
    if ((digit > 0 && digit < 4) && (now.day < 11 || now.day > 13)) {
      suffix = <String>['st', 'nd', 'rd'][digit - 1];
    }
    return DateFormat("dd'$suffix' MMM yyyy").format(now); // 'Sun, Jun 30th'
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: JAMII_PRIMARY_COLOR),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          return ListView(
            clipBehavior: Clip.none,
            children: [
             
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: JAMII_PRIMARY_COLOR,
                            border: Border.all(
                                color: JAMII_PRIMARY_COLOR, width: 3),
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: profile.jamiiUser.profilePhoto==""
                                ?Image.asset(
                                                "assets/images/placeholder.jpg",
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover):
                                file == null
                                    ? FadeInImage.assetNetwork(
                                        placeholder:
                                            "assets/images/placeholder.jpg",
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        image: profile.jamiiUser.profilePhoto!,
                                        imageErrorBuilder: (c, o, s) =>
                                            Image.asset(
                                                "assets/images/placeholder.jpg",
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover),
                                      )
                                    : Image.file(file!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.fill),
                              ),
                              Positioned(
                                bottom: 0,
                                right: -10,
                                child: CircleAvatar(
                                  backgroundColor: JAMII_PRIMARY_COLOR,
                                  radius: 14,
                                  child: IconButton(
                                    onPressed: (){
                                      Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            const SettingsScreen(isFromMenu: false,)));
                                    },
                                    padding: const EdgeInsets.all(0),
                                    icon: const Icon(JamIcons.camera,
                                        color: Colors.white, size: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ) /* ,
                        Text(
                          '${profile.jamiiUser.name} ${profile.jamiiUser.username}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20.0),
                        ) */
                      ],
                    ),
                    const Padding(
                      padding:  EdgeInsets.only(left:25.0),
                      child:  Align(
                        alignment: Alignment.centerLeft,
                        child:  Text(
                          'My Dashboard',
                          style: TextStyle(color: Colors.black, fontSize: 15.0),
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      height: 240,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: JAMII_PRIMARY_COLOR,
                        ),
                        color: JAMII_PRIMARY_COLOR,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${profile.jamiiUser.username}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            const SettingsScreen(isFromMenu: false,)));
                                  },
                                  icon: const Icon(Icons.edit,
                                      color: Colors.white))
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Today "+ today(),style:const TextStyle(color: Color(0xFF9570FC)))
                            ],
                          ),
                          const Divider(
                              height: 0.7,
                              color: Colors.grey,
                              indent: 4,
                              endIndent: 4),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("PUBLISHED",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10)),
                                    Consumer<ProfileProvider>(
                                        builder: (con, profProvider, child) {
                                      return Text(
                                          profProvider.published.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold));
                                    }),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      child: Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12))),
                                          child: ListTile(
                                            title: const Text("view all",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10)),
                                            trailing: const Icon(
                                                Icons.chevron_right,
                                                color: Colors.white),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          const MyStoriesScreen()));
                                              /* Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ReviewScreen(
                                                            isReview: true,
                                                            notReviewd:
                                                                false))) */
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      endIndent: 5,
                                      indent: 5,
                                    ),
                                    Consumer<ProfileProvider>(
                                        builder: (con, profProvider, child) {
                                      return InkWell(
                                        onTap: ()=>Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          const ReviewScreen(isReview: false,notReviewd:true))),
                                        child: Text(
                                            "${profProvider.underReview.toString()} post pending approval",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10)),
                                      );
                                    })
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("COMMENTS",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10)),
                                    Consumer<ProfileProvider>(
                                      builder: (context,profileProvider,child) {
                                        return  Text(profileProvider.comments.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold));
                                      }
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      child: Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12))),
                                          child: ListTile(
                                            tileColor: Colors.red,
                                            title: const Text("view all",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10)),
                                            trailing: const Icon(
                                                Icons.chevron_right,
                                                color: Colors.white),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          const MyCommentsScreen()));
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      endIndent: 5,
                                      indent: 5,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("REWARD BALANCE",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(JamIcons.coin,
                                            color: Colors.yellow),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text("${globals.jamiiUser.coins ?? 0}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: JAMII_PRIMARY_COLOR.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            const NotificationScreen()));
                              },
                              child: const Text("Notifications",
                                  style: TextStyle(color: Color(0xFF65676A),fontFamily: "Ubuntu"))),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            const SettingsScreen(isFromMenu: false,)));
                              },
                              child: const Text("Settings",
                                  style: TextStyle(color: Color(0xFF65676A),fontFamily: "Ubuntu"))),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            const TermsScreen()));
                              },
                              child: const Text("Terms and Policy",
                                  style: TextStyle(color: Color(0xFF65676A),fontFamily: "Ubuntu")))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        color: JAMII_PRIMARY_COLOR.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: !Provider.of<AuthProvider>(context).isLoading
                          ? Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  Icons.logout_outlined,
                                  color: JAMII_PRIMARY_COLOR.withOpacity(0.3),
                                ),
                                TextButton(
                                    onPressed: () async {
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (c) => _signOutSheet());
                                      /* bool res =
                                          await Provider.of<AuthProvider>(
                                                  context,
                                                  listen: false)
                                              .signOut(context);
                                      if (res == true) {
                                        await Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (con) =>
                                                    const LoginScreen()));
                                      } */
                                    },
                                    child: const Text("Log Out",
                                        style: TextStyle(
                                            color: JAMII_PRIMARY_COLOR,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)))
                              ],
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      JAMII_PRIMARY_COLOR)),
                            ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
