import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamii_check/data/profile/provider/profile_provider.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:jamii_check/global/globals.dart' as globals;
import 'package:jamii_check/ui/pages/others_screens/help_center.dart';
import 'package:jamii_check/ui/pages/others_screens/terms.dart';
import 'package:jamii_check/ui/widgets/others/web_view_screen.dart';
import 'package:provider/provider.dart';

class JfSupportScreen extends StatefulWidget {
  const JfSupportScreen({Key? key}) : super(key: key);

  @override
  _JfSupportScreenState createState() => _JfSupportScreenState();
}

class _JfSupportScreenState extends State<JfSupportScreen> {
  bool imageNotFound = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
                icon: const Icon(JamIcons.chevron_left),
                onPressed: () => Navigator.pop(context)),
            actions: [
              Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Consumer<ProfileProvider>(
                  builder: (_, profileProvider, child) {
                return imageNotFound
                    ? CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 15,
                        child: Center(
                          child: Text(
                            profileProvider.jamiiUser.name![0],
                            style: const TextStyle(
                                color: globals.JAMII_PRIMARY_COLOR,
                                fontSize: 30),
                          ),
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 15,
                        backgroundImage: NetworkImage(
                          profileProvider.jamiiUser.profilePhoto!,
                        ),
                        onBackgroundImageError: (_, st) {
                          setState(() {
                            imageNotFound = true;
                          });
                        },
                      );
              }),
            )
            ],
          title:const Text(
                  "Help & Support",
                ),
            backgroundColor: globals.JAMII_PRIMARY_COLOR,
                ),
      backgroundColor: Colors.white,
      body: Column(children: [
         ListTile(
          title: const Text("Help Center"),
          leading:const Icon(
            JamIcons.help,
            size: 30,
          ),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (_) =>
                      const HelpCenterScreen()),
            );
          },
        ),
        ListTile(
          title: const Text("Contact us"),
          leading: const Icon(JamIcons.user_circle, size: 30),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (_) =>
                      WebViewScreen(url: "https://www.jamiiforums.com/misc/contact", title: "Contact us")),
            );
          },
        ),
        ListTile(
          title: const Text("Terms and Privacy Policy"),
          onTap: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => const TermsScreen()));
          },
          leading: const Icon(JamIcons.task_list, size: 30),
        )
      ]),
    );
  }
}
