import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:hostel/model/complaints.dart';
// import 'package:hostel/ui/ComplaintDetails.dart';
// import 'package:hostel/ui/complaintform.dart';
import 'package:hostel/ui/food_list.dart';
import 'package:shimmer/shimmer.dart';

class FoodTest extends StatefulWidget {
  @override
  _FoodTestState createState() => _FoodTestState();
}

class _FoodTestState extends State<FoodTest> {
  List<Complaints> complaintList = [];
  List<Tab> tabBarViews;
  Map<dynamic, dynamic> data;
  String name;
  String userId = '';
  Complaints complaint;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  // final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference;
  @override
  @override
  void initState() {
    super.initState();

    complaint = Complaints("", "", "", "", "");
    databaseReference = database.reference();
    databaseReference.onChildAdded.listen(onDataAdded);
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.account_circle),
        //   onPressed: () {},
        // ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff8096ed),
        title: Text(' Food Details'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 200.0,
              child: firebasefood(),
            ),
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.edit),
      //   backgroundColor: Colors.green,
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => MyForm()));
      //     setState(() {});
      //   },
      // ),
    );
  }

  Widget firebasefood() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FoodItemList(),
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

  void onDataAdded(Event event) {
    setState(() {
      complaintList.add(Complaints.fromSnapshot(event.snapshot));
    });
  }
}
