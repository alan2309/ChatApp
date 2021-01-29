import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vector_math/vector_math_64.dart' as vec;

class MesssageTile extends StatelessWidget {
  final String msg, imgurl;
  final String time;
  final Alignment align;
  final Color color1;
  final Color color2;
  final double left, right;
  MesssageTile(
      {this.imgurl,
      this.msg,
      this.time,
      this.align,
      this.color1,
      this.color2,
      this.left,
      this.right});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: align,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            constraints: BoxConstraints(minWidth: 20, maxWidth: 300),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color1, color2]),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(
                    20,
                  ),
                  bottomLeft: Radius.circular(left),
                  bottomRight: Radius.circular(right)),
            ),
            child: msg != null
                ? Text(
                    msg,
                    style: TextStyle(fontSize: 20),
                  )
                : OnTapZoom(imgurl: imgurl),
          ),
          Positioned(
            child: Container(
              padding: EdgeInsets.only(
                right: 9,
              ),
              child: Text(
                time,
                style: TextStyle(fontSize: 10, color: Colors.black45),
              ),
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}

class OnTapZoom extends StatefulWidget {
  final String imgurl;
  OnTapZoom({this.imgurl});
  @override
  _OnTapZoomState createState() => _OnTapZoomState(imgurl: imgurl);
}

class _OnTapZoomState extends State<OnTapZoom>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(microseconds: 500));
    _animation = Tween(begin: 1.0, end: 3.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)
          ..addListener(() {
            setState(() {});
          }));
  }

  final String imgurl;
  _OnTapZoomState({this.imgurl});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onDoubleTap: () {
          if (_animationController.isCompleted) {
            _animationController.reverse();
          } else {
            _animationController.forward();
          }
        },
        child: Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4.diagonal3(vec.Vector3(
              _animation.value, _animation.value, _animation.value)),
          child: Image.network(
            imgurl,
            width: 200,
            height: 200,
          ),
        ));
  }
}
