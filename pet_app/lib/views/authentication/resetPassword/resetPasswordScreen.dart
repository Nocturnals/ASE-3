// flutter imports
import 'package:flutter/material.dart';

// responsive app imports
import 'package:responsive_builder/responsive_builder.dart' hide WidgetBuilder;
import 'package:pet_app/views/authentication/login/desktopTabletView.dart';

// UI imports
import 'package:pet_app/widgets/cButtons.dart';
import 'package:pet_app/widgets/BezierContainer.dart';

// internal imports
import 'desktopTabletView.dart';
import 'mobileView.dart';

class ResetPasswordScreen extends StatelessWidget {
  final WidgetBuilder devReduxBuilder;
  
  const ResetPasswordScreen({Key key, this.devReduxBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: devReduxBuilder != null ? devReduxBuilder(context) : null,
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
