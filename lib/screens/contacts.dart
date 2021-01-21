import 'package:flutter/material.dart';

import 'package:ChatApp/brain.dart';

import 'package:ChatApp/screens/listtile.dart';
import 'package:ChatApp/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Contacts extends StatefulWidget {
  static String id = 'contacts';
  @override
  _ContactsState createState() => _ContactsState();
}

class Constants {
  static const String Logout = 'Logout';

  static const List<String> choices = [
    Logout,
  ];
}

class _ContactsState extends State<Contacts> {
  String searchUser;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  Brain brain = new Brain();
  TextEditingController searchTextEditingController =
      new TextEditingController();
  List<Tile> s = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void choiceAction(String choice) {
    if (choice == Constants.Logout) {
      Navigator.popAndPushNamed(context, Login.id);
    }
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    try {
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              Container(
                child: Text('PROFILE HERE'),
              )
            ],
          ),
        ),
        body: ListView(
          children: [
            Column(
              children: <Widget>[
                Container(
                  height: 130.0,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: 900,
                        height: 100.0,
                        color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              // alignment: Alignment.centerLeft,
                              child: Text(
                                "Conversations",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontFamily: 'CK'),
                              ),
                            ),
                            Container(
                              child: PopupMenuButton(
                                  icon: Icon(
                                    IconData(62530,
                                        fontFamily: 'MaterialIcons'),
                                  ),
                                  onSelected: choiceAction,
                                  itemBuilder: (BuildContext context) {
                                    return Constants.choices
                                        .map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 80.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1.0),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 1.0),
                                color: Colors.white),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.menu,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _scaffoldKey.currentState.openDrawer();
                                  },
                                ),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Search",
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    print("your menu action here");
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.notifications,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    print("your menu action here");
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: s,
                    ),
                  ),
                ),
                StreamBuilder(
                    stream: _firestore.collection('users').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blueAccent,
                          ),
                        );
                      }
                      final names = snapshot.data.docs;
                      List<Tile> contacts = [];
                      for (var name in names) {
                        final userName = name.data()['name'];
                        if (name.data()['email'] != loggedInUser.email) {
                          final tile = Tile(
                              username: userName,
                              sender: loggedInUser.email,
                              reciever: name.data()['email']);
                          contacts.add(tile);
                        }
                      }
                      return Column(
                        children: contacts,
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
