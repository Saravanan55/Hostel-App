import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'profile_menu.dart';

class Body extends StatefulWidget {
  String docId, email, name, usn, phone, block, room, dept, url;
  Body(this.docId, this.email, this.name, this.usn, this.phone, this.block,
      this.room, this.dept, this.url);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _isDeleting = false;
  bool _isEdit = false;
  TextEditingController blockController = TextEditingController();
  TextEditingController roomController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.redAccent,
              size: 32,
            ),
            onPressed: () {
              setState(() {
                _isEdit = true;
              });
              userEditBottomSheet(context);
              setState(() {
                _isEdit = false;
              });
            },
          ),
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
              press: () => {},
            ),
            ProfileMenu(
              text: "Name : ${widget.name}",
              icon: Icon(Icons.arrow_forward_ios),
              press: () {},
            ),
            ProfileMenu(
              text: "Roll No :${widget.usn}",
              press: () {},
            ),
            ProfileMenu(
              text: "Dept:${widget.dept}",
              press: () {},
            ),
            ProfileMenu(
              text: "Mobile : ${widget.phone}",
              press: () {},
            ),
            ProfileMenu(
              text: "Block : ${widget.block}",
              press: () {},
            ),
            ProfileMenu(
              text: "Room No :${widget.room}",
              press: () {},
            ),
          ],
        ),
      ),
    );
  }

  void userEditBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * .60,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15.0),
            child: ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Update Profile"),
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
                        padding: const EdgeInsets.only(right: 15.0),
                        child: TextField(
                          controller: blockController,
                          decoration: InputDecoration(
                            helperText: "Block No",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: TextField(
                          controller: roomController,
                          decoration: InputDecoration(
                            helperText: "Room No",
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
                        Map<String, dynamic> data = <String, dynamic>{
                          "block": blockController.text,
                          "room": roomController.text
                        };
                        FirebaseDatabase.instance
                            .reference()
                            .child("users")
                            .child('${widget.docId}')
                            .update(data);
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future deleteUser(String docId) async {
    FirebaseDatabase.instance.reference().child("users").child(docId).remove();
    Firestore.instance.collection('users').document('${widget.email}').delete();
  }
}
