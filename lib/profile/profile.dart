import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:hostel/model/complaints.dart';
import 'package:hostel/profile/profile_pic.dart';
import 'package:hostel/ui/ComplaintDetails.dart';
import 'package:hostel/utils/CommonData.dart';
import 'infocard.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{
FirebaseUser currentUser;
List<Complaints> complaintList = List();
DatabaseReference databaseReference;
Map<dynamic, dynamic> data;

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
         return Scaffold(
         appBar: AppBar(
            backgroundColor: Color(0xff028090),
            title: Text('Profile Page'),
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
        );
  }
   Widget ProfileCard(String email,String number,String name,String usn,String block,String room){
    return Container(
    
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: 10,
            ),
            ProfilePic(),
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
              text: usn!=null ? usn : 'loading...',
              icon: Icons.format_list_numbered,
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
              text: number!=null ? number : 'loading...',
              icon: Icons.call,
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
              text: block!=null? block : 'loading...',
              icon: Icons.apartment,
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
              text: room!=null ? room : 'loading...',
              icon: Icons.room,
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

