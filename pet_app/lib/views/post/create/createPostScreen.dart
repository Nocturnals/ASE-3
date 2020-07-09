import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:responsive_builder/responsive_builder.dart' hide WidgetBuilder;

import 'package:pet_app/views/post/create/mobileView.dart';
import 'package:pet_app/views/post/create/desktopTabletView.dart';

class CreatePostScreen extends StatelessWidget {
  final WidgetBuilder devReduxBuilder;

  const CreatePostScreen({Key key, this.devReduxBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    // Alert dialogue when trying to go back 
    AlertDialog alertDialog = AlertDialog(
      title: Center(
        child: Text('Are you sure'),
      ),
      content: Text('  want to cancel creating post?'),
      actions: <Widget>[
        FlatButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
        ),
        FlatButton(
          child: Text('Yes'),
          onPressed: () {
            // return exit(0);
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
        ),
      ],
    );

    //
    return WillPopScope(
      child: ScreenTypeLayout(
        mobile: MobileView(),
        tablet: DestopTabletView(),
        desktop: DestopTabletView(),
      ),
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (_) { return alertDialog; }
        );
      }
    );
  }
}