import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jamii_check/data/auth/provider/auth_provider.dart';
import 'package:jamii_check/data/profile/provider/profile_provider.dart';
import 'package:jamii_check/data/profile/story/story_provider.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/models/story_model.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:jamii_check/ui/pages/story/review_screen.dart';
import 'package:jamii_check/ui/widgets/basewidgets/button/custom_button.dart';
import 'package:jamii_check/ui/widgets/basewidgets/textfield/custom_textfield.dart';
import 'package:jamii_check/utils/dimensions.dart';
import 'package:provider/provider.dart';
import 'package:jamii_check/global/globals.dart' as globals;

class UploadStoryScreen extends StatefulWidget {
  const UploadStoryScreen({Key? key}) : super(key: key);

  @override
  _UploadStoryScreenState createState() => _UploadStoryScreenState();
}

class _UploadStoryScreenState extends State<UploadStoryScreen> {
  String? id;
  String? tempid;
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _sourceFocus = FocusNode();
  final FocusNode _supportingInformationFocus = FocusNode();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _supportingInformationController =
      TextEditingController();
  File? file;
  final picker = ImagePicker();
  GlobalKey<FormState>? _formKey;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool _isAnonymous = false;
  bool _hasAcceptedRules = false;

  @override
  void initState() {
    super.initState();
  }

  void _clearImage() async {
    setState(() {
      file = null;
    });
  }

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

  void randomId() {
    tempid = "";
    final alp = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split("");
    final r = Random();
    final choice = r.nextInt(4);
    for (var i = 0; i < 4; i++) {
      if (choice == i) {
        final ran = r.nextInt(10);
        tempid = tempid! + ran.toString();
      } else {
        final ran = r.nextInt(26);
        tempid = tempid! + alp[ran].toString();
      }
    }
    setState(() {
      id = tempid;
    });
    debugPrint(id);
  }

