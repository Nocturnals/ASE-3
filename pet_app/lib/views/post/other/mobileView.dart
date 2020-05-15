import 'package:flutter/material.dart';

import 'package:pet_app/models/post.dart';

import 'fields.dart';

class MobileView extends StatelessWidget {
  final Post post;

  const MobileView({
    Key key,
    @required this.post
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0),
        child: Fields(post: post,)
      ),
    );
  }
}
