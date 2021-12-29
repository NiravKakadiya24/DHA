import 'package:flutter/cupertino.dart';
import 'package:jamii_check/data/profile/provider/profile_provider.dart';
import 'package:jamii_check/models/story_model.dart';
import 'package:jamii_check/ui/pages/story/story_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:jamii_check/models/in_app_notif_model.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:animations/animations.dart';
import 'package:intl/intl.dart';
import 'package:jamii_check/global/globals.dart' as globals;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<InAppNotif> notifications = [];
  final Box<InAppNotif> box = Hive.box('inAppNotifs');
  bool imageNotFound = false;
  @override
  void initState() {
    notifications = box.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Notifications"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(JamIcons.chevron_left),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Consumer<ProfileProvider>(
                  builder: (_, profileProvider, child) {
                return profileProvider.jamiiUser.profilePhoto==""?
                CircleAvatar(
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
                      ):
                      profileProvider.jamiiUser.profilePhoto == ""?
                      CircleAvatar(
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
                      ):
                 imageNotFound
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
          elevation: 0,
          backgroundColor: globals.JAMII_PRIMARY_COLOR),
      body: Container(
        padding:const EdgeInsets.only(top: 10),
        child: notifications.isNotEmpty
            ? ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (BuildContext context, int index) {
                  box.put(
                      box.keys.toList()[index],
                      notifications[index].type == "review"
                          ? InAppNotif(
                              author: notifications[index].author,
                              title: notifications[index].title,
                              body: notifications[index].body,
                              createdAt: notifications[index].createdAt,
                              story: notifications[index].story,
                              type: notifications[index].type,
                              read: true)
                          : InAppNotif(
                              author: notifications[index].author,
                              title: notifications[index].title,
                              body: notifications[index].body,
                              createdAt: notifications[index].createdAt,
                              type: notifications[index].type,
                              read: true));
                  return Dismissible(
                    onDismissed: (DismissDirection direction) {
                      setState(() {
                        notifications.removeAt(index);
                        box.deleteAt(index);
                      });
                    },
                    dismissThresholds: const {
                      DismissDirection.startToEnd: 0.5,
                      DismissDirection.endToStart: 0.5
                    },
                    secondaryBackground: Container(
                      color: Colors.red,
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(JamIcons.trash),
                        ),
                      ),
                    ),
                    background: Container(
                      color: Colors.red,
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(JamIcons.trash),
                        ),
                      ),
                    ),
                    key: UniqueKey(),
                    child: NotificationCard(notification: notifications[index]),
                  );
                },
              )
            : const Center(
                child: Text('No new notifications',
                    style: TextStyle(color: globals.JAMII_PRIMARY_COLOR))),
      ),
      floatingActionButton: notifications.isNotEmpty
          ? FloatingActionButton(
              mini: true,
              tooltip: "Clear Notifications",
              backgroundColor: globals.JAMII_PRIMARY_COLOR,
              onPressed: () {
                final AlertDialog deleteNotificationsPopUp = AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: const Text(
                    'Clear all notifications?',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: globals.JAMII_PRIMARY_COLOR),
                  ),
                  backgroundColor: Colors.white,
                  actions: [
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: Theme.of(context).hintColor,
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          notifications.clear();
                          box.clear();
                        });
                      },
                      child: const Text(
                        'YES',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: Theme.of(context).errorColor,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'NO',
                        style: TextStyle(
                   
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  actionsPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                );

                showModal(
                    context: context,
                    configuration: const FadeScaleTransitionConfiguration(),
                    builder: (BuildContext context) =>
                        deleteNotificationsPopUp);
              },
              child: const Icon(JamIcons.trash),
            )
          : Container(),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final InAppNotif? notification;

  const NotificationCard({Key? key, this.notification}) : super(key: key);

  static String stringForDatetime(DateTime dt) {
    final dtInLocal = dt.toLocal();
    final now = DateTime.now().toLocal();
    var dateString = "";

    final diff = now.difference(dtInLocal);

    if (now.day == dtInLocal.day) {
      final todayFormat = DateFormat("h:mm a");
      dateString += todayFormat.format(dtInLocal);
    } else if ((diff.inDays) == 1 ||
        (diff.inSeconds < 86400 && now.day != dtInLocal.day)) {
      final yesterdayFormat = DateFormat("h:mm a");
      dateString += "Yesterday, ${yesterdayFormat.format(dtInLocal)}";
    } else if (now.year == dtInLocal.year && diff.inDays > 1) {
      final monthFormat = DateFormat("MMM d");
      dateString += monthFormat.format(dtInLocal);
    } else {
      final yearFormat = DateFormat("MMM d y");
      dateString += yearFormat.format(dtInLocal);
    }

    return dateString;
  }

  _viewPost(BuildContext context, Story story) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => StoryDetailScreen(story: story)));
  }

  @override
  Widget build(BuildContext context) {
    return notification!.type != "review"
        ? ListTile(
            leading: const CircleAvatar(
              backgroundColor: globals.JAMII_PRIMARY_COLOR,
              child: Icon(
                JamIcons.user_circle,
                color: Colors.white,
              ),
            ),
            tileColor: Colors.white,
            title: Text(
              notification!.author!,
              style: const TextStyle(
                color: globals.JAMII_PRIMARY_COLOR,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          notification!.type == "welcome"
                              ? Row(
                                  children: [
                                    Text(
                                      notification!.title!,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Icon(
                                      JamIcons.flower,
                                      color: globals.JAMII_PRIMARY_COLOR,
                                    )
                                  ],
                                )
                              : Text(
                                  notification!.title!,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                          notification!.type == "welcome"
                              ? const SizedBox.shrink()
                              : Text(
                                  timeago.format(notification!.createdAt!),
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                )
                        ],
                      ),
                      /* Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Text(notification!.body!),
                    ) */
                      Text(notification!.body!)
                    ],
                  ),
                ),
              ],
            ),
          )
        : ExpansionTile(
            initiallyExpanded: true,
            childrenPadding: const EdgeInsets.only(left: 50, right: 6),
            leading: const CircleAvatar(
              backgroundColor: globals.JAMII_PRIMARY_COLOR,
              child: Icon(
                JamIcons.user_circle,
                color: Colors.white,
              ),
            ),
            iconColor: globals.JAMII_PRIMARY_COLOR,
            backgroundColor: Colors.white,
            title: Text(
              notification!.author!,
              style: const TextStyle(
                color: globals.JAMII_PRIMARY_COLOR,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                notification!.type == "welcome"
                    ? Row(children: [
                        Text(
                          notification!.title!,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          JamIcons.flower,
                          color: globals.JAMII_PRIMARY_COLOR,
                        )
                      ])
                    : notification!.type == "reward"
                        ? Row(children: [
                            Text(
                              notification!.title!,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              JamIcons.coin,
                              color: globals.JAMII_PRIMARY_COLOR,
                            )
                          ])
                        : Text(
                            notification!.title!,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                notification!.type == "welcome"
                    ? const SizedBox.shrink()
                    : Text(
                        timeago.format(notification!.createdAt!),
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey),
                      )
              ],
            ),
            children: <Widget>[
              InkWell(
                onTap: () {
                  /*  if (notification!.url == "") {
              if (notification!.pageName != null) {
                Navigator.pushNamed(context, notification!.pageName!,
                    arguments: notification!.arguments);
              }
            } else {
              launch(notification!.url!);
            } */
                },
                onLongPress: () {
                  HapticFeedback.lightImpact();
                },
                child: Ink(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, bottom: 5),
                        child: Text(notification!.body!),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 40, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 90,
                                width: 2,
                                color: notification!.story!.isFaked!
                                    ? globals.JAMII_RED_COLOR
                                    : globals.JAMII_GREEN_COLOR,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(notification!.story!.title!,
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  notification!.story!.isAnonymous!
                                      ? const SizedBox.shrink()
                                      : Text(
                                          "Story by ${notification!.story!.userName}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(DateFormat('yyyy-MM-dd')
                                      .format(notification!.story!.createdAt!)),
                                  Text(
                                    notification!.story!.isFaked!
                                        ? "FAKE"
                                        : "VERIFIED",
                                    style: TextStyle(
                                        color: notification!.story!.isFaked!
                                            ? globals.JAMII_RED_COLOR
                                            : globals.JAMII_GREEN_COLOR),
                                  )
                                ],
                              ),
                            ],
                          )),
                      Text(notification!.story!.content!,
                          style: const TextStyle(color: Colors.grey),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: TextButton(
                          onPressed: () =>
                              _viewPost(context, notification!.story!),
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(0)),
                          child: Container(
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: globals.JAMII_PRIMARY_COLOR,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 1)), // changes position of shadow
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text("View Post",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
  }
}
