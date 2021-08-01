// import 'dart:io';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hostel/food/add_screen.dart';
// import 'package:hostel/food/foodpage.dart';
// import 'package:hostel/food/item_list.dart';
// import 'package:hostel/issues/issuespending.dart';
// import 'package:hostel/issues/issuessolved.dart';
// import 'package:hostel/outpass/approved.dart';
// import 'package:hostel/outpass/pending.dart';
// import 'package:hostel/users/aids.dart';
// import 'package:hostel/users/civil.dart';
// import 'package:hostel/users/cse.dart';
// import 'package:hostel/users/ece.dart';
// import 'package:hostel/users/it.dart';
// import 'package:hostel/users/mech.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:hostel/model/complaints.dart';

// class AdminDash extends StatefulWidget {
//   @override
//   _AdminDashState createState() => _AdminDashState();
// }

// class _AdminDashState extends State<AdminDash> with TickerProviderStateMixin {
//   List<Complaints> complaintList = [];
//   Map<dynamic, dynamic> data;

//   Complaints complaint;
//   final FirebaseDatabase database = FirebaseDatabase.instance;
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   DatabaseReference databaseReference;
//   // TabController tabBarController;

//   @override
//   void initState() {
//     super.initState();
//     complaint = Complaints("", "", "", "", "");
//     databaseReference = database.reference();
//     databaseReference.onChildAdded.listen(onDataAdded);
//   }

//   Widget shimmers() {
//     return ListView(
//       children: <Widget>[
//         shimmerCard(),
//         shimmerCard(),
//         shimmerCard(),
//         shimmerCard(),
//         shimmerCard(),
//         shimmerCard()
//       ],
//     );
//   }

