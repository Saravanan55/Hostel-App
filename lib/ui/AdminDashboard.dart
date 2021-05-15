import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hostel/login.dart';
import 'package:hostel/model/complaints.dart';
import 'package:hostel/ui/ComplaintDetails.dart';
import 'package:hostel/utils/CommonData.dart';
import 'food/add_screen.dart';
import 'food/item_list.dart';
import 'outpassDetails.dart';

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
    complaint = Complaints("", "", "", "","");
    databaseReference = database.reference();
    databaseReference.onChildAdded.listen(onDataAdded);

    tabBarController =
        new TabController(length: 4, vsync: this, initialIndex: 0);
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
            ],
          ),
        ),
        body: Container(
          child: TabBarView(
            controller: tabBarController,
            children: <Widget>[
              issuesList('isuues'),
              studentList("Students"),
              outpassfirebase('outpass'),
              foodfirebase(),
            ],
          ),
        ),
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
        // child: Padding(
        //   padding: const EdgeInsets.all(10.0),
        //   child: ItemList(),
        // ),
      ),
    );
  }

  Widget issuesList(String complaintType) {
    return FirebaseAnimatedList(
        defaultChild: Center(child: shimmers()),
        query: databaseReference.child('hostel'),
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          data = snapshot.value;
          data['key'] = snapshot.key;
          print('${data['name']}');
          return eventCard(
              data["name"],
              data["detail"],
              data['phone'],
              data['url'],
              data["status"],
              data['id'],
              data['category'],
              complaintType,
              1,
              data['key']);
        });
  }

  Widget eventCard(
      String name,
      String detail,
      String phone,
      String url,
      String status,
      String id,
      String category,
      String complaintType,
      int flag,
      String key) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ComplaintDetails(name, detail, phone, url,
                    status, id, category, flag, key)));
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
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    width: 100,
                    height: 100,
                    child: Image.network(
                      url,
                      height: 150,
                      width: 150,
                    ),
                  ),
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
                          'ID : $id',
                          style: textStyle,
                        ),
                        Text(
                          'Number : $phone',
                          style: textStyle,
                        ),
                        Text(
                          'Category : $category',
                          style: textStyle,
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: 200),
                          child: Text(
                            'Detail : $detail',
                            overflow: TextOverflow.ellipsis,
                            style: textStyle,
                          ),
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

  Widget studentList(String students) {
    return new StreamBuilder(
      stream: Firestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        return !snapshot.hasData
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot data = snapshot.data.documents[index];
                  return studentCard(
                    data.documentID,
                    data["name"],
                    data["usn"],
                    data["mobile"],
                    data['block'],
                    data['room'],
                  );
                },
              );
      },
    );
  }

  Widget studentCard(
    String documentSnapshot,
    String name,
    String usn,
    String mobile,
    String block,
    String room,
  ) {
    return InkWell(
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
                          'Email : $documentSnapshot',
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

  Widget outpassfirebase(String complaintType) {
    return FirebaseAnimatedList(
        defaultChild: shimmers(), //Center(child: CircularProgressIndicator()),
        query: databaseReference.child('outpass'),
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          data = snapshot.value;
          data['key'] = snapshot.key;
          print('${data['name']}');
          return eventCardpass(
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
              1,
              data['key']);
        });
  }

  Widget eventCardpass(
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
                          'Date : $outdate',
                          style: textStyle,
                        ),
                        Text(
                          'Date : $indate',
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
