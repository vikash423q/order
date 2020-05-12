import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String name;
  String email;
  String phone;
  bool phoneVerified;

  User(this.uid, [this.name, this.email, this.phone, this.phoneVerified]);

  User.fromSnapshot(DocumentSnapshot snapshot) {
    this.uid = snapshot.documentID;
    this.name = snapshot.data['name'];
    this.email = snapshot.data['email'];
    this.phone = snapshot.data['phone'];
    this.phoneVerified = snapshot.data['phoneVerified'];
  }

  User.empty() {
    this.uid = "";
    this.name = "";
    this.email = "";
    this.phone = "";
    this.phoneVerified = false;
  }

  toJson() {
    return {
      "uid": uid,
      "name": this.name,
      "email": this.email,
      "phone": this.phone,
      "phoneVerified": this.phoneVerified
    };
  }

  String toHTML() {
    return this.toString().replaceAll(new RegExp(r'\n'), "<br>");
  }

  @override
  String toString() {
    return "Customer ID : $uid\nCustomer Name: $name \nCustomer Email: $email\nCustomer Phone: $phone\n\n";
  }
}
