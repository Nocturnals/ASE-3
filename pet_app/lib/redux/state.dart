// flutter imports
import 'package:flutter/foundation.dart';

// internal imports
import 'auth/authState.dart';
import 'post/postState.dart';
import 'homeFeed/homeFeedState.dart';

@immutable
class AppState {
  final AuthState authState;
  final PostState postState;
  final HomeFeedState homeFeedState;

  AppState({
    @required this.authState,
    @required this.postState,
    @required this.homeFeedState
  });

  factory AppState.initial() {
    return AppState(
      authState: AuthState.initialState(),
      postState: PostState.initialState(),
      homeFeedState: HomeFeedState.initialState()
    );
  }

  AppState copyWith({
    AuthState authState,
    PostState postState,
    HomeFeedState homeFeedState
  }) {
    return AppState(
      authState: authState ?? this.authState,
      postState: postState ?? this.postState,
      homeFeedState: homeFeedState ?? this.homeFeedState
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppState &&
          this.runtimeType == other.runtimeType &&
          this.authState == other.authState &&
          this.postState == other.postState &&
          this.homeFeedState == other.homeFeedState;

  @override
  int get hashCode => 
      this.authState.hashCode ^
      this.postState.hashCode ^
      this.homeFeedState.hashCode;
}
