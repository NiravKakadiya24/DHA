import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jamii_check/data/profile/provider/profile_provider.dart';
import 'package:jamii_check/global/globals.dart' as globals;
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:jamii_check/ui/pages/others_screens/password_change_screen.dart';
import 'package:jamii_check/ui/pages/others_screens/username_change_screen.dart';
import 'package:jamii_check/ui/widgets/basewidgets/textfield/custom_email_textfield.dart';
import 'package:jamii_check/ui/widgets/basewidgets/textfield/custom_password_textfield.dart';
import 'package:jamii_check/ui/widgets/basewidgets/textfield/custom_username.dart';
import 'package:jamii_check/utils/dimensions.dart';
import 'package:jamii_check/utils/theme.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  final bool? isFromMenu;
  const SettingsScreen({Key? key, this.isFromMenu}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  File? file;
  final picker = ImagePicker();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
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
          _usernameController.text = profile.jamiiUser!=null?profile.jamiiUser.username!: "";
          _emailController.text = profile.jamiiUser!=null?profile.jamiiUser.email! : "";

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                color: Colors.white,
                height: 500,
              ),
              Container(
                padding: const EdgeInsets.only(top: 35, left: 15),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: widget.isFromMenu!
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      widget.isFromMenu!
                          ? IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                JamIcons.chevron_left,
                                color: globals.JAMII_PRIMARY_COLOR,
                              ))
                          : const SizedBox.shrink(),
                      const Text("Settings",
                          style: TextStyle(
                              fontSize: 20, color: globals.JAMII_PRIMARY_COLOR),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ]),
              ),
              Container(
                padding: const EdgeInsets.only(top: 55),
                child: Column(
                  children: [
                    /* Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: globals.JAMII_PRIMARY_COLOR,
                            border: Border.all(
                                color: globals.JAMII_PRIMARY_COLOR, width: 3),
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: profile.jamiiUser.profilePhoto == ""
                                    ? Image.asset(
                                        "assets/images/placeholder.jpg",
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover)
                                :
                                file == null
                                    ? FadeInImage.assetNetwork(
                                        placeholder:
                                            "assets/images/placeholder.jpg",
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        image: profile.jamiiUser.profilePhoto!,
                                        imageErrorBuilder: (c, o, s) =>
                                            Image.asset(
                                                "assets/images/placeholder.jpg",
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover),
                                      )
                                    : Image.file(file!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.fill),
                              ),
                              Positioned(
                                bottom: 0,
                                right: -10,
                                child: CircleAvatar(
                                  backgroundColor: globals.JAMII_PRIMARY_COLOR,
                                  radius: 14,
                                  child: IconButton(
                                    onPressed: (){},
                                    padding: const EdgeInsets.all(0),
                                    icon: const Icon(JamIcons.camera,
                                        color: Colors.white, size: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ) /* ,
                        Text(
                          '${profile.jamiiUser.name} ${profile.jamiiUser.username}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20.0),
                        ) */
                      ],
                    ),
                     */const SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL),
                                      Text("Username", style: titilliumRegular)
                                    ],
                                  ),
                                  Consumer<ProfileProvider>(builder:
                                      (context, profileProvider, child) {
                                    return CustomUsername(
                                        textInputType: TextInputType.text,
                                        focusNode: _usernameFocus,
                                        hintText: profileProvider
                                                .jamiiUser.username ??
                                            "",
                                        //nextNode: _addressFocus,
                                        readOnly: true,
                                        controller: _usernameController,
                                        suffix: IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color:
                                                  globals.JAMII_PRIMARY_COLOR,
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          const UsernameChangeScreen()));
                                            }));
                                  }),
                                ],
                              ),
                            ), // for Email
                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Email"),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomEmailTextField(
                                    textInputType: TextInputType.emailAddress,
                                    focusNode: _emailFocus,
                                    hintText: profile.jamiiUser.email ?? '',
                                    controller: _emailController,
                                    readOnly: true,
                                  ),
                                ],
                              ),
                            ),
                            globals.jamiiUser.method != "google"
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        top: Dimensions.MARGIN_SIZE_DEFAULT,
                                        left: Dimensions.MARGIN_SIZE_DEFAULT,
                                        right: Dimensions.MARGIN_SIZE_DEFAULT),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Reset Password"),
                                        const SizedBox(
                                            height:
                                                Dimensions.MARGIN_SIZE_SMALL),
                                        CustomPasswordTextField(
                                            focusNode: _emailFocus,
                                            controller: _emailController,
                                            suffix: IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: globals
                                                      .JAMII_PRIMARY_COLOR,
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(
                                                          builder: (context) =>
                                                              const PasswordChangeScreen()));
                                                }),
                                            readOnly: true),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink()
                          ],
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
