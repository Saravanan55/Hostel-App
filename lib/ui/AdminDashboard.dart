import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hostel/food/foodpage.dart';
import 'package:hostel/issues/issuespending.dart';
import 'package:hostel/issues/issuessolved.dart';
import 'package:hostel/outpass/approved.dart';
import 'package:hostel/outpass/decline.dart';
import 'package:hostel/outpass/pending.dart';
import 'package:hostel/users/aids.dart';
import 'package:hostel/users/civil.dart';
import 'package:hostel/users/cse.dart';
import 'package:hostel/users/ece.dart';
import 'package:hostel/users/it.dart';
import 'package:hostel/users/mech.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hostel/login.dart';
import 'package:hostel/model/complaints.dart';
import 'package:hostel/utils/CommonData.dart';

class AdminDashboard extends StatefulWidget {
  //int loginTypeFlag;

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  List<Complaints> complaintList = [];
  Map<dynamic, dynamic> data;

  Complaints complaint;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference;
  TabController tabBarController;

  @override
  void initState() {
    super.initState();
    complaint = Complaints("", "", "", "", "");
    databaseReference = database.reference();
    databaseReference.onChildAdded.listen(onDataAdded);
  }

  Widget shimmers() {
    return ListView(
      children: <Widget>[
        shimmerCard(),
        shimmerCard(),
        shimmerCard(),
        shimmerCard(),
        shimmerCard(),
        shimmerCard()
      ],
    );
  }

