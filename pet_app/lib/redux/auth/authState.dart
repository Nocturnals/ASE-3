// flutter imports
import 'package:flutter/foundation.dart';

// model imports
import 'package:pet_app/models/loadingStatus.dart';
import 'package:pet_app/models/user.dart';

@immutable
class AuthState {
  final User loggedUser;
  final LoadingStatus loadingStatus;
  final String errorMessage;
  final String notifyMessage;

  /// initialize the auth state with user
  AuthState(
      {@required this.loggedUser,
      @required this.loadingStatus,
      @required this.errorMessage,
      @required this.notifyMessage});

  factory AuthState.initialState() {
    return AuthState(
      loggedUser: User.initial(),
      loadingStatus: LoadingStatus.idle,
      errorMessage: null,
      notifyMessage: null,
    );
  }

  AuthState copyWith(
      {User loggedUser,
      LoadingStatus loadingStatus,
      String errorMessage,
      String notifyMessage}) {
    return AuthState(
        loggedUser: loggedUser ?? this.loggedUser,
        loadingStatus: loadingStatus ?? this.loadingStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        notifyMessage: notifyMessage ?? this.notifyMessage);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          this.runtimeType == other.runtimeType &&
          this.loadingStatus == other.loadingStatus &&
          this.loggedUser == other.loggedUser &&
          this.errorMessage == other.errorMessage &&
          this.notifyMessage == other.notifyMessage;

  @override
  int get hashCode =>
      this.loggedUser.hashCode ^
      this.loadingStatus.hashCode ^
      this.errorMessage.hashCode ^
      this.notifyMessage.hashCode;
}
