import 'dart:io';

import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final File image;
  final String pictureUrl;
  final String placeholderImageUri;
  final Function imageGetter;

  ProfilePicture(
      {Key key,
      this.image,
      this.pictureUrl,
      this.placeholderImageUri,
      this.imageGetter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            alignment: Alignment.center,
            child: Stack(
              children: [
                // image
                CircleAvatar(
                  minRadius: 70,
                  backgroundImage: image == null
                      ? (pictureUrl.isEmpty
                          ? AssetImage(
                              placeholderImageUri,
                            )
                          : NetworkImage(
                              pictureUrl,
                            ))
                      : FileImage(
                          image,
                        ),
                ),

                // add/update image
                Positioned(
                    bottom: 5,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: .5,
                              color: Colors.grey.withOpacity(.5),
                              offset: Offset(3, 3),
                            )
                          ]),
                      child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () => imageGetter(),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
