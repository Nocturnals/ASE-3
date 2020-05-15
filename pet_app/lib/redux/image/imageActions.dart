import 'dart:io';

import 'package:flutter/foundation.dart';

// SET IMAGE
class SetImagesAction {
  final List<File> images;

  SetImagesAction({ @required this.images });
}
// RESET IMAGE
class ResetImagesAction {
  ResetImagesAction();
}