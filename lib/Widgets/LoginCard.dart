import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:order/Bloc/user_bloc.dart';
import 'package:order/Models/user.dart';
import 'package:order/SharedPreferences/utils.dart';
import 'package:the_validator/the_validator.dart';

import 'package:order/Widgets/EnterPhoneNumber.dart';
import 'package:order/Handlers/authorization.dart';

class LoginCard extends StatefulWidget {
  LoginCard({Key key}) : super(key: key);

  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  bool _showPassword = false;

  UserBloc _userBloc = UserBloc();

  String _loginEmail = '';
  String _loginPassword = '';
  var _emailError = null;
  var _passwordError = null;

  void changeLoginEmail(email) => setState(() => this._loginEmail = email);
  void changeLoginPassword(pass) => setState(() => this._loginPassword = pass);

  void togglePasswordVisibility() =>
      setState(() => _showPassword = !_showPassword);

  void _handleLogin(context) async {
    setState(() {
      this._emailError = null;
      this._passwordError = null;
    });
    if (Validator.isEmail(this._loginEmail)) {
      if (Validator.isPassword(this._loginPassword,
          shouldContainCapitalLetter: true,
          shouldContainNumber: true,
          minLength: 5)) {
        // Login Here
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Logging in..')));
        String uid = await loginWithEmail(
            context, this._loginEmail, this._loginPassword);
        User user = await getUserWithUid(uid);
        await putUser(user);
        Navigator.of(context).pushNamedAndRemoveUntil('/homepage', (_) => false,
            arguments: user);
      } else {
        setState(() {
          this._passwordError = 'Invalid password';
        });
      }
    } else {
      setState(() {
        this._emailError = 'Invalid email';
      });
    }
  }

  void signIn(BuildContext context) async {
    AuthCredential credential = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => EnterPhoneNumber(existing: true, phone: '')));
    if (credential == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Login Failed'),
      ));
      return;
    }
    try {
      var user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      User _user = await getUserWithUid(user.uid);
      await putUser(_user);
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/homepage', (_) => false, arguments: _user);
    } on PlatformException catch (error) {
      //TODO Show Snackbar
      print(error);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Error. ${error.message}'),
      ));
    } on Exception catch (e) {}
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
                    padding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                    onPressed: () => this.signIn(context),
                    splashColor: Colors.blue[200],
                    child: Text(
                      "Login with OTP?",
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
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                onChanged: (val) => this.changeLoginEmail(val),
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
                  errorText: this._passwordError,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      color: this._showPassword ? Colors.blue : Colors.red,
                      onPressed: this.togglePasswordVisibility),
                ),
                onChanged: (val) => this.changeLoginPassword(val),
              ),
              SizedBox(height: ScreenUtil().setHeight(15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    padding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => EnterPhoneNumber())),
                    splashColor: Colors.blue[200],
                    child: Text(
                      "Forgot Password?",
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
              onTap: () => this._handleLogin(context),
              child: Center(
                child: Material(
                    color: Colors.transparent,
                    child: Text("LOGIN",
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
