import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressIndicatorButton extends StatefulWidget {
  ProgressIndicatorButton({Key key}) : super(key: key);

  @override
  _ProgressIndicatorButtonState createState() =>
      _ProgressIndicatorButtonState();
}

class _ProgressIndicatorButtonState extends State<ProgressIndicatorButton> {
  double _width = 50.0;
  bool inProgress = false;
  Color _progressColor = Colors.transparent;
  Color _color = Colors.orange;
  ValueNotifier<Size> _size = ValueNotifier<Size>(Size(0, 0));

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// AnimatedContainer(
//               color: _color,
//               width: _width,
//               height: ScreenUtil().setHeight(80),
//               duration: Duration(seconds: 5),
//               curve: Curves.fastOutSlowIn,
//               onEnd: () => setState(
//                 () {
//                   this.inProgress = false;
//                   this._progressColor = Colors.transparent;
//                   this._width = 0.0;
//                 },
//               ),
//             ),

// InkWell(
//       child: Container(
//           margin: this.widget.margin,
//           height: this.widget.height,
//           width: double.infinity,
//           decoration: BoxDecoration(
//               gradient: this.widget.linearGradient,
//               borderRadius: BorderRadius.all(Radius.circular(7)),
//               boxShadow: [
//                 BoxShadow(
//                     color: Color(0xFF6078ea).withOpacity(.3),
//                     offset: Offset(0.0, 3.0),
//                     blurRadius: 8.0)
//               ]),
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: this.widget.onTap,
//               splashColor: this.widget.splashColor,
//               child: Center(child: this.widget.text),
//             ),
//           )),
//     );
