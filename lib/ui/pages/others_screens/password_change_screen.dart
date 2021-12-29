import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamii_check/data/profile/provider/profile_provider.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/models/user_model.dart';
import 'package:jamii_check/ui/widgets/basewidgets/button/custom_button.dart';
import 'package:jamii_check/ui/widgets/basewidgets/textfield/custom_password_textfield.dart';
import 'package:jamii_check/utils/dimensions.dart';
import 'package:jamii_check/utils/theme.dart';
import 'package:provider/provider.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({Key? key}) : super(key: key);

  @override
  _PasswordChangeScreenState createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final FocusNode _oldPasswordFocus = FocusNode();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _newPasswordConfirmFocus = FocusNode();

  final TextEditingController _olPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordConfirmController = TextEditingController();
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  _updateUserAccount(BuildContext c) async {
    String _oldPassword = _olPasswordController.text.trim();
    String _newPassword = _newPasswordController.text.trim();
    String _newPasswordConfirm = _newPasswordConfirmController.text.trim();

    if (_oldPassword.isEmpty || _newPassword.isEmpty || _newPasswordConfirm.isEmpty) {
      _scaffoldKey.currentState!.showSnackBar(const SnackBar(
          content: Text('Passwords should not be empty'),
          backgroundColor: Colors.red));
    } else if(_newPassword!=_newPasswordConfirm){
      _scaffoldKey.currentState!.showSnackBar(const SnackBar(
          content: Text('New password and confirmed password don\'t match'),
          backgroundColor: Colors.red));
    }
     else {
      /* if (file != null) {
        String url = await Provider.of<ProfileProvider>(context, listen: false)
            .uploadProfileImage(file!.path, randomId());
        if (url != null) {
          updateUserInfoModel.profilePhoto = url;
        }
      } */
      await Provider.of<ProfileProvider>(context, listen: false)
          .changePassword(_oldPassword,_newPassword)
          .then((response) {
        if (response == "success") {
          _olPasswordController.clear();
          _newPasswordController.clear();
          _newPasswordConfirmController.clear();
          _scaffoldKey.currentState!.showSnackBar(const SnackBar(
              content: Text('Password Successfully changed'),
              backgroundColor: Colors.green));
          setState(() {});
        } else {
          _scaffoldKey.currentState!.showSnackBar(SnackBar(
              content: Text(response.toString()), backgroundColor: Colors.red));
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                color: Colors.white,
                height: 500,
              ),
              Container(
                padding: const EdgeInsets.only(top: 45, left: 15),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Reset Password",
                          style: TextStyle(
                              fontSize: 20, color: JAMII_PRIMARY_COLOR),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ]),
              ),
              Container(
                padding: const EdgeInsets.only(top: 85),
                child: Column(
                  children: [
                    
                    const SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                              topRight: Radius.circular(
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                            )),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: const [
                                      SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      Text("Old password", style: titilliumRegular)
                                    ],
                                  ),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomPasswordTextField(
                                    focusNode: _oldPasswordFocus,
                                    //nextNode: _addressFocus,
                                    controller: _olPasswordController,
                                    readOnly:false
                                  ),
                                ],
                              ),
                            ), 
                            // for password confirm
                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("New Password"),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomPasswordTextField(
                                      focusNode: _newPasswordFocus,
                                      controller: _newPasswordController,
                                      readOnly: false),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Confirm Password"),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomPasswordTextField(
                                      focusNode: _newPasswordConfirmFocus,
                                      controller: _newPasswordConfirmController,
                                      readOnly: false),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: Dimensions.MARGIN_SIZE_LARGE,
                          vertical: Dimensions.MARGIN_SIZE_SMALL),
                      child: !Provider.of<ProfileProvider>(context).isLoading
                          ? CustomButton(
                              onTap: _updateUserAccount,
                              buttonText: "Reset password")
                          : const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    JAMII_PRIMARY_COLOR),
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
