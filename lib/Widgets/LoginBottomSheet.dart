import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

SingleChildScrollView buildLoginBottomSheet(BuildContext context) {
  return SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.orange[200],
        border: Border(top: BorderSide(color: Colors.blue[300], width: 2.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Enter your phone number to continue",
            style: TextStyle(
                color: Colors.black54,
                fontFamily: "Poppins-Medium",
                fontSize: ScreenUtil().setSp(22),
                letterSpacing: 0.8),
          ),
          SizedBox(height: ScreenUtil().setHeight(30)),
          Text(
            "Phone Number",
            style: TextStyle(
                color: Colors.grey[700],
                fontFamily: "Poppins-Bold",
                fontSize: ScreenUtil().setSp(28),
                letterSpacing: 0.8),
          ),
          SizedBox(height: ScreenUtil().setHeight(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(right: 32.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                ),
              )),
              RaisedButton(
                onPressed: () {},
                child: Text("Send OTP"),
                color: Colors.blue[200],
              )
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(35)),
          Center(
            child: Column(
              children: <Widget>[
                Text(
                  "Enter the code sent to ",
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Poppins-Bold",
                      fontSize: ScreenUtil().setSp(24)),
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                PinCodeTextField(
                  length: 4,
                  obsecureText: false,
                  animationType: AnimationType.fade,
                  animationDuration: Duration(milliseconds: 300),
                  borderRadius: BorderRadius.circular(1.0),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  onChanged: (value) {},
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Didn't recieve the code? ",
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: "Poppins-Bold",
                          fontSize: ScreenUtil().setSp(24)),
                    ),
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        "RESEND",
                        style: TextStyle(
                            color: Colors.blue[300],
                            fontFamily: "Poppins-Bold"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                ButtonTheme(
                  minWidth: double.infinity,
                  height: ScreenUtil().setHeight(75),
                  child: RaisedButton(
                    color: Colors.blue[200],
                    onPressed: () {},
                    child: Text(
                      'Verify',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: ScreenUtil().setSp(42),
                          fontFamily: "Poppins-Bold"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
