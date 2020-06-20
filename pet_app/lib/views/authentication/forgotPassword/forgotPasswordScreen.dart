// flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// responsive app imports
import 'package:responsive_builder/responsive_builder.dart' hide WidgetBuilder;
import 'package:pet_app/views/authentication/forgotPassword/desktopTabletView.dart';
import 'package:pet_app/views/authentication/forgotPassword/mobileView.dart';

// UI imports
import 'package:pet_app/widgets/cButtons.dart';
import 'package:pet_app/widgets/BezierContainer.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final WidgetBuilder devReduxBuilder;

  const ForgotPasswordScreen({Key key, this.devReduxBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        AlertDialog alertDialog = AlertDialog(
          title: Center(
            child: Text('Are you sure'),
          ),
          content: Text('  want to close the app?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Not Yet'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                // return exit(0);
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
          ],
        );
        return showDialog(
          context: context,
          builder: (_) {
            return alertDialog;
          },
        );
      },
      child: Scaffold(
        endDrawer: devReduxBuilder != null ? devReduxBuilder(context) : null,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                ScreenTypeLayout(
                  mobile: MobileView(),
                  tablet: DesktopTabletView(),
                  desktop: DesktopTabletView(),
                ),
                Positioned(top: 40, left: 0, child: cBackButton(context)),
                Positioned(
                    top: -MediaQuery.of(context).size.height * .15,
                    right: -MediaQuery.of(context).size.width * .4,
                    child: BezierContainer())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
