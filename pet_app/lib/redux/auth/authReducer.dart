import 'authState.dart';
import 'authActions.dart';

AuthState authReducer(AuthState state, dynamic action) {
  if (action is LoginSuccessAction) {
    return state.copyWith(
      loadingStatus: false,
      loggedUser: action.user,
    );
  } else if (action is LoginFailedAction) {
    return state.copyWith(
      loadingStatus: false,
      loggedUser: null,
    );
  } else if (action is LoginRequestSentAction) {
    return state.copyWith(
      loadingStatus: true,
      loggedUser: null,
    );
  }

  return state;
}
