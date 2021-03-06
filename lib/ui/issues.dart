import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:hostel/model/complaints.dart';
import 'package:hostel/ui/ComplaintDetails.dart';
import 'package:hostel/ui/complaintform.dart';
import 'package:shimmer/shimmer.dart';

class Issues extends StatefulWidget {
  @override
  _IssuesState createState() => _IssuesState();
}

class _IssuesState extends State<Issues> {
  List<Complaints> complaintList = [];
  List<Tab> tabBarViews;
  Map<dynamic, dynamic> data;
  String name;
  String userId = '';
  Complaints complaint;
  final FirebaseDatabase database = FirebaseDatabase.instance;
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
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff8096ed),
        title: Text('Hostel Issues'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 200.0,
              child: firebaseList("issues"),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xff8096ed),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyForm()));
          setState(() {});
        },
      ),
    );
  }

  static const textStyle = TextStyle(
    fontSize: 16,
  );
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
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
