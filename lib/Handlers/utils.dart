import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:order/Models/menu_item.dart';
import 'package:order/Models/order.dart';
import 'package:order/Models/user.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:intl/intl.dart';
import 'package:order/constants.dart';

Future<bool> delegateMail(User user, Order order) async {
  String username = Constants().restaurantMailId;
  String password = Constants().mailPassword;

  final smtpServer = gmail(username, password);
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.

  // Create our message.
  final message = Message()
    ..from = Address(username, 'Restaurant')
    ..recipients.add(user.email)
    ..ccRecipients.addAll(Constants().mailRecipients)
    ..subject = '${user.name} placed an order'
    ..text = 'Order received'
    ..html = order.toString();

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}

Future<String> upload(String collectionName, Map<String, dynamic> doc) async {
  DocumentReference docRef =
      await Firestore.instance.collection(collectionName).add(doc);
  return docRef.documentID;
}

Future<List<MenuItem>> verifyOrderWithServer(List<OrderItem> orderItems) async {
  try {
    List<String> uids = orderItems.map((e) => e.uid).toList();
    print(uids);
    var docs = await Firestore.instance
        .collection('menu')
        .where(FieldPath.documentId, whereIn: uids)
        .getDocuments();
    Map<String, OrderItem> orderMap =
        Map.fromIterable(orderItems, key: (e) => e.uid, value: (e) => e);
    var documents = docs.documents;
    documents.removeWhere((item) =>
        item.data['available'] &&
        item.data['offeredPrice'] == orderMap[item.documentID].price &&
        item.data['actualPrice'] == orderMap[item.documentID].actualPrice);
    return documents.map((e) => MenuItem.fromSnapshot(e)).toList();
  } on PlatformException catch (err) {
    return List<MenuItem>();
  }
}

Future<List<Order>> fetchOrderWithLimit(String userId, int limit) async {
  try {
    var docs = await Firestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .limit(limit)
        .getDocuments();
    var documents = docs.documents;
    return documents.map((e) => Order.fromSnapshot(e)).toList();
  } on PlatformException catch (err) {
    return List<Order>();
  }
}

List<MenuItem> updateCartListWithUpdatedMenuItems(
    List<MenuItem> updatedItems, List<MenuItem> cartItems) {
  for (var i = 0; i < cartItems.length; i++) {
    for (var j = 0; j < updatedItems.length; j++) {
      if (cartItems[i].uid == updatedItems[j].uid) {
        if (!updatedItems[j].available) continue;
        var oldItem = cartItems[i];
        cartItems[i] = updatedItems[j];
        cartItems[i].numOfItem = oldItem.numOfItem;
      }
    }
  }
  cartItems.removeWhere((item) => !item.available);
  return cartItems;
}

String formattedDateTime(DateTime dateTime) {
  var dateFormat = DateFormat.yMMMMEEEEd();
  var timeFormat = DateFormat.Hm();
  var dateString = dateFormat.format(dateTime);
  var timeString = timeFormat.format(dateTime);
  return "$dateString,\t$timeString";
}

DateTime dateTimefromString(String dateTime) {
  return DateTime.parse(dateTime);
}

String formatDateString(String dateTime) {
  return formattedDateTime(dateTimefromString(dateTime));
}
