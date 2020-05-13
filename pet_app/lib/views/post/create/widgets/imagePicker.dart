import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';

import '../constants.dart';

// import 'package:permission_handler/permission_handler.dart';

/// Widget to capture and crop the image
class ImageCapture extends StatefulWidget {
  ImageCapture({Key key}) : super(key: key);

  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  /// Active image file
  File _imageFile;
  LoadingStatus _imageLoaded = LoadingStatus.idle;

  @override
  void initState() {
    super.initState();

    _pickImage(ImageSource.gallery);
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _imageLoaded = LoadingStatus.loading; // set loading
    });

    /// pick image
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
      _imageLoaded = LoadingStatus.success;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Preview the image and crop it
      body: ListView(
        children: <Widget>[
          _imageFile != null ? [
            // If image selected
            Column(
              children: <Widget>[
                Image.file(_imageFile),
                SizedBox(
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.photo_camera),
                        onPressed: () => _pickImage(ImageSource.camera),
                      ),
                      IconButton(
                        icon: Icon(Icons.photo_library),
                        onPressed: () => _pickImage(ImageSource.gallery),
                      ),
                    ],
                  ),
                )
              ],
            )
            // Uploader(file: _imageFile)
          ] : 
          // If image cannot be selected
          Text("No image selected")
        ],
      ),
    );
  }
}