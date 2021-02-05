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
  final transformationController = TransformationController();
  _ImageViewerState({this.url});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
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
              color: Colors.black87,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InteractiveViewer(
                  transformationController: transformationController,
                  onInteractionEnd: (details) {
                    print('End');
                    setState(() {
                      transformationController.toScene(Offset.zero);
                    });
                  },
                  minScale: 0.1,
                  maxScale: 3,
                  child: Image.network(url),
                ),
              ))),
    );
  }
}
