import 'package:flutter/material.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:order/Models/bill.dart';
import 'package:shimmer/shimmer.dart';

class BillCard extends StatefulWidget {
  final Bill bill;
  final bool loading;
  BillCard({Key key, this.bill, this.loading}) : super(key: key);

  @override
  _BillCardState createState() => _BillCardState();
}

class _BillCardState extends State<BillCard> {
  Bill _bill;
  bool _loading;

  @override
  void initState() {
    this._bill = widget.bill;
    this._loading = widget.loading;
    super.initState();
  }

  @override
  void didUpdateWidget(BillCard oldWidget) {
    this._bill = widget.bill;
    this._loading = widget.loading;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.loading
        ? shimmer()
        : Container(
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
                      '₹${this._bill.total}',
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
                      '₹${this._bill.delivery}',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil().setSp(24),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: List.generate(
                      this._bill.discounts.length,
                      (idx) => Column(
                            children: <Widget>[
                              SizedBox(height: ScreenUtil().setHeight(20)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '${this._bill.discounts[idx]['name']} (${this._bill.discounts[idx]['rate']})',
                                    style: TextStyle(
                                      color: Colors.green[400],
                                      fontFamily: "Poppins-Medium",
                                      fontWeight: FontWeight.w400,
                                      fontSize: ScreenUtil().setSp(24),
                                    ),
                                  ),
                                  Text(
                                    '- ₹${this._bill.discounts[idx]['value']}',
                                    style: TextStyle(
                                      color: Colors.green[400],
                                      fontWeight: FontWeight.w500,
                                      fontSize: ScreenUtil().setSp(24),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: ScreenUtil().setHeight(20)),
                            ],
                          )),
                ),
                Divider(height: ScreenUtil().setHeight(2.0)),
                this._bill.tax > 0
                    ? Column(
                        children: <Widget>[
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
                                '₹${this._bill.tax}',
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
                        ],
                      )
                    : Container(),
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
                      '₹${this._bill.toPay}',
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
          );
  }
}

Widget shimmer() {
  return Container(
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
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              enabled: true,
              child: Container(
                color: Colors.white,
                height: ScreenUtil().setHeight(30.0),
                width: ScreenUtil().setWidth(200),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              enabled: true,
              child: Container(
                color: Colors.white,
                height: ScreenUtil().setHeight(25.0),
                width: ScreenUtil().setWidth(100),
              ),
            ),
          ],
        ),
        SizedBox(height: ScreenUtil().setHeight(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              enabled: true,
              child: Container(
                color: Colors.white,
                height: ScreenUtil().setHeight(30.0),
                width: ScreenUtil().setWidth(200),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              enabled: true,
              child: Container(
                color: Colors.white,
                height: ScreenUtil().setHeight(25.0),
                width: ScreenUtil().setWidth(100),
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
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              enabled: true,
              child: Container(
                color: Colors.white,
                height: ScreenUtil().setHeight(30.0),
                width: ScreenUtil().setWidth(200),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              enabled: true,
              child: Container(
                color: Colors.white,
                height: ScreenUtil().setHeight(25.0),
                width: ScreenUtil().setWidth(100),
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
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              enabled: true,
              child: Container(
                color: Colors.white,
                height: ScreenUtil().setHeight(30.0),
                width: ScreenUtil().setWidth(200),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              enabled: true,
              child: Container(
                color: Colors.white,
                height: ScreenUtil().setHeight(25.0),
                width: ScreenUtil().setWidth(100),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
