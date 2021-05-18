import 'package:cloud_firestore/cloud_firestore.dart';

final Firestore _firestore = Firestore.instance;
final CollectionReference _mainCollection = _firestore.collection('users');

class Database {
  static String userUid;

  //   void updateItem({String docID,String url}) async {
  //   final CollectionReference _mainCollection = Firestore.instance.collection('users');
  //    DocumentReference documentReferencer = _mainCollection.document(docID);

  //   Map<String, dynamic> data = <String, dynamic>{
  //     "url": url,
  //   };

  //   await documentReferencer
  //       .updateData(data)
  //       .whenComplete(() => print("Note item updated in the database"))
  //       .catchError((e) => print(e));
  // }
  
  static Stream<QuerySnapshot> readItems() {
    CollectionReference notesItemCollection = _mainCollection;

    return notesItemCollection.snapshots();
  }
}
