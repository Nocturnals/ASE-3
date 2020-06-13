// flutter imports
import 'package:flutter/material.dart';

// internal imports
import 'fields.dart';

class MobileView extends StatelessWidget {
  const MobileView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 20,
      ),
      child: Fields(),
    );
  }
}
