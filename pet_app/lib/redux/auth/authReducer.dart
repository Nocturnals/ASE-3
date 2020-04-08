import 'package:pet_app/models/loadingStatus.dart';

import 'authState.dart';
import 'authActions.dart';

AuthState authReducer(AuthState state, dynamic action) {
  if (action is LoginSuccessAction) {
    return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loggedUser: action.user,
    );
  } else if (action is LoginFailedAction) {
    return state.copyWith(
      loadingStatus: LoadingStatus.error,
      loggedUser: null,
    );
  } else if (action is LoginRequestSentAction) {
    return state.copyWith(
      loadingStatus: LoadingStatus.loading,
      loggedUser: null,
    );
  }

  return state;
}
