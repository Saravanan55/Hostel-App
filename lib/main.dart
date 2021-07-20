import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hostel/login.dart';
import 'package:hostel/ui/UserDashboard.dart';
import 'package:hostel/ui/AdminDashboard.dart';
import 'package:hostel/utils/Constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
    shared();
  }

  String _login, _role;

  shared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _login = (prefs.getString(Constants.isLoggedIn));
      _role = (prefs.getString(Constants.loggedInUserRole));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hostel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _login == "true"
          ? (_role == "student" ? UserDashboard() : AdminDashboard())
          : Login(),
    );
  }
}
