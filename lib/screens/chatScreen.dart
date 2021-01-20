import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String sender;
  final String reciever;
  ChatScreen({this.sender, this.reciever});
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Center(child: Text("Chat Page")),
            ),
          ),
        ],
      ),
    );
  }
}
