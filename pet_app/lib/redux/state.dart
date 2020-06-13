// flutter imports
import 'package:flutter/foundation.dart';

// internal imports
import 'auth/authState.dart';

@immutable
class AppState {
  final AuthState authState;

  AppState({
    @required this.authState,
  });

  factory AppState.initial() {
    return AppState(
      authState: AuthState.initialState(),
    );
  }

  AppState copyWith({
    AuthState authState,
  }) {
    return AppState(
      authState: authState ?? this.authState,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppState &&
          this.runtimeType == other.runtimeType &&
          this.authState == other.authState;

  @override
  int get hashCode => this.authState.hashCode;
}
