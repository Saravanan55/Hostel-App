import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:hostel/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostel/utils/bezierContainer.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _saving = false;
  Map data;
  bool validateName = false;
  bool validateEmail = false;
  bool validatePassword = false;
  bool validateUSN = false;
  bool validateBlock = false;
  bool validateRoom = false;
  bool validateMobile = false;
  bool _isHidden = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController usnController = TextEditingController();
  TextEditingController blockController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    Future<void> signUp() async {
      try {
        AuthResult result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        FirebaseUser user = result.user;

        Firestore.instance
            .collection("users")
            .document((emailController.text))
            .setData({
          "name": "${nameController.text}",
          "usn": "${usnController.text}",
          "block": "${blockController.text}",
          "room": "${roomController.text}",
          "mobile": "${mobileController.text}",
          "role": "student"
        });
         FirebaseDatabase.instance.reference().child("users").push().set({
          "name": "${nameController.text}",
          "usn": "${usnController.text}",
          "block": "${blockController.text}",
          "room": "${roomController.text}",
          "mobile": "${mobileController.text}",
          "role": "student",
          "email":"${emailController.text}"
        });
        print(user);
        user.sendEmailVerification();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      } catch (e) {
        _saving = false;
        setState(() {});
        print(e.message);
        Fluttertoast.showToast(
          msg: e.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }

    return Scaffold(
      body: Container(
        height: height,
        child: new Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //  mainAxisAlignment: MainAxisAlignment.start,
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 30),
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
                    Text(
                      "Name",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          value.isEmpty
                              ? validateName = true
                              : validateName = false;
                        });
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                          errorText:
                              validateName ? "Name can\'t be empty" : null,
                          hintText: "Name",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 12.0),
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(30),
                    ),
                    Text(
                      "Roll No.",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          value.isEmpty
                              ? validateUSN = true
                              : validateUSN = false;
                        });
                      },
                      controller: usnController,
                      decoration: InputDecoration(
                          errorText:
                              validateUSN ? "Roll no can\'t be empty" : null,
                          hintText: "Roll No",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 12.0),
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(30),
                    ),
                    Text("Hostel Block",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          value.isEmpty
                              ? validateBlock = true
                              : validateBlock = false;
                        });
                      },
                      controller: blockController,
                      decoration: InputDecoration(
                          errorText:
                              validateBlock ? "Block can\'t be empty" : null,
                          hintText: "Block",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 12.0),
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(30),
                    ),
                    Text("Room No.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    TextField(
                      keyboardType: TextInputType.numberWithOptions(),
                      onChanged: (value) {
                        setState(() {
                          value.isEmpty
                              ? validateRoom = true
                              : validateRoom = false;
                        });
                      },
                      controller: roomController,
                      decoration: InputDecoration(
                          errorText:
                              validateRoom ? "Room can\'t be empty" : null,
                          hintText: "Room No.",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 12.0),
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(35),
                    ),
                    Text("Mobile",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          value.isEmpty
                              ? validateMobile = true
                              : validateMobile = false;
                        });
                      },
                      maxLength: 10,
                      controller: mobileController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          errorText:
                              validateMobile ? "Mobile can\'t be empty" : null,
                          hintText: "Mobile",
                          prefixText: '+91-',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 12.0),
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(35),
                    ),
                    Text("Email",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
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
                          hintText: "Email",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 12.0),
                          border: InputBorder.none,
                          fillColor: Color(0xfff3f3f4),
                          filled: true),
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(35),
                    ),
                    Text("Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          value.isEmpty
                              ? validatePassword = true
                              : validatePassword = false;
                        });
                      },
                      obscureText: _isHidden,
                      controller: passwordController,
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
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(35),
                    ),
                    InkWell(
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
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
                                  colors: [
                                    Color(0xff5ed8e6),
                                    Color(0xff2cb7c7)
                                  ])),
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
                                  usnController.text.isEmpty
                                      ? validateUSN = true
                                      : validateUSN = false;
                                  blockController.text.isEmpty
                                      ? validateBlock = true
                                      : validateBlock = false;
                                  roomController.text.isEmpty
                                      ? validateRoom = true
                                      : validateRoom = false;
                                  mobileController.text.isEmpty
                                      ? validateMobile = true
                                      : validateMobile = false;
                                  nameController.text.isEmpty
                                      ? validateName = true
                                      : validateName = false;
                                });

                                data = {
                                  "name": "${nameController.text}",
                                  "usn": "${usnController.text}",
                                  "block": "${blockController.text}",
                                  "room": "${roomController.text}",
                                  "mobile": "${mobileController.text}",
                                  "role": "student"
                                };
                                if (!(validateMobile &&
                                    validateRoom &&
                                    validateBlock &&
                                    validateName &&
                                    validatePassword &&
                                    validateEmail &&
                                    validateUSN)) {
                                  _saving = true;
                                  signUp();
                                }
                              },
                              child: Center(
                                child: Text("SignUp",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
