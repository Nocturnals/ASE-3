import 'package:flutter/foundation.dart';

import 'package:pet_app/models/post.dart';

// CREATE POST
class CreatePostRequestSentAction {
  CreatePostRequestSentAction();
}
class CreatePostSuccessAction {
  final Post post;

  CreatePostSuccessAction({ @required this.post });
}
class CreatePostFailedAction {
  CreatePostFailedAction();
}


// UPDATE POST
class UpdatePostRequestSentAction {
  UpdatePostRequestSentAction();
}
class UpdatePostSuccessAction {
  final Post post;

  UpdatePostSuccessAction({ @required this.post });
}
class UpdatePostFailedAction {
  UpdatePostFailedAction();
}


// DELETE POST
class DeletePostRequestSentAction {
  DeletePostRequestSentAction();
}
class DeletePostSuccessAction {
  DeletePostSuccessAction();
}
class DeletePostFailedAction {
  DeletePostFailedAction();
}


// POST BY ID
class GetPostRequestSentAction {
  GetPostRequestSentAction();
}
class GetPostSuccessAction {
  final Post post;

  GetPostSuccessAction({ @required this.post });
}
class GetPostFailedAction {
  GetPostFailedAction();
}


// POSTS OF USER BY USER_ID
class GetUserPostsByIdRequestSentAction {
  GetUserPostsByIdRequestSentAction();
}
class GetUserPostsByIdSuccessAction {
  final List<Post> posts;

  GetUserPostsByIdSuccessAction({ @required this.posts });
}
class GetUserPostsByIdFailedAction {
  GetUserPostsByIdFailedAction();
}


// POSTS OF USER BY USERNAME
class GetUserPostsByUsernameRequestSentAction {
  GetUserPostsByUsernameRequestSentAction();
}
class GetUserPostsByUsernameSuccessAction {
  final List<Post> posts;

  GetUserPostsByUsernameSuccessAction({ @required this.posts });
}
class GetUserPostsByUsernameFailedAction {
  GetUserPostsByUsernameFailedAction();
}


// LIKED POSTS BY USER_ID
class GetUserLikedPostsByIdRequestSentAction {
  GetUserLikedPostsByIdRequestSentAction();
}
class GetUserLikedPostsByIdSuccessAction {
  final List<Post> posts;

  GetUserLikedPostsByIdSuccessAction({ @required this.posts });
}
class GetUserLikedPostsByIdFailedAction {
  GetUserLikedPostsByIdFailedAction();
}


// MENTIONED USER POSTS BY USERNAME
class GetMentionedUserPostsRequestSentAction {
  GetMentionedUserPostsRequestSentAction();
}
class GetMentionedUserPostsSuccessAction {
  final List<Post> posts;

  GetMentionedUserPostsSuccessAction({ @required this.posts });
}
class GetMentionedUserPostsFailedAction {
  GetMentionedUserPostsFailedAction();
}


// ADD LIKE
class AddLikeRequestSentAction {
  AddLikeRequestSentAction();
}
class AddLikeSuccessAction {
  AddLikeSuccessAction();
}
class AddLikeFailedAction {
  AddLikeFailedAction();
}

// REMOVE LIKE
class RemoveLikeRequestSentAction {
  RemoveLikeRequestSentAction();
}
class RemoveLikeSuccessAction {
  RemoveLikeSuccessAction();
}
class RemoveLikeFailedAction {
  RemoveLikeFailedAction();
}
