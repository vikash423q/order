class Bill {
  double total;
  double delivery;
  List<dynamic> discounts;
  double tax;
  double toPay;

  Bill.fromEmpty() {
    this.total = 0.0;
    this.delivery = 0.0;
    this.tax = 0.0;
    this.toPay = 0.0;
    this.discounts = [];
  }

  Bill.fromJson(Map<String, dynamic> json) {
    this.total = json['total'].toDouble();
    this.delivery = json['delivery'].toDouble();

    this.tax = json['tax'].toDouble();

    this.discounts = json['discounts'];
    this.toPay = json['toPay'].toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      "total": this.total,
      "delivery": this.delivery,
      "tax": this.tax,
      "toPay": this.toPay,
      "discounts": this.discounts
    };
  }
}
