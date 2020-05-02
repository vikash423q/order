import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

class FormCard extends StatefulWidget {
  FormCard({Key key}) : super(key: key);

  @override
  _FormCardState createState() => _FormCardState();
}

class _FormCardState extends State<FormCard> {
  bool _showPassword = false;

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
                blurRadius: 10.0)
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Login",
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(45),
                    fontFamily: "Poppins-Bold",
                    letterSpacing: 0.6)),
            SizedBox(height: ScreenUtil().setHeight(30)),
            Text("Email or Phone Number",
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(26),
                    fontFamily: "Poppins-Medium",
                    letterSpacing: 0.6)),
            TextField(
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(10.0))))),
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
                    hintText: "password",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        color: this._showPassword ? Colors.blue : Colors.red,
                        onPressed: this.togglePasswordVisibility))),
            SizedBox(height: ScreenUtil().setHeight(35)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Forget Password?",
                  style: TextStyle(
                      color: Colors.blue,
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil().setSp(28)),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(10.0)),
          ],
        ),
      ),
    );
  }
}
