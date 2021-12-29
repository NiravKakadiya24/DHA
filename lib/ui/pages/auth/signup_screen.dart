
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jamii_check/data/auth/provider/auth_provider.dart';
import 'package:jamii_check/data/notifications/notifications.dart';
import 'package:jamii_check/data/profile/provider/profile_provider.dart';
import 'package:jamii_check/data/search/provider/search_provider.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/theme/jam_icons_icons.dart';
import 'package:jamii_check/ui/pages/home/home_screen.dart';
import 'package:jamii_check/ui/pages/home/page_manager.dart';
import 'package:jamii_check/ui/widgets/basewidgets/button/custom_button.dart';
import 'package:jamii_check/ui/widgets/basewidgets/button/google_button.dart';
import 'package:jamii_check/ui/widgets/basewidgets/loader/custom_loader.dart';
import 'package:jamii_check/ui/widgets/basewidgets/textfield/custom_email_textfield.dart';
import 'package:jamii_check/ui/widgets/basewidgets/textfield/custom_password_textfield.dart';
import 'package:jamii_check/ui/widgets/basewidgets/textfield/custom_textfield.dart';
import 'package:jamii_check/ui/widgets/basewidgets/textfield/custom_username_textfield.dart';
import 'package:jamii_check/utils/dimensions.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  GlobalKey<FormState>? _formKey;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool isEmailVerified = false;

  navigatateDetails(BuildContext con,String email,String password){
    Navigator.push(context, MaterialPageRoute(builder: (con)=>UsernameScreen(email: email,password: password)));
  }
  addUser(BuildContext con) async {
    if (_formKey!.currentState!.validate()) {
      _formKey!.currentState!.save();
      isEmailVerified = true;

      String _email = _emailController.text.trim();
      String _password = _passwordController.text.trim();
      String _confirmPassword = _confirmPasswordController.text.trim();

      if (_email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Email is required"),
          backgroundColor: Colors.red,
        ));
      }else if (_password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Password is required"),
          backgroundColor: Colors.red,
        ));
      } else if (_confirmPassword.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Confirm password is required"),
          backgroundColor: Colors.red,
        ));
      } else if (_password != _confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("password did not match"),
          backgroundColor: Colors.red,
        ));
      } else {
        navigatateDetails(context,_emailController.text,_passwordController.text);
      }
    } else {
      isEmailVerified = false;
    }
  }
  bool isValidEmail(String emailText) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(emailText);
  }
  route(bool isRoute, String errorMessage) async {
    if (isRoute) {
      await Provider.of<ProfileProvider>(context, listen: false).getUserInfo();
      await Provider.of<ProfileProvider>(context, listen: false).getPublishedCount();
      await Provider.of<ProfileProvider>(context, listen: false).getCommentsCount();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const PageManager()), (route) => false);
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
    }
  }

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }
  void googleLogin() async{
    await Provider.of<AuthProvider>(context, listen: false).signInWithGoogle(route);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar:  SizedBox(
        height: 50,
        child:  Column(
          children:  [
            const Divider(color: Colors.grey,),
            InkWell(
              onTap: ()=>Navigator.pop(context),
              child: const Text("Already have an account? Sign in"))
          ],
        )
        ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
        children: [
          //logo
            Container(
                margin:
                    const EdgeInsets.only(left: Dimensions.MARGIN_SIZE_LARGE, right: Dimensions.MARGIN_SIZE_LARGE, bottom: Dimensions.MARGIN_SIZE_SMALL),
                child: Image.asset("assets/images/jamii_logo.png",height: 150,)),
            //login text
            Container(
                margin:
                    const EdgeInsets.only(left: Dimensions.MARGIN_SIZE_LARGE, right: Dimensions.MARGIN_SIZE_LARGE, bottom: Dimensions.MARGIN_SIZE_SMALL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                     Text("Register",style: TextStyle(color:JAMII_PRIMARY_COLOR,fontWeight: FontWeight.bold,fontSize: 20),),
                     SizedBox(height: 20,),
                     Text("Verify news around you ans share newsworthy stories on JamiiCheck",style: TextStyle(color:Colors.grey,fontSize: 15),)
                  ],
                )),
                const SizedBox(height: 20,),
          Form(
            key: _formKey,
            child: Column(
              children: [
                // for email
                Container(
                  margin: const EdgeInsets.only(left: Dimensions.MARGIN_SIZE_DEFAULT, right: Dimensions.MARGIN_SIZE_DEFAULT, top: Dimensions.MARGIN_SIZE_SMALL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Enter email address",style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 20,),
                      CustomEmailTextField(
                        focusNode: _emailFocus,
                        nextNode: _passwordFocus,
                        textInputType: TextInputType.emailAddress,
                        controller: _emailController,
                        //isValidator:true,
                        //validatorMessage: !isValidEmail(_emailController.text.trim())?"":"Enter a valid email",
                      ),
                    ],
                  ),
                ),
                // for password
                Container(
                  margin: const EdgeInsets.only(left: Dimensions.MARGIN_SIZE_DEFAULT, right: Dimensions.MARGIN_SIZE_DEFAULT, top: Dimensions.MARGIN_SIZE_SMALL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Password",style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 10,),
                      CustomPasswordTextField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        nextNode: _confirmPasswordFocus,
                        textInputAction: TextInputAction.next,
                        readOnly:false
                      ),
                    ],
                  ),
                ),
    
                // for re-enter password
                Container(
                  margin: const EdgeInsets.only(left: Dimensions.MARGIN_SIZE_DEFAULT, right: Dimensions.MARGIN_SIZE_DEFAULT, top: Dimensions.MARGIN_SIZE_SMALL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Confirm password",style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 10,),
                      CustomPasswordTextField(
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        textInputAction: TextInputAction.done,
                         readOnly:false
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Consumer<AuthProvider>(builder: (context, authProvider, child) {
              return Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: JAMII_PRIMARY_COLOR,
                    value: authProvider.isRemember,
                    onChanged: (value) {
                      authProvider.updateRemember(value!);
                    },
                  ),
                   Text("Keep me logged in",style:TextStyle(color: authProvider.isRemember?Colors.black:Colors.grey)),
                ],
              );
            }),
          // for register button
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 40),
            child: Provider.of<AuthProvider>(context).isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor:  AlwaysStoppedAnimation<Color>(
                        JAMII_PRIMARY_COLOR,
                      ),
                    ),
                  )
                : CustomButton(onTap:addUser, buttonText: "Register"),
          ),
            const Center(child: Text("Or",style: TextStyle(color: Colors.grey),)),
          Container(
              margin: const  EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 30),
              child: GoogleButton(onTap:googleLogin),
            ),
        ],
      ),

    );
  }
}
class UsernameScreen extends StatefulWidget {
  final String? email;
  final String? password;
  const UsernameScreen({ Key? key ,@required this.email,@required this.password}) : super(key: key);

  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  File? file;
  final picker = ImagePicker();
  String errorMessage="You can always change it later";
  List<String> suggestedUsernames=[];
  bool isCheck=false;
  bool showInfo=true;
  bool boolIsvalid=false;
  String? id;
  String? tempid;
    final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  onTapListTile(String username,BuildContext c) async{
    _usernameController.text=username;
    await register(c);
  }
  register(BuildContext c) async{
    await Provider.of<AuthProvider>(context, listen: false).checkUsername(_usernameController.text)
    .then((value) async {
      if(value==true){
        setState(() {
          errorMessage="The username ${_usernameController.text} available";
        isCheck=true;
        boolIsvalid=true;
        showInfo=false;
      });
      randomId();
      String picUrl="";
      if(file!=null){
        picUrl=await Provider.of<AuthProvider>(context, listen: false).uploadProfileImage(file!.path,id!);
      }
      await Provider.of<AuthProvider>(context, listen: false).signUp(widget.email!,widget.password!,_usernameController.text,picUrl?? "", route);
      }
      else if(value.length==5){
        setState(() {
        errorMessage="The username ${_usernameController.text} is not available";
        isCheck=true;
        boolIsvalid=false;
        suggestedUsernames=value;
        showInfo=false;
      });
      }
    });
  }
  route(bool isRoute, String errorMessage) async {
    if (isRoute) {
       await getNotifs();
      await Provider.of<ProfileProvider>(context, listen: false).getUserInfo();
      await Provider.of<ProfileProvider>(context, listen: false).getPublishedCount();
      await Provider.of<ProfileProvider>(context, listen: false).getCommentsCount();
      await Provider.of<ProfileProvider>(context, listen: false).getUnderReviewCount();
      await Provider.of<SearchProvider>(context, listen: false).initHistoryList();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const PageManager()), (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
    }
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation:0,
          flexibleSpace: AppBar(
            centerTitle: true,
            title: Image.asset("assets/images/jamii_logo.png",height: 200,),
            leading: IconButton(
                icon: const Icon(JamIcons.chevron_left,color: JAMII_PRIMARY_COLOR,),
                onPressed: ()=>Navigator.pop(context)),
            backgroundColor: Colors.white,
            elevation: 0,
          )),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const SizedBox(height: 50,),
          Container(
                          margin: const EdgeInsets.only(
                              top: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:Colors.transparent,
                            border: Border.all(
                                color: Colors.black87, width: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: file == null
                                    ? Image.asset(
                                                "assets/images/avatar.jpg",
                                                width: 100,
                                                height: 100,
                                                color: Colors.black87,
                                                fit: BoxFit.cover)
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
                        ),
          const SizedBox(height:50),
          Container(
                  margin: const EdgeInsets.only(left: Dimensions.MARGIN_SIZE_DEFAULT, right: Dimensions.MARGIN_SIZE_DEFAULT, top: Dimensions.MARGIN_SIZE_SMALL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Choose username",style: TextStyle(color: JAMII_PRIMARY_COLOR,fontSize: 24)),
                    const SizedBox(height: 20,),
                      CustomUsernameTextField(
                        focusNode: _usernameFocus,
                        textInputType: TextInputType.text,
                        controller: _usernameController,
                        isChecked: isCheck,
                        isValidUsername: boolIsvalid,
                        validatorMessage: errorMessage,
                        isValidator: true),
                    const SizedBox(height: 10,),
                    !showInfo?Text(errorMessage,style: TextStyle(color: boolIsvalid?JAMII_GREEN_COLOR:JAMII_RED_COLOR),):
                    Text(errorMessage,)
                    ],
                  ),
                ),
          for (var username in suggestedUsernames)
            ListTile(
              title: Text(username),
              trailing: const Icon(Icons.check, color: JAMII_PRIMARY_COLOR),
              onTap: ()=>onTapListTile(username,context),
            ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 40),
            child: Provider.of<AuthProvider>(context).isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor:  AlwaysStoppedAnimation<Color>(
                        JAMII_PRIMARY_COLOR,
                      ),
                    ),
                  )
                : CustomButton(onTap:register, buttonText: "Next"),
          ),
            TextButton(onPressed: (){
               onTapListTile(widget.email!.split("@")[0],context);
            }, child: const Text("Skip",style:TextStyle(color:JAMII_PRIMARY_COLOR))),
        ],
      ),
    );
  }
  @override
  void dispose() {
    file=null;
    super.dispose();
  }
}
