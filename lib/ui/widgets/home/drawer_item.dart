import 'package:flutter/material.dart';

class DrawerMenuWidget extends StatefulWidget {
  const DrawerMenuWidget({
    Key? key,
    @required this.icon,
    @required this.title,
    @required this.onTap,
    @required this.index,
  }) : super(key: key);

  final IconData? icon;
  final String? title;
  final Function? onTap;
  final int? index;

  @override
  _DrawerMenuWidgetState createState() => _DrawerMenuWidgetState();
}

class _DrawerMenuWidgetState extends State<DrawerMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(widget.icon, color: Colors.white),
        title: Text(
          widget.title!,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: Colors.white,
          ),
        ),
        onTap:widget.onTap!());
  }
}