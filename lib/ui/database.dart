import 'package:cloud_firestore/cloud_firestore.dart';

final Firestore _firestore = Firestore.instance;
final CollectionReference _mainCollection = _firestore.collection('notes');

class Database {
  static String userUid;

  static Future<void> addItem({
    String date,
    String breakfast,
    String lunch,
    String dinner,
  }) async {
    DocumentReference documentReferencer = _mainCollection.document(userUid);

    Map<String, dynamic> data = <String, dynamic>{
      "Date": date,
      "Break Fast": breakfast,
      "Lunch": lunch,
      "Dinner": dinner
    };

    await documentReferencer
        .setData(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

  static Future<void> updateItem({
    String date,
    String breakfast,
    String lunch,
    String dinner,
    String docId,
  }) async {
    DocumentReference documentReferencer = _mainCollection.document(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "Date": date,
      "Break Fast": breakfast,
      "Lunch": lunch,
      "Dinner": dinner
    };

    await documentReferencer
        .updateData(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readItems() {
    CollectionReference notesItemCollection = _mainCollection;

    return notesItemCollection.snapshots();
  }

  static Future<void> deleteItem({
    String docId,
  }) async {
    DocumentReference documentReferencer = _mainCollection.document(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}
