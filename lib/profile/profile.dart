import 'package:flutter/material.dart';
import 'infocard.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

const url = 'admin.com';
const email = 'admin@gmail.com';
const phone = '+91 987 654 32 10';
const location = 'coimbatore, TamilNadu';

class Profile extends StatelessWidget {

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
      backgroundColor: Colors.blueGrey[800],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/dp.jpg'),
            ),
            Text(
              'Admin',
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Pacifico',
              ),
            ),
            Text(
              'Passionate Learner',
              style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.blueGrey[200],
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Source Sans Pro'),
            ),
            SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.white,
              ),
            ),
            InfoCard(
              text: phone,
              icon: Icons.phone,
              onPressed: () async {
                String removeSpaceFromPhoneNumber =
                    phone.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
                final phoneCall = 'tel:$removeSpaceFromPhoneNumber';

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
              text: email,
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
              text: url,
              icon: Icons.web,
              onPressed: () async {
                if (await launcher.canLaunch(url)) {
                  await launcher.launch(url);
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
      ),
    );
  }
}