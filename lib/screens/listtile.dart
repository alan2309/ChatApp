import 'package:ChatApp/screens/chatScreen.dart';
import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final String username;
  final String sender, reciever, img;
  Tile({this.username, this.sender, this.reciever, this.img});
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatScreen(
            sender: sender,
            reciever: reciever,
            img: img,
            dispName: username,
          );
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
          border: Border.all(color: Colors.black54),
        ),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          title: Text(username),
          subtitle: Text('sub'),
          leading: Container(
            height: 50,
            width: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5000),
              child: img != null
                  ? Image.network(
                      img,
                      fit: BoxFit.scaleDown,
                    )
                  : Image.asset('assets/images/man.png'),
            ),
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
      ),
    );
  }
}
