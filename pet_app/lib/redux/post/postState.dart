import 'package:flutter/foundation.dart';

import 'package:pet_app/models/loadingStatus.dart';
import 'package:pet_app/models/post.dart';

@immutable
class PostState {
  final Post post;
  final List<Post> posts;
  final LoadingStatus loadingStatus;
  final String errorMessage;
  final String notifyMessage;

  /// initialize the post state with Post
  PostState({
    @required this.post,
    @required this.posts,
    @required this.loadingStatus,
    @required this.errorMessage,
    @required this.notifyMessage
  });

  factory PostState.initialState() {
    return PostState(
      post: Post.initial(),
      posts: [],
      loadingStatus: LoadingStatus.idle,
      errorMessage: null,
      notifyMessage: null,
    );
  }

  PostState copyWith({
    Post post, List<Post> posts,
    LoadingStatus loadingStatus,
    String errorMessage,
    String notifyMessage
  }) {
    return PostState(
      post: post ?? this.post,
      posts: posts ?? this.posts,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      notifyMessage: notifyMessage ?? this.notifyMessage
    );
  }

  @override
  bool operator == (Object other) => 
    identical(this, other) || 
      other is PostState && 
        this.runtimeType == other.runtimeType && 
        this.loadingStatus == other.loadingStatus &&
        this.post == other.post && 
        listEquals(this.posts, other.posts) &&
        this.errorMessage == other.errorMessage &&
        this.notifyMessage == other.notifyMessage;

  @override
  int get hashCode => 
      this.post.hashCode ^
      this.posts.hashCode ^
      this.loadingStatus.hashCode ^
      this.errorMessage.hashCode ^
      this.notifyMessage.hashCode;
}
