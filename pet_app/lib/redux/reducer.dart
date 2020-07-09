// internal imports
import 'state.dart';
import 'auth/authReducer.dart';
import 'homeFeed/homeFeedReducer.dart';

AppState appStateReducer(AppState state, dynamic action) {
  return AppState(
    authState: authReducer(state.authState, action),
    homeFeedState: homeFeedReducer(state.homeFeedState, action),
  );
}