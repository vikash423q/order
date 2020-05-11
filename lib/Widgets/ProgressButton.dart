import "package:flutter/material.dart";

class ProgressButton extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsets margin;
  final Text text;
  final LinearGradient linearGradient;
  final Color splashColor;
  final bool inProgress;
  final Function onTap;
  ProgressButton(
      {Key key,
      this.text,
      this.linearGradient,
      this.splashColor,
      this.inProgress,
      this.onTap,
      this.width,
      this.margin,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          margin: this.margin,
          height: this.height,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: this.linearGradient,
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
              onTap: this.onTap,
              splashColor: this.splashColor,
              child: Center(child: this.text),
            ),
          )),
    );
  }
}
