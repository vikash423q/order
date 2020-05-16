import 'package:order/Models/time_period.dart';

class RestaurantData {
  String name;
  String phone;
  String email;
  String address;
  bool open = true;
  DayPeriod openPeriod;

  RestaurantData.fromJson(json) {
    print('in from json restaurant');
    print(json);
    this.name = json['name'];
    this.phone = json['phone'];
    this.address = json['address'];
    this.open = json['open'];
    this.openPeriod = DayPeriod.fromJson(json['openPeriod']);
  }

  RestaurantData();
}
