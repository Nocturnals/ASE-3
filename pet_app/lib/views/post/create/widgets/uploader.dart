import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:firebase_storage/firebase_storage.dart';

class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  @override
  void initState() async {
    super.initState();

    // load the dot env file varaibles
    await DotEnv().load('.env');
  }

  final FirebaseStorage _storage = FirebaseStorage(storageBucket: DotEnv().env['storageBucket']);

  StorageUploadTask _uploadTask;

  String fileName = '${DateTime.now()}.jpeg';

  void _uploadFile() {
    String filePath = 'post_images/$fileName';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }  

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {

      /// Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder: (_, snapshot) {
          var event = snapshot?.data?.snapshot;

          double progressPercent = event != null
              ? event.bytesTransferred / event.totalByteCount
              : 0;

          return Column(
            children: [
              // Progress bar
              LinearProgressIndicator(value: progressPercent),
              Text(
                '${(progressPercent * 100).toStringAsFixed(2)} % '
              ),
            ],
          );
        }
      );     
    } else SizedBox(height: 0,);
  }
}