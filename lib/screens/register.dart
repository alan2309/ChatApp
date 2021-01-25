import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:ChatApp/button.dart';
import 'package:ChatApp/constants.dart';
import 'package:ChatApp/screens/contacts.dart';
import 'package:ChatApp/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ChatApp/brain.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Register extends StatefulWidget {
  static String id = 'register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;
  Brain brain = new Brain();
  bool showSpinner = false;
  String email;
  String password;
  String username;
  bool _obscure = true;
  File _image;
  String imageUrl;
  Future<void> getImage() async {
    File images = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = images;
    });
  }

  Future uploadPic(BuildContext context) async {
    String filename = basename(_image.path);
    Reference fireBaseStorageRef =
        FirebaseStorage.instance.ref().child(filename);
    UploadTask uploadTask = fireBaseStorageRef.putFile(_image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    var downloadUrl = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      imageUrl = downloadUrl;
      print(imageUrl);
    });
  }

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
                      child: (_image != null)
                          ? CircleAvatar(
                              radius: 100,
                              backgroundColor: Colors.transparent,
                              child: Image.file(_image))
                          : Stack(
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
                                Positioned(
                                  left: 80,
                                  bottom: 40,
                                  child: Icon(
                                    Icons.add_circle,
                                    size: 40,
                                  ),
                                )
                              ],
                            ),
                    ),
                  ),
                ),
                RoundedButton(
                  title: 'Add Photo',
                  colour: Colors.redAccent,
                  onPressed: () async {
                    getImage();
                  },
                ),
                SizedBox(
                  height: 48.0,
                ),
                Stack(
                  children: [
                    Positioned(
                      left: 15.0,
                      bottom: 15,
                      child: Icon(Icons.person, color: Colors.black54),
                    ),
                    TextField(
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        username = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter Username'),
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
                  title: 'Register',
                  colour: Colors.redAccent,
                  onPressed: () async {
                    uploadPic(context);
                    Map<String, dynamic> userData = {
                      "name": username,
                      "email": email,
                      "ppurl": imageUrl
                    };
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newUser != null) {
                        Navigator.pushNamed(context, Contacts.id);
                        brain.uploadUser(userData);
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
            Text('Already have an account?',
                style: TextStyle(color: Colors.black54)),
            FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, Login.id);
              },
              child: Text(
                'Log In',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
