import 'package:ChatApp/button.dart';
import 'package:ChatApp/constants.dart';
import 'package:ChatApp/screens/contacts.dart';
import 'package:ChatApp/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Login extends StatefulWidget {
  static String id = 'login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool _obscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.deepOrange, Colors.yellow]),
        ),
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Stack(
                        alignment: Alignment(0, 0),
                        children: [
                          Positioned(
                            top: 15,
                            child: Icon(
                              Icons.circle,
                              color: Colors.white,
                              size: 200,
                            ),
                          ),
                          Image.asset('assets/images/man.png'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                Stack(
                  children: [
                    Positioned(
                      left: 15.0,
                      bottom: 15,
                      child: Icon(Icons.mail, color: Colors.black54),
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your email'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Stack(
                  children: [
                    Positioned(
                      left: 15.0,
                      bottom: 15,
                      child: Icon(Icons.lock, color: Colors.black54),
                    ),
                    TextField(
                      obscureText: _obscure,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your password'),
                    ),
                    Positioned(
                      right: 0.0,
                      child: IconButton(
                          icon: _obscure
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              if (_obscure)
                                _obscure = false;
                              else
                                _obscure = true;
                            });
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  title: 'Log In',
                  colour: Colors.redAccent,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (user != null) {
                        Navigator.pushNamed(context, Contacts.id);
                      }

                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: kMessageContainerDecoration.copyWith(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Don't have an account?",
              style: TextStyle(color: Colors.black87, fontSize: 15),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, Register.id);
              },
              child: Text(
                'Register',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
