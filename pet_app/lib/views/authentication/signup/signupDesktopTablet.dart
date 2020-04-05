import 'package:flutter/material.dart';

import 'signUpFields.dart';

class SignUpDesktopTablet extends StatelessWidget {
  const SignUpDesktopTablet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: SignUpFields(),
      ),
    );
  }
}