  void _uploadStory(BuildContext c) async {
    String _title = _titleController.text.trim();
    String _source = _sourceController.text.trim();
    String _supportingInformation =
        _supportingInformationController.text.trim();
    if (_title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Title should not be empty'),
          backgroundColor: Colors.red));
    } else if (_source.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Source link should not be empty'),
          backgroundColor: Colors.red));
    } else if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Choose an image for story'),
          backgroundColor: Colors.red));
    } else if (!_hasAcceptedRules) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Agree to out Terms and Conditions'),
          backgroundColor: Colors.red));
    } else if (globals.jamiiUser.restricted == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('You cannot post,your account is restricted.'),
          backgroundColor: Colors.red));
    } else {
      randomId();
      final picUrl = await Provider.of<StoryProvider>(context, listen: false)
          .uploadStoryImage(file!.path ?? '', id!);
      if (picUrl != null) {
        Story story = Story(
            id: id,
            title: _title,
            sourceUrl: _source,
            supportingInformation: _supportingInformation.toString() ?? "",
            content: "",
            photoUrl: picUrl,
            userEmail: globals.jamiiUser.email,
            userName: globals.jamiiUser.name,
            isFaked: false,
            review: false,
            isAnonymous: _isAnonymous,
            createdAt: DateTime.now().toUtc(),
            tags: [],
            inHeadlines: false);
        final result = await Provider.of<StoryProvider>(context, listen: false)
            .submitStory(story);
        if (result == true) {
          FocusScope.of(context).unfocus();
          await Provider.of<ProfileProvider>(context, listen: false)
              .incrementPublished();
          await Provider.of<ProfileProvider>(context, listen: false)
              .incrementUnderReview();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      const ReviewScreen(isReview: false, notReviewd: true)));
          _titleController.clear();
          _sourceController.clear();
          _supportingInformationController.clear();
          _clearImage();
          setState(() {
            _isAnonymous = false;
            _hasAcceptedRules = false;
            file = null;
          });
        }
      }

      /* JamiiUser updateUserInfoModel =
          Provider.of<ProfileProvider>(context, listen: false).jamiiUser;
      updateUserInfoModel.name = _nameController.text ?? "";
      updateUserInfoModel.username = _usernameController.text ?? "";
      String pass = _passwordController.text ?? ''; */

      /* await Provider.of<ProfileProvider>(context, listen: false).updateUserInfo(
        updateUserInfoModel, pass, file!, Provider.of<AuthProvider>(context, listen: false).getUserToken(),
      ).then((response) {
        if(response.isSuccess) {
          Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Updated Successfully'), backgroundColor: Colors.green));
          _passwordController.clear();
          _confirmPasswordController.clear();
          setState(() {});
        }else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message), backgroundColor: Colors.red));
        }
      }); */
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "My Stories",
          style: TextStyle(color: JAMII_PRIMARY_COLOR),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(
                top: Dimensions.MARGIN_SIZE_DEFAULT,
                left: Dimensions.MARGIN_SIZE_DEFAULT,
                right: Dimensions.MARGIN_SIZE_DEFAULT),
            child: Text("Fact check",
                style: TextStyle(color: Colors.black, fontSize: 20)),
          ),
          const Padding(
            padding: EdgeInsets.only(
                top: Dimensions.MARGIN_SIZE_DEFAULT,
                left: Dimensions.MARGIN_SIZE_DEFAULT,
                right: Dimensions.MARGIN_SIZE_DEFAULT),
            child: Text("Fact checking process takes 1 to 2 hours.",
                style: TextStyle(color: Colors.grey)),
          ),
          Container(
            margin: const EdgeInsets.only(
                top: Dimensions.MARGIN_SIZE_DEFAULT,
                left: Dimensions.MARGIN_SIZE_DEFAULT,
                right: Dimensions.MARGIN_SIZE_DEFAULT),
            child: Column(
              children: [
                const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                CustomTextField(
                  textInputType: TextInputType.text,
                  focusNode: _titleFocus,
                  nextNode: _sourceFocus,
                  hintText: "Add title",
                  controller: _titleController,
                ),
                const SizedBox(height: Dimensions.MARGIN_SIZE_LARGE),
                CustomTextField(
                  textInputType: TextInputType.text,
                  leadindIcon: const Icon(Icons.link),
                  focusNode: _sourceFocus,
                  nextNode: _supportingInformationFocus,
                  hintText: "Paste source url",
                  controller: _sourceController,
                ),
                const SizedBox(height: Dimensions.MARGIN_SIZE_LARGE),
                CustomTextField(
                  textInputType: TextInputType.text,
                  focusNode: _supportingInformationFocus,
                  maxLine: 8,
                  hintText: "Supporting Information (optional)",
                  controller: _supportingInformationController,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              file == null ? const SizedBox.shrink() : const Text("1 image uploaded"),
              file == null
                  ? IconButton(
                      onPressed: () async => _choose(),
                      icon: const Icon(
                        JamIcons.pictures_f,
                        color: JAMII_GREEN_COLOR,
                      ))
                  : IconButton(
                      onPressed: () async => _clearImage(),
                      icon: const Icon(
                        JamIcons.close,
                        color: Colors.red,
                      )),
              file == null ? const Text("Picture") : const SizedBox.shrink(),
              Switch(
                value: _isAnonymous,
                onChanged: (value) {
                  setState(() {
                    _isAnonymous = value;
                  });
                },
                activeTrackColor: JAMII_PRIMARY_COLOR.withOpacity(0.5),
                activeColor: JAMII_PRIMARY_COLOR,
              ),
              Text("Posted by me",
                  style: TextStyle(
                      color: _isAnonymous ? JAMII_PRIMARY_COLOR : Colors.grey))
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(
                top: Dimensions.MARGIN_SIZE_DEFAULT,
                left: Dimensions.MARGIN_SIZE_DEFAULT,
                right: Dimensions.MARGIN_SIZE_DEFAULT),
            child: Text('(Image file size limit:20mb)'),
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: JAMII_PRIMARY_COLOR,
            title: Text(
              'I agree to the Terms and Conditions',
              style: TextStyle(
                  color: _hasAcceptedRules ? Colors.black : Colors.grey),
            ),
            value: _hasAcceptedRules,
            onChanged: (value) {
              setState(() {
                _hasAcceptedRules = value!;
              });
            },
          ),
          Container(
            margin: const EdgeInsets.symmetric(
                horizontal: Dimensions.MARGIN_SIZE_LARGE,
                vertical: Dimensions.MARGIN_SIZE_SMALL),
            child: !Provider.of<StoryProvider>(context).isLoading
                ? CustomButton(onTap: _uploadStory, buttonText: "Submit")
                : const Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(JAMII_PRIMARY_COLOR)),
                  ),
          )
        ],
      ),
    );
  }
}
