import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order/Bloc/cart_bloc.dart';
import 'package:order/Bloc/menu_bloc.dart';
import 'package:order/Models/menu_item.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:order/Widgets/CategoryCard.dart';
import 'package:order/Widgets/Dish.dart';

class MenuPage extends StatefulWidget {
  CartBloc cartBloc;
  MenuPage({Key key, this.cartBloc}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final MenuBloc _menuBloc = MenuBloc();
  String _phone = "+91 7686885294";
  CartBloc _cartBloc;
  bool _onlyVeg = false;

  void updateCart(MenuItem item) {
    this._cartBloc.cartEventSink.add(CartItemAddedEvent(item));
  }

  void removeFromCart(MenuItem item) {
    this._cartBloc.cartEventSink.add(CartItemRemovedEvent(item));
  }

  List<MenuItem> updateMenuItems(List<MenuItem> items) {
    print('updating');
    for (var idx = 0; idx < items.length; idx++) {
      for (var jdx = 0; jdx < this._cartBloc.cartItems.length; jdx++) {
        if (items[idx].uid == this._cartBloc.cartItems[jdx].uid) {
          items[idx] = this._cartBloc.cartItems[jdx];
        }
      }
    }
    return items;
  }

  @override
  void initState() {
    this._cartBloc = widget.cartBloc;
    this._menuBloc.menuEventSink.add(MenuRefreshEvent());
    super.initState();
  }

  @override
  void dispose() {
    _menuBloc.dispose();
    super.dispose();
  }

  List<Dish> recommended(List<MenuItem> items) {
    var selectedItems;
    if (this._onlyVeg) {
      selectedItems = items
          .where((e) => e.recommended & !e.nonVeg)
          .map((e) => Dish(
                key: Key(items.indexOf(e).toString()),
                updateCart: updateCart,
                menuItem: e,
                removeFromCart: this.removeFromCart,
              ))
          .toList();
    } else {
      selectedItems = items
          .where((e) => e.recommended)
          .map((e) => Dish(
                key: Key(items.indexOf(e).toString()),
                menuItem: e,
                updateCart: updateCart,
                removeFromCart: this.removeFromCart,
              ))
          .toList();
    }
    return selectedItems;
  }

  Widget categories(List<MenuItem> data) {
    Map<String, List<MenuItem>> cats = {};
    for (MenuItem item in data) {
      for (String cat in item.category) {
        if (!cats.containsKey(cat)) {
          cats[cat] = List<MenuItem>();
        }
        cats[cat].add(item);
      }
    }
    List<Widget> widgets = List<Widget>();
    cats.forEach((el, _list) {
      widgets.add(SizedBox(height: ScreenUtil().setHeight(15.0)));
      widgets.add(Category(
          categoryName: el,
          menuitems: _list,
          updateCart: updateCart,
          removeFromCart: removeFromCart));
    });
    return Column(children: widgets);
  }

  void _toggleVeg(bool val) => setState(() {
        this._onlyVeg = val;
        if (val) {
          this._cartBloc.cartEventSink.add(CartNonVegItemReset());
          this._menuBloc.menuEventSink.add(MenuNonVegItemResetEvent());
        }
      });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
        initialData: <MenuItem>[],
        stream: this._menuBloc.menu,
        builder: (context, AsyncSnapshot<List<MenuItem>> snapshot) {
          List<MenuItem> items = this.updateMenuItems(snapshot.data);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(30.0),
                    vertical: ScreenUtil().setHeight(0.0)),
                decoration: _boxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/food.jpg',
                      width: double.infinity,
                      height: ScreenUtil().setHeight(240.0),
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: ScreenUtil().setHeight(30.0)),
                    Text(
                      "Mom's Kitchen",
                      style: TextStyle(
                          color: Colors.black87,
                          fontFamily: "Poppins-Bold",
                          fontSize: ScreenUtil().setSp(42)),
                    ),
                    Text(
                      "Lakshmi Layout Road, JP Nagar",
                      style: TextStyle(
                          color: Colors.black54,
                          fontFamily: "Poppins-Medium",
                          fontSize: ScreenUtil().setSp(20)),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          this._phone,
                          style: TextStyle(
                              color: Colors.black54,
                              fontFamily: "Poppins-Medium",
                              fontSize: ScreenUtil().setSp(20)),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.call,
                            size: 16,
                            color: Colors.green,
                          ),
                          onPressed: () => launch("tel://${this._phone}"),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(40.0)),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(15.0)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(25.0),
                    vertical: ScreenUtil().setHeight(25.0)),
                decoration: _boxDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "VEG ONLY",
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(22),
                              fontFamily: "Poppins-Bold"),
                        ),
                        Switch(
                          value: this._onlyVeg,
                          onChanged: this._toggleVeg,
                          activeColor: Colors.green[500],
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20.0)),
                    Divider(
                      height: 5.0,
                      thickness: 1.0,
                    ),
                    SizedBox(height: ScreenUtil().setHeight(40.0)),
                    Text(
                      'Recommended',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: ScreenUtil().setSp(30),
                          fontFamily: "Poppins-Bold",
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(25.0)),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      physics: ScrollPhysics(),
                      childAspectRatio: 4 / 5,
                      children: recommended(items),
                    ),
                  ],
                ),
              ),
              categories(items),
            ],
          );
        },
      ),
    );
  }
}

BoxDecoration _boxDecoration() {
  return BoxDecoration(
    color: Colors.white,
    // boxShadow: [
    //   BoxShadow(
    //     color: Colors.grey,
    //     blurRadius: 0.0,
    //     spreadRadius: 0.0,
    //     offset: Offset(0.0, 0.5), // shadow direction: bottom right
    //   ),
    // ],
  );
}
