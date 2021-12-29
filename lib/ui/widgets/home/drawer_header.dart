import 'package:flutter/material.dart';
import 'package:jamii_check/global/globals.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/images/jamii_check.jpg',
            width: 100,
            height: 72,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "Jamii check",
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: JAMII_PRIMARY_COLOR),
          ),
        ],
      ),
      decoration: const BoxDecoration(color: Colors.white),
    );
  }
}
