import 'dart:io';
import 'package:flutter/foundation.dart';

@immutable
class Image {
  final File image;

  Image(
      { @required this.image }
  );

  factory Image.initial() {
    return Image( image: null );
  }

  Image copyWith({
    File image
  }) {
    return Image(
      image: image ?? this.image
    );
  }

  Image.fromMap(Map json)
      : image = json['image'];

   Map toMap() => {
    'image': this.image,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Image &&
          this.runtimeType == other.runtimeType &&
          this.image == other.image;

  @override
  int get hashCode =>
      this.image.hashCode;
}
