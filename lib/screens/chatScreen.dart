import 'package:ChatApp/brain.dart';
import 'package:ChatApp/screens/msgTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'msgTile.dart';

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
  String msg;
  final String sender;
  final String reciever;
  _ChatScreenState({this.sender, this.reciever});

  final _firestore = FirebaseFirestore.instance;
  Brain brain = new Brain();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: setAppBar(reciever),
      body: Stack(
        children: <Widget>[
          Container(
            child: StreamBuilder(
                stream: _firestore.collection('chats').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blueAccent,
                      ),
                    );
                  }
                  final messages = snapshot.data.docs;
                  List<MesssageTile> messageBubbles = [];
                  for (var message in messages) {
                    final messageText = message.data()['message'];
                    if (message.data()['sender'] == sender &&
                        message.data()['reciever'] == reciever) {
                      final messageBubble = MesssageTile(
                        msg: messageText,
                        align: Alignment.centerRight,
                        color1: Colors.blue[600],
                        color2: Colors.lightBlue,
                        left: 20,
                        right: 0,
                      );
                      messageBubbles.add(messageBubble);
                    } else if (message.data()['sender'] == reciever &&
                        message.data()['reciever'] == sender) {
                      final messageBubble = MesssageTile(
                        msg: messageText,
                        align: Alignment.centerLeft,
                        color1: Colors.lightGreen,
                        color2: Colors.green,
                        left: 0,
                        right: 20,
                      );
                      messageBubbles.add(messageBubble);
                    }
                  }
                  return Expanded(
                    child: ListView(
                      children: messageBubbles,
                    ),
                  );
                }),
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
                        onChanged: (value) {
                          msg = value;
                        },
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
                        onTap: () {
                          Map<String, String> chat = {
                            "sender": sender,
                            "reciever": reciever,
                            "message": msg
                          };
                          brain.uploadChats(chat);
                        },
                        splashColor: Colors.red, // inkwell color
                        child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Image.asset('assets/images/arrow.png'),
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

Widget setAppBar(String name) {
  return new AppBar(
    automaticallyImplyLeading: true,
    elevation: 0.0, // for elevation
    titleSpacing: 10.0, // if you want remove title spacing with back button
    title: Text(
      name,
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
