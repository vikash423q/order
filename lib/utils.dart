import 'package:cloud_firestore/cloud_firestore.dart';

double totalCost(double price, int quantity) {
  return (price * quantity).roundToDouble();
}

double deliveryCharge() {
  return 30.0;
}

double taxAmount(double amount) {
  return (0.18 * amount).roundToDouble();
}

double discountedAmount(double initialPrice, double finalPrice,
    {int quantity = 1}) {
  return (initialPrice * quantity - finalPrice * quantity).roundToDouble();
}
