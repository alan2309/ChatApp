import 'package:ChatApp/brain.dart';
import 'package:ChatApp/screens/listtile.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  static String id = 'contacts';
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  String searchUser;
  Brain brain = new Brain();
  TextEditingController searchTextEditingController =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 40, right: 20, left: 20),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 5, bottom: 40, top: 50),
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
                  margin: EdgeInsets.only(bottom: 10),
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
                        onTap: () {
                          brain
                              .getUser(searchTextEditingController.text)
                              .then((val) {
                            searchUser = val.toString();
                          });
                        },
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
                Tile(
                  username: searchUser,
                ),
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
