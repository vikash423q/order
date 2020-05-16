import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

import 'package:order/Bloc/cart_bloc.dart';
import 'package:order/Handlers/authorization.dart';
import 'package:order/Models/address.dart';
import 'package:order/Models/bill.dart';
import 'package:order/Models/menu_item.dart';
import 'package:order/Models/order.dart';
import 'package:order/Models/user.dart';
import 'package:order/Services/orderService.dart';
import 'package:order/SharedPreferences/utils.dart';
import 'package:order/Widgets/AddRemoveButton.dart';
import 'package:order/Widgets/AddressPage.dart';
import 'package:order/Widgets/BillCard.dart';
import 'package:order/Widgets/OrderReview.dart';
import 'package:order/Widgets/ProgressButton.dart';
import 'package:order/Widgets/ProgressIndicatorButton.dart';
import 'package:order/constants.dart';
import 'package:order/exceptions.dart';
import 'package:order/Handlers/utils.dart';
import 'package:order/utils.dart';
import 'package:the_validator/the_validator.dart';

class CartPage extends StatefulWidget {
  final CartBloc cartBloc;
  final User user;
  CartPage({Key key, this.cartBloc, this.user}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CartBloc _cartBloc;
  bool _readyForOrder = false;
  bool _shouldShowProgress = false;
  final _formKey = GlobalKey<FormState>();
  Address _address = Address();
  User _user;
  String _suggestion;
  bool _loadingAddress = false;
  List<Address> addresses = [];
  int idxSelected = 0;
  Bill _bill = Bill.fromEmpty();
  bool _billLoading = true;

  void _increaseItemCount(MenuItem item) => setState(() {
        this._readyForOrder = false;
        this._cartBloc.cartEventSink.add(
            CartItemAddedEvent(item, fromCart: true, callback: updateBill));
      });
  void _decreaseItemCount(MenuItem item) => setState(() {
        this._readyForOrder = false;
        this._cartBloc.cartEventSink.add(
            CartItemRemovedEvent(item, fromCart: true, callback: updateBill));
      });

  void _toggleReadyForOrder() {
    // if (isUserVerified(_user)) {}
    if (!this._billLoading)
      setState(() => this._readyForOrder = !this._readyForOrder);
  }

  void updateBill() async {
    if (this._cartBloc.cartItems.length == 0) {
      return;
    }
    setState(() {
      this._billLoading = true;
    });
    Bill bill = await generateBillService(this._user.uid,
        this._cartBloc.cartItems.map((e) => e.toJson()).toList());
    if (this.mounted) {
      setState(() {
        print("updating bill");
        this._bill = bill;
        this._billLoading = false;
      });
    }
  }

  void fetchAddress() async {
    if (this._billLoading) return;
    read_uid().then((id) {
      setState(() {
        this._loadingAddress = true;
        this._readyForOrder = false;
        this._shouldShowProgress = false;
      });
      getUserWithUid(id).then(
        (user) => setState(() {
          this.addresses = user.address;
          this._loadingAddress = false;
          this._readyForOrder = true;
          this.addresses.forEach((element) {
            if (element.isDefault)
              this.idxSelected = this.addresses.indexOf(element);
          });
        }),
      );
    });
  }

  void selectAddress(int idx) {
    setState(() {
      this.idxSelected = idx;
    });
  }

  void _confirmOrder(context) {
    Order order = Order.fromMenuItems(this._cartBloc.cartItems,
        address: this.addresses[idxSelected],
        bill: this._bill,
        status: "PENDING",
        suggestion: this._suggestion,
        userId: this._user.uid);

    print(order.toString());
    try {
      order.validate();
      setState(() {
        this._shouldShowProgress = true;
      });
      placeOrderService(order).then((value) {
        print(value);
        if (value['status'] == "ok") {
          this._cartBloc.cartEventSink.add(CartClearEvent());
          this._toggleReadyForOrder();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => OrderReview(orderId: value['data'])));
        } else {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(value['data'])));
        }
      });
      // verifyOrderWithServer(order.orderItems).then((updatedItems) {
      //   if (updatedItems.length > 0) {
      //     // update cart with updated Items
      //     var updatedCartList = updateCartListWithUpdatedMenuItems(
      //         updatedItems, this._cartBloc.cartItems);
      //     this
      //         ._cartBloc
      //         .cartEventSink
      //         .add(CartListUpdatedEvent(updatedCartList));

      //     Scaffold.of(context).showSnackBar(SnackBar(
      //       content: Text("Cart items updated. Removed if not available"),
      //     ));
      //     setState(() {
      //       this._readyForOrder = false;
      //       this._shouldShowProgress = false;
      //     });
      //   } else {
      //     // proceed to place order.
      //     upload('orders', order.toJson()).then((docId) {
      //       this._cartBloc.cartEventSink.add(CartClearEvent());
      //       this._toggleReadyForOrder();
      //       order.uid = docId;
      //       delegateMail(this._user, order);
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (ctx) => OrderReview(orderId: docId)));
      //     });
      //   }
      // });
    } on ValidationException catch (err) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(err.message),
      ));
      setState(() {
        this._shouldShowProgress = false;
      });
    }
  }

  @override
  void initState() {
    this._cartBloc = widget.cartBloc;
    this._user = widget.user;
    updateBill();
    super.initState();
  }

  @override
  void didUpdateWidget(CartPage oldWidget) {
    print('widget updated');
    print(oldWidget.cartBloc.cartItems);
    print(widget.cartBloc.cartItems);
    if (oldWidget.cartBloc.cartItems != widget.cartBloc.cartItems) {
      updateBill();
    }
    super.didUpdateWidget(oldWidget);
  }

  double _calcTotal(List<MenuItem> items) {
    return items.where((element) => element.available).fold<double>(
        0.0,
        (previousValue, element) =>
            previousValue +
            element.numOfItem * element.offeredPrice.toDouble());
  }

  double _calcDeliveryCharge(List<MenuItem> items) {
    return deliveryCharge();
  }

  double _calcTaxes(List<MenuItem> items) {
    return taxAmount(this._calcTotal(items));
  }

  double _calcToPay(List<MenuItem> items) {
    return this._calcTotal(items) +
        this._calcDeliveryCharge(items) +
        this._calcTaxes(items);
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    print('should Progress');
    print(_shouldShowProgress);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Column(
              children: List.generate(
                this._cartBloc.cartItems.length,
                (index) => Container(
                  key: Key(index.toString()),
                  margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(2)),
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
                          SizedBox(width: ScreenUtil().setWidth(10.0)),
                          Container(
                            padding: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                  color: this._cartBloc.cartItems[index].nonVeg
                                      ? Colors.red
                                      : Colors.green),
                            ),
                            child: Container(
                              height: ScreenUtil().setHeight(8.0),
                              width: ScreenUtil().setWidth(8.0),
                              decoration: BoxDecoration(
                                  color: this._cartBloc.cartItems[index].nonVeg
                                      ? Colors.red
                                      : Colors.green,
                                  shape: BoxShape.circle),
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(20.0),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                this._cartBloc.cartItems[index].name,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(26),
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87),
                              ),
                              !this._cartBloc.cartItems[index].available
                                  ? Text(
                                      "Not available",
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(20),
                                          fontWeight: FontWeight.w400,
                                          color: Colors.deepOrange),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          AddRemoveButton(
                            width: ScreenUtil().setHeight(150.0),
                            height: ScreenUtil().setHeight(52.0),
                            count: this._cartBloc.cartItems[index].numOfItem,
                            disabled:
                                !this._cartBloc.cartItems[index].available,
                            onDecrease: () => this._decreaseItemCount(
                                this._cartBloc.cartItems[index]),
                            onIncrease: () => this._increaseItemCount(
                                this._cartBloc.cartItems[index]),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(50.0)),
                          Container(
                            width: ScreenUtil().setWidth(75.0),
                            height: ScreenUtil().setWidth(60.0),
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  this._cartBloc.cartItems[index].actualPrice ==
                                              null ||
                                          this
                                                  ._cartBloc
                                                  .cartItems[index]
                                                  .numOfItem ==
                                              0
                                      ? SizedBox(height: 0.0)
                                      : Text(
                                          '₹${(this._cartBloc.cartItems[index].actualPrice * this._cartBloc.cartItems[index].numOfItem)}',
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.black54,
                                              fontSize: ScreenUtil().setSp(20),
                                              fontWeight: FontWeight.w400),
                                        ),
                                  Text(
                                    '₹${(this._cartBloc.cartItems[index].offeredPrice * this._cartBloc.cartItems[index].numOfItem)}',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: ScreenUtil().setSp(24),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(15.0)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          this._cartBloc.cartItems.length > 0
              ? Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(120.0),
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(15.0),
                      vertical: ScreenUtil().setHeight(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.book,
                        color: Colors.black54,
                        size: 28,
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(20.0),
                      ),
                      Flexible(
                        child: TextField(
                          onChanged: (val) => setState(() {
                            this._suggestion = val;
                          }),
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                          ),
                          maxLines: 2,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Write suggestions to the restaurant...',
                            hintStyle: TextStyle(
                              fontFamily: "Poppins-Medium",
                              fontSize: ScreenUtil().setSp(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(160),
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.shopping_basket,
                            color: Colors.orange[400], size: 32),
                        Text(
                          'Add something to cart..',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(24),
                              fontFamily: "Poppins-Medium",
                              color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
          SizedBox(height: ScreenUtil().setHeight(20)),
          this._cartBloc.cartItems.length > 0
              ? BillCard(bill: this._bill, loading: this._billLoading)
              : SizedBox(),
          SizedBox(height: ScreenUtil().setHeight(20)),
          this._readyForOrder
              ? Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(20.0),
                            vertical: ScreenUtil().setHeight(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Builder(builder: (context) {
                              var _list = [
                                ListTile(
                                  title: Center(
                                    child: RaisedButton(
                                      padding: EdgeInsets.zero,
                                      elevation: 0,
                                      color: Colors.orange[300],
                                      onPressed: () async {
                                        await Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    AddressPage()));
                                        fetchAddress();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.zero,
                                        margin: EdgeInsets.zero,
                                        width: ScreenUtil().setWidth(150),
                                        height: ScreenUtil().setHeight(30),
                                        child: Center(
                                          child: Text(
                                            'Add New',
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(20),
                                                fontFamily: "Poppins Medium",
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ];
                              _list = this.addresses.length > 0 ? _list : [];
                              _list.addAll(List.generate(
                                this.addresses.length,
                                (idx) => ListTile(
                                  key: Key(idx.toString()),
                                  enabled: false,
                                  dense: true,
                                  title: Text(
                                    addresses[idx].houseNumber,
                                    style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontWeight: FontWeight.w600,
                                      fontSize: ScreenUtil().setSp(22),
                                    ),
                                  ),
                                  subtitle: Text(
                                    [addresses[idx].area, addresses[idx].city]
                                        .join(", "),
                                    style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontWeight: FontWeight.w600,
                                      fontSize: ScreenUtil().setSp(20),
                                    ),
                                  ),
                                  trailing: RaisedButton(
                                    padding: EdgeInsets.zero,
                                    elevation: 0,
                                    color: idx == idxSelected
                                        ? Colors.grey[100]
                                        : Colors.orange[300],
                                    onPressed: () {
                                      selectAddress(idx);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.zero,
                                      margin: EdgeInsets.zero,
                                      width: ScreenUtil().setWidth(150),
                                      height: ScreenUtil().setHeight(30),
                                      child: Center(
                                        child: Text(
                                          idx == idxSelected
                                              ? 'Selected'
                                              : 'Select',
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(20),
                                              fontFamily: "Poppins Medium",
                                              color: idx == idxSelected
                                                  ? Colors.grey
                                                  : Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                              return ExpansionTile(
                                title: Text(
                                  "Address",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: ScreenUtil().setSp(30),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins-Bold"),
                                ),
                                children: _list,
                              );
                            }),
                            this.addresses.length > 0
                                ? ListTile(
                                    enabled: true,
                                    dense: true,
                                    title: Text(
                                      addresses[idxSelected].houseNumber,
                                      style: TextStyle(
                                        fontFamily: "Poppins-Medium",
                                        fontWeight: FontWeight.w600,
                                        fontSize: ScreenUtil().setSp(22),
                                      ),
                                    ),
                                    subtitle: Text(
                                      [
                                        addresses[idxSelected].area,
                                        addresses[idxSelected].city
                                      ].join(", "),
                                      style: TextStyle(
                                        fontFamily: "Poppins-Medium",
                                        fontWeight: FontWeight.w600,
                                        fontSize: ScreenUtil().setSp(20),
                                      ),
                                    ),
                                    trailing: RaisedButton(
                                      padding: EdgeInsets.zero,
                                      elevation: 0,
                                      color: Colors.grey[100],
                                      onPressed: () {},
                                      child: Container(
                                        padding: EdgeInsets.zero,
                                        margin: EdgeInsets.zero,
                                        width: ScreenUtil().setWidth(150),
                                        height: ScreenUtil().setHeight(30),
                                        child: Center(
                                          child: Text(
                                            'Selected',
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(20),
                                                fontFamily: "Poppins Medium",
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : ListTile(
                                    title: Center(
                                      child: RaisedButton(
                                        padding: EdgeInsets.zero,
                                        elevation: 0,
                                        color: Colors.orange[300],
                                        onPressed: () async {
                                          await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      AddressPage()));
                                          fetchAddress();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.zero,
                                          margin: EdgeInsets.zero,
                                          width: ScreenUtil().setWidth(150),
                                          height: ScreenUtil().setHeight(30),
                                          child: Center(
                                            child: Text(
                                              'Add Address',
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(20),
                                                  fontFamily: "Poppins Medium",
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(25.0)),
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(25.0),
                            vertical: ScreenUtil().setHeight(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Mode Of Payment",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins-Bold"),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(25.0)),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.payment,
                                  color: Colors.black87,
                                ),
                                SizedBox(width: ScreenUtil().setWidth(20)),
                                Text(
                                  "Cash on delivery",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: ScreenUtil().setSp(26),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Poppins-Medium"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(40)),
                      ProgressButton(
                        height: ScreenUtil().setHeight(75),
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(24)),
                        linearGradient: LinearGradient(
                            colors: [Colors.orange[400], Colors.orange[500]]),
                        onTap: () => this._confirmOrder(context),
                        splashColor: Colors.orange[800],
                        progressColor: Colors.orange[700],
                        showProgress: this._shouldShowProgress,
                        text: Text(
                          "CONFIRM",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(32),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          SizedBox(height: ScreenUtil().setHeight(20)),
          !this._readyForOrder && this._cartBloc.cartItems.length > 0
              ? ProgressButton(
                  height: ScreenUtil().setHeight(75),
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(24)),
                  linearGradient: LinearGradient(
                      colors: [Colors.orange[400], Colors.orange[500]]),
                  onTap: () => this.fetchAddress(),
                  splashColor: Colors.orange[800],
                  progressColor: Colors.orange[700],
                  showProgress: this._loadingAddress,
                  text: Text(
                    "CONTINUE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(32),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : SizedBox(),
          SizedBox(height: ScreenUtil().setHeight(180)),
        ],
      ),
    );
  }
}
