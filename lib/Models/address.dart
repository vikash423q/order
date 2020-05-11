import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order/exceptions.dart';
import 'package:the_validator/the_validator.dart';

class Address {
  String key;
  String houseNumber;
  String landmark;
  String street;
  String area;
  String zip;
  String city = "Patna";
  String state = "Bihar";
  String country = "India";

  Address(
      {this.key,
      this.houseNumber,
      this.landmark,
      this.street,
      this.area,
      this.zip});

  Address.fromSnapshot(DocumentSnapshot snapshot) {
    this.key = snapshot.documentID;
    this.houseNumber = snapshot.data['house'];
    this.landmark = snapshot.data['landmark'];
    this.street = snapshot.data['street'];
    this.area = snapshot.data['area'];
    this.zip = snapshot.data['zip'];
    this.city = snapshot.data['city'];
    this.state = snapshot.data['state'];
    this.country = snapshot.data['country'];
  }

  Address.fromJson(Map<String, dynamic> _map) {
    this.houseNumber = _map['houseNumber'];
    this.landmark = _map['landmark'];
    this.street = _map['street'];
    this.area = _map['area'];
    this.zip = _map['zip'];
    this.city = _map['city'];
    this.state = _map['state'];
    this.country = _map['country'];
  }

  toJson() {
    return {
      'houseNumber': this.houseNumber,
      'landmark': this.landmark,
      'street': this.street,
      'area': this.area,
      'zip': this.zip,
      'city': this.city,
      'state': this.state,
      'country': this.country
    };
  }

  toString() {
    var _list = [
      houseNumber,
      landmark,
      street,
      area,
      '\nPin Code: $zip',
      city,
      state
    ];
    _list.removeWhere((element) => element == null);
    return _list.join(", ");
  }

  validate() {
    if (Validator.isRequired(houseNumber)) {
      if (Validator.isRequired(area)) {
        if (Validator.isRequired(zip)) {
        } else {
          throw ValidationException('Pin Code is required');
        }
      } else {
        throw ValidationException('Area is required');
      }
    } else {
      throw ValidationException('House No is required');
    }
    return true;
  }
}
