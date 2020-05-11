import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:order/Bloc/user_bloc.dart';
import 'package:order/Models/user.dart';
import 'package:order/Widgets/EnterPhoneNumber.dart';
import 'package:the_validator/the_validator.dart';

import 'package:order/Handlers/authorization.dart';
import 'package:order/SharedPreferences/utils.dart';

class SignUpCard extends StatefulWidget {
  SignUpCard({Key key}) : super(key: key);

  @override
  _SignUpCardState createState() => _SignUpCardState();
}

class _SignUpCardState extends State<SignUpCard> {
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  UserBloc _userBloc = UserBloc();

  String _signUpName = '';
  String _signUpEmail = '';
  String _signUpPhone = '+91 ';
  String _signUpPassword = '';
  String _signUpConfirmPassword = '';
  var _nameError = null;
  var _emailError = null;
  var _phoneError = null;
  var _passwordError = null;
  var _confirmPasswordError = null;

  void changeSignUpName(name) => setState(() => this._signUpName = name);
  void changeSignUpEmail(email) => setState(() => this._signUpEmail = email);
  void changeSignUpPhone(phone) => setState(() => this._signUpPhone = phone);
  void changeSignUpPassword(pass) =>
      setState(() => this._signUpPassword = pass);
  void changeSignUpConfirmPassword(pass) =>
      setState(() => this._signUpConfirmPassword = pass);

  void togglePasswordVisibility() =>
      setState(() => _showPassword = !_showPassword);

  void toggleConfirmPasswordVisibility() =>
      setState(() => _showConfirmPassword = !_showConfirmPassword);

  void signUpCallback(BuildContext context) async {
    final AuthCredential credential =
        await Navigator.of(context).push(new MaterialPageRoute(
            builder: (ctx) => EnterPhoneNumber(
                  existing: false,
                  phone: this._signUpPhone,
                )));
    print(credential);
    if (credential == null) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Phone verification failed. Try again.')));
      return;
    }
    try {
      bool isRegistered = await registerNewUser(context, this._signUpName,
          this._signUpEmail, this._signUpPhone, this._signUpPassword);
      if (isRegistered) {
        //linkphone
        String uid = await linkPhoneWithUser(
            this._signUpEmail, this._signUpPassword, credential);
        print(uid);
        if (uid != null) {
          await put_uid(uid);
          User user = await getUserWithUid(uid);
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/homepage', (_) => false,
              arguments: user);
        } else {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('Phone could not be linked. Try again.')));
        }
      } else {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed. Try again.')));
      }
    } on PlatformException catch (error) {} catch (e) {}
  }

  void _handleSignUp(context) async {
    setState(() {
      this._nameError = null;
      this._phoneError = null;
      this._passwordError = null;
      this._confirmPasswordError = null;
      this._emailError = null;
    });
    if (this._signUpName.length > 3) {
      if (Validator.isEmail(this._signUpEmail)) {
        if (Validator.isPassword(
          this._signUpPassword,
          shouldContainCapitalLetter: true,
          shouldContainNumber: true,
          minLength: 5,
        )) {
          var phone = this._signUpPhone.replaceFirst("+91", "");
          phone = phone.trim();
          if (Validator.isNumber(phone) && phone.length == 10) {
            if (Validator.isEqualTo(
                this._signUpPassword, this._signUpConfirmPassword)) {
              bool isValid = await validateEmailAndPhone(
                  context, this._signUpEmail, this._signUpPhone);
              if (isValid) {
                this.signUpCallback(context);
              }
            } else {
              setState(() {
                this._confirmPasswordError = "Passwords don't match";
              });
            }
          } else {
            setState(() {
              this._phoneError = "Enter 10 digit mobile number";
            });
          }
        } else {
          setState(() {
            this._passwordError =
                "Invalid Password. Must have a capital and num and 5 digits long";
          });
        }
      } else {
        setState(() {
          this._emailError = "Invalid email";
        });
      }
    } else {
      setState(() {
        this._nameError = "Invalid Name. Must be more than 3 characters";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
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
              Text("Name",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(26),
                      fontFamily: "Poppins-Medium",
                      letterSpacing: 0.6)),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "name",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                  errorText: this._nameError,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                onChanged: (val) => this.changeSignUpName(val),
              ),
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
                  errorText: this._emailError,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                onChanged: (val) => this.changeSignUpEmail(val),
              ),
              SizedBox(height: ScreenUtil().setHeight(25)),
              Text("Phone",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(26),
                      fontFamily: "Poppins-Medium",
                      letterSpacing: 0.6)),
              TextFormField(
                keyboardType: TextInputType.number,
                maxLength: 14,
                initialValue: '+91 ',
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "phone",
                  counterText: "",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                  errorText: this._phoneError,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
                onChanged: (val) => this.changeSignUpPhone(val),
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
                  errorText: this._passwordError,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      color: this._showPassword ? Colors.blue : Colors.red,
                      onPressed: this.togglePasswordVisibility),
                ),
                onChanged: (val) => this.changeSignUpPassword(val),
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
                  errorText: this._confirmPasswordError,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      color:
                          this._showConfirmPassword ? Colors.blue : Colors.red,
                      onPressed: this.toggleConfirmPasswordVisibility),
                ),
                onChanged: (val) => this.changeSignUpConfirmPassword(val),
              ),
              SizedBox(height: ScreenUtil().setHeight(35))
            ],
          ),
        ),
      ),
      SizedBox(height: ScreenUtil().setHeight(40)),
      InkWell(
        child: Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(80),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF17ead9), Color(0xFF6078ea)]),
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: [
                BoxShadow(
                    blurRadius: 8.0,
                    offset: Offset(0.0, 8.0),
                    color: Color(0xFF6078ea).withOpacity(.3))
              ]),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => this._handleSignUp(context),
              child: Center(
                child: Material(
                    color: Colors.transparent,
                    child: Text("SIGNUP",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins-Bold",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0))),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
