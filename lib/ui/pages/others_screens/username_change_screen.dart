import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jamii_check/data/profile/provider/profile_provider.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/helper/utils.dart';
import 'package:jamii_check/models/user_model.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:jamii_check/ui/widgets/basewidgets/button/custom_button.dart';
import 'package:jamii_check/ui/widgets/basewidgets/textfield/custom_email_textfield.dart';
import 'package:jamii_check/ui/widgets/basewidgets/textfield/custom_username.dart';
import 'package:jamii_check/utils/dimensions.dart';
import 'package:jamii_check/utils/theme.dart';
import 'package:provider/provider.dart';

class UsernameChangeScreen extends StatefulWidget {
  const UsernameChangeScreen({Key? key}) : super(key: key);

  @override
  _UsernameChangeScreenState createState() => _UsernameChangeScreenState();
}

class _UsernameChangeScreenState extends State<UsernameChangeScreen> {
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  File? file;
  final picker = ImagePicker();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  void _choose() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  _updateUserAccount(BuildContext c) async {
    String _username = _usernameController.text.trim();
    String _email = _emailController.text.trim();

    if (Provider.of<ProfileProvider>(context, listen: false)
                .jamiiUser
                .username ==
            _usernameController.text &&
        file == null) {
      _scaffoldKey.currentState!.showSnackBar(const SnackBar(
          content: Text('Change something to update'),
          backgroundColor: Colors.red));
    } else if (_username.isEmpty) {
      _scaffoldKey.currentState!.showSnackBar(const SnackBar(
          content: Text('Username should not be empty'),
          backgroundColor: Colors.red));
    } else {
      JamiiUser updateUserInfoModel =
          Provider.of<ProfileProvider>(context, listen: false).jamiiUser;
      updateUserInfoModel.username = _usernameController.text ?? "";
      if (file != null) {
        String url = await Provider.of<ProfileProvider>(context, listen: false)
            .uploadProfileImage(file!.path, randomId());
        if (url != null) {
          updateUserInfoModel.profilePhoto = url;
        }
      }
      await Provider.of<ProfileProvider>(context, listen: false)
          .updateUserInfo(updateUserInfoModel)
          .then((response) {
        if (response == "success") {
          _scaffoldKey.currentState!.showSnackBar(const SnackBar(
              content: Text('Updated Successfully'),
              backgroundColor: Colors.green));
          setState(() {});
        } else {
          _scaffoldKey.currentState!.showSnackBar(SnackBar(
              content: Text(response.message), backgroundColor: Colors.red));
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
          _usernameController.text = profile.jamiiUser.username!;
          _emailController.text = profile.jamiiUser.email!;

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
                    children: [
                      IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                JamIcons.chevron_left,
                                color: JAMII_PRIMARY_COLOR,
                              )),
                      const Text("Username edit",
                          style: TextStyle(
                              fontSize: 20, color: JAMII_PRIMARY_COLOR),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ]),
              ),
              Container(
                padding: const EdgeInsets.only(top: 55),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: JAMII_PRIMARY_COLOR,
                            border: Border.all(
                                color: JAMII_PRIMARY_COLOR, width: 3),
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: file == null
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
                                  backgroundColor: JAMII_PRIMARY_COLOR,
                                  radius: 14,
                                  child: IconButton(
                                    onPressed: _choose,
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
                                      Text("Username", style: titilliumRegular)
                                    ],
                                  ),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomUsername(
                                    textInputType: TextInputType.text,
                                    focusNode: _usernameFocus,
                                    hintText: profile.jamiiUser.username ?? "",
                                    //nextNode: _addressFocus,
                                    controller: _usernameController,
                                  ),
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
                                      readOnly: true),
                                ],
                              ),
                            ),
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
                              buttonText: "Update account")
                          : const Center(
                              child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(JAMII_PRIMARY_COLOR),
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
