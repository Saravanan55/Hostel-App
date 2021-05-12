import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'edit_item.dart';
import 'colors.dart';
import 'database.dart';
import 'edit_screen.dart';

class ItemList extends StatelessWidget {
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
              //var noteInfo = snapshot.data.documents[index].data;
              String docID = snapshot.data.documents[index].documentID;
              String date = snapshot.data.documents[index].data['Date'];
              String breakfast =
                  snapshot.data.documents[index].data['Break Fast'];
              String lunch = snapshot.data.documents[index].data['Lunch'];
              String dinner = snapshot.data.documents[index].data['Dinner'];

              return InkWell(
                // decoration: BoxDecoration(
                //   color: CustomColors.firebaseGrey.withOpacity(0.1),
                //   borderRadius: BorderRadius.circular(8.0),
                // ),
                // child: ListTile(
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(8.0),
                //   ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditScreen(
                      currentdate: date,
                      currentbreakfast: breakfast,
                      currentlunch: lunch,
                      currentdinner: dinner,
                      documentId: docID,
                    ),
                  ),
                ),
                // title: Text(
                //   'Date : $date',
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                //   style: TextStyle(fontSize: 20.0),
                // ),
                // subtitle: Column(
                //   children: <Widget>[
                //     Text(
                //       'Break fast : $breakfast',
                //       overflow: TextOverflow.ellipsis,
                //       style: TextStyle(fontSize: 20.0),
                //     ),
                //     Text(
                //       'Lunch : $lunch',
                //       maxLines: 1,
                //       overflow: TextOverflow.ellipsis,
                //       style: TextStyle(fontSize: 20.0),
                //     ),
                //     Text(
                //       'Dinner : $dinner',
                //       maxLines: 1,
                //       overflow: TextOverflow.ellipsis,
                //       style: TextStyle(fontSize: 20.0),
                //     ),
                //   ],
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6),
                  child: Container(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 6.0,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListTile(
                          title: Text(
                            'Date : $date',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 20.0),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Break fast : $breakfast',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 20.0),
                              ),
                              Text(
                                'Lunch : $lunch',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 20.0),
                              ),
                              Text(
                                'Dinner : $dinner',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }

        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              CustomColors.firebaseOrange,
            ),
          ),
        );
      },
    );
  }
}
