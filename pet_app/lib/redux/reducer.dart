import 'state.dart';
import 'auth/authReducer.dart';

AppState appStateReducer(AppState state, dynamic action) {
  return AppState(
    authState: authReducer(state.authState, action),
  );
}