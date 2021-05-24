import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'profile_menu.dart';

class Body extends StatefulWidget {
  String docId, email, name, usn, phone, block, room, url;
  Body(this.docId, this.email, this.name, this.usn, this.phone, this.block,
      this.room, this.url);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          _isDeleting
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                    right: 16.0,
                  ),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.redAccent,
                    ),
                    strokeWidth: 3,
                  ),
                )
              : IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                    size: 32,
                  ),
                  onPressed: () async {
                    setState(() {
                      _isDeleting = true;
                    });

                    deleteUser('${widget.docId}');

                    setState(() {
                      _isDeleting = false;
                    });

                    Navigator.of(context).pop();
                  },
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            SizedBox(
              height: 115,
              width: 115,
              child: Stack(
                fit: StackFit.expand,
                overflow: Overflow.visible,
                children: [
                  CircleAvatar(
                    radius: 50,
                    child: new Container(
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: new NetworkImage('${widget.url}')))),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ProfileMenu(
              text: "Email : ${widget.email}",
              // icon: "assets/icons/User Icon.svg",y
              press: () => {},
            ),
            ProfileMenu(
              text: "Name : ${widget.name}",
              // icon: "assets/icons/Bell.svg",
              icon: Icon(Icons.arrow_forward_ios),
              press: () {},
            ),
            ProfileMenu(
              text: "Roll No :${widget.usn}",
              // icon: "assets/icons/Settings.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Mobile : ${widget.phone}",
              // icon: "assets/icons/Question mark.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Block : ${widget.block}",
              // icon: "assets/icons/Log out.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Room No :${widget.room}",
              // icon: "assets/icons/Log out.svg",
              press: () {},
            ),
          ],
        ),
      ),
    );
  }

  Future deleteUser(String docId) async {
    FirebaseDatabase.instance.reference().child("users").child(docId).remove();
    Firestore.instance.collection('users').document('${widget.email}').delete();
  }
}
