import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:order/Models/menu_item.dart';
import 'package:order/Widgets/AddRemoveButton.dart';

class FlatDish extends StatefulWidget {
  MenuItem menuItem;
  Function updateCart;
  final Function removeFromCart;

  FlatDish({Key key, this.menuItem, this.updateCart, this.removeFromCart})
      : super(key: key);

  @override
  _FlatDishState createState() => _FlatDishState();
}

class _FlatDishState extends State<FlatDish> {
  MenuItem _menuItem;
  Function _updateCart;
  Function _removeFromCart;

  void _increaseItemCount() => setState(() {
        this._menuItem.numOfItem++;
        this._updateCart(this._menuItem);
      });
  void _decreaseItemCount() => setState(() {
        this._menuItem.numOfItem--;
        this._removeFromCart(this._menuItem);
      });

  @override
  void initState() {
    this._menuItem = widget.menuItem;
    this._updateCart = widget.updateCart;
    this._removeFromCart = widget.removeFromCart;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        width: ScreenUtil().setHeight(200),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                    color: this._menuItem.nonVeg ? Colors.red : Colors.green),
              ),
              child: Container(
                height: ScreenUtil().setHeight(8.0),
                width: ScreenUtil().setWidth(8.0),
                decoration: BoxDecoration(
                    color: this._menuItem.nonVeg ? Colors.red : Colors.green,
                    shape: BoxShape.circle),
              ),
            ),
            SizedBox(width: ScreenUtil().setHeight(20.0)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  this._menuItem.name,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(26),
                      fontWeight: FontWeight.normal,
                      color: Colors.black87),
                ),
                Row(
                  children: <Widget>[
                    this._menuItem.actualPrice > this._menuItem.offeredPrice
                        ? Text(
                            "₹${this._menuItem.actualPrice}",
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.black54,
                                fontSize: ScreenUtil().setSp(20),
                                fontWeight: FontWeight.w400),
                          )
                        : SizedBox(),
                    SizedBox(width: ScreenUtil().setHeight(10.0)),
                    Text(
                      "₹${this._menuItem.offeredPrice}",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: ScreenUtil().setSp(24),
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                !this._menuItem.available
                    ? Text(
                        'Not available',
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
      ),
      trailing: AddRemoveButton(
        width: ScreenUtil().setHeight(150.0),
        height: ScreenUtil().setHeight(52.0),
        count: this._menuItem.numOfItem,
        disabled: !this._menuItem.available,
        onDecrease: this._decreaseItemCount,
        onIncrease: this._increaseItemCount,
      ),
    );
  }
}
