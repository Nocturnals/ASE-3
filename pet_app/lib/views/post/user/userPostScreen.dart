import 'package:flutter/material.dart';

import 'package:pet_app/models/post.dart';

import 'package:responsive_builder/responsive_builder.dart' hide WidgetBuilder;

import 'mobileView.dart';
import 'desktopTabletView.dart'; 

class UserPostScreen extends StatelessWidget {
  final Post post;

  final WidgetBuilder devReduxBuilder;

  const UserPostScreen({
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