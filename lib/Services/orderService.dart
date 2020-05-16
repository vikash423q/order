import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:order/Models/bill.dart';
import 'package:order/Models/menu_item.dart';
import 'package:order/Models/order.dart';
import 'package:order/Models/restaurant_data.dart';

Future<Bill> generateBillService(
    String userId, List<Map<String, dynamic>> orderItems) async {
  print('called generateBillService');
  var body = json.encode({"userId": userId, "orderItems": orderItems});
  var response = await http.post(
      'https://us-central1-order-f58e4.cloudfunctions.net/generateBill',
      headers: {'Content-Type': 'application/json'},
      body: body);

  if (response.statusCode != 200) {
    return Bill.fromEmpty();
  }
  var res = json.decode(response.body);

  return Bill.fromJson(res);
}

Future<Map<String, dynamic>> placeOrderService(Order order) async {
  print('called placeOrderService');

  Map<String, dynamic> request = order.toJson();
  request['html'] = order.toHTML();

  var body = json.encode(request);
  var response = await http.post(
      'https://us-central1-order-f58e4.cloudfunctions.net/placeOrder',
      headers: {'Content-Type': 'application/json'},
      body: body);

  if (response.statusCode != 200) {
    return {"status": "failed", "data": response.body};
  } else
    return {"status": "ok", "data": response.body};
}

Future<RestaurantData> getRestaurantDetail() async {
  print('called getRestaurant');

  var response = await http.post(
      'https://us-central1-order-f58e4.cloudfunctions.net/getRestaurantDetail');

  if (response.statusCode != 200) {
    return RestaurantData();
  }

  return RestaurantData.fromJson(json.decode(response.body));
}

Future<List<MenuItem>> getMenuList() async {
  print('called getMenuList');

  var response = await http
      .post('https://us-central1-order-f58e4.cloudfunctions.net/listMenuItems');

  if (response.statusCode != 200) {
    return [];
  }
  var result = json.decode(response.body);
  List<MenuItem> items =
      List.of(result).map((e) => MenuItem.fromJson(e)).toList();
  return items;
}
