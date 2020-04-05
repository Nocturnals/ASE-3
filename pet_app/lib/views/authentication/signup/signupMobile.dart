import 'package:flutter/material.dart';

import 'signUpFields.dart';

class SignUpMobile extends StatelessWidget {
  const SignUpMobile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 20,
      ),
      child: SignUpFields(),
    );
  }
}
