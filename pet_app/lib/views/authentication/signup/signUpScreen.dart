import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:responsive_builder/responsive_builder.dart' hide WidgetBuilder;

import 'package:pet_app/views/authentication/signup/desktopTabletView.dart';
import 'package:pet_app/views/authentication/signup/mobileView.dart';
import 'package:pet_app/widgets/bezierContainer.dart';
import 'package:pet_app/widgets/cButtons.dart';

class SignUpScreen extends StatelessWidget {
  final WidgetBuilder devReduxBuilder;


  const SignUpScreen({Key key, this.devReduxBuilder}) : super(key: key);

  Widget _loginAccountLabel(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/login');
            },
            child: Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _loginAccountLabel(context),
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
