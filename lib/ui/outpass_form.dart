import 'dart:io';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hostel/utils/Constants.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;
final Firestore store = Firestore.instance;

class OutpassForm extends StatefulWidget {
  OutpassForm({Key key, this.uid}) : super(key: key);
  final String uid;
  @override
  _OutpassFormState createState() => _OutpassFormState();
}

class _OutpassFormState extends State<OutpassForm> {
  File sampleImage;
  String filename;
  bool validateOutDate = false;
  bool validateInDate = false;
  bool validateDepTime = false;
  bool validateInTime = false;
  bool validateAddress = false;
  bool validateReason = false;
  String _name, _mobile, _block, _room;
  FirebaseUser currentUser;
  // final ImagePicker picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    this.getCurrentUser();
    shared();
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  shared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = (prefs.getString(Constants.loggedInUserName));
      _mobile = (prefs.getString(Constants.loggedInUserMobile));
      _block = (prefs.getString(Constants.loggedInUserBlock));
      _room = (prefs.getString(Constants.loggedInUserRoom));
    });
  }

  bool validateName = true;
  bool validateNumber = true;

  // Future getImage() async {
  //   final tempImage = await picker.getImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 40,
  //   );
  //   setState(() {
  //     sampleImage = tempImage as File;
  //     filename = sampleImage.toString();
  //   });
  // }

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController outpassInDate = TextEditingController();
  TextEditingController outpassOutDate = TextEditingController();
  TextEditingController outpassDepTimeController = TextEditingController();
  TextEditingController outpassInTimeController = TextEditingController();
  TextEditingController outpassAddressController = TextEditingController();
  TextEditingController outpassReason = TextEditingController();

  bool saving = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff7f84fa),
        title: Text('Create Outpass'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: saving,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: ListView(
            children: <Widget>[
              new TextField(
                readOnly: true,
                onChanged: (value) {
                  setState(() {
                    value.isEmpty
                        ? validateOutDate = true
                        : validateOutDate = false;
                  });
                },
                decoration: InputDecoration(
                  errorText:
                      validateOutDate ? "Out Date can\'t be empty" : null,
                  icon: const Icon(Icons.calendar_today),
                  hintText: 'Enter the out date',
                  labelText: 'Out Date',
                ),
                // keyboardType: TextInputType.datetime,
                onTap: () async {
                  var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));
                  outpassOutDate.text = date.toString().substring(0, 10);
                },

                controller: outpassOutDate,
              ),
              ////////////////////////////////////////
              new TextField(
                readOnly: true,
                decoration: InputDecoration(
                  errorText: validateInDate ? "In Date can\'t be empty" : null,
                  icon: const Icon(Icons.calendar_today),
                  hintText: 'Enter the in date',
                  labelText: 'In Date',
                ),
                // keyboardType: TextInputType.datetime,
                onTap: () async {
                  var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));
                  outpassInDate.text = date.toString().substring(0, 10);
                },
                onChanged: (value) {
                  setState(() {
                    value.isEmpty
                        ? validateInDate = true
                        : validateInDate = false;
                  });
                },
                controller: outpassInDate,
              ),
              /////////////////////////////
              new TextField(
                readOnly: true,
                decoration: InputDecoration(
                  errorText:
                      validateDepTime ? "Departure Time can\'t be empty" : null,
                  icon: const Icon(Icons.access_time),
                  hintText: 'Enter the time of leaving',
                  labelText: 'Departure Time',
                ),
                onTap: () async {
                  var time = await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                  );
                  outpassDepTimeController.text = time.format(context);
                },
                onChanged: (value) {
                  setState(() {
                    value.isEmpty
                        ? validateDepTime = true
                        : validateDepTime = false;
                  });
                },
                controller: outpassDepTimeController,
              ),
              /////////////////////////////////
              new TextField(
                readOnly: true,
                decoration: InputDecoration(
                  errorText: validateInTime ? "In Time can\'t be empty" : null,
                  icon: const Icon(Icons.access_time),
                  hintText: 'Enter a expected arrival time',
                  labelText: 'In Time',
                ),
                // keyboardType: TextInputType.datetime,
                onTap: () async {
                  var time = await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                  );
                  outpassInTimeController.text = time.format(context);
                },
                onChanged: (value) {
                  setState(() {
                    value.isEmpty
                        ? validateInTime = true
                        : validateInTime = false;
                  });
                },
                controller: outpassInTimeController,
              ),
              new TextField(
                decoration: InputDecoration(
                  errorText: validateAddress ? "Address can\'t be empty" : null,
                  icon: const Icon(Icons.add_location),
                  hintText: 'Enter the address of visit',
                  labelText: 'Address',
                ),
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {
                    value.isEmpty
                        ? validateAddress = true
                        : validateAddress = false;
                  });
                },
                controller: outpassAddressController,
              ),
              new TextField(
                decoration: InputDecoration(
                  errorText: validateReason ? "Reason can\'t be empty" : null,
                  icon: const Icon(Icons.description),
                  hintText: 'Enter the Reason',
                  labelText: 'Reason',
                ),
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {
                    value.isEmpty
                        ? validateReason = true
                        : validateReason = false;
                  });
                },
                controller: outpassReason,
              ),
              SizedBox(height: 45),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Color(0xff7f84fa)),
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                onPressed: () async {
                  setState(() {
                    validateName = nameController.text.isEmpty ? false : true;
                    validateNumber =
                        phoneController.text.isEmpty ? false : true;
                    validateOutDate =
                        outpassOutDate.text.isEmpty ? true : false;
                    validateInDate = outpassInDate.text.isEmpty ? true : false;
                    validateDepTime =
                        outpassDepTimeController.text.isEmpty ? true : false;
                    validateInTime =
                        outpassInTimeController.text.isEmpty ? true : false;
                    validateAddress =
                        outpassAddressController.text.isEmpty ? true : false;
                    validateReason = outpassReason.text.isEmpty ? true : false;
                  });

                  Map data = {
                    "Name": "$_name",
                    "Email": "${currentUser.email}",
                    "Phone": "$_mobile",
                    "Out Date": "${outpassOutDate.text.trim()}",
                    "In Date": "${outpassInDate.text.trim()}",
                    "Departure Time": "${outpassDepTimeController.text.trim()}",
                    "In Time": "${outpassInTimeController.text.trim()}",
                    "Address": "${outpassAddressController.text.trim()}",
                    "Reason": "${outpassReason.text.trim()}",
                    "block": "$_block",
                    "room": "$_room",
                    "status": "Pending",
                    "uid": currentUser.uid
                  };
                  if (!validateOutDate &&
                      !validateInDate &&
                      !validateInTime &&
                      !validateDepTime &&
                      !validateAddress &&
                      !validateReason) {
                    saving = true;
                    database.reference().child("outpass").push().set(data);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
