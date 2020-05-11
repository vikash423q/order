import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";

import "package:order/Widgets/VerifyOTP.dart";
import "package:order/Handlers/authorization.dart";
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:the_validator/the_validator.dart';

import 'dart:async';

class EnterPhoneNumber extends StatefulWidget {
  bool existing;
  String phone;
  EnterPhoneNumber({Key key, this.existing, this.phone}) : super(key: key);

  @override
  _EnterPhoneNumberState createState() => _EnterPhoneNumberState();
}

class _EnterPhoneNumberState extends State<EnterPhoneNumber> {
  String _phone = "";
  bool _valid = true;
  bool _inProgress = false;
  bool _inputMode = false;
  bool _existingUser;
  String _status = "";
  Color _statusColor = Colors.orange;
  int _timeout = 30;
  Function _userCallback;
  String _verificationId = '';
  String _code = '';
  FocusNode _phoneFocusNode = new FocusNode();

  @override
  void initState() {
    this._existingUser = widget.existing;
    super.initState();

    if (!widget.existing) {
      this._phone = widget.phone;
      this._status = "";
      this._statusColor = Colors.orange;
      this._inProgress = true;
      WidgetsBinding.instance
          .addPostFrameCallback((_) => this._handleSendOTP(context));
    }
  }

  void _verifyCode(BuildContext ctx) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: this._verificationId, smsCode: this._code);
      AuthResult res =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (res.user.uid != null) {
        Navigator.of(ctx).pop(credential);
      } else {
        Navigator.of(ctx).pop();
      }
    } catch (error) {
      //TODO Show Snackbar
      Navigator.of(ctx).pop();
    }
  }

  void _handleSendOTP(BuildContext context) async {
    print('called');
    void onSuccess(var credentials) {
      setState(() {
        this._inputMode = false;
        this._inProgress = true;
        this._statusColor = Colors.blue[300];
        this._status = "OTP verified successfully";
      });
      Navigator.of(context).pop(credentials);
    }

    void onFail(AuthException authException) {
      print("Failed");
      print(authException.code);
      setState(() {
        this._inProgress = false;
        this._statusColor = Colors.red;
        this._inputMode = false;
        this._status = "Failed. ${authException.message}";
      });
    }

    void onSent(var verificationId, var values) {
      print("Sent");
      setState(() {
        this._verificationId = verificationId;
        this._inputMode = true;
        this._inProgress = false;
        this._statusColor = Colors.orange;
        this._status = "OTP sent. Expires in ${this._timeout} seconds";
        this._phoneFocusNode.unfocus();
      });
    }

    void onRetrieval(var verificationId) {
      print("Retrieved");
      print(verificationId);
      // Navigator.of(context).pushReplacement(new MaterialPageRoute(
      //     builder: (ctx) => VerifyOTP(
      //           phone: this._phone,
      //           verificationId: verificationId,
      //           callback: this._userCallback,
      //         )));
      if (verificationId == this._verificationId) {
        setState(() {
          this._status = 'OTP expired. Retry.';
          this._statusColor = Colors.red;
          this._inputMode = false;
          this._verificationId = "";
          this._inProgress = false;
        });
      }
    }

    var phone = this._phone.replaceFirst("+91", "");
    phone = phone.trim();
    if (Validator.isNumber(phone) && phone.length == 10) {
      setState(() {
        this._valid = true;
        this._inProgress = true;
        this._statusColor = Colors.orange;
        this._status = "Sending OTP..";
      });

      try {
        final FirebaseAuth _auth = FirebaseAuth.instance;

        if (this._existingUser) {
          bool exists = await phoneNumberExists(this._phone);
          if (!exists) {
            setState(() {
              this._valid = true;
              this._inProgress = false;
              this._statusColor = Colors.red;
              this._status = "Phone number doesn't exist";
            });
            return;
          }
        }
        await _auth.verifyPhoneNumber(
            phoneNumber: this._phone,
            timeout: Duration(seconds: this._timeout),
            verificationCompleted: (authCredential) =>
                onSuccess(authCredential),
            verificationFailed: (authException) => onFail(authException),
            codeAutoRetrievalTimeout: (verificationId) =>
                onRetrieval(verificationId),
            // called when the SMS code is sent
            codeSent: (verificationId, [code]) =>
                onSent(verificationId, [code]));
      } catch (error) {}
    } else {
      setState(() {
        this._valid = false;
        this._inProgress = false;
        this._inputMode = false;
      });
    }
  }

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
                  "SEND OTP",
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: "Poppins-Bold",
                      fontSize: ScreenUtil().setSp(16)),
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
                "Enter 10 digit mobile number",
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil().setSp(18)),
              ),
              SizedBox(height: ScreenUtil().setHeight(25.0)),
              TextFormField(
                initialValue: this._existingUser ? "+91 " : this._phone,
                autofocus: !this._inputMode,
                focusNode: this._phoneFocusNode,
                enabled: this._existingUser,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  new LengthLimitingTextInputFormatter(14),
                ],
                decoration: InputDecoration(
                    isDense: true,
                    errorText: this._valid ? null : "Invalid mobile number"),
                onChanged: (val) => setState(() => this._phone = val),
              ),
              SizedBox(height: ScreenUtil().setHeight(10.0)),
              Text(
                this._status,
                style: TextStyle(
                    color: this._statusColor,
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil().setSp(20)),
              ),
              this._inputMode
                  ? SizedBox(height: ScreenUtil().setHeight(50.0))
                  : Container(),
              this._inputMode
                  ? PinCodeTextField(
                      length: 6,
                      obsecureText: true,
                      autoFocus: true,
                      animationType: AnimationType.fade,
                      animationDuration: Duration(milliseconds: 300),
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      textInputType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          this._code = value;
                          this._inProgress = false;
                        });
                      },
                    )
                  : SizedBox(height: ScreenUtil().setHeight(0.0)),
              SizedBox(height: ScreenUtil().setHeight(50.0)),
              ButtonTheme(
                minWidth: double.infinity,
                height: ScreenUtil().setHeight(75),
                child: RaisedButton(
                  color: this._inProgress ? Colors.blue[200] : Colors.blue,
                  onPressed: () => !this._inProgress
                      ? this._inputMode
                          ? this._code.length == 6
                              ? this._verifyCode(context)
                              : () {}
                          : this._handleSendOTP(context)
                      : () {},
                  child: Text(
                    this._inputMode ? 'VERIFY' : 'CONTINUE',
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