  Widget shimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    width: 70.0,
                    height: 70.0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 10.0,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 10.0,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 10.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
          automaticallyImplyLeading: false,
          actions: <Widget>[
            GestureDetector(
              child: Icon(Icons.logout),
              onTap: () {
                CommonData.clearLoggedInUserData();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ],
          backgroundColor: Color(0xff8096ed),
          title: Text('Admin Dashboard'),
        ),
        body: Container(
          color: Colors.white,
          margin: EdgeInsets.only(left: 4.0, right: 4, bottom: 0, top: 10),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Text(
                      "Hostel Issues".toUpperCase(),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                delegate: SliverChildListDelegate(
                  [
                    Row(
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Pending()));
                            },
                            child: Container(
                              height: 115.0,
                              width: (MediaQuery.of(context).size.width / 2) -
                                  32.0,
                              margin: EdgeInsets.only(
                                  left: 10.0,
                                  right: 5.0,
                                  top: 5.0,
                                  bottom: 5.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 8,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 30.0),
                                        child: Icon(Icons.warning,
                                            size: 30.0, color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Pending',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/image_02.png"),
                                    fit: BoxFit.cover),
                                color: Color(0xFF333366),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0, 2.0),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Solved()));
                            },
                            child: Container(
                              height: 115.0,
                              width: (MediaQuery.of(context).size.width / 2) -
                                  32.0,
                              margin: EdgeInsets.only(
                                  left: 10.0,
                                  right: 5.0,
                                  top: 5.0,
                                  bottom: 5.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 8,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 30.0),
                                        child: Icon(Icons.check_circle,
                                            size: 30.0, color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Done',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/image_02.png"),
                                    fit: BoxFit.cover),
                                color: Color(0xFF333366),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0, 2.0),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),

              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(padding: EdgeInsets.all(2)),
                    Text("OUTPASS",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              //SizedBox(height: 12),
              SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  delegate: SliverChildListDelegate([
                    Row(
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OutpassPending()));
                            },
                            child: Container(
                              height: 115.0,
                              width: (MediaQuery.of(context).size.width / 3) -
                                  32.0,
                              margin: EdgeInsets.only(
                                  left: 10.0,
                                  right: 5.0,
                                  top: 15.0,
                                  bottom: 15.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 8,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 30.0),
                                        child: Icon(Icons.warning,
                                            size: 30.0, color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Pending',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/outpassdesign.jpg"),
                                  fit: BoxFit.cover,
                                ),
                                color: Color(0xFF333366),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0, 2.0),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OutpassApproved()));
                            },
                            child: Container(
                              height: 115.0,
                              width: (MediaQuery.of(context).size.width / 3) -
                                  28.0,
                              margin: EdgeInsets.only(
                                  left: 10.0,
                                  right: 5.0,
                                  top: 15.0,
                                  bottom: 15.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 8,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 30.0),
                                        child: Icon(Icons.check_circle,
                                            size: 30.0, color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Approved',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/outpassdesign.jpg"),
                                    fit: BoxFit.cover),
                                color: Color(0xFF333366),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0, 2.0),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OutpassDecline()));
                            },
                            child: Container(
                              height: 115.0,
                              width: (MediaQuery.of(context).size.width / 3) -
                                  32.0,
                              margin: EdgeInsets.only(
                                  left: 10.0,
                                  right: 5.0,
                                  top: 15.0,
                                  bottom: 15.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 8,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 30.0),
                                        child: Icon(Icons.highlight_off,
                                            size: 30.0, color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Decline',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage("assets/outpassdesign.jpg"),
                                    fit: BoxFit.cover),
                                color: Color(0xFF333366),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0, 2.0),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                  ])),

              // Card(),
              // SizedBox(height: 12),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Text("STUDENTS",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                delegate: SliverChildListDelegate(
                  [
                    Row(
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Csedept()));
                            },
                            child: Container(
                              height: 115.0,
                              width: (MediaQuery.of(context).size.width / 2) -
                                  32.0,
                              margin: EdgeInsets.only(
                                  left: 10.0,
                                  right: 5.0,
                                  top: 5.0,
                                  bottom: 5.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 8,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 30.0),
                                        child: Icon(Icons.people,
                                            size: 30.0, color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'CSE DEPT',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(""),
                                    fit: BoxFit.fitWidth),
                                color: Color(0xFF333366),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0, 2.0),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Itdept()));
                            },
                            child: Container(
                              height: 115.0,
                              width: (MediaQuery.of(context).size.width / 2) -
                                  32.0,
                              margin: EdgeInsets.only(
                                  left: 10.0,
                                  right: 5.0,
                                  top: 5.0,
                                  bottom: 5.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 8,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 30.0),
                                        child: Icon(Icons.people,
                                            size: 30.0, color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'IT DEPT',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(""), fit: BoxFit.cover),
                                color: Color(0xFF333366),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0, 2.0),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Ecedept()));
                            },
                            child: Container(
                              height: 115.0,
                              width: (MediaQuery.of(context).size.width / 2) -
                                  32.0,
                              margin: EdgeInsets.only(
                                  left: 10.0,
                                  right: 5.0,
                                  top: 5.0,
                                  bottom: 5.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 8,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 30.0),
                                        child: Icon(Icons.people,
                                            size: 30.0, color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'ECE DEPT',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(""), fit: BoxFit.cover),
                                color: Color(0xFF333366),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0, 2.0),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Civildept()));
                            },
                            child: Container(
                              height: 115.0,
                              width: (MediaQuery.of(context).size.width / 2) -
                                  32.0,
                              margin: EdgeInsets.only(
                                  left: 10.0,
                                  right: 5.0,
                                  top: 5.0,
                                  bottom: 5.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 8,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 30.0),
                                        child: Icon(Icons.people,
                                            size: 30.0, color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'CIVIL DEPT',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(""), fit: BoxFit.cover),
                                color: Color(0xFF333366),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0, 2.0),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Mechdept()));
                            },
                            child: Container(
                              height: 115.0,
                              width: (MediaQuery.of(context).size.width / 2) -
                                  32.0,
                              margin: EdgeInsets.only(
                                  left: 10.0,
                                  right: 5.0,
                                  top: 5.0,
                                  bottom: 5.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 8,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 30.0),
                                        child: Icon(Icons.people,
                                            size: 30.0, color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'MECH DEPT',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(""), fit: BoxFit.cover),
                                color: Color(0xFF333366),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0, 2.0),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AiDsdept()));
                            },
                            child: Container(
                              height: 115.0,
                              width: (MediaQuery.of(context).size.width / 2) -
                                  32.0,
                              margin: EdgeInsets.only(
                                  left: 10.0,
                                  right: 5.0,
                                  top: 5.0,
                                  bottom: 5.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 8,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 30.0),
                                        child: Icon(Icons.people,
                                            size: 30.0, color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'AI&DS DEPT',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(""), fit: BoxFit.cover),
                                color: Color(0xFF333366),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0, 2.0),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FoodPage()));
                            },
                            child: Container(
                              height: 100.0,
                              width: MediaQuery.of(context).size.width - 32.0,
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
                        // Positioned(
                        //   top: 0,
                        //   right: (MediaQuery.of(context).size.width / 2) - 42.0,
                        //   //  right: -36,
                        //   child: IconButton(
                        //     onPressed: () {},
                        //     icon: Icon(Icons.more_vert),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onDataAdded(Event event) {
    setState(() {
      complaintList.add(Complaints.fromSnapshot(event.snapshot));
    });
  }
}
