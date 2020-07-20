// flutter imports
import 'package:flutter/material.dart';

// UI imports
import 'package:pet_app/widgets/loader.dart';

// internal imports
import './registerPage/registerForm.dart';

class BabySitterScreen extends StatelessWidget {
  final WidgetBuilder devReduxBuilder;
  const BabySitterScreen({Key key, @required this.devReduxBuilder})
      : super(key: key);

  Future<void> getUserisregister() async {
    // TODO: implement the checking for if the user is registered as babysitter
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BabySitter'),
      ),
      endDrawer: devReduxBuilder == null ? null : devReduxBuilder(context),
      body: RegisterForm(),
    );
  }
}
