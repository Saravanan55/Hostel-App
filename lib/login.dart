import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel/reset.dart';
import 'package:hostel/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hostel/ui/AdminDashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hostel/ui/UserDashboard.dart';
import 'package:hostel/utils/Constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostel/utils/bezierContainer.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  bool validateEmail = false;
  bool validatePassword = false;
  String name, usn, role, mobile, block, room;
  bool _isSelected = false;
  bool _isHidden = true;
  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  bool _saving = false;
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return ModalProgressHUD(
      inAsyncCall: _saving,
      child: WillPopScope(
        onWillPop: () => _onWillPop(),
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 45.0, top: 10.0),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Image.asset("assets/image_02.png")
                ],
              ),
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    formCard(),
                    SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(40),
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(40),
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(30),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Don\'t have an account ?',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new SignUp()));
                          },
                          child: Text("SignUp",
                              style: TextStyle(
                                  color: Color(0xFF5d74e3),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    try {
      final FirebaseUser user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text))
          .user;

      var d = await Firestore.instance
          .collection('users')
          .document(emailController.text)
          .get()
          .then((DocumentSnapshot) async {
        name = DocumentSnapshot.data['name'];
        usn = DocumentSnapshot.data['usn'];
        role = DocumentSnapshot.data['role'];
        block = DocumentSnapshot.data['block'];
        room = DocumentSnapshot.data['room'];
        mobile = DocumentSnapshot.data['mobile'];
        print("name : $name");
        final prefs = await SharedPreferences.getInstance();

        prefs.setString(Constants.loggedInUserRole, role);
        prefs.setString(Constants.loggedInUserBlock, block);
        prefs.setString(Constants.loggedInUserRoom, room);
        prefs.setString(Constants.loggedInUserMobile, mobile);
        prefs.setString(Constants.loggedInUserName, name);
        prefs.setString(Constants.isLoggedIn, 'true');
        //  print("Constants name : ${Constants.loggedInUserMobile}");
        print(DocumentSnapshot.data.toString());
      });
      _saving = false;
      if (role == "student")
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => UserDashboard()));
      else
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AdminDashboard()));
    } catch (e) {
      print(e.message);
      _saving = false;
      setState(() {});
      Fluttertoast.showToast(
        msg: e.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  formCard() {
    final height = MediaQuery.of(context).size.height;
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'H',
                        style: GoogleFonts.portLligatSans(
                          textStyle: Theme.of(context).textTheme.display1,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Color(0xffe46b10),
                        ),
                        children: [
                          TextSpan(
                            text: 'OS',
                            style: TextStyle(color: Colors.black, fontSize: 30),
                          ),
                          TextSpan(
                            text: 'TEL',
                            style: TextStyle(
                                color: Color(0xffe46b10), fontSize: 30),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text("Email",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  TextField(
                    controller: emailController,
                    onChanged: (value) {
                      setState(() {
                        value.isEmpty
                            ? validateEmail = true
                            : validateEmail = false;
                      });
                    },
                    decoration: InputDecoration(
                        errorText:
                            validateEmail ? "Email can\'t be empty" : null,
                        hintText: "email",
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 12.0),
                        border: InputBorder.none,
                        fillColor: Color(0xfff3f3f4),
                        filled: true),
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(30),
                  ),
                  Text("Password",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          value.isEmpty
                              ? validatePassword = true
                              : validatePassword = false;
                        });
                      },
                      controller: passwordController,
                      obscureText: _isHidden,
                      decoration: InputDecoration(
                          errorText: validatePassword
                              ? "Password can\'t be empty"
                              : null,
                          hintText: "Password",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 12.0),
                          suffix: InkWell(
                            onTap: _togglePasswordView,
                            child: Icon(
                              _isHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: Text("Forgot Password?",
                            style: TextStyle(
                                color: Colors.blue,
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil.getInstance().setSp(28))),
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ResetScreen())),
                      )
                    ],
                  ),
                  InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.shade200,
                                offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 2)
                          ],
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xff5ed8e6), Color(0xff2cb7c7)])),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              emailController.text.isEmpty
                                  ? validateEmail = true
                                  : validateEmail = false;
                              passwordController.text.isEmpty
                                  ? validatePassword = true
                                  : validatePassword = false;
                            });
                            if (!validateEmail && !validatePassword) {
                              _saving = true;
                              signIn();
                            }
                          },
                          child: Center(
                            child: Text(
                              "LOGIN",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
