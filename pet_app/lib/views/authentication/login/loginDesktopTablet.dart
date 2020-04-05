import 'package:flutter/material.dart';

import 'loginFields.dart';

class LoginDestopTablet extends StatelessWidget {
  const LoginDestopTablet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: LoginFields()
      ),
    );
  }
}
