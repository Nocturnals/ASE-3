// flutter imports
import 'package:flutter/material.dart';

// internal imports
import 'fields.dart';

class DesktopTabletView extends StatelessWidget {
  const DesktopTabletView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: Fields(),
      ),
    );
  }
}
