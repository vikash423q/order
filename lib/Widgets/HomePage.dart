import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order/Bloc/cart_bloc.dart';
import 'package:order/Bloc/menu_bloc.dart';
import 'package:order/Widgets/AccountPage.dart';
import 'package:order/Widgets/CartPage.dart';
import 'package:order/Widgets/MenuPage.dart';
import 'package:badges/badges.dart';

import 'package:order/Bloc/user_bloc.dart';
import 'package:order/Models/user.dart';
import 'package:order/Models/menu_item.dart';

class HomePage extends StatefulWidget {
  final User user;
  HomePage({Key key, this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserBloc _userBloc = UserBloc();
  CartBloc _cartBloc;

  User _user;
  Color appBarColor = Colors.orange[600];
  int _currentIndex = 0;

  void _changeIndex(val) => setState(() => this._currentIndex = val);

  @override
  void initState() {
    print(widget.user);
    this._user = widget.user;
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

    return Scaffold(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search, color: appBarColor),
              onPressed: this._searchItem),
        ],
      ),
      body: [
        MenuPage(cartBloc: this._cartBloc),
        CartPage(
          cartBloc: this._cartBloc,
          userId: this._user.uid,
        ),
        AccountPage()
      ][this._currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: this._changeIndex, // new
        currentIndex: this._currentIndex, // new
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orange[600],
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            title: Text('Menu'),
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
                        badgeContent: Text(_count.toString()),
                        child: Icon(Icons.shopping_basket),
                      )
                    : Icon(Icons.shopping_basket);
              },
            ),
            title: Text('Cart'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Account'),
          ),
        ],
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

// StreamBuilder<User>(
//         stream: _userBloc.user,
//         builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
//           print(snapshot.data);
//           return Center(
//               child: Column(
//             children: <Widget>[
//               Text(snapshot.data.uid != null ? snapshot.data.uid : ''),
//               Text(snapshot.data.name != null ? snapshot.data.name : ''),
//               Text(snapshot.data.email != null ? snapshot.data.email : ''),
//               Text(snapshot.data.phone != null ? snapshot.data.phone : '')
//             ],
//           ));
//         },
//       )
