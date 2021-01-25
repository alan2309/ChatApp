import 'package:ChatApp/brain.dart';
import 'package:ChatApp/screens/contacts.dart';
import 'package:ChatApp/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  static String id = "editProfile";
  final User loggedInUser;
  Profile({this.loggedInUser});
  @override
  _ProfileState createState() => _ProfileState(loggedInUser: loggedInUser);
}

class _ProfileState extends State<Profile> {
  final User loggedInUser;
  _ProfileState({this.loggedInUser});
  Widget textfield({String hintText, TextEditingController controller}) {
    return Material(
        elevation: 4,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                letterSpacing: 2,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
              fillColor: Colors.white30,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none)),
        ));
  }

  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  TextEditingController repass = new TextEditingController();
  Brain brain = new Brain();
  @override
  void initState() {
    super.initState();
    getProfile();
  }

  void getProfile() async {
    email.text = loggedInUser.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF555555),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                painter: HeaderCurvedContainer(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text('EDIT PROFILE',
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 4,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 5),
                        shape: BoxShape.circle,
                        color: Colors.white,
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage('assets/images/man.png'))),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 450,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            textfield(
                                hintText: 'Username', controller: username),
                            textfield(hintText: 'Email', controller: email),
                            textfield(hintText: 'Password', controller: pass),
                            textfield(
                              hintText: 'Confirm password',
                            ),
                            Container(
                              height: 55,
                              width: double.infinity,
                              child: RaisedButton(
                                onPressed: () {
                                  Map<String, String> info = {
                                    "name": username.text,
                                    "email": email.text
                                  };
                                  if (loggedInUser.email == email.text) {
                                    brain.updateUser(loggedInUser.email, info);
                                    Navigator.popAndPushNamed(
                                        context, Contacts.id);
                                  } else {
                                    loggedInUser.updateEmail(email.text);
                                    brain.updateUser(loggedInUser.email, info);
                                    Navigator.popAndPushNamed(
                                        context, Login.id);
                                  }
                                },
                                color: Colors.black54,
                                child: Center(
                                    child: Text(
                                  'Update',
                                  style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.white,
                                  ),
                                )),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 270, left: 184),
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xFF555555);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
