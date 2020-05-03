import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:pin_code_fields/pin_code_fields.dart';

import "package:order/Widgets/ChangePassword.dart";

class VerifyOTP extends StatefulWidget {
  VerifyOTP({Key key}) : super(key: key);

  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
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
                  "VERIFY DETAILS",
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
                  "OTP send to 7686885294",
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
                "Enter OTP",
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil().setSp(18)),
              ),
              SizedBox(height: ScreenUtil().setHeight(25.0)),
              PinCodeTextField(
                length: 4,
                obsecureText: false,
                animationType: AnimationType.fade,
                animationDuration: Duration(milliseconds: 300),
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                textInputType: TextInputType.number,
                borderRadius: BorderRadius.circular(1.0),
                fieldHeight: 50,
                fieldWidth: 40,
                onChanged: (value) {},
              ),
              SizedBox(height: ScreenUtil().setHeight(60.0)),
              ButtonTheme(
                minWidth: double.infinity,
                height: ScreenUtil().setHeight(75),
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => ChangePassword())),
                  child: Text(
                    'VERIFY',
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
