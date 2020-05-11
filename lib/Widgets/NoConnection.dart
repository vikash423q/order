import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoConnection extends StatelessWidget {
  const NoConnection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Center(
              child: Container(
                  padding: EdgeInsets.only(top: 0),
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.link_off, color: Colors.grey, size: 60),
                      Text(
                        "Oops.. No Connection",
                        style: TextStyle(
                            fontFamily: "Poppins-Medium",
                            fontSize: ScreenUtil().setSp(36),
                            color: Colors.black45),
                      ),
                      OutlineButton(
                          color: Colors.orange[400],
                          child: Text(
                            "Try again",
                            style: TextStyle(color: Colors.orange[400]),
                          ),
                          onPressed: () => Navigator.pop(context)),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
