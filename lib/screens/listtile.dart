import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
        border: Border.all(color: Colors.black54),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text('username'),
        subtitle: Text('sub'),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(40),
          ),
          padding: EdgeInsets.all(5),
          child: Image.asset('assets/images/man.png'),
        ),
        trailing: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(40),
          ),
          padding: EdgeInsets.all(0),
          child: Image.asset('assets/images/arrow.png'),
        ),
      ),
    );
  }
}
