import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:pet_app/models/loadingStatus.dart';
import 'package:pet_app/redux/state.dart';
import 'package:pet_app/views/authentication/login/message.dart';
import 'package:redux/redux.dart';
import 'package:responsive_builder/responsive_builder.dart' hide WidgetBuilder;

import 'package:pet_app/views/authentication/login/mobileView.dart';
import 'package:pet_app/views/authentication/login/desktopTabletView.dart';

import 'package:pet_app/widgets/cButtons.dart';
import 'package:pet_app/widgets/BezierContainer.dart';

class LoginScreen extends StatelessWidget {
  final WidgetBuilder devReduxBuilder;

  const LoginScreen({Key key, this.devReduxBuilder}) : super(key: key);

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
              Navigator.pushNamed(context, '/signup');
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
          },
        );
      },
      child: StoreConnector<AppState, MessageViewModel>(
        converter: (Store<AppState> store) => MessageViewModel.create(store),
        builder: (BuildContext context, MessageViewModel messageViewModel) {
          // if message exists clear is after some time
          if (messageViewModel.state.loadingStatus == LoadingStatus.error) {
            Future.delayed(const Duration(milliseconds: 50), () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Center(
                        child: Text('Error'),
                      ),
                      content: Text(messageViewModel.state.errorMessage),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            messageViewModel.resetMessage();
                            Navigator.of(context, rootNavigator: true).pop('dialog');
                          },
                          child: Text('Retry'),
                        )
                      ],
                    );
                  });
            });
          }

          // return the sceen
          return Scaffold(
            endDrawer:
                devReduxBuilder != null ? devReduxBuilder(context) : null,
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: <Widget>[
                    ScreenTypeLayout(
                      mobile: MobileView(),
                      tablet: DestopTabletView(),
                      desktop: DestopTabletView(),
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
          );
        },
      ),
    );
  }
}
