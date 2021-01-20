import 'package:ChatApp/screens/msgTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String sender;
  final String reciever;
  ChatScreen({this.sender, this.reciever});
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() =>
      _ChatScreenState(sender: sender, reciever: reciever);
}

class _ChatScreenState extends State<ChatScreen> {
  final String sender;
  final String reciever;
  _ChatScreenState({this.sender, this.reciever});
  List<MesssageTile> texts = [];

  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    messages();
  }

  void messages() async {
    await for (var snapshot in _firestore.collection('chats').snapshots()) {
      for (var chats in snapshot.docs) {
        if (chats.data()['sender'].toString() == sender) {
          texts.add(MesssageTile(
              msg: chats.data()['message'], align: Alignment.centerRight));
        } else if (chats.data()['reciever'].toString() == reciever) {
          texts.add(MesssageTile(
            msg: chats.data()['message'],
            align: Alignment.centerLeft,
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: setAppBar(),
      body: Stack(
        children: <Widget>[
          Container(
            child: ListView(
              children: [
                Column(
                  children: texts,
                ),
              ],
            ),
          ),

          //   height: 100,
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white70,
              child: Row(
                children: <Widget>[
                  Container(
                    height: 50,
                    margin: EdgeInsets.all(10),
                    width: 330,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 30.0,
                      width: 250,
                      alignment: FractionalOffset.bottomLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type Message......',
                          hintStyle: TextStyle(
                              color: Colors.black,
                              height: 0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      child: ClipOval(
                    child: Material(
                      color: Colors.white, // button color
                      child: InkWell(
                        onTap: () {},
                        splashColor: Colors.red, // inkwell color
                        child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Image.asset('assets/images/direct.png'),
                            )),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget setAppBar() {
  return new AppBar(
    automaticallyImplyLeading: true,
    elevation: 0.0, // for elevation
    titleSpacing: 10.0, // if you want remove title spacing with back button
    title: Text(
      'About US',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    leading: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.green[100],
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Image.asset('assets/images/man.png'),
    ),
  );
}
