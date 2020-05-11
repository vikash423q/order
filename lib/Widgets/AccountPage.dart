import 'package:flutter/material.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:order/Handlers/utils.dart';
import 'package:order/Models/order.dart';
import 'package:order/Models/user.dart';
import 'package:order/SharedPreferences/utils.dart';
import 'package:order/Widgets/OrderReview.dart';
import 'package:order/constants.dart';
import 'package:share/share.dart';
import 'package:order/Widgets/ProgressButton.dart';

class AccountPage extends StatefulWidget {
  User user;
  AccountPage({Key key, this.user}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  User _user;
  int _limit = 3;
  bool _alert = false;
  bool _loading = true;
  bool _all = false;
  List<Order> _orders = List<Order>();

  void logOut(context) {
    removeUser().then((value) =>
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false));
  }

  void increaseLimit() {
    setState(() {
      this._loading = true;
    });
    fetchOrderWithLimit(this._user.uid, this._limit + 3)
        .then((orders) => setState(() {
              if (this._orders.length == orders.length) {
                this._all = true;
              }
              if (orders.length > this._orders.length) {
                this._limit += 3;
                this._orders = orders;
              }
            }));
  }

  Widget horizontalLine() {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(3.0),
      color: Colors.black87,
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
    );
  }

  @override
  void initState() {
    this._user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(30.0),
                vertical: ScreenUtil().setHeight(40)),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "My Account",
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "Poppins-Bold",
                      fontSize: ScreenUtil().setSp(28)),
                ),
                SizedBox(height: ScreenUtil().setHeight(30)),
                Divider(),
                SizedBox(height: ScreenUtil().setHeight(20)),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    highlightColor: Colors.orange[400],
                    onTap: () {
                      Share.share(Constants().appShareLink);
                    },
                    child: Text(
                      "Share with friends",
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontFamily: "Poppins-Medium",
                          fontWeight: FontWeight.w400,
                          fontSize: ScreenUtil().setSp(24)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(75)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "PAST ORDERS",
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: ScreenUtil().setSp(20),
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(20)),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(30.0),
                vertical: ScreenUtil().setHeight(0)),
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Column(
                  children: List.generate(
                    this._orders.length,
                    (idx) => InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) =>
                                  OrderReview(orderId: this._orders[idx].uid))),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: ScreenUtil().setHeight(50)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    this
                                        ._orders[idx]
                                        .address
                                        .houseNumber
                                        .trim(),
                                    style: TextStyle(
                                      fontFamily: "Poppins-Bold",
                                      fontSize: ScreenUtil().setSp(22),
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    this._orders[idx].address.area.trim(),
                                    style: TextStyle(
                                      fontFamily: "Poppins-Medium",
                                      fontSize: ScreenUtil().setSp(18),
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: ScreenUtil().setHeight(20)),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "₹ " +
                                            this._orders[idx].total.toString(),
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(24),
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black45,
                                        ),
                                      ),
                                      SizedBox(width: ScreenUtil().setWidth(5)),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Colors.black26,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: ScreenUtil().setHeight(20)),
                                ],
                              )
                            ],
                          ),
                          Divider(height: 4, thickness: 1),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          Column(
                            children: List.generate(
                              this._orders[idx].orderItems.length,
                              (i) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      this._orders[idx].orderItems[i].name +
                                          " x ${this._orders[idx].orderItems[i].quantity}",
                                      style: TextStyle(
                                        fontFamily: "Poppins-Medium",
                                        fontSize: ScreenUtil().setSp(22),
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          Divider(height: 4, thickness: 1),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                formattedDateTime(this._orders[idx].createdOn),
                                style: TextStyle(
                                  fontFamily: "Poppins-Medium",
                                  fontSize: ScreenUtil().setSp(20),
                                  color: Colors.black38,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenUtil().setHeight(30)),
                          horizontalLine(),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                      onPressed: this.increaseLimit,
                      child: Text(
                          "${this._all ? "NO" : "VIEW"} ${this._orders.length > 0 ? "MORE" : "PAST"} ORDERS",
                          style: TextStyle(
                            color: Colors.orange[500],
                            fontFamily: "Poppins-Bold",
                            fontSize: ScreenUtil().setSp(24),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(50)),
          InkWell(
            onTap: () async {
              await showDialog(
                context: this.context,
                child: new AlertDialog(
                  content: Text("Are you sure you want to logout?"),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.orange[400],
                              fontSize: ScreenUtil().setSp(26),
                              fontFamily: "Poppins-Bold"),
                        )),
                    FlatButton(
                        onPressed: () => this.logOut(context),
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              color: Colors.orange[400],
                              fontSize: ScreenUtil().setSp(28),
                              fontFamily: "Poppins-Bold"),
                        ))
                  ],
                ),
              );
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(30.0),
                  vertical: ScreenUtil().setHeight(30)),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "LOGOUT",
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontFamily: "Poppins-Bold",
                        fontSize: ScreenUtil().setSp(32),
                        fontWeight: FontWeight.w400),
                  ),
                  Icon(
                    Icons.settings_power,
                    color: Colors.grey[800],
                    size: 24,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(320)),
        ],
      ),
    );
  }
}
