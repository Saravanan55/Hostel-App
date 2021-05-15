import 'dart:io';
import 'package:flutter/services.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hostel/utils/Constants.dart';

//test
final FirebaseDatabase database = FirebaseDatabase.instance;
final Firestore store = Firestore.instance;
// final auth = FirebaseAuth.instance;
// final user = auth.currentUser();

class OutpassForm extends StatefulWidget {
  OutpassForm({Key key, this.uid}) : super(key: key);
  final String uid;
  @override
  _OutpassFormState createState() => _OutpassFormState();
}

class _OutpassFormState extends State<OutpassForm> {
  File sampleImage;
  String filename;
  // String random;
  bool validateDate = false;
  bool validateDepTime = false;
  bool validateInTime = false;
  bool validateAddress = false;
  String _name, _mobile, _block, _room;
  FirebaseUser currentUser;

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
  }

  // _selectDate(BuildContext context) async {
  //   DateTime newSelectedDate = await showDatePicker(
  //       context: context,
  //       initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
  //       firstDate: DateTime(2000),
  //       lastDate: DateTime(2040),
  //       builder: (BuildContext context, Widget child) {
  //         return Theme(
  //           data: ThemeData.dark().copyWith(
  //             colorScheme: ColorScheme.dark(
  //               primary: Colors.deepPurple,
  //               onPrimary: Colors.white,
  //               surface: Colors.blueGrey,
  //               onSurface: Colors.yellow,
  //             ),
  //             dialogBackgroundColor: Colors.blue[500],
  //           ),
  //           child: child,
  //         );
  //       });

  //   if (newSelectedDate != null) {
  //     _selectedDate = newSelectedDate;
  //     outpassDateController
  //       text = DateFormat.yMMMd().format(_selectedDate)
  //       selection = TextSelection.fromPosition(TextPosition(
  //           offset: outpassDateController.text.length,
  //           affinity: TextAffinity.upstream));
  //   }
  // }

  static const textStyle = TextStyle(fontSize: 15);
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
        backgroundColor: Color(0xff028090),
        title: Text('Create Outpass'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: saving,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: ListView(
            children: <Widget>[
              new TextField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.calendar_today),
                  hintText: 'Enter the out date',
                  labelText: 'Out Date',
                ),
                keyboardType: TextInputType.datetime,
                onChanged: (value) {
                  setState(() {
                    value.isEmpty ? validateDate = true : validateDate = false;
                  });
                },
                controller: outpassOutDate,
              ),
              new TextField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.calendar_today),
                  hintText: 'Enter the in date',
                  labelText: 'In Date',
                ),
                keyboardType: TextInputType.datetime,
                onChanged: (value) {
                  setState(() {
                    value.isEmpty ? validateDate = true : validateDate = false;
                  });
                },
                controller: outpassInDate,
              ),
              new TextField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.access_time),
                  hintText: 'Enter the time of leaving',
                  labelText: 'Departure Time',
                ),
                // onTap: () {
                //   _selectDate(context);
                // },
                keyboardType: TextInputType.datetime,
                // inputFormatters: [
                //   WhitelistingTextInputFormatter.digitsOnly,
                // ],
                onChanged: (value) {
                  setState(() {
                    value.isEmpty
                        ? validateDepTime = true
                        : validateDepTime = false;
                  });
                },
                controller: outpassDepTimeController,
              ),
              new TextField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.access_time),
                  hintText: 'Enter a expected arrival time',
                  labelText: 'In Time',
                ),
                keyboardType: TextInputType.datetime,
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
                decoration: const InputDecoration(
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
                decoration: const InputDecoration(
                  icon: const Icon(Icons.description),
                  hintText: 'Enter the Reason',
                  labelText: 'Reason',
                ),
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {
                    value.isEmpty
                        ? validateAddress = true
                        : validateAddress = false;
                  });
                },
                controller: outpassReason,
              ),
              SizedBox(height: 45),
              RaisedButton(
                color: Color(0xff028090),
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                onPressed: () async {
                  saving = true;
                  setState(() {
                    validateName = nameController.text.isEmpty ? false : true;
                    //  validateDetail = infoController.text.isEmpty ? true : false;
                    validateNumber =
                        phoneController.text.isEmpty ? false : true;
                    validateDate = outpassOutDate.text.isEmpty ? true : false;
                    validateDate = outpassInDate.text.isEmpty ? true : false;
                    validateDepTime =
                        outpassDepTimeController.text.isEmpty ? true : false;
                    validateInTime =
                        outpassInTimeController.text.isEmpty ? true : false;
                    validateAddress =
                        outpassAddressController.text.isEmpty ? true : false;
                  });
                  //    random = randomAlphaNumeric(6);

                  Map data = {
                    "Name": "$_name",
                    "Email":"${currentUser.email}",
                    "Phone": "$_mobile",
                    "Out Date": "${outpassOutDate.text.trim()}",
                    "In Date": "${outpassOutDate.text.trim()}",
                    "Departure Time": "${outpassDepTimeController.text.trim()}",
                    "In Time": "${outpassInTimeController.text.trim()}",
                    "Address": "${outpassAddressController.text.trim()}",
                    "Reason": "${outpassReason.text.trim()}",
                    "block": "$_block",
                    "room": "$_room",
                    "status": "Pending",
                    "uid": currentUser.uid
                  };
                  if (!validateDate && !validateInTime && !validateDepTime)
                    database.reference().child("outpass").push().set(data);
                  // store
                  //     .collection("outpass")
                  //     .document(currentUser.uid)
                  //     .collection("outpass")
                  //     .add({
                  //   "Name": "$_name",
                  //   "Phone": "$_mobile",
                  //   "Date": "${outpassDateController.text.trim()}",
                  //   "Departure Time":
                  //       "${outpassDepTimeController.text.trim()}",
                  //   "In Time": "${outpassInTimeController.text.trim()}",
                  //   "Address": "${outpassAddressController.text.trim()}",
                  //   "id": "${random}",
                  //   "block": "$_block",
                  //   "room": "$_room",
                  //   "status": "Pending",
                  //   "uid": currentUser.uid
                  // });
                  Navigator.pop(context);
                  //   Firestore.instance
                  //       .collection("hostel")
                  //       .document((_name))
                  //       .setData(data);
                  // Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// //import '../home_page.dart';
// import 'UserDashboard.dart';

// class OutpassForm extends StatefulWidget {
//   @override
//   _OutpassFormState createState() => _OutpassFormState();
// }

// class _OutpassFormState extends State<OutpassForm> {
//   GlobalKey<FormState> _key = new GlobalKey();
//   bool _autovalidate = false;
//   String outpassName,
//       outpassDate,
//       outpassDepartureTime,
//       outpassInTime,
//       outpassAddress;
//   int count = 0;
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text('Outpass Form'),
//       ),
//       body: new SingleChildScrollView(
//         child: new Container(
//           padding: new EdgeInsets.all(15.0),
//           child: new Form(
//             key: _key,
//             autovalidate: _autovalidate,
//             child: formUI(),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget formUI() {
//     return new Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         new TextField(
//           decoration: const InputDecoration(
//             icon: const Icon(Icons.person),
//             hintText: 'Enter your first and last name',
//             labelText: 'Name',
//           ),
//           onChanged: (value) {
//             this.outpassName = value;
//           },
//         ),
//         new TextField(
//           decoration: const InputDecoration(
//             icon: const Icon(Icons.calendar_today),
//             hintText: 'Enter the date',
//             labelText: 'Date',
//           ),
//           keyboardType: TextInputType.datetime,
//           onChanged: (value) {
//             this.outpassDate = value;
//           },
//         ),
//         new TextField(
//           decoration: const InputDecoration(
//             icon: const Icon(Icons.access_time),
//             hintText: 'Enter the time of leaving',
//             labelText: 'Departure Time',
//           ),
//           keyboardType: TextInputType.datetime,
//           inputFormatters: [
//             WhitelistingTextInputFormatter.digitsOnly,
//           ],
//           onChanged: (value) {
//             this.outpassDepartureTime = value;
//           },
//         ),
//         new TextField(
//           decoration: const InputDecoration(
//             icon: const Icon(Icons.access_time),
//             hintText: 'Enter a expected arrival time',
//             labelText: 'In Time',
//           ),
//           keyboardType: TextInputType.datetime,
//           onChanged: (value) {
//             this.outpassInTime = value;
//           },
//         ),
//         new TextField(
//           decoration: const InputDecoration(
//             icon: const Icon(Icons.add_location),
//             hintText: 'Enter the address of visit',
//             labelText: 'Address',
//           ),
//           keyboardType: TextInputType.text,
//           onChanged: (value) {
//             this.outpassAddress = value;
//           },
//         ),
//         new RaisedButton(
//           onPressed: _sendToServer,
//           child: new Text('Send'),
//         ),
//       ],
//     );
//   }

//   _sendToServer() {
//     count++;
//     if (_key.currentState.validate()) {
//       _key.currentState.save();
//       DatabaseReference ref = FirebaseDatabase.instance.reference();
//       var dataOutpass = {
//         'personNameOutpass': this.outpassName,
//         'date': this.outpassDate,
//         'departureTime': this.outpassDepartureTime,
//         'inTime': this.outpassInTime,
//         'address': this.outpassAddress,
//         'status': 'http://aux.iconspalace.com/uploads/12756772011468829104.png'
//       };
//       ref.child('Outpass').push().set(dataOutpass).then((v) {
//         _key.currentState.reset();
//       });
//     } else {
//       setState(() {
//         _autovalidate = true;
//       });
//     }

//     Navigator.of(context).push(new MaterialPageRoute(
//         builder: (BuildContext context) => UserDashboard()));
//   }
// }
