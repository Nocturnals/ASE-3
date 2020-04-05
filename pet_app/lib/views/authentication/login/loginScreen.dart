import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:responsive_builder/responsive_builder.dart';

import 'package:pet_app/src/signup.dart';
import 'package:pet_app/views/authentication/login/loginMobile.dart';
import 'package:pet_app/views/authentication/login/loginDesktopTablet.dart';

import 'widgets/cButtons.dart';
import 'widgets/bezierContainer.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  Widget _createAccountLabel(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpPage()));
            },
            child: Text(
              'Register',
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
            });
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                ScreenTypeLayout(
                  mobile: LoginMobile(),
                  tablet: LoginDestopTablet(),
                  desktop: LoginDestopTablet(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _createAccountLabel(context),
                ),
                Positioned(top: 40, left: 0, child: cBackButton(context)),
                Positioned(
                  top: -MediaQuery.of(context).size.height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
