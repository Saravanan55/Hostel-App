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
  bool validateblock = false;
  bool validateroom = false;
  Future<void> updatedata() async {
    Map<String, dynamic> data = <String, dynamic>{
      "block": blockController.text,
      "room": roomController.text
    };
    // Firestore.instance
    //     .collection("users")
    //     .document(('${widget.email}'))
    //     .setData({
    //   "block": "${blockController.text}",
    //   "room": "${roomController.text}",
    //   });
    // FirebaseDatabase.instance.reference().child("users").push().set({
    //   "block": "${blockController.text}",
    //   "room": "${roomController.text}",
    //  });
    FirebaseDatabase.instance
        .reference()
        .child("users")
        .child('${widget.docId}')
        .update(data);
    Navigator.of(context).pop();
  }

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

  userEditBottomSheet(BuildContext context) {
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
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Update Profile",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                                      ? validateblock = true
                                      : validateblock = false;
                                });
                              },
                              controller: blockController,
                              decoration: InputDecoration(
                                errorText: validateblock
                                    ? "Block no can\'t be empty"
                                    : null,
                                border: OutlineInputBorder(),
                                labelText: 'Block No',
                                hintText: 'Enter Block No',
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
                            padding: const EdgeInsets.all(15.0),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  value.isEmpty
                                      ? validateroom = true
                                      : validateroom = false;
                                });
                              },
                              maxLength: 10,
                              controller: roomController,
                              decoration: InputDecoration(
                                errorText: validateroom
                                    ? "Room no can\'t be empty"
                                    : null,
                                border: OutlineInputBorder(),
                                labelText: 'Room No',
                                hintText: 'Enter Room No',
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
                              blockController.text.isEmpty
                                  ? validateblock = true
                                  : validateblock = false;
                              roomController.text.isEmpty
                                  ? validateroom = true
                                  : validateroom = false;
                            });
                            if (!(validateblock && validateroom)) {
                              updatedata();
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
  }

  Future deleteUser(String docId) async {
    FirebaseDatabase.instance.reference().child("users").child(docId).remove();
    Firestore.instance.collection('users').document('${widget.email}').delete();
  }
}
