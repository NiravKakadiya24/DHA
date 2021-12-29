import 'package:flutter/cupertino.dart';
import 'package:jamii_check/global/globals.dart' as globals;
import 'package:jamii_check/main.dart' as main;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:jamii_check/models/in_app_notif_model.dart';

final FirebaseFirestore databaseReference = FirebaseFirestore.instance;

Future<QuerySnapshot> getLastMonthNotifs(String modifier) async {
  return databaseReference
      .collection("notifications")
      .orderBy("createdAt", descending: true)
      .where("createdAt",
          isGreaterThan:
              DateTime.now().toUtc().subtract(const Duration(days: 30)))
      .where('modifier', isEqualTo: modifier)
      .get();
}

Future<QuerySnapshot> getLatestNotifs(String modifier) async {
  return databaseReference
      .collection("notifications")
      .orderBy("createdAt", descending: true)
      .where("createdAt", isGreaterThan: main.prefs.get('lastFetchTime'))
      .where('modifier', isEqualTo: modifier)
      .get();
}

Future<void> getNotifs() async {
  debugPrint("Fetching notifs");
  final Box<InAppNotif> box = Hive.box('inAppNotifs');
  if (main.prefs.get('lastFetchTime') != null) {
    debugPrint("Last fetch time ${main.prefs.get('lastFetchTime')}");

    //for all users
    getLatestNotifs('all').then((snap) {
      for (final doc in snap.docs) {
        if (doc.data()['modifier'] != '' || doc.data()['modifier'] != null) {
          box.add(InAppNotif.fromSnapshot(doc.data()));
        }
      }
    });

    //specific user notif
    getLatestNotifs(globals.jamiiUser.email!).then((snap) {
      for (final doc in snap.docs) {
        if (doc.data()['modifier'] != '' || doc.data()['modifier'] != null) {
          box.add(InAppNotif.fromSnapshot(doc.data()));
        }
      }
    });
    main.prefs.put('lastFetchTime', DateTime.now());
  } else {
    debugPrint("Fetching for first time");
    box.clear();
    //for all users
    getLastMonthNotifs('all').then((snap) {
      for (final doc in snap.docs) {
        if (doc.data()['modifier'] != '' || doc.data()['modifier'] != null) {
          box.add(InAppNotif.fromSnapshot(doc.data()));
        }
      }
    });
    //for specific user only
    getLastMonthNotifs(globals.jamiiUser.email!).then((snap) {
      for (final doc in snap.docs) {
        if (doc.data()['modifier'] != '' || doc.data()['modifier'] != null) {
          box.add(InAppNotif.fromSnapshot(doc.data()));
        }
      }
    });
    main.prefs.put('lastFetchTime', DateTime.now());
  }
}
