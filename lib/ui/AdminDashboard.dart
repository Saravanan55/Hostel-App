import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hostel/food/add_screen.dart';
import 'package:hostel/food/item_list.dart';
import 'package:hostel/issues/issuespending.dart';
import 'package:hostel/issues/issuessolved.dart';
import 'package:hostel/outpass/approved.dart';
import 'package:hostel/outpass/pending.dart';
import 'package:hostel/profile_user/body.dart';
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
  int loginTypeFlag;

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  List<Complaints> complaintList = List();
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

    tabBarController =
        new TabController(length: 5, vsync: this, initialIndex: 0);
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

  static const textStyle = TextStyle(
    fontSize: 16,
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            GestureDetector(
              child: Container(
                child: SvgPicture.asset("assets/Log out.svg"),
                // color: Colors.white,
              ),
              onTap: () {
                CommonData.clearLoggedInUserData();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            )
          ],
          backgroundColor: Color(0xff028090),
          title: Text('Admin Dashboard'),
          bottom: TabBar(
            controller: tabBarController,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.0, color: Colors.white),
                insets: EdgeInsets.symmetric(horizontal: 0.0)),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 15,
            unselectedLabelStyle: TextStyle(
                color: Colors.black26,
                fontSize: 15.0,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w400),
            unselectedLabelColor: Colors.grey.shade400,
            labelColor: Colors.white,
            isScrollable: true,
            labelStyle: TextStyle(
                fontSize: 15.0,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700),
            tabs: <Widget>[
              Tab(
                child: Text('Issues'),
              ),
              Tab(
                child: Text('Students'),
              ),
              Tab(
                child: Text('Outpass'),
              ),
              Tab(
                child: Text('Food'),
              ),
              Tab(
                child: Text("Text"),
              )
            ],
          ),
        ),
        body: Container(
          child: TabBarView(
            controller: tabBarController,
            children: <Widget>[
              issues(),
              studentList("Students"),
              outpassfirebase(),
              foodfirebase(),
              testing(),
            ],
          ),
        ),
      ),
    );
  }

  Widget testing() {
    return Card(
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2,
        children: <Widget>[
          Card(
            color: Color(0xff0ff24b),
            elevation: 6,
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Csedept()));
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 18.0),
                    Text(
                      'CSE Student',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Color(0xff0ff24b),
            elevation: 6,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Itdept()));
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 18.0),
                    Text(
                      'IT Student',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Color(0xff0ff24b),
            elevation: 6,
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Ecedept()));
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 18.0),
                    Text(
                      'ECE Student',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Color(0xff0ff24b),
            elevation: 6,
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Mechdept()));
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 18.0),
                    Text(
                      'MECH Student',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            color: Color(0xff0ff24b),
            elevation: 6,
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Civildept()));
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 18.0),
                    Text(
                      'CIVIL Student',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget foodfirebase() {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddScreen(),
            ),
          );
        },
        backgroundColor: Color(0xff028090),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
      body: SafeArea(
        child: ItemList(),
      ),
    );
  }

  Widget studentList(String complaintType) {
    return FirebaseAnimatedList(
      defaultChild: Center(child: shimmers()),
      query: databaseReference.child('users'),
      itemBuilder: (BuildContext context, DataSnapshot snapshot,
          Animation<double> animation, int index) {
        data = snapshot.value;
        data['key'] = snapshot.key;
        print('${data['name']}');
        return studentCard(
            data['key'],
            data['email'],
            data["name"],
            data["usn"],
            data["mobile"],
            data['block'],
            data['room'],
            data['url']);
      },
    );
  }

  Widget studentCard(String documentId, String email, String name, String usn,
      String mobile, String block, String room, String url) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Body(
                    documentId, email, name, usn, mobile, block, room, url)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6),
        child: Container(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 6.0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Email : $email',
                          style: textStyle,
                        ),
                        Text(
                          'Name : $name',
                          style: textStyle,
                        ),
                        Text(
                          'Roll No : $usn',
                          style: textStyle,
                        ),
                        Text(
                          'Mobile : $mobile',
                          style: textStyle,
                        ),
                        Text(
                          'Block : $block',
                          style: textStyle,
                        ),
                        Text(
                          'Room : $room',
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget outpassfirebase() {
    return Card(
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2,
        children: <Widget>[
          Card(
            color: Color(0xfffa3434),
            elevation: 6,
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OutpassPending()));
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 18.0),
                    Text(
                      'Outpass \n Pending',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            elevation: 6,
            color: Color(0xff0ff24b),
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OutpassApproved()));
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 18.0),
                    Text(
                      'Outpass \n Approved',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget issues() {
    return Card(
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2,
        children: <Widget>[
          Card(
            color: Color(0xfffa3434),
            elevation: 6,
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Pending()));
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 18.0),
                    Text(
                      'Issues \n Pending',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            elevation: 6,
            color: Color(0xff0ff24b),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Solved()));
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 18.0),
                    Text(
                      'Issues \n Solved',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onDataAdded(Event event) {
    setState(() {
      complaintList.add(Complaints.fromSnapshot(event.snapshot));
    });
  }
}
