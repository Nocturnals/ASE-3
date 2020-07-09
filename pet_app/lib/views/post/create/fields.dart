import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:pet_app/constants/keys.dart';
import 'package:redux/redux.dart';

import 'package:pet_app/redux/state.dart' show AppState;
import 'package:pet_app/models/loadingStatus.dart';
import 'package:pet_app/widgets/loader.dart';

import "./createPostViewModel.dart";

class Fields extends StatefulWidget {
  Fields({Key key}) : super(key: key);

  @override
  _FieldsState createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  /// Active image file
  File _imageFile;
  String fileName;
  LoadingStatus _imageLoaded = LoadingStatus.idle;
  LoadingStatus _loadingStatus = LoadingStatus.idle;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // 
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _description;
  List<String> _mediaUrls;

  @override
  void initState() {
    super.initState();

    _imageFile = null;

    _pickImage(ImageSource.gallery);
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _imageLoaded = LoadingStatus.loading; // set loading
    });

    /// pick image
    File selected = await ImagePicker.pickImage(source: source);

    if (selected != null) {
      setState(() {
        _imageFile = selected;
        fileName = '${DateTime.now()}-${basename(selected.path)}.jpeg';
        _imageLoaded = LoadingStatus.success;
      });
    }
  }

  // Create post submission
  void validateAndSubmit(CreatePostViewModel createPostViewModel) async {
    setState(() {
      _loadingStatus = LoadingStatus.loading;
    });
    // Validate the form and submit
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      // form is valid
      form.save();
      // bool _isValid = await _uploadFile(fileName);
      
      // Call createPost function
      createPostViewModel.create(
        description: _description,
        mediaUrls: _mediaUrls
      );

      setState(() {
        _loadingStatus = LoadingStatus.idle;
      });
    } else {
      setState(() {
        _loadingStatus = LoadingStatus.error;
      });
    }
  }

  // // Upload Image
  // Future<bool> _uploadFile(String fileName) async {
  //   try {
  //     String filePath = 'post_images/$fileName';
  //     // Firebase File Upload variables
  //     final FirebaseStorage _storage = FirebaseStorage(storageBucket: DotEnv().env['storageBucket']);
  //     StorageReference _storageReference = _storage.ref().child(filePath);
  //     // Upload file
  //     StorageUploadTask _uploadTask = _storageReference.putFile(_imageFile);
  //     await _uploadTask.onComplete;
  //     // Set states
  //     _storageReference.getDownloadURL().then((fileUrl) {
  //       setState(() {
  //         _loadingStatus = LoadingStatus.success;
  //         _mediaUrls = [ fileUrl ];
  //       });
  //     });

  //     return true;
  //   } catch (error) {
  //     debugPrint(error);
  //     return false;
  //   }
  // }

  // App Bar
  Widget _appBar(CreatePostViewModel createPostViewModel, BuildContext context) {
    return AppBar(
      leading: FlatButton(
        onPressed: () { Navigator.pop(context); },
        child: Icon(Icons.chevron_left),
      ),
      // Title
      title: Text("New Post"),
      // Share Post
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.file_upload),
          onPressed: () {
            _imageFile != null ? validateAndSubmit(createPostViewModel) :
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text('Select an image to continue.'),
                duration: Duration(seconds: 3),
              )
            );
          }
        )
      ], 
    );
  }

  // Image Picker
  Widget _imagePickerField() {
    print(_imageFile);
    return Container(
      // Preview the image and crop it
      child: _imageFile != null 
        ? // If image selected
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
        : SizedBox(
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
    );
  }

  // description field
  Widget _descriptionField() {
    return TextFormField(
      obscureText: false,
      decoration: InputDecoration(
        border: InputBorder.none,
        fillColor: Color(0xfff3f3f4),
        filled: true,
      ),
      keyboardType: TextInputType.text,
      validator: (value) {
        return null;
      },
      onSaved: (value) {
        _description = value;
      },
    );
  }

  // Build
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CreatePostViewModel> (
      converter: (Store<AppState> store) => CreatePostViewModel.create(store),
      builder: (BuildContext context, CreatePostViewModel createPostViewModel) =>
        createPostViewModel.state.loadingStatus == LoadingStatus.loading
          ? Center(
              child: Loader(),
            )
          : Stack(
              children: <Widget>[
                /// Create Post Widget
                Material(
                  elevation: 0,
                  child: Scaffold(
                    key: _scaffoldKey,
                    appBar: _appBar(createPostViewModel, context),
                    body: Form(
                      key: _formKey,
                      child: ListView(
                        children: <Widget>[
                          // Image Field
                          _imagePickerField(),

                          // Description Text Field
                          _descriptionField(),
                        ],
                      ),
                    )
                  )
                ),


                // // Loading Widget
                // _loadingStatus == LoadingStatus.loading ? 
                // Material(
                //   elevation: 1,
                //   child: SizedBox(
                //     height: MediaQuery.of(context).size.height,
                //     width: MediaQuery.of(context).size.width,
                //     child: Loader()
                //   ),
                // ) : null
              ],
            ),
    );
  }
}