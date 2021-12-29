import 'package:flutter/material.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:provider/provider.dart';

class CustomButton extends StatelessWidget {
  final Function? onTap;
  final String? buttonText;
  const CustomButton({Key? key, this.onTap, @required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:()=>onTap!(context),
      style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
      child: Container(
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: JAMII_PRIMARY_COLOR,
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 1)), // changes position of shadow
            ],
            borderRadius: BorderRadius.circular(10)),
        child: Text(buttonText!,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            )),
      ),
    );
  }
}
