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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
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
}
