import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

import "package:order/Widgets/LoginBottomSheet.dart";

class LoginCard extends StatefulWidget {
  LoginCard({Key key}) : super(key: key);

  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  bool _showPassword = false;

  String _user = '';
  String _password = '';

  void togglePasswordVisibility() =>
      setState(() => _showPassword = !_showPassword);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 15.0),
                blurRadius: 15.0),
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -10.0),
                blurRadius: 10.0),
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Login",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(45),
                      fontFamily: "Poppins-Bold",
                      letterSpacing: 0.6),
                ),
                FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                  onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) => buildLoginBottomSheet(ctx)),
                  splashColor: Colors.blue[200],
                  child: Text(
                    "Login with Phone?",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: ScreenUtil().setSp(24),
                        fontFamily: "Poppins-Bold",
                        letterSpacing: 0.6),
                  ),
                )
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(30)),
            Text("Email or Phone Number",
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(26),
                    fontFamily: "Poppins-Medium",
                    letterSpacing: 0.6)),
            TextField(
              decoration: InputDecoration(
                  isDense: true,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              onChanged: (val) => setState(() => this._user = val),
            ),
            SizedBox(height: ScreenUtil().setHeight(30)),
            Text(
              "Password",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(26),
                  fontFamily: "Poppins-Medium",
                  letterSpacing: 0.6),
            ),
            TextField(
              obscureText: !this._showPassword,
              decoration: InputDecoration(
                isDense: true,
                hintText: "password",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                suffixIcon: IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    color: this._showPassword ? Colors.blue : Colors.red,
                    onPressed: this.togglePasswordVisibility),
              ),
              onChanged: (val) => setState(() => this._password = val),
            ),
            SizedBox(height: ScreenUtil().setHeight(15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                  onPressed: () {},
                  splashColor: Colors.blue[200],
                  child: Text(
                    "Forget Password?",
                    style: TextStyle(
                        color: Colors.blue,
                        fontFamily: "Poppins-Bold",
                        fontSize: ScreenUtil().setSp(24),
                        letterSpacing: 0.6),
                  ),
                )
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(10.0)),
          ],
        ),
      ),
    );
  }
}
