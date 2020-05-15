import 'package:flutter/material.dart';

import 'package:pet_app/widgets/cButtons.dart';

// App Bar
Widget homeFeedAppBar(BuildContext context) {
  return AppBar(
    centerTitle: true,
    title: cTitle(context),
    backgroundColor: Color(0xfff99100),
  );
}