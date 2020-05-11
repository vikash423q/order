import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddRemoveButton extends StatelessWidget {
  final int count;
  final double width;
  final double height;
  final Function onIncrease;
  final Function onDecrease;
  final bool disabled;
  AddRemoveButton(
      {Key key,
      this.count,
      this.onIncrease,
      this.onDecrease,
      this.disabled,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = this.disabled == null || !this.disabled
        ? Colors.transparent
        : Colors.grey[300];

    return Container(
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.grey[400]),
      ),
      child: this.count == 0
          ? Center(
              child: RaisedButton(
                color: Colors.transparent,
                elevation: 0.0,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: this.disabled ? () {} : this.onIncrease,
                child: Text(
                  "ADD",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(24),
                    color: Colors.green[300],
                  ),
                ),
              ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: this.disabled ? () {} : this.onDecrease,
                  child: Container(
                    height: double.infinity,
                    width: ScreenUtil().setWidth(50),
                    child: Center(
                      child: Text(
                        "-",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: ScreenUtil().setSp(40),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.zero,
                  width: ScreenUtil().setWidth(40.0),
                  height: double.infinity,
                  child: Center(
                    child: Text(
                      this.count.toString(),
                      style: TextStyle(
                          color: Colors.green[300],
                          fontSize: ScreenUtil().setSp(24),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                InkWell(
                  onTap: this.disabled ? () {} : this.onIncrease,
                  child: Container(
                    height: double.infinity,
                    width: ScreenUtil().setWidth(50),
                    child: Center(
                      child: Text(
                        "+",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: ScreenUtil().setSp(40),
                          color: Colors.green[300],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
