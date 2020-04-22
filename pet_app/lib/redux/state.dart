import 'package:flutter/foundation.dart';

import 'auth/authState.dart';
import 'post/postState.dart';

@immutable
class AppState {
  final AuthState authState;
  final PostState postState;

  AppState({
    @required this.authState,
    @required this.postState,
  });

  factory AppState.initial() {
    return AppState(
      authState: AuthState.initialState(),
      postState: PostState.initialState(),
    );
  }

  AppState copyWith({
    AuthState authState,
  }) {
    return AppState(
      authState: authState ?? this.authState,
      postState: postState ?? this.postState,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppState &&
          this.runtimeType == other.runtimeType &&
          this.authState == other.authState &&
          this.postState == other.postState;

  @override
  int get hashCode => this.authState.hashCode ^ this.postState.hashCode;
}
