import 'package:redux/redux.dart';

import 'package:pet_app/models/loadingStatus.dart';

import 'authState.dart';
import 'authActions.dart';

final Function authReducer = combineReducers<AuthState>([
  TypedReducer<AuthState, LoginSuccessAction>(_loginsuccess),
  TypedReducer<AuthState, LoginFailedAction>(_loginFailed),
  TypedReducer<AuthState, LoginRequestSentAction>(_loginRequestSent),
  TypedReducer<AuthState, RegisterRequestSentAction>(_registerRequestSent),
  TypedReducer<AuthState, RegisterFailedAction>(_registerFailed),
  TypedReducer<AuthState, RegisterSuccessAction>(_registerSuccess),
  TypedReducer<AuthState, ResetMessageAction>(_resetMessage),
]);

AuthState _loginsuccess(AuthState state, LoginSuccessAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loggedUser: action.user,
  );
}

AuthState _loginFailed(AuthState state, LoginFailedAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.error,
    loggedUser: null,
    errorMessage: action.message,
  );
}

AuthState _loginRequestSent(AuthState state, LoginRequestSentAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.loading,
    loggedUser: null,
  );
}

AuthState _registerRequestSent(
    AuthState state, RegisterRequestSentAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.loading,
    loggedUser: null,
  );
}

AuthState _registerSuccess(AuthState state, RegisterSuccessAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.loading,
    loggedUser: null,
  );
}

AuthState _registerFailed(AuthState state, RegisterFailedAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.error,
    loggedUser: null,
    errorMessage: action.message,
  );
}

AuthState _resetMessage(AuthState state, ResetMessageAction action) {
  return state.copyWith(errorMessage: null, loadingStatus: LoadingStatus.idle);
}
