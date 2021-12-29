
import 'package:flutter/cupertino.dart';
import 'package:jamii_check/models/in_app_notif_model.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:jamii_check/ui/pages/others_screens/notification_screen.dart';
import 'package:provider/provider.dart';
import 'package:jamii_check/global/globals.dart' as globals;
import 'package:jamii_check/main.dart' as main;

class CategoriesBar extends StatefulWidget {
  final GlobalKey<ScaffoldState>? pageManagerKey;
  const CategoriesBar({
    Key? key,
    @required this.pageManagerKey
  }) : super(key: key);

  @override
  _CategoriesBarState createState() => _CategoriesBarState();
}

class _CategoriesBarState extends State<CategoriesBar> {
  final key = GlobalKey();
  bool noNotification = true;
  final Box<InAppNotif> box = Hive.box('inAppNotifs');
  List notifications = [];
  @override
  void initState() {
    if (main.prefs.get("Subscriber", defaultValue: true) as bool) {
      fetchNotifications();
    } else {
      noNotification = true;
    }
    super.initState();
  }
  Future<void> fetchNotifications() async {
    setState(() {
      notifications = box.values.toList();
    });
    checkNewNotification();
  }
  void checkNewNotification() {
    final Box<InAppNotif> box = Hive.box('inAppNotifs');
    notifications = box.values.toList();
    notifications.removeWhere((element) => element.read == true);
    if (notifications.isEmpty) {
      setState(() {
        noNotification = true;
      });
    } else {
      setState(() {
        noNotification = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
     if (!globals.tooltipShown) {
      Future.delayed(const Duration(seconds: 2)).then((_) {
        try {
          final dynamic tooltip = key.currentState;
          if (!noNotification && notifications.isNotEmpty) {
            tooltip.ensureTooltipVisible();
            globals.tooltipShown = true;
          }
          if (!noNotification && notifications.isNotEmpty) {
            Future.delayed(const Duration(seconds: 5)).then((_) {
              tooltip.deactivate();
            });
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      });
    }
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      centerTitle: true,
      title: Image.asset('assets/images/jamii_logo.png',height: 150,),
      leading:IconButton(
        icon:const Icon(
                Icons.menu,
                color: globals.JAMII_PRIMARY_COLOR,
              ),
        onPressed:()=>widget.pageManagerKey!.currentState!.openDrawer(),
       ) ,
      actions: [
        IconButton(
        icon: noNotification
            ? const Icon(
                JamIcons.bell,
                color: Color(0xFF65676A),
              )
            : Tooltip(
                key: key,
                message: notifications.length != 1
                    ? "${notifications.length} new notifications!"
                    : "${notifications.length} new notification!",
                child: Stack(children: <Widget>[
                  const Icon(
                    JamIcons.bell,
                    color: Color(0xFF65676A),
                  ),
                  Positioned(
                    top: 0.0,
                    left: 0.0,
                    child: CircleAvatar(
                      radius: 6,
                      backgroundColor: globals.JAMII_PRIMARY_COLOR,
                      child: Text(notifications.length.toString(),style: const TextStyle(fontSize: 8,color: Colors.white),),
                    )
                  )
                ]),
              ),
        tooltip: 'Notifications',
        onPressed: () {
          setState(() {
            noNotification = true;
          });
          Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            const NotificationScreen()));
        },
      )
      ],
    );
  }
}
