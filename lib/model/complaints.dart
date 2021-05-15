import 'package:firebase_database/firebase_database.dart';

class Complaints {
  String key;
  String name;
  String detail;
  String status;
  String phone;
  String email;


  Complaints(this.name,this.detail,this.status,this.phone,this.email);

  Complaints.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value["name"],
        detail= snapshot.value["detail"],
        status= snapshot.value["status"],
        phone =snapshot.value["phone"],
        email = snapshot.value["email"];



  toJson() {
    return {
      "name": name,
      "detail": detail,
      "status": status,
      "phone":phone,
      "email":email
    };
  }
}