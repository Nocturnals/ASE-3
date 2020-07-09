import 'package:flutter/material.dart';

import 'package:pet_app/models/post.dart';

import 'fields.dart';

class DestopTabletView extends StatelessWidget {
  final Post post;

  const DestopTabletView({
    Key key,
    @required this.post
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: Fields(post: post,)
        ),
      ),
    );
  }
}