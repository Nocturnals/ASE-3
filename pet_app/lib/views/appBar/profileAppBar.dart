import 'package:flutter/material.dart';

// App Bar
Widget profileAppBar(BuildContext context, String profilePhotoUrl) {
  // profile photo
  Widget _profilePhotoField(String url) {
    return Container(
      // width: 190.0,
      // height: 190.0,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        image: new DecorationImage(
            fit: BoxFit.fill,
            image: new NetworkImage(url),
        )
      )
    );
  }

  return AppBar(
    leading: _profilePhotoField(profilePhotoUrl),
    title: Text("Profile"),
    backgroundColor: Color(0xfff99100),
  );
}