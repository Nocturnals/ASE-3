import 'package:pet_app/redux/image/imageActions.dart';
import 'package:redux/redux.dart';

import 'imageState.dart';

final Function postReducer = combineReducers<ImageState>([
  TypedReducer<ImageState, SetImagesAction>(_setImage),
  TypedReducer<ImageState, ResetImagesAction>(_resetImage),
]);

// SET IMAGE
ImageState _setImage(ImageState state, SetImagesAction action) {
  return state.copyWith(
    images: action.images
  );
}

// RESET IMAGE
ImageState _resetImage(ImageState state, ResetImagesAction action) {
  return state.copyWith(
    images: []
  );
}