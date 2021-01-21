import 'package:flutter/material.dart';

class MesssageTile extends StatelessWidget {
  final String msg;
  final Alignment align;
  final Color color1;
  final Color color2;
  final double left, right;
  MesssageTile(
      {this.msg, this.align, this.color1, this.color2, this.left, this.right});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: align,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Container(
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
        child: Text(
          msg,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
