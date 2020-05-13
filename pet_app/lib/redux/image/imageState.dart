import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:pet_app/models/loadingStatus.dart';

@immutable
class ImageState {
  final List<File> images;

  /// initialize the auth state with File
  ImageState({
    @required this.images,
  });

  factory ImageState.initialState() {
    return ImageState(
      images: [],
    );
  }

  ImageState copyWith({
    List<File> images,
  }) {
    return ImageState(
      images: images ?? this.images,
    );
  }

  @override
  bool operator == (Object other) => 
    identical(this, other) || 
      other is ImageState && 
        this.runtimeType == other.runtimeType && 
        this.images == other.images;

  @override
  int get hashCode => 
      this.images.hashCode;
}
