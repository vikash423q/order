import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressButton extends StatefulWidget {
  final double width;
  final double height;
  final EdgeInsets margin;
  final Text text;
  final LinearGradient linearGradient;
  final Color splashColor;
  final bool showProgress;
  final Color progressColor;
  final Function onTap;
  ProgressButton(
      {Key key,
      this.text,
      this.linearGradient,
      this.splashColor,
      this.progressColor,
      this.onTap,
      this.showProgress,
      this.width,
      this.margin,
      this.height})
      : super(key: key);

  @override
  _ProgressButtonState createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> {
  double _width = 0.0;
  double _finalWidth = ScreenUtil().setWidth(600);

  void handleProgress(ProgressButton oldWidget) {
    if (!oldWidget.showProgress && widget.showProgress) {
      setState(() {
        this._width = _finalWidth;
      });
    }
    if (!widget.showProgress) {
      setState(() {
        this._width = 0.0;
      });
    }
  }

  @override
  void didUpdateWidget(ProgressButton oldWidget) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => this.handleProgress(oldWidget));
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          margin: this.widget.margin,
          height: this.widget.height,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: this.widget.linearGradient,
              borderRadius: BorderRadius.all(Radius.circular(7)),
              boxShadow: [
                BoxShadow(
                    color: Color(0xFF6078ea).withOpacity(.3),
                    offset: Offset(0.0, 3.0),
                    blurRadius: 8.0)
              ]),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                widget.onTap();
                // print(widget.showProgress);
                // if (widget.showProgress) {
                //   widget.onTap();
                //   print('setting width as final');
                //   setState(() {
                //     this._width = this._finalWidth;
                //   });
                // }
              },
              splashColor: this.widget.splashColor,
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      widget.showProgress
                          ? AnimatedContainer(
                              decoration: BoxDecoration(
                                color: widget.progressColor,
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(7)),
                              ),
                              width: _width,
                              height: double.infinity,
                              duration: Duration(seconds: 5),
                              curve: Curves.fastOutSlowIn,
                            )
                          : Container(),
                    ],
                  ),
                  Center(child: this.widget.text),
                ],
              ),
            ),
          )),
    );
  }
}
