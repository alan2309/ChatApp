import 'package:ChatApp/screens/chatScreen.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final String url;
  ImageViewer({this.url});
  @override
  _ImageViewerState createState() => _ImageViewerState(url: url);
}

class _ImageViewerState extends State<ImageViewer> {
  final String url;
  _ImageViewerState({this.url});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, ChatScreen.id);
          },
        ),
      ),
      body: Center(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Image.network(url),
      )),
    );
  }
}
