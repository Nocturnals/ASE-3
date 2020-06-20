// flutter imports
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final WidgetBuilder devReduxBuilder;

  const HomeScreen({Key key, this.devReduxBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: devReduxBuilder != null ? devReduxBuilder(context) : null,
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Welcome to home page'),
      ),
    );
  }
}