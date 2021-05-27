import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hostel/model/complaints.dart';
import 'package:hostel/ui/ComplaintDetails.dart';
import 'package:image_picker/image_picker.dart';
import 'infocard.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseUser currentUser;
  List<Complaints> complaintList = List();
  DatabaseReference databaseReference;
  Map<dynamic, dynamic> data;
  File sampleImage;
  String filename;
  String random;
  DataSnapshot snapshot;
  String key;
  bool validatenumber = false;
  TextEditingController numberController = TextEditingController();
  void initState() {
    super.initState();
    this.getCurrentUser();
    databaseReference = database.reference();
    databaseReference.onChildAdded.listen(onDataAdded);
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  Future getImage(String key) async {
    File tempImage = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );
    setState(() {
//        if(sampleImage==null)
//           sampleImage= File("assets/image_02.png");
      sampleImage = tempImage;
      filename = sampleImage.toString();
    });
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('$random');
    final StorageUploadTask task = firebaseStorageRef.putFile(sampleImage);
    var downUrl = await (await task.onComplete).ref.getDownloadURL();
    String url = downUrl.toString();
    Map<String, dynamic> data = <String, dynamic>{
      "url": url,
    };
    FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(key)
        .update(data);
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
    showDialog(context: context, builder: (x) => Dialog);
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
                    data['key'].toString(),
                    data['email'],
                    data['mobile'],
                    data['name'],
                    data['usn'],
                    data['block'],
                    data['room'],
                    data['url'],
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget ProfileCard(String key, String email, String number, String name,
      String usn, String block, String room, String url) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 115,
            width: 115,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                CircleAvatar(
                  radius: 50,
                  child: new Container(
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: new NetworkImage('$url')))),
                ),
                Positioned(
                  right: -16,
                  bottom: 0,
                  child: SizedBox(
                    height: 46,
                    width: 46,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Colors.white),
                      ),
                      color: Color(0xFFF5F6F9),
                      onPressed: () => getImage(key),
                      child: SvgPicture.asset("assets/Camera Icon.svg"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
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
            text: email != null ? email : 'loading...',
            icon: Icons.email,
            onPressed: () async {},
          ),
          InfoCard(
            text: usn != null ? usn : 'loading...',
            icon: Icons.format_list_numbered,
            onPressed: () async {},
          ),
          InfoCard(
            text: number != null ? number : 'loading...',
            icon: Icons.call,
            onPressed: () async {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: Material(
                        type: MaterialType.transparency,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(15),
                          height: 300,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: ListView(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Change Number",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(Icons.cancel),
                                    color: Colors.orange,
                                    iconSize: 25,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            value.isEmpty
                                                ? validatenumber = true
                                                : validatenumber = false;
                                          });
                                        },
                                        maxLength: 10,
                                        controller: numberController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          errorText: validatenumber
                                              ? "Number no can\'t be empty"
                                              : null,
                                          border: OutlineInputBorder(),
                                          labelText: 'Number',
                                          hintText: 'Enter your Number',
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RaisedButton(
                                    child: Text('Update'),
                                    color: Colors.green,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        numberController.text.isEmpty
                                            ? validatenumber = true
                                            : validatenumber = false;
                                      });
                                      if (!(validatenumber)) {
                                        FirebaseDatabase.instance
                                            .reference()
                                            .child("users")
                                            .child('$key')
                                            .update({
                                          "mobile": numberController.text
                                        });
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
          ),
          InfoCard(
            text: block != null ? block : 'loading...',
            icon: Icons.apartment,
            onPressed: () async {},
          ),
          InfoCard(
            text: room != null ? room : 'loading...',
            icon: Icons.room,
            onPressed: () async {},
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
