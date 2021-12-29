import 'package:flutter/material.dart';
import 'package:jamii_check/data/auth/provider/auth_provider.dart';
import 'package:jamii_check/data/notifications/notifications.dart';
import 'package:jamii_check/data/profile/provider/profile_provider.dart';
import 'package:jamii_check/data/search/provider/search_provider.dart';
import 'package:jamii_check/global/globals.dart';
import 'package:jamii_check/ui/pages/auth/forget_password_screen.dart';
import 'package:jamii_check/ui/pages/auth/signup_screen.dart';
import 'package:jamii_check/ui/pages/home/page_manager.dart';
import 'package:jamii_check/ui/widgets/basewidgets/button/custom_button.dart';
import 'package:jamii_check/ui/widgets/basewidgets/button/google_button.dart';
import 'package:jamii_check/ui/widgets/basewidgets/textfield/custom_email_textfield.dart';
import 'package:jamii_check/ui/widgets/basewidgets/textfield/custom_password_textfield.dart';
import 'package:jamii_check/utils/dimensions.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController!.text = "";
    _passwordController!.text = "";
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  final FocusNode _emailNode = FocusNode();
  final FocusNode _passNode = FocusNode();
  void googleLogin() async{
    await Provider.of<AuthProvider>(context, listen: false).signInWithGoogle(route);
  }
  void loginUser(BuildContext c) async {
    if (_formKeyLogin!.currentState!.validate()) {
      _formKeyLogin!.currentState!.save();

      String _email = _emailController!.text.trim();
      String _password = _passwordController!.text.trim();

      if (_email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Email is required"),
          backgroundColor: Colors.red,
        ));
      } else if (_password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(("password is required")),
          backgroundColor: Colors.red,
        ));
      } else {
        await Provider.of<AuthProvider>(context, listen: false).logIn(_email,_password, route);
      }
    }
  }
  route(bool isRoute, String errorMessage) async {
    if (isRoute) {
       await getNotifs();
      await Provider.of<ProfileProvider>(context, listen: false).getUserInfo();
      await Provider.of<ProfileProvider>(context, listen: false).getPublishedCount();
      await Provider.of<ProfileProvider>(context, listen: false).getCommentsCount();
      await Provider.of<ProfileProvider>(context, listen: false).getUnderReviewCount();
      await Provider.of<SearchProvider>(context, listen: false).initHistoryList();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) =>  const PageManager()), (route) => false);
      _emailController!.clear();
      _passwordController!.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar:  SizedBox(
        height: 50,
        child:  Column(
            children: [
              const Divider(
                color: Colors.grey,
              ),
              InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (con) => const SignUpScreen()));
                  },
                  child: const Text("Do not have an account? Register"))
            ],
          )
        ),
      body: Form(
        key: _formKeyLogin,
        child: ListView(
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
                     Text("Log in",style: TextStyle(color:JAMII_PRIMARY_COLOR,fontWeight: FontWeight.bold,fontSize: 20),),
                     SizedBox(height: 20,),
                     Text("Hello,we are happy to have you back",style: TextStyle(color:Colors.grey,fontSize: 15),)
                  ],
                )),
                const SizedBox(height: 20,),
            // for Email
            Container(
                margin:
                    const EdgeInsets.only(left: Dimensions.MARGIN_SIZE_LARGE, right: Dimensions.MARGIN_SIZE_LARGE, bottom: Dimensions.MARGIN_SIZE_SMALL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Email address"),
                    const SizedBox(height: 20,),
                    CustomEmailTextField(
                  focusNode: _emailNode,
                  nextNode: _passNode,
                  textInputType: TextInputType.emailAddress,
                  controller: _emailController,
                )
                  ],
                )),
    
            // for Password
            Container(
                margin:
                    const EdgeInsets.only(left: Dimensions.MARGIN_SIZE_LARGE, right: Dimensions.MARGIN_SIZE_LARGE, bottom: Dimensions.MARGIN_SIZE_DEFAULT),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Password"),
                    const SizedBox(height: 20,),
                    CustomPasswordTextField(
                  textInputAction: TextInputAction.done,
                  focusNode: _passNode,
                  controller: _passwordController,
                   readOnly:false
                )
                  ],
                )),
    
            // for forgetpassword
            Container(
              margin: const EdgeInsets.only(left: Dimensions.MARGIN_SIZE_SMALL, right: Dimensions.MARGIN_SIZE_SMALL),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){ 
                      FocusScope.of(context).unfocus();
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ForgetPasswordScreen()));
                      },
                    child: const Text("Forget your password?",style: TextStyle(color: JAMII_PRIMARY_COLOR),),
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
            // for signin button
            Container(
              margin:
                  const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 30),
              child: Provider.of<AuthProvider>(context).isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(JAMII_PRIMARY_COLOR),
                      ),
                    )
                  : CustomButton(onTap: loginUser, buttonText: "Log in"),
            ),
            const Center(child: Text("Or",style:TextStyle(color: Colors.grey))),
            Container(
              margin: const  EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 30),
              child: GoogleButton(onTap:googleLogin),
            ),
    
            //for order as guest
            /* Provider.of<AuthProvider>(context).isLoading
              ? const SizedBox()
              : Center(
                  child: TextButton(
                  onPressed: () {
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashBoardScreen()));
                  },
                  child: const Text("Skip for now",
                      style: TextStyle(fontSize: Dimensions.FONT_SIZE_SMALL, color: JAMII_PRIMARY_COLOR)),
                )), */
          ],
        ),
      ),
    );
  }
}
