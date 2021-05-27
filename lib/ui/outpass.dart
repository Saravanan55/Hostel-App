import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hostel/login.dart';
import 'package:hostel/model/complaints.dart';
import 'package:hostel/ui/product_fab_leave.dart';
import 'package:hostel/utils/CommonData.dart';
import 'outpassDetails.dart';

class Outpass extends StatefulWidget {
  @override
  _OutpassState createState() => _OutpassState();
}

class _OutpassState extends State<Outpass> with TickerProviderStateMixin {
  List<Complaints> complaintList = List();
  List<Tab> tabBarViews;
  Map<dynamic, dynamic> data;
  String name;
  String userId = '';
  Complaints complaint;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final auth = FirebaseAuth.instance;
  final Firestore store = Firestore.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference;
  TabController tabBarController;
  FirebaseUser currentUser;
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
  void initState() {
    super.initState();
    this.getCurrentUser();
    complaint = Complaints("", "", "", "", "");
    databaseReference = database.reference();
    databaseReference.onChildAdded.listen(onDataAdded);

    tabBarController =
        new TabController(length: 1, vsync: this, initialIndex: 0);
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  static const textStyle = TextStyle(
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButton: ProductFABLeave(),
        appBar: AppBar(
          actions: <Widget>[
            GestureDetector(
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onTap: () {
                CommonData.clearLoggedInUserData();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            )
          ],
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Outpass'),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            controller: tabBarController,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.0, color: Colors.white),
                insets: EdgeInsets.symmetric(horizontal: 0.0)),
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
                child: Text('Outpass Detail'),
              ),
            ],
          ),
        ),
        body: Container(
            child: TabBarView(
          controller: tabBarController,
          children: [
            new FirebaseAnimatedList(
                defaultChild: shimmers(),
                query: databaseReference
                    .child('outpass')
                    .orderByChild("uid")
                    .equalTo(currentUser.uid),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  data = snapshot.value;
                  data['key'] = snapshot.key;
                  print('${data['name']}');
                  return eventCard(
                      data["Name"],
                      data["Phone"],
                      data["Out Date"],
                      data["In Date"],
                      data["Departure Time"],
                      data["In Time"],
                      data["Address"],
                      data["Reason"],
                      data["id"],
                      data['block'],
                      data["room"],
                      data["status"],
                      0,
                      data['key']);
                }),
          ],
        )),
      ),
    );
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

  Widget eventCard(
      String name,
      String phone,
      String outdate,
      String indate,
      String deptime,
      String intime,
      String address,
      String reason,
      String id,
      String block,
      String room,
      String status,
      int flag,
      String key) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OutpassDetails(
                    name,
                    phone,
                    outdate,
                    indate,
                    deptime,
                    intime,
                    address,
                    reason,
                    id,
                    block,
                    room,
                    status,
                    flag,
                    key)));
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
                          'Name : $name',
                          style: textStyle,
                        ),
                        Text(
                          'Mobile : $phone',
                          style: textStyle,
                        ),
                        Text(
                          'Out Date : $outdate',
                          style: textStyle,
                        ),
                        Text(
                          'In Date : $indate',
                          style: textStyle,
                        ),
                        Text(
                          'Departure Time : $deptime',
                          style: textStyle,
                        ),
                        Text(
                          'In Time : $intime',
                          style: textStyle,
                        ),
                        Text(
                          'Address : $address',
                          style: textStyle,
                        ),
                        Text(
                          'Reason : $reason',
                          style: textStyle,
                        ),
                        Text(
                          'Block : $block',
                          style: textStyle,
                        ),
                        Text(
                          'Room No : $room',
                          style: textStyle,
                        ),
                        Text(
                          'Status : $status',
                          style: TextStyle(
                              color: status == "Pending"
                                  ? Colors.red
                                  : Colors.green),
                        )
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

  void onDataAdded(Event event) {
    setState(() {
      complaintList.add(Complaints.fromSnapshot(event.snapshot));
    });
  }
}
