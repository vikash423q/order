import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";

class SignUpCard extends StatefulWidget {
  SignUpCard({Key key}) : super(key: key);

  @override
  _SignUpCardState createState() => _SignUpCardState();
}

class _SignUpCardState extends State<SignUpCard> {
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  String _email = '';
  String _phone = '';
  String _password = '';
  String _confirmPassword = '';

  void togglePasswordVisibility() =>
      setState(() => _showPassword = !_showPassword);

  void toggleConfirmPasswordVisibility() =>
      setState(() => _showConfirmPassword = !_showConfirmPassword);

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
            Text("SignUp",
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(45),
                    fontFamily: "Poppins-Bold",
                    letterSpacing: 0.6)),
            SizedBox(height: ScreenUtil().setHeight(25)),
            Text("Email",
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(26),
                    fontFamily: "Poppins-Medium",
                    letterSpacing: 0.6)),
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                isDense: true,
                hintText: "email",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
              ),
              onChanged: (val) => setState(() => this._email = val),
            ),
            SizedBox(height: ScreenUtil().setHeight(25)),
            Text("Phone",
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(26),
                    fontFamily: "Poppins-Medium",
                    letterSpacing: 0.6)),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                isDense: true,
                hintText: "phone",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
              ),
              onChanged: (val) => setState(() => this._phone = val),
            ),
            SizedBox(height: ScreenUtil().setHeight(25)),
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
            SizedBox(height: ScreenUtil().setHeight(25)),
            Text(
              "Confirm Password",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(26),
                  fontFamily: "Poppins-Medium",
                  letterSpacing: 0.6),
            ),
            TextField(
              obscureText: !this._showConfirmPassword,
              decoration: InputDecoration(
                isDense: true,
                hintText: "confirm password",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                suffixIcon: IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    color: this._showConfirmPassword ? Colors.blue : Colors.red,
                    onPressed: this.toggleConfirmPasswordVisibility),
              ),
              onChanged: (val) => setState(() => this._confirmPassword = val),
            ),
            SizedBox(height: ScreenUtil().setHeight(35))
          ],
        ),
      ),
    );
  }
}
