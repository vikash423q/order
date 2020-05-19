import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order/Models/menu_item.dart';

import 'package:order/Widgets/FlatDish.dart';

class Category extends StatefulWidget {
  final String categoryName;
  final List<MenuItem> menuitems;
  final Function removeFromCart;
  final Function updateCart;
  Category(
      {Key key,
      this.categoryName,
      this.menuitems,
      this.updateCart,
      this.removeFromCart})
      : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  String _categoryName;
  List<MenuItem> _menuItems;
  Function _updateCart;
  Function _removeFromCart;

  @override
  void initState() {
    this._categoryName = widget.categoryName;
    this._updateCart = widget.updateCart;
    this._menuItems = widget.menuitems;
    this._removeFromCart = widget.removeFromCart;
    super.initState();
  }

  @override
  void didUpdateWidget(Category oldWidget) {
    this._menuItems = widget.menuitems;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(25.0),
          vertical: ScreenUtil().setHeight(25.0)),
      color: Colors.white,
      child: ExpansionTile(
        title: Text(
          this._categoryName,
          style: TextStyle(
              color: Colors.black87,
              fontSize: ScreenUtil().setSp(30),
              fontFamily: "Poppins-Bold",
              fontWeight: FontWeight.w400),
        ),
        children: List.generate(
          this._menuItems.length,
          (index) => FlatDish(
            key: Key(this._menuItems[index].name),
            menuItem: this._menuItems[index],
            updateCart: this._updateCart,
            removeFromCart: this._removeFromCart,
          ),
        ),
      ),
    );
  }
}
