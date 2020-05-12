import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order/Models/menu_item.dart';
import 'package:order/Widgets/AddRemoveButton.dart';
import 'package:shimmer/shimmer.dart';

class Dish extends StatefulWidget {
  final MenuItem menuItem;
  final Function updateCart;
  final Function removeFromCart;
  final bool loading;
  Dish(
      {Key key,
      this.menuItem,
      this.updateCart,
      this.removeFromCart,
      this.loading})
      : super(key: key);

  @override
  _DishState createState() => _DishState();
}

class _DishState extends State<Dish> {
  MenuItem _menuItem;
  Function _updateCart;
  Function _removeFromCart;
  bool _loading = false;

  void _increaseItemCount() => setState(() {
        print('in increaseItemCOunt');
        this._menuItem.numOfItem++;
        this._updateCart(this._menuItem);
      });
  void _decreaseItemCount() => setState(() {
        print('in decreaseItemCount');
        this._menuItem.numOfItem--;
        this._removeFromCart(this._menuItem);
      });

  @override
  void initState() {
    this._menuItem = widget.menuItem;
    this._loading = widget.loading == null ? false : widget.loading;
    this._updateCart = widget.updateCart;
    this._removeFromCart = widget.removeFromCart;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_loading);
    return _loading
        ? shimmer(_loading)
        : Container(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(13.0),
                vertical: ScreenUtil().setHeight(10.0)),
            width: ScreenUtil().setWidth(340.0),
            height: ScreenUtil().setHeight(400.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Stack(
                    children: <Widget>[
                      Image.network(
                        this._menuItem.imageUrl,
                        width: ScreenUtil().setWidth(340),
                        height: ScreenUtil().setHeight(200),
                        fit: BoxFit.cover,
                      ),
                      !this._menuItem.available
                          ? Container(
                              width: ScreenUtil().setWidth(340),
                              height: ScreenUtil().setHeight(200),
                              color: Color.fromARGB(160, 0, 0, 0),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(8.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      this._menuItem.cuisine,
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    !this._menuItem.available
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
                SizedBox(height: ScreenUtil().setHeight(8.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: this._menuItem.nonVeg
                                ? Colors.red
                                : Colors.green),
                      ),
                      child: Container(
                        height: ScreenUtil().setHeight(8.0),
                        width: ScreenUtil().setWidth(8.0),
                        decoration: BoxDecoration(
                            color: this._menuItem.nonVeg
                                ? Colors.red
                                : Colors.green,
                            shape: BoxShape.circle),
                      ),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(12.0)),
                    Text(
                      this._menuItem.name,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(26),
                          fontWeight: FontWeight.normal,
                          color: Colors.black87),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(40)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          "₹${(this._menuItem.offeredPrice)}",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: ScreenUtil().setSp(24),
                              fontWeight: FontWeight.w400),
                        ),
                        this._menuItem.actualPrice != null
                            ? Text(
                                "₹${(this._menuItem.actualPrice)}",
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.black54,
                                    fontSize: ScreenUtil().setSp(20),
                                    fontWeight: FontWeight.w400),
                              )
                            : SizedBox(height: 0.0),
                      ],
                    ),
                    AddRemoveButton(
                      width: ScreenUtil().setHeight(150.0),
                      height: ScreenUtil().setHeight(52.0),
                      disabled: !this._menuItem.available,
                      count: this._menuItem.numOfItem,
                      onDecrease: this._decreaseItemCount,
                      onIncrease: this._increaseItemCount,
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}

Widget shimmer(bool loading) {
  return Container(
    padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(13.0),
        vertical: ScreenUtil().setHeight(10.0)),
    width: ScreenUtil().setWidth(340.0),
    height: ScreenUtil().setHeight(400.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          child: Stack(
            children: <Widget>[
              Shimmer.fromColors(
                baseColor: Colors.grey[100],
                highlightColor: Colors.grey[300],
                enabled: loading,
                child: Container(
                  color: Colors.white,
                  width: ScreenUtil().setWidth(340),
                  height: ScreenUtil().setHeight(200),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(8.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              enabled: loading,
              child: Container(
                color: Colors.white,
                height: ScreenUtil().setHeight(15.0),
                width: ScreenUtil().setWidth(100),
              ),
            ),
          ],
        ),
        SizedBox(height: ScreenUtil().setHeight(8.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              enabled: loading,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(2.0),
                child: Container(
                  height: ScreenUtil().setHeight(10.0),
                  width: ScreenUtil().setWidth(10.0),
                  decoration: BoxDecoration(shape: BoxShape.circle),
                ),
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(12.0)),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              enabled: loading,
              child: Container(
                color: Colors.white,
                height: ScreenUtil().setHeight(25.0),
                width: ScreenUtil().setWidth(150),
              ),
            ),
          ],
        ),
        SizedBox(height: ScreenUtil().setHeight(40)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              enabled: loading,
              child: Container(
                color: Colors.white,
                height: ScreenUtil().setHeight(25.0),
                width: ScreenUtil().setWidth(80),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[100],
              highlightColor: Colors.grey[300],
              enabled: loading,
              child: Container(
                  color: Colors.white,
                  width: ScreenUtil().setHeight(150.0),
                  height: ScreenUtil().setHeight(52.0)),
            ),
          ],
        ),
      ],
    ),
  );
}
