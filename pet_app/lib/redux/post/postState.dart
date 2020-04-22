import 'package:flutter/foundation.dart';

import 'package:pet_app/models/loadingStatus.dart';
import 'package:pet_app/models/post.dart';

@immutable
class PostState {
  final Post post;
  final List<Post> posts;
  final LoadingStatus loadingStatus;

  /// initialize the auth state with Post
  PostState({
    @required this.post,
    @required this.posts,
    @required this.loadingStatus,
  });

  factory PostState.initialState() {
    return PostState(
      post: Post.initial(),
      posts: [],
      loadingStatus: LoadingStatus.x,
    );
  }

  PostState copyWith({Post post, List<Post> posts, LoadingStatus loadingStatus}) {
    return PostState(
      post: post ?? this.post,
      posts: posts ?? this.posts,
      loadingStatus: loadingStatus ?? this.loadingStatus,
    );
  }

  @override
  bool operator == (Object other) => 
    identical(this, other) || 
      other is PostState && 
        this.runtimeType == other.runtimeType && 
        this.loadingStatus == other.loadingStatus &&
        this.post == other.post && 
        listEquals(this.posts, other.posts);

  @override
  int get hashCode => this.post.hashCode ^ this.posts.hashCode ^ this.loadingStatus.hashCode;
}
