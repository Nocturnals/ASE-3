import 'package:pet_app/models/loadingStatus.dart';
import 'package:redux/redux.dart';

import 'homeFeedState.dart';
import 'homeFeedActions.dart';

final Function homeFeedReducer = combineReducers<HomeFeedState>([
  // GET LOGGED USER POSTS
  TypedReducer<HomeFeedState, GetLoggedUserHomeFeedRequestAction>(_getLoggedUserHomeFeedRequest),
  TypedReducer<HomeFeedState, GetLoggedUserHomeFeedSuccessAction>(_getLoggedUserHomeFeedSuccess),
  TypedReducer<HomeFeedState, GetLoggedUserHomeFeedFailedAction>(_getLoggedUserHomeFeedFailed),

  // GET GUEST USER POSTS
  TypedReducer<HomeFeedState, GetGuestUserHomeFeedRequestAction>(_getGuestUserHomeFeedRequest),
  TypedReducer<HomeFeedState, GetGuestUserHomeFeedSuccessAction>(_getGuestUserHomeFeedSuccess),
  TypedReducer<HomeFeedState, GetGuestUserHomeFeedFailedAction>(_getGuestUserHomeFeedFailed),
]);

/// reducers
// GET LOGGED USER POSTS
HomeFeedState _getLoggedUserHomeFeedRequest(HomeFeedState state, GetLoggedUserHomeFeedRequestAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.loading,
    posts: null
  );
}
HomeFeedState _getLoggedUserHomeFeedSuccess(HomeFeedState state, GetLoggedUserHomeFeedSuccessAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    posts: action.posts
  );
}
HomeFeedState _getLoggedUserHomeFeedFailed(HomeFeedState state, GetLoggedUserHomeFeedFailedAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.error,
    posts: null,
    errorMessage: action.message
  );
}

// GET GUEST USER POSTS
HomeFeedState _getGuestUserHomeFeedRequest(HomeFeedState state, GetGuestUserHomeFeedRequestAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.loading,
    posts: null
  );
}
HomeFeedState _getGuestUserHomeFeedSuccess(HomeFeedState state, GetGuestUserHomeFeedSuccessAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    posts: action.posts
  );
}
HomeFeedState _getGuestUserHomeFeedFailed(HomeFeedState state, GetGuestUserHomeFeedFailedAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.error,
    posts: null,
    errorMessage: action.message
  );
}