//   Widget shimmerCard() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300],
//       highlightColor: Colors.grey[100],
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(right: 8.0),
//                   child: Container(
//                     width: 70.0,
//                     height: 70.0,
//                     child: Container(
//                       height: 40,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.0),
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 3.0),
//                       ),
//                       Container(
//                         width: double.infinity,
//                         height: 10.0,
//                         color: Colors.white,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 7.0),
//                       ),
//                       Container(
//                         width: double.infinity,
//                         height: 10.0,
//                         color: Colors.white,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 7.0),
//                       ),
//                       Container(
//                         width: double.infinity,
//                         height: 10.0,
//                         color: Colors.white,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<bool> _onWillPop() {
//     return showDialog(
//           context: context,
//           builder: (context) => new AlertDialog(
//             title: new Text('Are you sure?'),
//             content: new Text('Do you want to exit the App'),
//             actions: <Widget>[
//               new TextButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 child: new Text('No'),
//               ),
//               new TextButton(
//                 onPressed: () => exit(0),
//                 child: new Text('Yes'),
//               ),
//             ],
//           ),
//         ) ??
//         false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//           appBar: AppBar(
//             actions: <Widget>[
//               GestureDetector(
//                 child: Container(
//                   child: SvgPicture.asset("assets/Log out.svg"),
//                 ),
//                 onTap: () {},
//               )
//             ],
//             backgroundColor: Color(0xff028090),
//             title: Text('Admin Dash'),
//           ),
//           body: Container(
//             color: Colors.white,
//             margin: EdgeInsets.only(left: 4.0, right: 4, bottom: 0, top: 10),
//             child: CustomScrollView(
//               slivers: <Widget>[
//                 SliverList(
//                   delegate: SliverChildListDelegate(
//                     [
//                       Text(
//                         "Hostel Issues".toUpperCase(),
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SliverGrid(
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2),
//                   delegate: SliverChildListDelegate(
//                     [
//                       Row(
//                         children: <Widget>[
//                           InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => Pending()));
//                               },
//                               child: Container(
//                                 height: 115.0,
//                                 width: (MediaQuery.of(context).size.width / 2) -
//                                     32.0,
//                                 margin: EdgeInsets.only(
//                                     left: 10.0,
//                                     right: 5.0,
//                                     top: 5.0,
//                                     bottom: 5.0),
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Expanded(
//                                         flex: 8,
//                                         child: Padding(
//                                           padding: EdgeInsets.only(top: 30.0),
//                                           child: Icon(Icons.warning,
//                                               size: 30.0, color: Colors.white),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         flex: 2,
//                                         child: Text(
//                                           'Pending',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 14.0,
//                                               fontWeight: FontWeight.bold),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: AssetImage("assets/image_02.png"),
//                                       fit: BoxFit.cover),
//                                   color: Color(0xFF333366),
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   boxShadow: <BoxShadow>[
//                                     BoxShadow(
//                                       color: Colors.black,
//                                       blurRadius: 2.0,
//                                       spreadRadius: 0.0,
//                                       offset: Offset(2.0, 2.0),
//                                     )
//                                   ],
//                                 ),
//                               )),
//                         ],
//                       ),
//                       Row(
//                         children: <Widget>[
//                           InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => Solved()));
//                               },
//                               child: Container(
//                                 height: 115.0,
//                                 width: (MediaQuery.of(context).size.width / 2) -
//                                     32.0,
//                                 margin: EdgeInsets.only(
//                                     left: 10.0,
//                                     right: 5.0,
//                                     top: 5.0,
//                                     bottom: 5.0),
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Expanded(
//                                         flex: 8,
//                                         child: Padding(
//                                           padding: EdgeInsets.only(top: 30.0),
//                                           child: Icon(Icons.check_circle,
//                                               size: 30.0, color: Colors.white),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         flex: 2,
//                                         child: Text(
//                                           'Done',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 14.0,
//                                               fontWeight: FontWeight.bold),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: AssetImage("assets/image_02.png"),
//                                       fit: BoxFit.cover),
//                                   color: Color(0xFF333366),
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   boxShadow: <BoxShadow>[
//                                     BoxShadow(
//                                       color: Colors.black,
//                                       blurRadius: 2.0,
//                                       spreadRadius: 0.0,
//                                       offset: Offset(2.0, 2.0),
//                                     )
//                                   ],
//                                 ),
//                               )),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SliverList(
//                   delegate: SliverChildListDelegate(
//                     [
//                       Padding(padding: EdgeInsets.all(2)),
//                       Text("OUTPASS",
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                 ),
//                 SliverGrid(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2),
//                     delegate: SliverChildListDelegate([
//                       Row(
//                         children: <Widget>[
//                           InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             OutpassPending()));
//                               },
//                               child: Container(
//                                 height: 115.0,
//                                 width: (MediaQuery.of(context).size.width / 2) -
//                                     32.0,
//                                 margin: EdgeInsets.only(
//                                     left: 10.0,
//                                     right: 5.0,
//                                     top: 5.0,
//                                     bottom: 5.0),
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Expanded(
//                                         flex: 8,
//                                         child: Padding(
//                                           padding: EdgeInsets.only(top: 30.0),
//                                           child: Icon(Icons.warning,
//                                               size: 30.0, color: Colors.white),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         flex: 2,
//                                         child: Text(
//                                           'Pending',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 14.0,
//                                               fontWeight: FontWeight.bold),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: AssetImage(
//                                           "assets/outpassdesign.jpg"),
//                                       fit: BoxFit.cover),
//                                   color: Color(0xFF333366),
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   boxShadow: <BoxShadow>[
//                                     BoxShadow(
//                                       color: Colors.black,
//                                       blurRadius: 2.0,
//                                       spreadRadius: 0.0,
//                                       offset: Offset(2.0, 2.0),
//                                     )
//                                   ],
//                                 ),
//                               )),
//                         ],
//                       ),
//                       Row(
//                         children: <Widget>[
//                           InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                             OutpassApproved()));
//                               },
//                               child: Container(
//                                 height: 115.0,
//                                 width: (MediaQuery.of(context).size.width / 2) -
//                                     32.0,
//                                 margin: EdgeInsets.only(
//                                     left: 10.0,
//                                     right: 5.0,
//                                     top: 5.0,
//                                     bottom: 5.0),
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Expanded(
//                                         flex: 8,
//                                         child: Padding(
//                                           padding: EdgeInsets.only(top: 5.0),
//                                           child: Icon(Icons.check_circle,
//                                               size: 30.0, color: Colors.white),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         flex: 2,
//                                         child: Text(
//                                           'Approved',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 14.0,
//                                               fontWeight: FontWeight.bold),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: AssetImage(
//                                           "assets/outpassdesign.jpg"),
//                                       fit: BoxFit.cover),
//                                   color: Color(0xFF333366),
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   boxShadow: <BoxShadow>[
//                                     BoxShadow(
//                                       color: Colors.black,
//                                       blurRadius: 2.0,
//                                       spreadRadius: 0.0,
//                                       offset: Offset(2.0, 2.0),
//                                     )
//                                   ],
//                                 ),
//                               )),
//                         ],
//                       ),
//                     ])),
//                 // Card(),
//                 SliverList(
//                   delegate: SliverChildListDelegate(
//                     [
//                       Text("STUDENTS",
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                 ),
//                 SliverGrid(
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2),
//                   delegate: SliverChildListDelegate(
//                     [
//                       Row(
//                         children: <Widget>[
//                           InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => Csedept()));
//                               },
//                               child: Container(
//                                 height: 115.0,
//                                 width: (MediaQuery.of(context).size.width / 2) -
//                                     32.0,
//                                 margin: EdgeInsets.only(
//                                     left: 10.0,
//                                     right: 5.0,
//                                     top: 5.0,
//                                     bottom: 5.0),
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Expanded(
//                                         flex: 8,
//                                         child: Padding(
//                                           padding: EdgeInsets.only(top: 30.0),
//                                           child: Icon(Icons.people,
//                                               size: 30.0, color: Colors.white),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         flex: 2,
//                                         child: Text(
//                                           'CSE DEPT',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 14.0,
//                                               fontWeight: FontWeight.bold),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: AssetImage(""),
//                                       fit: BoxFit.fitWidth),
//                                   color: Color(0xFF333366),
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   boxShadow: <BoxShadow>[
//                                     BoxShadow(
//                                       color: Colors.black,
//                                       blurRadius: 2.0,
//                                       spreadRadius: 0.0,
//                                       offset: Offset(2.0, 2.0),
//                                     )
//                                   ],
//                                 ),
//                               )),
//                         ],
//                       ),
//                       Row(
//                         children: <Widget>[
//                           InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => Itdept()));
//                               },
//                               child: Container(
//                                 height: 115.0,
//                                 width: (MediaQuery.of(context).size.width / 2) -
//                                     32.0,
//                                 margin: EdgeInsets.only(
//                                     left: 10.0,
//                                     right: 5.0,
//                                     top: 5.0,
//                                     bottom: 5.0),
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Expanded(
//                                         flex: 8,
//                                         child: Padding(
//                                           padding: EdgeInsets.only(top: 30.0),
//                                           child: Icon(Icons.people,
//                                               size: 30.0, color: Colors.white),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         flex: 2,
//                                         child: Text(
//                                           'IT DEPT',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 14.0,
//                                               fontWeight: FontWeight.bold),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: AssetImage(""), fit: BoxFit.cover),
//                                   color: Color(0xFF333366),
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   boxShadow: <BoxShadow>[
//                                     BoxShadow(
//                                       color: Colors.black,
//                                       blurRadius: 2.0,
//                                       spreadRadius: 0.0,
//                                       offset: Offset(2.0, 2.0),
//                                     )
//                                   ],
//                                 ),
//                               )),
//                         ],
//                       ),
//                       Row(
//                         children: <Widget>[
//                           InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => Ecedept()));
//                               },
//                               child: Container(
//                                 height: 115.0,
//                                 width: (MediaQuery.of(context).size.width / 2) -
//                                     32.0,
//                                 margin: EdgeInsets.only(
//                                     left: 10.0,
//                                     right: 5.0,
//                                     top: 5.0,
//                                     bottom: 5.0),
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Expanded(
//                                         flex: 8,
//                                         child: Padding(
//                                           padding: EdgeInsets.only(top: 30.0),
//                                           child: Icon(Icons.people,
//                                               size: 30.0, color: Colors.white),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         flex: 2,
//                                         child: Text(
//                                           'ECE DEPT',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 14.0,
//                                               fontWeight: FontWeight.bold),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: AssetImage(""), fit: BoxFit.cover),
//                                   color: Color(0xFF333366),
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   boxShadow: <BoxShadow>[
//                                     BoxShadow(
//                                       color: Colors.black,
//                                       blurRadius: 2.0,
//                                       spreadRadius: 0.0,
//                                       offset: Offset(2.0, 2.0),
//                                     )
//                                   ],
//                                 ),
//                               )),
//                         ],
//                       ),
//                       Row(
//                         children: <Widget>[
//                           InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => Civildept()));
//                               },
//                               child: Container(
//                                 height: 115.0,
//                                 width: (MediaQuery.of(context).size.width / 2) -
//                                     32.0,
//                                 margin: EdgeInsets.only(
//                                     left: 10.0,
//                                     right: 5.0,
//                                     top: 5.0,
//                                     bottom: 5.0),
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Expanded(
//                                         flex: 8,
//                                         child: Padding(
//                                           padding: EdgeInsets.only(top: 30.0),
//                                           child: Icon(Icons.people,
//                                               size: 30.0, color: Colors.white),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         flex: 2,
//                                         child: Text(
//                                           'CIVIL DEPT',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 14.0,
//                                               fontWeight: FontWeight.bold),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: AssetImage(""), fit: BoxFit.cover),
//                                   color: Color(0xFF333366),
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   boxShadow: <BoxShadow>[
//                                     BoxShadow(
//                                       color: Colors.black,
//                                       blurRadius: 2.0,
//                                       spreadRadius: 0.0,
//                                       offset: Offset(2.0, 2.0),
//                                     )
//                                   ],
//                                 ),
//                               )),
//                         ],
//                       ),
//                       Row(
//                         children: <Widget>[
//                           InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => Mechdept()));
//                               },
//                               child: Container(
//                                 height: 115.0,
//                                 width: (MediaQuery.of(context).size.width / 2) -
//                                     32.0,
//                                 margin: EdgeInsets.only(
//                                     left: 10.0,
//                                     right: 5.0,
//                                     top: 5.0,
//                                     bottom: 5.0),
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Expanded(
//                                         flex: 8,
//                                         child: Padding(
//                                           padding: EdgeInsets.only(top: 30.0),
//                                           child: Icon(Icons.people,
//                                               size: 30.0, color: Colors.white),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         flex: 2,
//                                         child: Text(
//                                           'MECH DEPT',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 14.0,
//                                               fontWeight: FontWeight.bold),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: AssetImage(""), fit: BoxFit.cover),
//                                   color: Color(0xFF333366),
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   boxShadow: <BoxShadow>[
//                                     BoxShadow(
//                                       color: Colors.black,
//                                       blurRadius: 2.0,
//                                       spreadRadius: 0.0,
//                                       offset: Offset(2.0, 2.0),
//                                     )
//                                   ],
//                                 ),
//                               )),
//                         ],
//                       ),
//                       Row(
//                         children: <Widget>[
//                           InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => AiDsdept()));
//                               },
//                               child: Container(
//                                 height: 115.0,
//                                 width: (MediaQuery.of(context).size.width / 2) -
//                                     32.0,
//                                 margin: EdgeInsets.only(
//                                     left: 10.0,
//                                     right: 5.0,
//                                     top: 5.0,
//                                     bottom: 5.0),
//                                 child: Align(
//                                   alignment: Alignment.center,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Expanded(
//                                         flex: 8,
//                                         child: Padding(
//                                           padding: EdgeInsets.only(top: 30.0),
//                                           child: Icon(Icons.people,
//                                               size: 30.0, color: Colors.white),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         flex: 2,
//                                         child: Text(
//                                           'AI&DS DEPT',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 14.0,
//                                               fontWeight: FontWeight.bold),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image: AssetImage(""), fit: BoxFit.cover),
//                                   color: Color(0xFF333366),
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   boxShadow: <BoxShadow>[
//                                     BoxShadow(
//                                       color: Colors.black,
//                                       blurRadius: 2.0,
//                                       spreadRadius: 0.0,
//                                       offset: Offset(2.0, 2.0),
//                                     )
//                                   ],
//                                 ),
//                               )),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SliverList(
//                   // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   //     crossAxisCount: 1),
//                   delegate: SliverChildListDelegate(
//                     [
//                       // Padding(
//                       //     padding: EdgeInsets.symmetric(
//                       //         vertical: 16.0, horizontal: 24.0)),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => FoodPage()));
//                               },
//                               child: Container(
//                                 height: 100.0,
//                                 width: MediaQuery.of(context).size.width - 32.0,
//                                 child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Container(height: 4.0),
//                                       Text("Food details".toUpperCase(),
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontFamily: 'Poppins',
//                                               fontSize: 25.0,
//                                               fontWeight: FontWeight.w600)),
//                                       Container(height: 10.0),
//                                     ]),
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                       image:
//                                           AssetImage("assets/fooddesign.png"),
//                                       fit: BoxFit.cover),
//                                   color: Color(0xFF333366),
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   boxShadow: <BoxShadow>[
//                                     BoxShadow(
//                                       color: Colors.black12,
//                                       blurRadius: 10.0,
//                                       offset: Offset(0.0, 10.0),
//                                     ),
//                                   ],
//                                 ),
//                               )),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           )),
//     );
//   }

//   Widget studentlist() {
//     return SingleChildScrollView(
//         child: Container(
//             height: 600.0,
//             child: Card(
//               child: GridView.count(
//                 scrollDirection: Axis.vertical,
//                 crossAxisCount: 2,
//                 children: <Widget>[
//                   Card(
//                     color: Color(0xff0ff24b),
//                     elevation: 6,
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.push(context,
//                             MaterialPageRoute(builder: (context) => Csedept()));
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             SizedBox(height: 18.0),
//                             Text(
//                               'CSE Student',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontSize: 24, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Card(
//                     color: Color(0xff0ff24b),
//                     elevation: 6,
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.push(context,
//                             MaterialPageRoute(builder: (context) => Itdept()));
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             SizedBox(height: 18.0),
//                             Text(
//                               'IT Student',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontSize: 24, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Card(
//                     color: Color(0xff0ff24b),
//                     elevation: 6,
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.push(context,
//                             MaterialPageRoute(builder: (context) => Ecedept()));
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             SizedBox(height: 18.0),
//                             Text(
//                               'ECE Student',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontSize: 24, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Card(
//                     color: Color(0xff0ff24b),
//                     elevation: 6,
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => Mechdept()));
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             SizedBox(height: 18.0),
//                             Text(
//                               'MECH Student',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontSize: 24, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Card(
//                     color: Color(0xff0ff24b),
//                     elevation: 6,
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => Civildept()));
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             SizedBox(height: 18.0),
//                             Text(
//                               'CIVIL Student',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontSize: 24, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             )));
//   }

//   Widget foodfirebase() {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => AddScreen(),
//             ),
//           );
//         },
//         backgroundColor: Color(0xff028090),
//         child: Icon(
//           Icons.add,
//           color: Colors.white,
//           size: 32,
//         ),
//       ),
//       body: SafeArea(
//         child: ItemList(),
//       ),
//     );
//   }

//   Widget outpassfirebase() {
//     return Container(
//         height: 200.0,
//         child: Card(
//           child: GridView.count(
//             scrollDirection: Axis.vertical,
//             crossAxisCount: 2,
//             children: <Widget>[
//               Card(
//                 color: Color(0xfffa3434),
//                 elevation: 6,
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => OutpassPending()));
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         SizedBox(height: 18.0),
//                         Text(
//                           'Outpass \n Pending',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Card(
//                 elevation: 6,
//                 color: Color(0xff0ff24b),
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => OutpassApproved()));
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         SizedBox(height: 18.0),
//                         Text(
//                           'Outpass \n Approved',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }

//   Widget issues() {
//     return Container(
//         height: 200.0,
//         child: Card(
//           child: GridView.count(
//             scrollDirection: Axis.vertical,
//             crossAxisCount: 2,
//             children: <Widget>[
//               Card(
//                 color: Color(0xfffa3434),
//                 elevation: 6,
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => Pending()));
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         SizedBox(height: 18.0),
//                         Text(
//                           'Issues \n Pending',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Card(
//                 elevation: 6,
//                 color: Color(0xff0ff24b),
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => Solved()));
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         SizedBox(height: 18.0),
//                         Text(
//                           'Issues \n Solved',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }

//   void onDataAdded(Event event) {
//     setState(() {
//       complaintList.add(Complaints.fromSnapshot(event.snapshot));
//     });
//   }
// }
