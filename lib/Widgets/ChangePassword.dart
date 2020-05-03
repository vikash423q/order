import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:pin_code_fields/pin_code_fields.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  String _password = '';
  String _confirmPassword = '';

  void togglePasswordVisibility() =>
      setState(() => _showPassword = !_showPassword);

  void toggleConfirmPasswordVisibility() =>
      setState(() => _showConfirmPassword = !_showConfirmPassword);

  @override
  Widget build(BuildContext context) {
    var pageHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          height: pageHeight / 2 * .4,
          width: double.infinity,
          color: Colors.orange[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.grey[700],
                    size: 32.0,
                  ),
                  onPressed: () => Navigator.pop(context)),
              SizedBox(height: ScreenUtil().setHeight(40)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(24.0)),
                child: Text(
                  "CHANGE PASSWORD",
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "Poppins-Bold",
                      fontSize: ScreenUtil().setSp(32)),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(24.0)),
                child: Text(
                  "Create new password",
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: "Poppins-Bold",
                      fontSize: ScreenUtil().setSp(18)),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: ScreenUtil().setHeight(20.0)),
              Text(
                "Enter New Password",
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil().setSp(18)),
              ),
              SizedBox(height: ScreenUtil().setHeight(5.0)),
              TextField(
                obscureText: !this._showPassword,
                decoration: InputDecoration(
                  isDense: true,
                  suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      color: this._showPassword ? Colors.blue : Colors.red,
                      onPressed: this.togglePasswordVisibility),
                ),
                onChanged: (val) => setState(() => this._password = val),
              ),
              SizedBox(height: ScreenUtil().setHeight(35.0)),
              Text(
                "Confirm New Password",
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil().setSp(18)),
              ),
              SizedBox(height: ScreenUtil().setHeight(5.0)),
              TextField(
                obscureText: !this._showConfirmPassword,
                decoration: InputDecoration(
                  isDense: true,
                  suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      color:
                          this._showConfirmPassword ? Colors.blue : Colors.red,
                      onPressed: this.toggleConfirmPasswordVisibility),
                ),
                onChanged: (val) => setState(() => this._confirmPassword = val),
              ),
              SizedBox(height: ScreenUtil().setHeight(60.0)),
              ButtonTheme(
                minWidth: double.infinity,
                height: ScreenUtil().setHeight(75),
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {},
                  child: Text(
                    'CHANGE',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(36),
                        fontFamily: "Poppins-Bold"),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
