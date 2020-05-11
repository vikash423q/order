import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:order/Models/menu_item.dart';
import 'package:order/Models/order.dart';

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
