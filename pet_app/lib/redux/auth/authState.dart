import 'package:flutter/foundation.dart';

import 'package:pet_app/models/loadingStatus.dart';
import 'package:pet_app/models/user.dart';

@immutable
class AuthState {
  final User loggedUser;
  final LoadingStatus loadingStatus;
  final String errorMessage;

  /// initialize the auth state with user
  AuthState(
      {@required this.loggedUser,
      @required this.loadingStatus,
      @required this.errorMessage});

  factory AuthState.initialState() {
    return AuthState(
      loggedUser: User.initial(),
      loadingStatus: LoadingStatus.idle,
      errorMessage: null,
    );
  }

  AuthState copyWith(
      {User loggedUser, LoadingStatus loadingStatus, String errorMessage}) {
    return AuthState(
        loggedUser: loggedUser ?? this.loggedUser,
        loadingStatus: loadingStatus ?? this.loadingStatus,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          this.runtimeType == other.runtimeType &&
          this.loadingStatus == other.loadingStatus &&
          this.loggedUser == other.loggedUser &&
          this.errorMessage == other.errorMessage;

  @override
  int get hashCode => this.loggedUser.hashCode ^ this.loadingStatus.hashCode ^ this.errorMessage.hashCode;
}
