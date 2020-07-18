import 'package:flutter/material.dart';

class BabySitterScreen extends StatelessWidget {
  final WidgetBuilder devReduxBuilder;
  const BabySitterScreen({Key key, @required this.devReduxBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BabySitter'),
      ),
      endDrawer: devReduxBuilder == null ? null : devReduxBuilder(context),
      body: Center(
        child: Text('Babysitter'),
      ),
    );
  }
}
