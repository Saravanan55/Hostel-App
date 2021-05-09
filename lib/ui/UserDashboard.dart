import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hostel/login.dart';
import 'package:hostel/model/complaints.dart';
import 'package:hostel/ui/ComplaintDetails.dart';
import 'package:hostel/ui/product_fab.dart';
import 'package:hostel/utils/CommonData.dart';
import 'food_list.dart';

class UserDashboard extends StatefulWidget {
  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard>
    with TickerProviderStateMixin {
  List<Complaints> complaintList = List();
  List<Tab> tabBarViews;
  Map<dynamic, dynamic> data;
  String name;
  String userId = '';
  Complaints complaint;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference;
  TabController tabBarController;
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

    complaint = Complaints("", "", "", "");
    databaseReference = database.reference();
    databaseReference.onChildAdded.listen(onDataAdded);

    tabBarController =
        new TabController(length: 2, vsync: this, initialIndex: 0);
    //  tabBarViews = [firebaseList("general"), firebaseList1("Student")];
  }

  static const textStyle = TextStyle(
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // floatingActionButton: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: <Widget>[
        //     FloatingActionButton(
        //       tooltip: 'Add a Complaint',
        //       backgroundColor: Color(0xff028090),
        //       onPressed: () {
        //         Navigator.push(
        //             context, MaterialPageRoute(builder: (context) => MyForm()));
        //       },
        //       child: Icon(
        //         Icons.edit,
        //         color: Colors.white,
        //       ),
        //     ),

        //     // floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        //     FloatingActionButton(
        //       tooltip: 'Add a Complaint',
        //       backgroundColor: Color(0xff028090),
        //       onPressed: () {
        //         Navigator.push(
        //             context, MaterialPageRoute(builder: (context) => MyForm()));
        //       },
        //       child: Icon(
        //         Icons.article,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ],
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: ProductFAB(),
        // floatingActionButton: FloatingActionButton(
        //   tooltip: 'Add a Complaint',
        //   backgroundColor: Color(0xff028090),
        //   onPressed: () {
        //     Navigator.push(
        //         context, MaterialPageRoute(builder: (context) => ProductFAB()));
        //   },
        //   child: Icon(
        //     Icons.edit,
        //     color: Colors.white,
        //   ),
        // ),
        // floatingActionButton: FloatingActionButton(
        //   tooltip: 'Add a Complaint',
        //   backgroundColor: Color(0xff028090),
        //   onPressed: () {
        //     Navigator.push(
        //         context, MaterialPageRoute(builder: (context) => MyForm()));
        //   },
        //   child: Icon(
        //     Icons.edit,
        //     color: Colors.white,
        //   ),
        // ),
        //),
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
          title: Text(' Dashboard'),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            controller: tabBarController,
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.0, color: Colors.white),
                insets: EdgeInsets.symmetric(horizontal: 0.0)),
            //indicatorSize: TabBarIndicatorSize.tab,
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
//          indicatorColor: Colors.blue,
//          labelColor: Colors.white,
//          unselectedLabelColor: Colors.white,
            tabs: <Widget>[
              Tab(
                child: Text('Complaint'),
              ),
              Tab(
                child: Text('Food'),
              ),
              // Tab(
              //   child: Text('Civil'),
              // ),
              // Tab(
              //   child: Text('Sanitation'),
              // ),
              // Tab(
              //   child: Text('Food'),
              // ),
            ],
          ),
        ),
        body: Container(
          child: TabBarView(
            controller: tabBarController,
            children: <Widget>[
              firebaseList('Electrical'),
              firebasefood(),
              //   // firebaseList('Sanitation'),
              //   // firebaseList('Food'),
            ],
            //  children: firebaseList1("General"),
          ),
        ),
      ),
    );
  }

  Widget firebaseList(String complaintType) {
    return FirebaseAnimatedList(
        defaultChild: shimmers(),
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
              0,
              data['key']);
          // else
          //   return Container();
        });
  }

  Widget firebasefood() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: FoodItemList(),
        ),
      ),
    );
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
//    else
//      return Container();
  }
// -------------------------------------------------
  // Future<Widget> firebaseList1(String complaintType) async {
  //   final FirebaseUser user = await auth.currentUser();
  //   final uid = user.uid;
  //   return FirebaseAnimatedList(
  //       defaultChild: shimmers(), //Center(child: CircularProgressIndicator()),
  //       query: databaseReference.child('hostel'),
  //       itemBuilder: (BuildContext context, DataSnapshot snapshot,
  //           Animation<double> animation, int index) {
  //         data = snapshot.value;
  //         data['key'] = snapshot.key;
  //         print('${data['name']}');
  //         //  if (complaintType == data['category'])
  //         return eventCard(
  //             data["name"],
  //             data["detail"],
  //             data['phone'],
  //             data['url'],
  //             data["status"],
  //             data['id'],
  //             data['category'],
  //             complaintType,
  //             0,
  //             data['key']);
  //         // else
  //         //   return Container();
  //       });
  // }

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
//        child: Column(
//          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.only(bottom: 8.0),
//              child: Row(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: [
//                  Container(
//                    width: 48.0,
//                    height: 48.0,
//                    color: Colors.white,
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                  ),
//                  Expanded(
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: [
//                        Container(
//                          width: double.infinity,
//                          height: 8.0,
//                          color: Colors.white,
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.symmetric(vertical: 2.0),
//                        ),
//                        Container(
//                          width: double.infinity,
//                          height: 8.0,
//                          color: Colors.white,
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.symmetric(vertical: 2.0),
//                        ),
//                        Container(
//                          width: 40.0,
//                          height: 8.0,
//                          color: Colors.white,
//                        ),
//                      ],
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
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

class _DemoBottomAppBar extends StatelessWidget {
  const _DemoBottomAppBar({
    this.color,
    this.fabLocation,
    this.shape,
  });

  final Color color;
  final FloatingActionButtonLocation fabLocation;
  final NotchedShape shape;

  static final List<FloatingActionButtonLocation> kCenterLocations =
      <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: color,
      shape: shape,
      child: Row(children: <Widget>[
        if (kCenterLocations.contains(fabLocation))
          const Expanded(child: SizedBox()),
        IconButton(
          icon: const Icon(
            Icons.search,
            semanticLabel: 'show search action',
          ),
          onPressed: () {
            Scaffold.of(context).showSnackBar(
              const SnackBar(content: Text('This is a dummy search action.')),
            );
          },
        ),
      ]),
    );
  }
}
