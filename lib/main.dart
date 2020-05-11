import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order/SharedPreferences/utils.dart';
import 'package:order/Widgets/HomePage.dart';
import 'package:order/Widgets/NoConnection.dart';

import 'Widgets/LoginCard.dart';
import 'Widgets/SignUpCard.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/homepage',
      onGenerateRoute: (settings) {
        if (settings.name == '/homepage') {
          final args = settings.arguments;
          return MaterialPageRoute(builder: (context) {
            return HomePage(user: args);
          });
        }
        if (settings.name == '/login') {
          return MaterialPageRoute(builder: (context) {
            return LoginPage();
          });
        }
        if (settings.name == '/noconnection') {
          return MaterialPageRoute(builder: (context) {
            return NoConnection();
          });
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    ));

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _login = true;

  void toggleLogin() => setState(() => this._login = !_login);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
      backgroundColor: Colors.orange[200].withOpacity(0.8),
      resizeToAvoidBottomPadding: true,
      body: Builder(
        builder: (context) => Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 28.0),
                  child: Image.asset(
                    "assets/deliver.png",
                    width: ScreenUtil().setWidth(360),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Image.asset("assets/image_02.png")),
              ],
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image.asset(
                          "assets/logo.png",
                          width: ScreenUtil().setWidth(110),
                          height: ScreenUtil().setHeight(110),
                        ),
                        Text("Order",
                            style: TextStyle(
                                fontFamily: "Poppins-Bold",
                                fontSize: ScreenUtil().setSp(46),
                                letterSpacing: 0.6,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(100)),
                    this._login ? LoginCard() : SignUpCard(),
                    SizedBox(height: ScreenUtil().setHeight(30)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          this._login ? "New User? " : "Already Registered? ",
                          style: TextStyle(fontFamily: "Poppins-Medium"),
                        ),
                        InkWell(
                            onTap: toggleLogin,
                            child: Text(this._login ? "SignUp" : "Login",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: "Poppins-Bold")))
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(30)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
