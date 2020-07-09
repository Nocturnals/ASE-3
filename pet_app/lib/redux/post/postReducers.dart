import 'package:pet_app/models/loadingStatus.dart';
import 'package:redux/redux.dart';

import 'postState.dart';
import 'postActions.dart';

final Function postReducer = combineReducers<PostState>([
  // POST
  // CREATE POST
  TypedReducer<PostState, CreatePostRequestSentAction>(_createPostRequest),
  TypedReducer<PostState, CreatePostSuccessAction>(_createPostSuccess),
  TypedReducer<PostState, CreatePostFailedAction>(_createPostFailed),
  // UPDATE POST
  TypedReducer<PostState, UpdatePostRequestSentAction>(_updatePostRequest),
  TypedReducer<PostState, UpdatePostSuccessAction>(_updatePostSuccess),
  TypedReducer<PostState, UpdatePostFailedAction>(_updatePostFailed),
  // DELETE POST
  TypedReducer<PostState, DeletePostRequestSentAction>(_deletePostRequest),
  TypedReducer<PostState, DeletePostSuccessAction>(_deletePostSuccess),
  TypedReducer<PostState, DeletePostFailedAction>(_deletePostFailed),
  // ADD LIKE
  TypedReducer<PostState, AddLikeRequestSentAction>(_addLikeRequest),
  TypedReducer<PostState, AddLikeSuccessAction>(_addLikeSuccess),
  TypedReducer<PostState, AddLikeFailedAction>(_addLikeFailed),
  // REMOVE LIKE
  TypedReducer<PostState, RemoveLikeRequestSentAction>(_removeLikeRequest),
  TypedReducer<PostState, RemoveLikeSuccessAction>(_removeLikeSuccess),
  TypedReducer<PostState, RemoveLikeFailedAction>(_removeLikeFailed),

  // GET
  // POST BY ID
  TypedReducer<PostState, GetPostRequestSentAction>(_getPostRequest),
  TypedReducer<PostState, GetPostSuccessAction>(_getPostSuccess),
  TypedReducer<PostState, GetPostFailedAction>(_getPostFailed),
  // POSTS BY USER_ID
  TypedReducer<PostState, GetPostsByUserIdRequestSentAction>(_getPostsByIdRequest),
  TypedReducer<PostState, GetPostsByUserIdSuccessAction>(_getPostsByIdSuccess),
  TypedReducer<PostState, GetPostsByUserIdFailedAction>(_getPostsByIdFailed),
  // POSTS BY USERNAME
  TypedReducer<PostState, GetUserPostsByUsernameRequestSentAction>(_getPostsByUsernameRequest),
  TypedReducer<PostState, GetUserPostsByUsernameSuccessAction>(_getPostsByUsernameSuccess),
  TypedReducer<PostState, GetUserPostsByUsernameFailedAction>(_getPostsByUsernameFailed),
  // LIKED POSTS BY USER_ID
  TypedReducer<PostState, GetUserLikedPostsByIdRequestSentAction>(_getLikedPostsRequest),
  TypedReducer<PostState, GetUserLikedPostsByIdSuccessAction>(_getLikedPostsSuccess),
  TypedReducer<PostState, GetUserLikedPostsByIdFailedAction>(_getLikedPostsByIdFailed),
  // MENTIONED USER POSTS BY USERNAME
  TypedReducer<PostState, GetMentionedUserPostsRequestSentAction>(_getMentionedUserPostsRequest),
  TypedReducer<PostState, GetMentionedUserPostsSuccessAction>(_getMentionedUserPostsSuccess),
  TypedReducer<PostState, GetMentionedUserPostsFailedAction>(_getMentionedUserPostsFailed),

  // RESET MESSAGE
  TypedReducer<PostState, ResetMessageAction>(_resetMessage),
]);


/// reducers
// CREATE POST
PostState _createPostRequest(PostState state, CreatePostRequestSentAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.loading,
    post: null
  );
}
PostState _createPostSuccess(PostState state, CreatePostSuccessAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    notifyMessage: action.message
  );
}
PostState _createPostFailed(PostState state, CreatePostFailedAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.error,
    errorMessage: action.message
  );
}

