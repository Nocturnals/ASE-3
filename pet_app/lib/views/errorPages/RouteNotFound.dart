// flutter imports
import 'package:flutter/material.dart';

class PageNotFoundScreen extends StatelessWidget {
  final WidgetBuilder devReduxBuilder;
  final routeName;
  const PageNotFoundScreen({Key key, @required this.devReduxBuilder, @required this.routeName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route not found'),
      ),
      endDrawer: devReduxBuilder == null ? null : devReduxBuilder(context),
      body: Center(
        child: Text(routeName),
      ),
    );
  }
}