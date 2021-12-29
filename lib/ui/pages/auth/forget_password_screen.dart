import 'package:flutter/material.dart';

import 'package:jamii_check/data/auth/provider/auth_provider.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/helper/utils.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:jamii_check/ui/widgets/basewidgets/button/custom_button.dart';
import 'package:jamii_check/ui/widgets/basewidgets/loader/custom_loader.dart';
import 'package:jamii_check/ui/widgets/basewidgets/textfield/custom_email_textfield.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  
 final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  ForgetPasswordScreen({Key? key}) : super(key: key);

  onReset(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_controller.text.isEmpty) {
      _scaffoldKey.currentState!.showSnackBar(const SnackBar(
          content: Text("Email is required"), backgroundColor: Colors.red));
    } else if (!isValidEmail(_controller.text)) {
      _scaffoldKey.currentState!.showSnackBar(const SnackBar(
          content: Text("Enter correct email format"),
          backgroundColor: Colors.red));
    } else {
      await Provider.of<AuthProvider>(context, listen: false)
          .resetPassword(_controller.text)
          .then((value) {
        if (value == true) {
          /* FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          } */
          _scaffoldKey.currentState!.showSnackBar(SnackBar(
              content: Text(
                  'Password reset email sent to your adress ${_controller.text}'),
              backgroundColor: JAMII_GREEN_COLOR));
          _controller.clear();
        } else {
          _scaffoldKey.currentState!.showSnackBar(
              SnackBar(content: Text(value), backgroundColor: Colors.red));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: AppBar(
            centerTitle: true,
            title: Image.asset(
              "assets/images/jamii_logo.png",
              height: 200,
            ),
            leading: IconButton(
                icon: const Icon(
                  JamIcons.chevron_left,
                  color: JAMII_PRIMARY_COLOR,
                ),
                onPressed: () => Navigator.pop(context)),
            backgroundColor: Colors.white,
            elevation: 0,
          )),
      body: Container(
        margin: const EdgeInsets.only(top: 200),
        decoration: const BoxDecoration(
            //image: Provider.of<ThemeProvider>(context).darkTheme ? null : DecorationImage(image: AssetImage(Images.background), fit: BoxFit.fill),
            ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  children: [
                    Text("Enter your email",
                        style: TextStyle(
                            color: Theme.of(context).hintColor, fontSize: 20)),
                    CustomEmailTextField(
                      controller: _controller,
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: (50)),
                    Builder(
                      builder: (context) =>
                          !Provider.of<AuthProvider>(context).isLoading
                              ? CustomButton(
                                  buttonText: "Send email",
                                  onTap: onReset,
                                )
                              :  const Center(
                                  child: CircularProgressIndicator(valueColor:  AlwaysStoppedAnimation<Color>(
                        JAMII_PRIMARY_COLOR,
                      ))),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
