import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItem {
  String key;
  String uid;
  String name;
  String cuisine;
  List<String> category;
  int actualPrice;
  int offeredPrice;
  String imageUrl;
  bool available;
  bool nonVeg;
  bool recommended;
  int numOfItem = 0;

  MenuItem(
      {this.uid,
      this.name,
      this.cuisine,
      this.category,
      this.actualPrice,
      this.offeredPrice,
      this.imageUrl,
      this.available,
      this.nonVeg,
      this.recommended});

  MenuItem.fromSnapshot(DocumentSnapshot snapshot) {
    print('loading menuItem from snapshot');
    this.uid = snapshot.documentID;
    this.key = this.uid;
    this.name = snapshot.data['name'];
    this.cuisine = snapshot.data['cuisine'];
    this.category = List<String>.from(snapshot.data['category']);
    this.actualPrice = snapshot.data['actualPrice'].toInt();
    this.offeredPrice = snapshot.data['offeredPrice'].toInt();
    this.imageUrl = snapshot.data['imageUrl'];
    this.available = snapshot.data['available'];
    this.nonVeg = snapshot.data['nonVeg'];
    this.recommended = snapshot.data['recommended'];
  }

  toJson() {
    return {
      'name': this.name,
      'cuisine': this.cuisine,
      'category': this.category,
      'actualPrice': this.actualPrice,
      'offeredPrice': this.offeredPrice,
      'imageUrl': this.imageUrl,
      'available': this.available,
      'nonVeg': this.nonVeg,
      'recommended': this.recommended
    };
  }
}
