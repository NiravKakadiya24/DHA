import 'dart:math';

String randomId() {
    String tempid = "";
    final alp = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split("");
    final r = Random();
    final choice = r.nextInt(4);
    for (var i = 0; i < 4; i++) {
      if (choice == i) {
        final ran = r.nextInt(10);
        tempid = tempid + ran.toString();
      } else {
        final ran = r.nextInt(26);
        tempid = tempid + alp[ran].toString();
      }
    }
    return tempid;
  }
  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }
  