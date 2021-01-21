import 'package:ChatApp/brain.dart';
import 'package:ChatApp/button.dart';
import 'package:ChatApp/screens/listtile.dart';
import 'package:ChatApp/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  static String id = 'contacts';
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  String searchUser;
  var scaffoldKey = GlobalKey<ScaffoldState>();
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
    return Scaffold(
      key: scaffoldKey,
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            RoundedButton(
              onPressed: () {
                Navigator.pushNamed(context, Login.id);
              },
              title: 'Logout',
              colour: Colors.black,
            ),
          ],
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          Container(
            padding: EdgeInsets.only(top: 10, right: 20, left: 20),
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 5, bottom: 20, top: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Conversation',
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'CK',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // button color
                            child: InkWell(
                              onTap: () =>
                                  scaffoldKey.currentState.openDrawer(),

                              splashColor: Colors.red, // inkwell color
                              child: SizedBox(
                                width: 56,
                                height: 56,
                                child: Icon(
                                  IconData(62530, fontFamily: 'MaterialIcons'),
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 30.0,
                        width: 250,
                        child: TextField(
                          controller: searchTextEditingController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search username',
                            hintStyle: TextStyle(
                                color: Colors.black,
                                height: 0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.all(5),
                          child: Image.asset('assets/images/search.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: s,
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
          ),
        ],
      ),
      floatingActionButton: Container(
        height: 80,
        width: 80,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.green[200],
            elevation: 10,
            onPressed: () {},
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
