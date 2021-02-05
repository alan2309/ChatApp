import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ChatApp/screens/viewProfile.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';
import 'package:ChatApp/brain.dart';
import 'package:ChatApp/screens/msgTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'msgTile.dart';
import 'viewProfile.dart';

ScrollController _controller = ScrollController();

class ChatScreen extends StatefulWidget {
  final String sender;
  final String reciever, img, dispName, recieverToken;
  ChatScreen(
      {this.sender,
      this.reciever,
      this.img,
      this.dispName,
      this.recieverToken});
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState(
      sender: sender,
      reciever: reciever,
      img: img,
      recieverToken: recieverToken,
      dispName: dispName);
}

class _ChatScreenState extends State<ChatScreen> {
  final String sender;
  final String reciever, img, dispName, recieverToken;
  TextEditingController messagecontrol = new TextEditingController();
  _ChatScreenState(
      {this.sender,
      this.reciever,
      this.img,
      this.dispName,
      this.recieverToken});

  final _firestore = FirebaseFirestore.instance;
  Brain brain = new Brain();
  File _image;
  String imageUrl;
  Future<void> getImage(ImageSource source) async {
    PickedFile selectedFile = await ImagePicker().getImage(source: source);
    File image = File(selectedFile.path);

    if (image != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxHeight: 700,
          maxWidth: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.amber,
            toolbarTitle: 'Crop Image',
            statusBarColor: Colors.transparent,
            backgroundColor: Colors.white,
          ));

      setState(() {
        _image = cropped;
      });
    }
  }

  Future uploadPic(BuildContext context) async {
    String filename = basename(_image.path);
    Reference fireBaseStorageRef =
        FirebaseStorage.instance.ref().child(filename);
    UploadTask uploadTask = fireBaseStorageRef.putFile(_image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    var downloadUrl = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      imageUrl = downloadUrl.toString();
    });
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 30),
              width: MediaQuery.of(context).size.width,
              height: 90.0,
              color: Colors.red,
              child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ViewProfile(
                        loggedInUser: dispName, sender: reciever, img: img);
                  }));
                },
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
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5000),
                        child: img != null
                            ? Image.network(
                                img,
                                fit: BoxFit.scaleDown,
                              )
                            : Image.asset('assets/images/man.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        dispName,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/images/bg.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: StreamBuilder(
                    stream: _firestore
                        .collection('chats')
                        .orderBy("time", descending: true)
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
                            imgurl: message.data()['imgurl'],
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
                            imgurl: message.data()['imgurl'],
                          );
                          messageBubbles.add(messageBubble);
                        }
                      }
                      return Flexible(
                        child: ListView(
                          reverse: true,
                          controller: _controller,
                          children: messageBubbles,
                        ),
                      );
                    }),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.grey[200],
                child: Row(
                  children: <Widget>[
                    Stack(
                      children: [
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(60)),
                            ),
                            child: TextFormField(
                              onTap: () => _controller
                                  .jumpTo(_controller.position.minScrollExtent),
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
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: IconButton(
                            icon: Icon(
                              Icons.photo_camera,
                              size: 30,
                            ),
                            onPressed: () {
                              getImage(ImageSource.gallery);
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                        child: ClipOval(
                      child: Material(
                        color: Colors.white, // button color
                        child: InkWell(
                          onTap: () async {
                            _controller
                                .jumpTo(_controller.position.minScrollExtent);
                            if (messagecontrol.text != "") {
                              sendNotification(
                                  token: recieverToken,
                                  message: messagecontrol.text,
                                  name: sender);
                              _image = null;
                              DateTime now = new DateTime.now();
                              Map<String, dynamic> chat = {
                                "sender": sender,
                                "reciever": reciever,
                                "message": messagecontrol.text,
                                "time": DateTime.now().millisecondsSinceEpoch,
                                "timedisp":
                                    "${now.hour.toString()}:${now.minute.toString()}",
                                "imgurl": null,
                              };
                              brain.uploadChats(chat);
                              messagecontrol.text = "";
                            } else if (_image != null) {
                              sendNotification(
                                  token: recieverToken,
                                  message: 'YOU RECIEVED AN IMAGE',
                                  name: sender);
                              String imgurl = await uploadPic(context);
                              DateTime now = new DateTime.now();
                              Map<String, dynamic> chat = {
                                "sender": sender,
                                "reciever": reciever,
                                "message": null,
                                "time": DateTime.now().millisecondsSinceEpoch,
                                "timedisp":
                                    "${now.hour.toString()}:${now.minute.toString()}",
                                "imgurl": imgurl,
                              };
                              brain.uploadChats(chat);
                              _image = null;
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

Future<Map<String, dynamic>> sendNotification(
    {String token, String name, String message}) async {
  Brain brain = Brain();
  await http.post(
    'https://fcm.googleapis.com/fcm/send',
    headers: <String, String>{
      'Content-type': 'application/json',
      'Authorization': 'key=${brain.getServerKey()}'
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{'body': message, 'title': name},
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': token,
      },
    ),
  );
}
