import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order/Handlers/utils.dart';
import 'package:order/Models/address.dart';
import 'package:order/Models/bill.dart';
import 'package:order/Models/menu_item.dart';
import 'package:the_validator/the_validator.dart';
import 'package:order/exceptions.dart';
import 'package:order/utils.dart';

class Order {
  String uid;
  String userId;
  Address address;
  List<OrderItem> orderItems;
  String suggestion;
  String status; // confirmed, cancelled, pending
  Bill bill;
  DateTime createdOn;

  Order({this.address, this.orderItems});

  Order.fromMenuItems(List<MenuItem> menuList,
      {this.address, this.userId, this.status, this.suggestion, this.bill}) {
    if (menuList.length < 1) {
      throw Exception("Menu List can't be empty");
    }
    this.orderItems = menuList.map((menu) {
      var _cost = totalCost(menu.offeredPrice.toDouble(), menu.numOfItem);
      var _discount = discountedAmount(
          menu.actualPrice.toDouble(), menu.offeredPrice.toDouble(),
          quantity: menu.numOfItem);
      return OrderItem(
          uid: menu.uid,
          name: menu.name,
          price: menu.offeredPrice,
          actualPrice: menu.actualPrice,
          nonVeg: menu.nonVeg,
          quantity: menu.numOfItem,
          cost: _cost,
          discount: _discount);
    }).toList();
    this.createdOn = DateTime.now();
  }

  Order.fromSnapshot(DocumentSnapshot snapshot) {
    this.uid = snapshot.documentID;
    this.userId = snapshot.data["userId"];
    this.address = Address.fromJson(snapshot.data["address"]);
    this.orderItems =
        List<Map<String, dynamic>>.from(snapshot.data["orderItems"])
            .map((item) => OrderItem.fromJson(item))
            .toList();
    this.suggestion = snapshot.data["suggestion"];
    this.status = snapshot.data["status"];
    this.createdOn = DateTime.parse(snapshot.data["createdOn"]);
    this.bill = Bill.fromJson(snapshot.data['bill']);
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userId': userId,
      'address': address.toJson(),
      'orderItems': orderItems.map((e) => e.toJson()).toList(),
      'suggestion': suggestion,
      "status": status,
      "bill": bill.toJson(),
      'createdOn': createdOn.toString()
    };
  }

  String toHTML() {
    return this.toString().replaceAll(new RegExp(r'\n'), "<br>");
  }

  toString() {
    String _heading =
        "\nAddress: ${address.toString()}\nOrdered on : ${formattedDateTime(createdOn)}\nSuggestion : $suggestion\n\nOrder Items :";
    String _orderItems =
        orderItems.map((e) => e.toString()).toList().join("\n");
    String _discounts = bill.discounts
        .map((e) => "\n${e['name']}\t${e['value']}")
        .toList()
        .join("\n");
    String _bill =
        "\nTotal : ${bill.total}\nDiscount : $_discounts\nDelivery : ${bill.delivery}\nTax : ${bill.tax}\nTo Pay : ${bill.toPay}";
    return "$_heading\n$_orderItems\n$_bill";
  }

  validate() {
    if (userId != null) {
      if (address.validate()) {
        if (orderItems.length > 0) {
          orderItems.forEach((element) {
            element.validate();
          });
          if (bill.total > 0 && bill.toPay > 0) {
            if (Validator.isRequired(status)) {
            } else
              throw ValidationException("Status is required");
          } else
            throw ValidationException("Total and ToPay can't be 0");
        } else
          throw ValidationException("Order Items can't be 0");
      } else
        throw ValidationException("Address is required");
    } else
      throw ValidationException("UserId is required");
    return true;
  }
}

class OrderItem {
  String uid;
  String name;
  int quantity;
  int price;
  bool nonVeg;
  int actualPrice;
  num cost;
  num discount;

  OrderItem(
      {this.uid,
      this.name,
      this.quantity,
      this.price,
      this.nonVeg,
      this.actualPrice,
      this.cost,
      this.discount});

  toJson() {
    return {
      'uid': uid,
      'name': name,
      'nonVeg': nonVeg,
      'quantity': quantity,
      'price': price,
      'actualPrice': actualPrice,
      'cost': cost.roundToDouble(),
      'discount': discount.roundToDouble()
    };
  }

  toString() {
    return "\nItem : $name\nQuantity : $quantity\nPrice : $price\nActualPrice : $actualPrice\nCost : $cost\nDiscount : $discount\n";
  }

  OrderItem.fromJson(Map<String, dynamic> map) {
    this.uid = map['uid'];
    this.name = map['name'];
    this.nonVeg = map['nonVeg'];
    this.quantity = map['quantity'];
    this.price = map['price'];
    this.actualPrice = map['actualPrice'];
    this.cost = map['cost'];
    this.discount = map['discount'];
  }

  bool validate() {
    if (uid != null) {
      if (name != null) {
        if (quantity > 0) {
          if (price > 0) {
          } else
            throw ValidationException('Invalid Price');
        } else
          throw ValidationException('Quantity could not be 0');
      } else
        throw ValidationException('Name is required');
    } else
      throw ValidationException('Uid is required');
    return true;
  }
}
