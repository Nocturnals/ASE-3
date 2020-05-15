import 'state.dart';
import 'auth/authReducer.dart';
import 'post/postReducer.dart';
import 'homeFeed/homeFeedReducer.dart';

AppState appStateReducer(AppState state, dynamic action) {
  return AppState(
    authState: authReducer(state.authState, action),
    postState: postReducer(state.postState, action),
    homeFeedState: homeFeedReducer(state.homeFeedState, action),
  );
}