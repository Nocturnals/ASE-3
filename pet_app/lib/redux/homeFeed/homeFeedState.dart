import 'package:flutter/foundation.dart';

import 'package:pet_app/models/loadingStatus.dart';
import 'package:pet_app/models/post.dart';

@immutable
class HomeFeedState {
  final List<Post> posts;
  final LoadingStatus loadingStatus;
  final String errorMessage;
  final String notifyMessage;

  /// initialize the homeFeed state with Post
  HomeFeedState({
    @required this.posts,
    @required this.loadingStatus,
    @required this.errorMessage,
    @required this.notifyMessage
  });

  factory HomeFeedState.initialState() {
    return HomeFeedState(
      posts: [],
      loadingStatus: LoadingStatus.idle,
      errorMessage: null,
      notifyMessage: null,
    );
  }

  HomeFeedState copyWith({
    List<Post> posts,
    LoadingStatus loadingStatus,
    String errorMessage,
    String notifyMessage
  }) {
    return HomeFeedState(
      posts: posts ?? this.posts,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      notifyMessage: notifyMessage ?? this.notifyMessage
    );
  }

  @override
  bool operator == (Object other) => 
    identical(this, other) || 
      other is HomeFeedState && 
        this.runtimeType == other.runtimeType && 
        this.loadingStatus == other.loadingStatus &&
        listEquals(this.posts, other.posts) &&
        this.errorMessage == other.errorMessage &&
        this.notifyMessage == other.notifyMessage;

  @override
  int get hashCode => 
      this.posts.hashCode ^
      this.loadingStatus.hashCode ^
      this.errorMessage.hashCode ^
      this.notifyMessage.hashCode;
}