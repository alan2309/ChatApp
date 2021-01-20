import 'package:flutter/material.dart';

class MesssageTile extends StatelessWidget {
  final String msg;
  final Alignment align;
  MesssageTile({this.msg, this.align});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: align,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [const Color(0xff007ef4), const Color(0xff2a75bc)]),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(
                20,
              ),
              bottomLeft: Radius.circular(20)),
        ),
        child: Text(
          msg,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
