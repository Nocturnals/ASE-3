import 'package:flutter/foundation.dart';

import 'package:pet_app/models/loadingStatus.dart';
import 'package:pet_app/models/user.dart';

@immutable
class AuthState {
  final User loggedUser;
  final LoadingStatus loadingStatus;

  /// initialize the auth state with user
  AuthState({
    @required this.loggedUser,
    @required this.loadingStatus,
  });

  factory AuthState.initialState() {
    return AuthState(
      loggedUser: User.initial(),
      loadingStatus: LoadingStatus.x,
    );
  }

  AuthState copyWith({User loggedUser, bool loadingStatus}) {
    return AuthState(
      loggedUser: loggedUser ?? this.loggedUser,
      loadingStatus: loadingStatus ?? this.loadingStatus,
    );
  }

  @override
  bool operator == (Object other) => 
    identical(this, other) || 
      other is AuthState && 
        this.runtimeType == other.runtimeType && 
        this.loadingStatus == other.loadingStatus &&
        this.loggedUser == other.loggedUser;

  @override
  int get hashCode => this.loggedUser.hashCode ^ this.loadingStatus.hashCode;
}
