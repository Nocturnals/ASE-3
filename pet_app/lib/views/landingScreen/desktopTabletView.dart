// flutter imports
import 'package:flutter/material.dart';


// internal imports
import 'fields.dart';

class DesktopTabletView extends StatelessWidget {
  const DesktopTabletView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 200),
        child: Fields()
      ),
    );
  }
}
