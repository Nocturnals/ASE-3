import 'package:flutter/material.dart';

import 'package:pet_app/models/post.dart';

import 'package:responsive_builder/responsive_builder.dart' hide WidgetBuilder;

import 'package:pet_app/views/post/other/mobileView.dart';
import 'package:pet_app/views/post/other/desktopTabletView.dart'; 

class PostScreen extends StatelessWidget {
  final Post post;

  final WidgetBuilder devReduxBuilder;

  const PostScreen({
    Key key,
    @required this.post, 
    this.devReduxBuilder
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: MobileView(post: post,),
      tablet: DestopTabletView(post: post,),
      desktop: DestopTabletView(post: post,),
    );
  }
}