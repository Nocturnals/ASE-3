import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart' hide WidgetBuilder;

import 'package:pet_app/views/home/homeFeed/mobileView.dart';
import 'package:pet_app/views/home/homeFeed/desktopTabletView.dart';

class HomeFeed extends StatelessWidget {

  const HomeFeed({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ScreenTypeLayout(
          mobile: MobileView(),
          desktop: DestopTabletView(),
          tablet: DestopTabletView(),
        )
      ],
    );
  }
}