// UPDATE POST
PostState _updatePostRequest(PostState state, UpdatePostRequestSentAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.loading,
    post: null
  );
}
PostState _updatePostSuccess(PostState state, UpdatePostSuccessAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    post: action.post
  );
}
PostState _updatePostFailed(PostState state, UpdatePostFailedAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.error,
    post: null,
    errorMessage: action.message
  );
}

// DELETE POST
PostState _deletePostRequest(PostState state, DeletePostRequestSentAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.loading
  );
}
PostState _deletePostSuccess(PostState state, DeletePostSuccessAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    notifyMessage: action.message
  );
}
PostState _deletePostFailed(PostState state, DeletePostFailedAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.error,
    errorMessage: action.message
  );
}

// ADD LIKE
PostState _addLikeRequest(PostState state, AddLikeRequestSentAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.loading,
  );
}
PostState _addLikeSuccess(PostState state, AddLikeSuccessAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    notifyMessage: action.message
  );
}
PostState _addLikeFailed(PostState state, AddLikeFailedAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.error,
    errorMessage: action.message
  );
}

// REMOVE LIKE
PostState _removeLikeRequest(PostState state, RemoveLikeRequestSentAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.loading,
  );
}
PostState _removeLikeSuccess(PostState state, RemoveLikeSuccessAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    notifyMessage: action.message
  );
}
PostState _removeLikeFailed(PostState state, RemoveLikeFailedAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.error,
    errorMessage: action.message
  );
}


// GET
// POST BY ID
PostState _getPostRequest(PostState state, GetPostRequestSentAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.loading,
    post: null
  );
}
PostState _getPostSuccess(PostState state, GetPostSuccessAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    post: action.post
  );
}
PostState _getPostFailed(PostState state, GetPostFailedAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.error,
    post: null,
    errorMessage: action.message
  );
}

// POSTS BY USER_ID
PostState _getPostsByIdRequest(PostState state, GetPostsByUserIdRequestSentAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.loading,
    posts: []
  );
}
PostState _getPostsByIdSuccess(PostState state, GetPostsByUserIdSuccessAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    posts: action.posts
  );
}
PostState _getPostsByIdFailed(PostState state, GetPostsByUserIdFailedAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.error,
    posts: null,
    errorMessage: action.message
  );
}

// POSTS BY USERNAME
PostState _getPostsByUsernameRequest(PostState state, GetUserPostsByUsernameRequestSentAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.loading,
    posts: []
  );
}
PostState _getPostsByUsernameSuccess(PostState state, GetUserPostsByUsernameSuccessAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    posts: action.posts
  );
}
PostState _getPostsByUsernameFailed(PostState state, GetUserPostsByUsernameFailedAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.error,
    posts: null,
    errorMessage: action.message
  );
}

// LIKED POSTS BY USER_ID
PostState _getLikedPostsRequest(PostState state, GetUserLikedPostsByIdRequestSentAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.loading,
    posts: []
  );
}
PostState _getLikedPostsSuccess(PostState state, GetUserLikedPostsByIdSuccessAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    posts: action.posts
  );
}
PostState _getLikedPostsByIdFailed(PostState state, GetUserLikedPostsByIdFailedAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.error,
    posts: null,
    errorMessage: action.message
  );
}

// MENTIONED USER POSTS BY USERNAME
PostState _getMentionedUserPostsRequest(PostState state, GetMentionedUserPostsRequestSentAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.loading,
    posts: []
  );
}
PostState _getMentionedUserPostsSuccess(PostState state, GetMentionedUserPostsSuccessAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    posts: action.posts
  );
}
PostState _getMentionedUserPostsFailed(PostState state, GetMentionedUserPostsFailedAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.error,
    posts: null,
    errorMessage: action.message
  );
}


// RESET MESSAGE
PostState _resetMessage(PostState state, ResetMessageAction action) {
  return state.copyWith(errorMessage: null, loadingStatus: LoadingStatus.idle);
}