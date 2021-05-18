import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:hostel/model/complaints.dart';
import 'package:hostel/profile/profile_pic.dart';
import 'package:hostel/ui/ComplaintDetails.dart';
import 'package:hostel/ui/food/database.dart';
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
// void updateItem({String docID,String url}) async {
//     final CollectionReference _mainCollection = Firestore.instance.collection('users');
//      DocumentReference documentReferencer = _mainCollection.document(docID);

//     Map<String, dynamic> data = <String, dynamic>{
//       "url": url,
//     };
//     await documentReferencer
//         .updateData(data)
//         .whenComplete(() => print("Note item updated in the database"))
//         .catchError((e) => print(e));
//   }
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
      //        new StreamBuilder<QuerySnapshot>(
      // stream: Database.readItems(),
      // builder: (context, snapshot) {
      //   if (snapshot.hasError) {
      //     return Text('Something went wrong');
      //   }
      //    else if (snapshot.hasData || snapshot.data != null) {
      //     return ListView.separated(
      //       separatorBuilder: (context, index) => SizedBox(height: 16.0),
      //       itemCount: snapshot.data.documents.length,
      //       itemBuilder: (context, index) {
      //         String docID = snapshot.data.documents[index].documentID;
      //         String email=snapshot.data.documents[index].documentID;
      //         String mobile=snapshot.data.documents[index].data['mobile'];
      //         String name=snapshot.data.documents[index].data['name'];
      //         String usn=snapshot.data.documents[index].data['usn'];
      //         String block=snapshot.data.documents[index].data['block'];
      //         String room=snapshot.data.documents[index].data['room'];
      //         String url=snapshot.data.documents[index].data['url'];
      //         return ProfileCard(docID,email, mobile, name, usn, block, room,url);

              
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
                }),
               ),
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

