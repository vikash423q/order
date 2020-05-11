import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order/Bloc/cart_bloc.dart';
import 'package:order/Bloc/menu_bloc.dart';
import 'package:order/Handlers/authorization.dart';
import 'package:order/SharedPreferences/utils.dart';
import 'package:order/Widgets/AccountPage.dart';
import 'package:order/Widgets/CartPage.dart';
import 'package:order/Widgets/MenuPage.dart';
import 'package:badges/badges.dart';

import 'package:order/Bloc/user_bloc.dart';
import 'package:order/Models/user.dart';
import 'package:order/Models/menu_item.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  final User user;
  HomePage({Key key, this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserBloc _userBloc = UserBloc();
  CartBloc _cartBloc;
  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _subscription;

  void onConnectivityChange(ConnectivityResult result) {
    // print(result);
    // switch (result) {
    //   case ConnectivityResult.wifi:
    //   case ConnectivityResult.mobile:
    //     Navigator.pop(context, '/homepage');
    //     break;
    //   case ConnectivityResult.none:
    //     Navigator.pushNamed(context, '/noconnection');
    //     break;
    //   default:
    //     Navigator.pushNamed(context, '/noconnection');
    //     break;
    // }
    // TODO: Show snackbar, etc if no connectivity
  }

  User _user;
  Color appBarColor = Colors.orange[600];
  int _currentIndex = 0;

  void _changeIndex(val) => setState(() => this._currentIndex = val);

  @override
  void initState() {
    if (this._user == null || this._user.name == null) {
      print('reading user');
      readUser().then((value) {
        print(value.toJson());
        if (value.uid != null && value.name != null) {
          setState(() {
            this._user = value;
          });
        } else if (value.uid == null) {
          Navigator.pushNamed(context, '/login');
        } else {
          print('calling server');
          getUserWithUid(value.uid).then((value) {
            print(value.toJson());
            if (value.uid == null) {
              Navigator.pushNamed(context, '/login');
            } else {
              setState(() => this._user = value);
            }
          });
        }
      });
    }
    this._cartBloc = CartBloc();
    _userBloc.userEventSink.add(UserChangedEvent(this._user));
    super.initState();
  }

  @override
  void dispose() {
    this._userBloc.dispose();
    this._cartBloc.dispose();
    super.dispose();
  }

  void _searchItem() {}

  int _getCartItemsCount(snapshot) => snapshot.data
      .map((e) => e.numOfItem)
      .fold(0, (value, element) => value + element);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    return this._user == null
        ? Container()
        : Scaffold(
            backgroundColor: Colors.grey[200],
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () => this._changeIndex(1),
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.all(Radius.circular(7.0))),
            //   child: Container(
            //     width: ScreenUtil().setWidth(60.0),
            //     height: ScreenUtil().setHeight(40.0),
            //     decoration: BoxDecoration(
            //       shape: BoxShape.rectangle,
            //     ),
            //   ),
            // ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 1,
              leading: Icon(
                Icons.person_outline,
                color: appBarColor,
              ),
              title: Text(
                this._user.name,
                style: TextStyle(
                  color: appBarColor,
                  fontSize: 16,
                ),
              ),
              actions: <Widget>[],
            ),
            body: [
              MenuPage(cartBloc: this._cartBloc),
              CartPage(
                cartBloc: this._cartBloc,
                user: this._user,
              ),
              AccountPage(user: this._user)
            ][this._currentIndex], // new
            bottomNavigationBar: BottomNavigationBar(
              onTap: this._changeIndex, // new
              currentIndex: this._currentIndex, // new
              backgroundColor: Colors.white,
              selectedItemColor: Colors.orange[600],
              items: [
                new BottomNavigationBarItem(
                  icon: Icon(Icons.fastfood),
                  title: Text(
                    'Menu',
                    style: TextStyle(
                        fontFamily: "Poppins-Bold",
                        fontSize: ScreenUtil().setSp(20)),
                  ),
                ),
                new BottomNavigationBarItem(
                  icon: StreamBuilder(
                    initialData: <MenuItem>[],
                    stream: this._cartBloc.cartList,
                    builder: (context, AsyncSnapshot<List<MenuItem>> snapshot) {
                      int _count = this._getCartItemsCount(snapshot);
                      return _count > 0
                          ? Badge(
                              badgeColor: Colors.orange[400],
                              badgeContent: Text(
                                _count.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              child: Icon(Icons.shopping_basket),
                            )
                          : Icon(Icons.shopping_basket);
                    },
                  ),
                  title: Text(
                    'Cart',
                    style: TextStyle(
                        fontFamily: "Poppins-Bold",
                        fontSize: ScreenUtil().setSp(20)),
                  ),
                ),
                new BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  title: Text(
                    'Account',
                    style: TextStyle(
                        fontFamily: "Poppins-Bold",
                        fontSize: ScreenUtil().setSp(20)),
                  ),
                ),
              ],
            ),
          );
  }
}
