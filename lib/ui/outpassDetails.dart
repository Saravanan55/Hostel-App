import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class OutpassDetails extends StatefulWidget {
  final String name,
      phone,
      outdate,
      indate,
      deptime,
      intime,
      address,
      reason,
      id,
      block,
      room,
      status;
  final int flag;
  final String keys;
  OutpassDetails(
      this.name,
      this.phone,
      this.outdate,
      this.indate,
      this.deptime,
      this.intime,
      this.address,
      this.reason,
      this.id,
      this.block,
      this.room,
      this.status,
      this.flag,
      this.keys);

  @override
  _OutpassDetailsState createState() => _OutpassDetailsState();
}

final FirebaseDatabase database = FirebaseDatabase.instance;

class _OutpassDetailsState extends State<OutpassDetails> {
  Map data;
  String message;
  bool val;
  String statusChange;
  String pText = "Pending";
  String dText = "Done";

  void initState() {
    super.initState();
    if (this.widget.status == "Done") {
      val = true;
      statusChange = dText;
    } else {
      val = false;
      statusChange = pText;
    }
  }

  static const textStyle = TextStyle(
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff028090),
        title: Text('OutpassDetail'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6),
        child: ListView(
          children: <Widget>[
            Container(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 6.0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Name : ${widget.name}',
                        style: textStyle,
                      ),
                      Text(
                        'Mobile : ${widget.phone}',
                        style: textStyle,
                      ),
                      Text(
                        'Out Date : ${widget.outdate}',
                        overflow: TextOverflow.ellipsis,
                        style: textStyle,
                      ),
                      Text(
                        'In Date : ${widget.indate}',
                        overflow: TextOverflow.ellipsis,
                        style: textStyle,
                      ),
                      Text(
                        'Departure Time :  ${widget.deptime}',
                        style: textStyle,
                      ),
                      Text(
                        'In Time :  ${widget.intime}',
                        style: textStyle,
                      ),
                      Text(
                        'Address :  ${widget.address}',
                        style: textStyle,
                      ),
                      Text(
                        'Block :  ${widget.block}',
                        style: textStyle,
                      ),
                      Text(
                        'Room No :  ${widget.room}',
                        style: textStyle,
                      ),
                      Text(
                        'Status : $statusChange',
                        style: TextStyle(
                            fontSize: 16,
                            color: statusChange == "Pending"
                                ? Colors.red
                                : Colors.green),
                      ),
                      widget.flag == 0
                          ? Container()
                          : Row(
                              children: <Widget>[
                                Text('Approved'),
                                Checkbox(
                                  value: this.val,
                                  onChanged: (value) {
                                    setState(() {
                                      this.val = value;
                                      if (this.val == true)
                                        message = "Done";
                                      else
                                        message = "Pending";
                                      statusChange = message;

                                      database
                                          .reference()
                                          .child('outpass')
                                          .child(widget.keys)
                                          .update({
                                        "Name": "${widget.name}",
                                        "Phone": "${widget.phone}",
                                        "Out Date": "${widget.outdate}",
                                        "In Date": "${widget.indate}",
                                        "Departure Time": "${widget.deptime}",
                                        "In Time": "${widget.intime}",
                                        "Address": "${widget.address}",
                                        "id": "${widget.id}",
                                        "block": "${widget.block}",
                                        "room": "${widget.room}",
                                        "status": "$statusChange"
                                      });
                                    });
                                  },
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
