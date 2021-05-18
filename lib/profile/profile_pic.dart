import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hostel/model/complaints.dart';
import 'package:hostel/ui/ComplaintDetails.dart';
import 'package:image_picker/image_picker.dart';

import 'database.dart';
class ProfilePic extends StatefulWidget {
  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  File sampleImage;
  String filename;
  String random;
  FirebaseUser currentUser;
  List<Complaints> complaintList = List();
  DatabaseReference databaseReference;
  DataSnapshot snapshot;
  var url;
  // const ProfilePic({
  //   Key key,
  // }) : super(key: key);
  void initState() {
    super.initState();
    this.getCurrentUser();
    databaseReference = database.reference();
    databaseReference.onChildAdded.listen(onDataAdded);
}
void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }
   Future getImage() async {
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
    url = downUrl.toString();
    Map<String, dynamic> data = <String, dynamic>{
      "url": url,
    };
    Firestore.instance.collection('users').document(currentUser.email).updateData(data); 
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Database.readItems(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.hasData || snapshot.data != null) {
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 16.0),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              String docID = snapshot.data.documents[index].documentID;
              String url = snapshot.data.documents[index].data['url'];

    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          CircleAvatar(
              radius: 50,
          //     backgroundColor: DecorationImage(
          //   image: AssetImage("assets/images/bulb.jpg"),
          //   fit: BoxFit.cover,
          // ),
              child:Image.network(url,fit:BoxFit.cover,),
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
                onPressed: getImage,
                child: SvgPicture.asset("assets/Camera Icon.svg"),
              ),
            ),
          ),
        ],
      ),
    );
  }); }
  });
}
  void onDataAdded(Event event) {
    setState(() {
      complaintList.add(Complaints.fromSnapshot(event.snapshot));
    });
  }
  //  Future<String> uploadImage() async {
  //   // print('\n\n$filename\n\n');
  //   final StorageReference firebaseStorageRef =
  //       FirebaseStorage.instance.ref().child('$random');
  //   final StorageUploadTask task = firebaseStorageRef.putFile(sampleImage);
  //   var downUrl = await (await task.onComplete).ref.getDownloadURL();
  //   url = downUrl.toString();
  //   return url;
  // }
}