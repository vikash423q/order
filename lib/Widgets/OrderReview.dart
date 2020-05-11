import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order/Models/order.dart';

class OrderReview extends StatefulWidget {
  String orderId;
  OrderReview({Key key, this.orderId}) : super(key: key);

  @override
  _OrderReviewState createState() => _OrderReviewState();
}

class _OrderReviewState extends State<OrderReview> {
  String _orderId;
  bool _loading = true;
  Order _order;

  void toggleLoading() => setState(() => this._loading = !this._loading);

  @override
  void initState() {
    this._orderId = widget.orderId;
    Firestore.instance
        .collection('orders')
        .document(this._orderId)
        .get()
        .then((snapshot) => setState(() {
              this._loading = false;
              print(snapshot);
              this._order = Order.fromSnapshot(snapshot);
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.orange[500],
            ),
            onPressed: () => Navigator.pop(context)),
        centerTitle: true,
        title: Text(
          'Order Review',
          style: TextStyle(
            color: Colors.orange[500],
            fontSize: ScreenUtil().setHeight(30),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Builder(builder: (context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(20.0),
                    vertical: ScreenUtil().setHeight(40)),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(20.0)),
                    Text(
                      "Order ID",
                      style: TextStyle(
                          color: Colors.black54,
                          fontFamily: "Poppins-Bold",
                          fontSize: ScreenUtil().setSp(28),
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10.0)),
                    InkWell(
                      onLongPress: () {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Order ID copied"),
                        ));
                        Clipboard.setData(ClipboardData(text: this._orderId));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            this._orderId,
                            style: TextStyle(
                                color: Colors.black87,
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil().setSp(26),
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "Long press to copy",
                            style: TextStyle(
                                color: Colors.black45,
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil().setSp(18),
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    this._loading
                        ? SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                      height: ScreenUtil().setHeight(25.0)),
                                  Text(
                                    "Deliver to",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: "Poppins-Bold",
                                        fontSize: ScreenUtil().setSp(28),
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                      height: ScreenUtil().setHeight(10.0)),
                                  Text(
                                    "${this._order.address.toString()}",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: "Poppins-Medium",
                                        fontSize: ScreenUtil().setSp(22),
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                      height: ScreenUtil().setHeight(10.0)),
                                  Text(
                                    "${this._order.createdOn}",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: "Poppins-Medium",
                                        fontSize: ScreenUtil().setSp(22),
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              this._order.status != null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                            height:
                                                ScreenUtil().setHeight(25.0)),
                                        Text(
                                          "Status",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontFamily: "Poppins-Bold",
                                              fontSize: ScreenUtil().setSp(28),
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                            height:
                                                ScreenUtil().setHeight(10.0)),
                                        Text(
                                          "${this._order.status}",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontFamily: "Poppins-Medium",
                                              fontSize: ScreenUtil().setSp(22),
                                              fontWeight: FontWeight.w400),
                                        ),
                                        // TODO Revisit status design.
                                        Text(
                                          "Don't worry. Status doesn't reflect your order proceedings.\nThis part is under construction",
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontFamily: "Poppins-Medium",
                                              fontSize: ScreenUtil().setSp(18),
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                            height:
                                                ScreenUtil().setHeight(10.0)),
                                      ],
                                    )
                                  : SizedBox(),
                              this._order.suggestion != null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                            height:
                                                ScreenUtil().setHeight(25.0)),
                                        Text(
                                          "Suggestion",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontFamily: "Poppins-Bold",
                                              fontSize: ScreenUtil().setSp(28),
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                            height:
                                                ScreenUtil().setHeight(10.0)),
                                        Text(
                                          "${this._order.suggestion}",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontFamily: "Poppins-Medium",
                                              fontSize: ScreenUtil().setSp(22),
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                            height:
                                                ScreenUtil().setHeight(10.0)),
                                      ],
                                    )
                                  : SizedBox(),
                            ],
                          ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(80)),
              !this._loading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            "DETAILS",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: ScreenUtil().setSp(26),
                                fontFamily: "Poppins-Bold",
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    )
                  : SizedBox(),
              SizedBox(height: ScreenUtil().setHeight(15)),
              !this._loading
                  ? Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(15.0),
                          vertical: ScreenUtil().setHeight(20)),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          this._order.orderItems.length,
                          (index) => Container(
                            key: Key(index.toString()),
                            margin: EdgeInsets.only(
                                bottom: ScreenUtil().setHeight(2)),
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(15.0),
                                vertical: ScreenUtil().setHeight(20.0)),
                            color: Colors.white,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                        width: ScreenUtil().setWidth(10.0)),
                                    Container(
                                      padding: EdgeInsets.all(2.0),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color: this
                                                    ._order
                                                    .orderItems[index]
                                                    .nonVeg
                                                ? Colors.red
                                                : Colors.green),
                                      ),
                                      child: Container(
                                        height: ScreenUtil().setHeight(8.0),
                                        width: ScreenUtil().setWidth(8.0),
                                        decoration: BoxDecoration(
                                            color: this
                                                    ._order
                                                    .orderItems[index]
                                                    .nonVeg
                                                ? Colors.red
                                                : Colors.green,
                                            shape: BoxShape.circle),
                                      ),
                                    ),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(20.0),
                                    ),
                                    Text(
                                      this._order.orderItems[index].name,
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(26),
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87),
                                    ),
                                    Text(
                                      "  x  ${this._order.orderItems[index].quantity}",
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(26),
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      '₹${this._order.orderItems[index].actualPrice * this._order.orderItems[index].quantity}',
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.black54,
                                          fontSize: ScreenUtil().setSp(22),
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      '₹${this._order.orderItems[index].cost}',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: ScreenUtil().setSp(24),
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              Divider(color: Colors.white, height: 2),
              !this._loading
                  ? Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(40.0),
                          vertical: ScreenUtil().setHeight(25)),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Item Total",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: "Poppins-Medium",
                                    fontSize: ScreenUtil().setSp(24),
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "₹${this._order.total}",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: ScreenUtil().setSp(24),
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10.0)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Delivery Charges",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: "Poppins-Medium",
                                    fontSize: ScreenUtil().setSp(24),
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "₹${this._order.delivery}",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: ScreenUtil().setSp(24),
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10.0)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Discount",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: "Poppins-Medium",
                                    fontSize: ScreenUtil().setSp(24),
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "₹${this._order.orderItems.fold(0, (val, el) => val + el.discount)}",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: ScreenUtil().setSp(24),
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10.0)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Tax and Charges(18%)",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: "Poppins-Medium",
                                    fontSize: ScreenUtil().setSp(24),
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "₹${this._order.tax}",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: ScreenUtil().setSp(24),
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10.0)),
                        ],
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: ScreenUtil().setHeight(250)),
            ],
          ),
        );
      }),
    );
  }
}
