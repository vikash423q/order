import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

import 'package:order/Bloc/cart_bloc.dart';
import 'package:order/Models/address.dart';
import 'package:order/Models/menu_item.dart';
import 'package:order/Models/order.dart';
import 'package:order/Models/user.dart';
import 'package:order/SharedPreferences/utils.dart';
import 'package:order/Widgets/AddRemoveButton.dart';
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

  void _increaseItemCount(MenuItem item) => setState(() {
        print('in increase Item Count');
        this._readyForOrder = false;
        this
            ._cartBloc
            .cartEventSink
            .add(CartItemAddedEvent(item, fromCart: true));
      });
  void _decreaseItemCount(MenuItem item) => setState(() {
        print('in Decrease item count');
        this._readyForOrder = false;
        this
            ._cartBloc
            .cartEventSink
            .add(CartItemRemovedEvent(item, fromCart: true));
      });

  void _toggleReadyForOrder() =>
      setState(() => this._readyForOrder = !this._readyForOrder);

  void _confirmOrder(context) {
    bool validated = this._formKey.currentState.validate();
    if (!validated) {
      setState(() {
        this._shouldShowProgress = false;
      });
      return;
    } else {
      setState(() {
        this._shouldShowProgress = true;
      });
    }
    this._formKey.currentState.save();
    Order order = Order.fromMenuItems(this._cartBloc.cartItems,
        address: this._address,
        status: "PENDING",
        suggestion: this._suggestion,
        userId: this._user.uid);
    try {
      order.validate();
      verifyOrderWithServer(order.orderItems).then((updatedItems) {
        if (updatedItems.length > 0) {
          // update cart with updated Items
          var updatedCartList = updateCartListWithUpdatedMenuItems(
              updatedItems, this._cartBloc.cartItems);
          this
              ._cartBloc
              .cartEventSink
              .add(CartListUpdatedEvent(updatedCartList));

          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Cart items updated. Removed if not available"),
          ));
          setState(() {
            this._readyForOrder = false;
            this._shouldShowProgress = false;
          });
        } else {
          // proceed to place order.
          upload('orders', order.toJson()).then((docId) {
            this._cartBloc.cartEventSink.add(CartClearEvent());
            this._toggleReadyForOrder();
            order.uid = docId;
            delegateMail(this._user, order);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => OrderReview(orderId: docId)));
          });
        }
      });
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
    formattedDateTime(DateTime.now());
    dateTimefromString(DateTime.now().toString());
    super.initState();
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
              ? Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(25.0),
                      vertical: ScreenUtil().setHeight(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Bill Details',
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: "Poppins-Bold",
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Item Total',
                            style: TextStyle(
                              color: Colors.black54,
                              fontFamily: "Poppins-Medium",
                              fontWeight: FontWeight.w400,
                              fontSize: ScreenUtil().setSp(24),
                            ),
                          ),
                          Text(
                            '₹${this._calcTotal(this._cartBloc.cartItems)}',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil().setSp(24),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenUtil().setHeight(20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Delivery Fee',
                            style: TextStyle(
                              color: Colors.black54,
                              fontFamily: "Poppins-Medium",
                              fontWeight: FontWeight.w400,
                              fontSize: ScreenUtil().setSp(24),
                            ),
                          ),
                          Text(
                            '₹${this._calcDeliveryCharge(this._cartBloc.cartItems)}',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil().setSp(24),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenUtil().setHeight(20)),
                      Divider(height: ScreenUtil().setHeight(2.0)),
                      SizedBox(height: ScreenUtil().setHeight(20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Taxes and Charges (18%)',
                            style: TextStyle(
                              color: Colors.black54,
                              fontFamily: "Poppins-Medium",
                              fontWeight: FontWeight.w400,
                              fontSize: ScreenUtil().setSp(24),
                            ),
                          ),
                          Text(
                            '₹${this._calcTaxes(this._cartBloc.cartItems)}',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil().setSp(24),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenUtil().setHeight(20)),
                      Divider(height: ScreenUtil().setHeight(2.0)),
                      SizedBox(height: ScreenUtil().setHeight(20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'To Pay',
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: "Poppins-Bold",
                              fontWeight: FontWeight.w400,
                              fontSize: ScreenUtil().setSp(26),
                            ),
                          ),
                          Text(
                            '₹${this._calcToPay(this._cartBloc.cartItems)}',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil().setSp(26),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          SizedBox(height: ScreenUtil().setHeight(20)),
          this._readyForOrder
              ? Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(25.0),
                          vertical: ScreenUtil().setHeight(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Address",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(30),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins-Bold"),
                            ),
                            Text(
                              "*Outside ${Constants().restrictedArea} not allowed",
                              style: TextStyle(
                                  color: Colors.orange[400],
                                  fontSize: ScreenUtil().setSp(18),
                                  fontWeight: FontWeight.normal,
                                  fontFamily: "Poppins-Medium"),
                            ),
                            TextFormField(
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                labelText: 'House/Flat No',
                              ),
                              maxLines: 1,
                              validator: (value) => Validator.isRequired(value)
                                  ? null
                                  : "Required Field",
                              onSaved: (val) => this._address.houseNumber = val,
                            ),
                            TextFormField(
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Landmark',
                                ),
                                maxLines: 1,
                                onSaved: (val) => this._address.landmark = val),
                            TextFormField(
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Area',
                                ),
                                validator: (value) =>
                                    Validator.isRequired(value)
                                        ? null
                                        : "Required Field",
                                maxLines: 1,
                                onSaved: (val) => this._address.area = val),
                            TextFormField(
                                initialValue: Constants().allowedPinCode[0],
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLength: 6,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Pin Code',
                                ),
                                validator: (value) => Validator.isNumber(
                                            value) &&
                                        Constants()
                                                .allowedPinCode
                                                .indexOf(value) >=
                                            0 &&
                                        value.length == 6
                                    ? null
                                    : "Should be valid 6 digit value and belong inside the restricted area",
                                maxLines: 1,
                                onSaved: (val) => this._address.zip = val),
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
                      Builder(builder: (context) {
                        rebuildAllChildren(context);
                        return ProgressButton(
                          height: ScreenUtil().setHeight(75),
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(24)),
                          linearGradient: LinearGradient(
                              colors: [Colors.orange[400], Colors.orange[500]]),
                          onTap: () => this._shouldShowProgress
                              ? null
                              : this._confirmOrder(context),
                          splashColor: Colors.orange[800],
                          progressColor: Colors.orange[700],
                          inProgress: this._shouldShowProgress,
                          text: Text(
                            "CONFIRM",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(32),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }),
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
                  onTap: this._toggleReadyForOrder,
                  splashColor: Colors.orange[800],
                  progressColor: Colors.orange[700],
                  inProgress: this._readyForOrder,
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
