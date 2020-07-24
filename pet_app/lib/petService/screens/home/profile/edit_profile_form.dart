import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_app/petService/helpers/app_dialogs.dart';
import 'package:pet_app/petService/model/user.dart';
import 'package:pet_app/petService/services/services.dart';
import 'package:pet_app/petService/services/storage/storage_service.dart';
import 'package:pet_app/petService/services/user/user_service.dart';
import 'package:pet_app/petService/widgets/input_field.dart';
import 'package:pet_app/petService/widgets/profile_picture.dart';
import 'package:pet_app/widgets/loader.dart';

class EditProfileForm extends StatefulWidget {
  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  bool _isLoading = false;
  User currentUser;
  bool isInitialized = false;

  final StorageService _storageService = services.get<StorageService>();
  final UserService _userService = services.get<UserService>();

  File _image;
  final _formKey = GlobalKey<FormState>();
  final biographyController = TextEditingController();
  final locationController = TextEditingController();

  Future getImage() async {
    final imageSource = await AppDialogs.chooseImageSource(context);

    if (imageSource != null) {
      final file = await ImagePicker.pickImage(source: imageSource);
      print('file is $file');
      if (file != null) {
        setState(() => _image = file);
      }
    }
  }

  void initProfileForm() {
    currentUser = ModalRoute.of(context).settings.arguments;
    this.biographyController.text = currentUser.bio;
    this.locationController.text = currentUser.location;
  }

  @override
  void dispose() {
    biographyController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isInitialized == false) {
      initProfileForm();
      isInitialized = true;
    }

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            ProfilePicture(
                image: _image,
                pictureUrl: currentUser.pictureUrl,
                placeholderImageUri: "assets/blank_profile.png",
                imageGetter: getImage),
            SizedBox(
              height: 50,
            ),
            InputField(
              controller: biographyController,
              hintText: "About me",
            ),
            InputField(
              controller: locationController,
              hintText: "Location",
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("I want to pet sit"),
                Checkbox(
                  value: currentUser.isPetSitter,
                  onChanged: (newVal) {
                    setState(() {
                      currentUser.isPetSitter = newVal;
                    });
                  },
                )
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text('I provide services for pets'),
              Checkbox(
                value: currentUser.isServiceProvider,
                onChanged: (newVal) {
                  setState(() {
                    currentUser.isServiceProvider = newVal;
                  });
                },
              )
            ]),
            _isLoading
                ? Container(height: 50, width: double.infinity, child: Loader())
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          updateInfo(
                              currentUser,
                              _image,
                              biographyController.text,
                              locationController.text);
                        } else
                          AppDialogs.showAlertDialog(
                              context,
                              "Operation failed",
                              "Please make sure that the inputs are in the correct format!");
                      },
                      child: Text('Save'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void updateInfo(User user, File picture, String bio, String location) async {
    setState(() {
      _isLoading = true;
    });
    user.bio = bio;
    user.location = location;
    if (_image != null) {
      String pictureUrl = await _storageService.uploadPhoto(_image);
      user.pictureUrl = pictureUrl;
      await _userService.updateUser(user);
      Navigator.of(context).pop();
    } else {
      await _userService
          .updateUser(user)
          .whenComplete(() => Navigator.of(context).pop());
    }
    setState(() {
      _isLoading = false;
    });
  }
}
