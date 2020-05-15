import 'package:flutter/foundation.dart';

import 'package:pet_app/models/post.dart';

// CREATE POST
class CreatePostRequestSentAction {
  CreatePostRequestSentAction();
}
class CreatePostSuccessAction {
  final String message;

  CreatePostSuccessAction({ @required this.message });
}
class CreatePostFailedAction {
  final String message;
  
  CreatePostFailedAction({ @required this.message });
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
  final String message;

  UpdatePostFailedAction({ @required this.message });
}


// DELETE POST
class DeletePostRequestSentAction {
  DeletePostRequestSentAction();
}
class DeletePostSuccessAction {
  final String message;

  DeletePostSuccessAction({ @required this.message });
}
class DeletePostFailedAction {
  final String message;

  DeletePostFailedAction({ @required this.message });
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
  final String message;

  GetPostFailedAction({ @required this.message });
}


// POSTS OF USER BY USER_ID
class GetPostsByUserIdRequestSentAction {
  GetPostsByUserIdRequestSentAction();
}
class GetPostsByUserIdSuccessAction {
  final List<Post> posts;

  GetPostsByUserIdSuccessAction({ @required this.posts });
}
class GetPostsByUserIdFailedAction {
  final String message;

  GetPostsByUserIdFailedAction({ @required this.message });
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
  final String message;

  GetUserPostsByUsernameFailedAction({ @required this.message });
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
  final String message;

  GetUserLikedPostsByIdFailedAction({ @required this.message });
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
  final String message;

  GetMentionedUserPostsFailedAction({ @required this.message });
}


// ADD LIKE
class AddLikeRequestSentAction {
  AddLikeRequestSentAction();
}
class AddLikeSuccessAction {
  final String message;

  AddLikeSuccessAction({ @required this.message });
}
class AddLikeFailedAction {
  final String message;

  AddLikeFailedAction({ @required this.message });
}

// REMOVE LIKE
class RemoveLikeRequestSentAction {
  RemoveLikeRequestSentAction();
}
class RemoveLikeSuccessAction {
  final String message;

  RemoveLikeSuccessAction({ @required this.message });
}
class RemoveLikeFailedAction {
  final String message;

  RemoveLikeFailedAction({ @required this.message });
}


// RESET MESSAGE
class ResetMessageAction {
  ResetMessageAction();
}
