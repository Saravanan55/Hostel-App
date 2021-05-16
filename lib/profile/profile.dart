import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:hostel/model/complaints.dart';
import 'package:hostel/ui/ComplaintDetails.dart';
import '../login.dart';
import 'infocard.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{
//final url = 'admin.com';
// final email = 'admin@gmail.com';
//final phone = '+91 987 654 32 10';
final location = 'coimbatore, TamilNadu';
FirebaseUser currentUser;
List<Complaints> complaintList = List();
//final Firestore _firestore = Firestore.instance;
DatabaseReference databaseReference;
Map<dynamic, dynamic> data;
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

void initState() {
    super.initState();
    this.getCurrentUser();
    databaseReference = database.reference();
    databaseReference.onChildAdded.listen(onDataAdded);
}
 void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }
  void _showDialog(BuildContext context, {String title, String msg}) {
    final Dialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: <Widget>[
        RaisedButton(
          color: Colors.teal,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Close',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        )
      ],
    );
    showDialog(context: context, builder: (x) =>  Dialog);
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
               // CommonData.clearLoggedInUserData();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            )
          ],
        ),

          body: new Column(
        children: <Widget>[
          new Flexible(
            child: new FirebaseAnimatedList(
                query: databaseReference
                    .child('users')
                    .orderByChild("email")
                    .equalTo(currentUser.email),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  data = snapshot.value;
                  data['key'] = snapshot.key;
                  return ProfileCard(
                    data['email'],
                    data['mobile'],
                    data['name'],
                    data['usn'],
                    data['block'],
                    data['room']
                  );                
                }),),
        ],
          ),
        ));
  }
   Widget ProfileCard(String email,String number,String name,String usn,String block,String room){
    return Container(
    
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: 10,
            ),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/dp.jpg'),
            ),
            Text(
              '$name',
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Pacifico',
              ),
            ),
            SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.white,
              ),
            ),
             InfoCard(
              text:  email!=null? email : 'loading...',
              icon: Icons.email,
              onPressed: () async {
                final emailAddress = 'mailto:$email';
                if (await launcher.canLaunch(emailAddress)) {
                  await launcher.launch(emailAddress);
                } else {
                  _showDialog(
                    context,
                    title: 'Sorry',
                    msg: 'please try again ',
                  );
                }
              },
            ),
            InfoCard(
              text: number!=null? number : 'loading...',
              icon: Icons.phone,
              onPressed: () async {
                  final phoneCall = number;
                if (await launcher.canLaunch(phoneCall)) {
                  await launcher.launch(phoneCall);
                } else {
                  _showDialog(
                    context,
                    title: 'Sorry',
                    msg: 'please try again ',
                  );
                }
              },
            ),
            InfoCard(
              text: name!=null ? name : 'loading...',
              icon: Icons.web,
              onPressed: () async {
                if (await launcher.canLaunch(name)) {
                  await launcher.launch(name);
                } else {
                  _showDialog(
                    context,
                    title: 'Sorry',
                    msg: 'please try again ',
                  );
                }
              },
            ),
            InfoCard(
              text: location,
              icon: Icons.location_city,
              onPressed: () {
                print('location');
              },
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

