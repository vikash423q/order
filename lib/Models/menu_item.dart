import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order/Models/time_period.dart';

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
  DayPeriod availabilityPeriod;

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
      this.recommended,
      this.availabilityPeriod});

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
    if (snapshot.data['availabilityPeriod'] != null) {
      this.availabilityPeriod =
          DayPeriod.fromJson(snapshot.data['availabilityPeriod']);
    } else {
      this.availabilityPeriod = DayPeriod.fromEmpty();
    }
  }

  MenuItem.fromJson(json) {
    print('loading menuItem from json');
    this.uid = json['uid'];
    this.key = this.uid;
    this.name = json['name'];
    this.cuisine = json['cuisine'];
    this.category = List<String>.from(json['category']);
    this.actualPrice =
        json['actualPrice'] != null ? json['actualPrice'].toInt() : 0;
    this.offeredPrice = json['offeredPrice'].toInt();
    this.imageUrl = json['imageUrl'];
    this.available = json['available'];
    this.nonVeg = json['nonVeg'];
    this.recommended = json['recommended'];
    if (json['availabilityPeriod'] != null) {
      this.availabilityPeriod = DayPeriod.fromJson(json['availabilityPeriod']);
    } else {
      this.availabilityPeriod = DayPeriod.fromEmpty();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'name': this.name,
      'cuisine': this.cuisine,
      'category': this.category,
      'actualPrice': this.actualPrice,
      'offeredPrice': this.offeredPrice,
      'imageUrl': this.imageUrl,
      'available': this.available,
      'nonVeg': this.nonVeg,
      'recommended': this.recommended,
      'quantity': this.numOfItem,
      'availabilityPeriod': this.availabilityPeriod.toJson()
    };
  }
}
