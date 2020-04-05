import 'package:flutter/material.dart';
import 'package:pet_app/views/authentication/login/desktopTabletView.dart';

import 'package:responsive_builder/responsive_builder.dart';

import 'desktopTabletView.dart';
import 'mobileView.dart';
import 'package:pet_app/widgets/cButtons.dart';
import 'package:pet_app/widgets/BezierContainer.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              ScreenTypeLayout(
                mobile: MobileView(),
                tablet: DestopTabletView(),
                desktop: DesktopTabletView(),
              ),
              Positioned(
                top: 40,
                left: 0,
                child: cBackButton(context),
              ),
              Positioned(
                  top: -MediaQuery.of(context).size.height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer())
            ],
          ),
        ),
      ),
    );
  }
}
