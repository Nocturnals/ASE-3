import 'package:flutter/material.dart';

import 'loginFields.dart';

class LoginMobile extends StatelessWidget {
  const LoginMobile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 20,
        ),
        child: LoginFields());
  }
}
