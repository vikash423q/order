import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyOTP extends StatefulWidget {
  String phone;
  String verificationId;
  Function callback;
  VerifyOTP({Key key, this.phone, this.verificationId, this.callback})
      : super(key: key);

  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  String _code = '';
  String _phone;
  String _verificationId;
  Function _callback;
  bool _complete = false;

  @override
  void initState() {
    this._phone = widget.phone;
    this._verificationId = widget.verificationId;
    this._callback = widget.callback;
    super.initState();
  }

  void verifyCode(BuildContext ctx) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: this._verificationId, smsCode: this._code);
      this._callback(ctx, credential);
    } catch (error) {
      //TODO Show Snackbar
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text('Error. ${error.code}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    print(this._code);
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
                  'OTP send to ${widget.phone}',
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
                length: 6,
                obsecureText: true,
                autoFocus: true,
                animationType: AnimationType.fade,
                animationDuration: Duration(milliseconds: 300),
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                textInputType: TextInputType.number,
                onCompleted: (val) {
                  setState(() {
                    this._complete = true;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    this._code = value;
                    this._complete = value.length == 6;
                  });
                },
              ),
              SizedBox(height: ScreenUtil().setHeight(60.0)),
              ButtonTheme(
                minWidth: double.infinity,
                height: ScreenUtil().setHeight(75),
                child: RaisedButton(
                  color: this._complete ? Colors.blue : Colors.blue[200],
                  onPressed:
                      this._complete ? () => this.verifyCode(context) : () {},
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
