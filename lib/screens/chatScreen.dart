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
  final String sender;
  final String reciever;
  TextEditingController messagecontrol = new TextEditingController();
  _ChatScreenState({this.sender, this.reciever});

  final _firestore = FirebaseFirestore.instance;
  Brain brain = new Brain();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 20),
              width: MediaQuery.of(context).size.width,
              height: 90.0,
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: EdgeInsets.all(2),
                    child: Image.asset('assets/images/man.png'),
                  ),
                  Container(
                    // alignment: Alignment.centerLeft,
                    child: Text(
                      reciever,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontFamily: 'CK'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/fuji.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: StreamBuilder(
                    stream: _firestore
                        .collection('chats')
                        .orderBy("time", descending: false)
                        .snapshots(),
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
                            time: message.data()["timedisp"],
                            msg: messageText,
                            align: Alignment.centerRight,
                            color1: Colors.blue[800],
                            color2: Colors.lightBlue[100],
                            left: 20,
                            right: 0,
                          );
                          messageBubbles.add(messageBubble);
                        } else if (message.data()['sender'] == reciever &&
                            message.data()['reciever'] == sender) {
                          final messageBubble = MesssageTile(
                            time: message.data()["timedisp"],
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
            ),

            //   height: 100,
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.grey[200],
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
                          controller: messagecontrol,
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
                            if (messagecontrol.text != "") {
                              DateTime now = new DateTime.now();
                              Map<String, dynamic> chat = {
                                "sender": sender,
                                "reciever": reciever,
                                "message": messagecontrol.text,
                                "time": DateTime.now().millisecondsSinceEpoch,
                                "timedisp":
                                    "${now.hour.toString()}:${now.minute.toString()}"
                              };
                              brain.uploadChats(chat);
                              messagecontrol.text = "";
                            } else {
                              print("empty");
                            }
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
      ),
    );
  }
}
