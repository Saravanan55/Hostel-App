import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:hostel/ui/outpassDetails.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hostel/model/complaints.dart';

class OutpassPending extends StatefulWidget {
  @override
  _OutpassPendingState createState() => _OutpassPendingState();
}

class _OutpassPendingState extends State<OutpassPending>
    with TickerProviderStateMixin {
  List<Complaints> complaintList = List();
  List<Tab> tabBarViews;
  Map<dynamic, dynamic> data;
  String name;
  Complaints complaint;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();
    complaint = Complaints("", "", "", "", "");
    databaseReference = database.reference();
    databaseReference.onChildAdded.listen(onDataAdded);
  }

  static const textStyle = TextStyle(
    fontSize: 16,
  );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Outpass Pending'),
        ),
        body: Container(
            child: new FirebaseAnimatedList(
                defaultChild: shimmers(),
                query: databaseReference
                    .child('outpass')
                    .orderByChild('status')
                    .equalTo('Pending'),
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
                })));
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
