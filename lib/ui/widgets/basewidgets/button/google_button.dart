import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoogleButton extends StatelessWidget {
  final Function? onTap;
   const GoogleButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
          alignment: Alignment.center,
      decoration: BoxDecoration(
           border: Border.all(color: Colors.black,width: 0.4),
              borderRadius: BorderRadius.circular(10)),
      child: TextButton.icon(
        onPressed:()=>onTap!(),
        label: const Text("Continue with Google",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              )),
        style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
        icon:  Image.asset("assets/images/google_logo.png"),
      ),
    );
  }
}
