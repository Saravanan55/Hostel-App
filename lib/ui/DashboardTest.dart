import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hostel/ui/foodtest.dart';
import 'package:hostel/ui/issuesTest.dart';
//import 'package:hostel/ui/outpass.dart';
import 'package:hostel/ui/outpasstest.dart';
import 'package:hostel/ui/profile/profile.dart';

class DashboardTest extends StatefulWidget {
  @override
  _DashboardTestState createState() => _DashboardTestState();
}

class _DashboardTestState extends State<DashboardTest>
    with TickerProviderStateMixin {
  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the App'),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new TextButton(
                onPressed: () => exit(0),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            // actions: <Widget>[
            //   GestureDetector(
            //     child: Icon(
            //       Icons.logout,
            //       color: Colors.white,
            //     ),
            //     onTap: () {
            //       CommonData.clearLoggedInUserData();
            //       Navigator.push(
            //           context, MaterialPageRoute(builder: (context) => Login()));
            //     },
            //   )
            // ],
            leading: IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
            ),
            backgroundColor: Color(0xff8096ed),
            title: Text(' DashboardTest'),
          ),
          body: new Column(
            children: <Widget>[
              // new GradientAppBar("treva"),
              PlanetRow(),
            ],
          ),
        ));
  }
}

class PlanetRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Column(children: [
          Row(
            children: <Widget>[
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => IssuesTest()));
                  },
                  child: Container(
                    height: 100.0,
                    width: MediaQuery.of(context).size.width - 48.0,
                    // margin: new EdgeInsets.only(left: 46.0),
                    //constraints: BoxConstraints.expand(),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(height: 4.0),
                          Text("hostel issues".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w600)),
                          Container(height: 10.0),
                        ]),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/image_02.png"),
                          fit: BoxFit.cover),
                      color: Color(0xFF333366),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          offset: Offset(0.0, 10.0),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FoodTest()));
                  },
                  child: Container(
                    height: 100.0,
                    width: MediaQuery.of(context).size.width - 48.0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(height: 4.0),
                          Text("Food details".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w600)),
                          Container(height: 10.0),
                        ]),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/fooddesign.png"),
                          fit: BoxFit.cover),
                      color: Color(0xFF333366),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          offset: Offset(0.0, 10.0),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => OutpassTest()));
                  },
                  child: Container(
                    height: 100.0,
                    width: MediaQuery.of(context).size.width - 48.0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(height: 4.0),
                          Text("outpass".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w600)),
                          Container(height: 10.0),
                        ]),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/outpassdesign.jpg"),
                          fit: BoxFit.cover),
                      color: Color(0xFF333366),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          offset: Offset(0.0, 10.0),
                        ),
                      ],
                    ),
                  )),
            ],
          )
        ]));
  }
}
