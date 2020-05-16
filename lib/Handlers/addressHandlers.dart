import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:order/Models/address.dart';
import 'package:order/Models/user.dart';
import 'package:order/SharedPreferences/utils.dart';

Future<bool> updateAddressForUser(Address address,
    {bool delete = false}) async {
  try {
    User user = await readUser();
    DocumentSnapshot userDoc = await Firestore.instance
        .collection('users')
        .document(user.uid)
        .snapshots()
        .first;
    List<Address> existingAddresses =
        List<dynamic>.of(userDoc.data['address'] ?? [])
            .map((e) => Address.fromJson(e))
            .toList();

    existingAddresses.removeWhere((element) =>
        element.houseNumber == address.houseNumber &&
        element.area == address.area);

    if (address.isDefault) {
      existingAddresses = existingAddresses.map((e) {
        e.isDefault = false;
        return e;
      }).toList();
    }

    if (!delete) existingAddresses.add(address);
    List<Map<String, dynamic>> existingAddressJson =
        existingAddresses.map((e) => e.toJson()).toList();
    await Firestore.instance
        .collection('users')
        .document(user.uid)
        .updateData({'address': existingAddressJson});
    return true;
  } on PlatformException catch (err) {
    return false;
  }
}
