import 'package:flutter/material.dart';

import 'fields.dart';

class MobileView extends StatelessWidget {
  const MobileView({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0),
        child: Fields()
      ),
    );
  }
}
