import 'package:pet_app/models/loadingStatus.dart';

import 'postState.dart';
import 'postActions.dart';

PostState postReducer(PostState state, dynamic action) {
  switch (action) {
    // POST
    // CREATE POST
    case CreatePostRequestSentAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.loading,
        post: null
      );
    case CreatePostSuccessAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.success,
        post: action.post
      );
    case CreatePostFailedAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.error,
        post: null
      );


    // UPDATE POST
    case UpdatePostRequestSentAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.loading,
        post: null
      );
    case UpdatePostSuccessAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.success,
        post: action.post
      );
    case UpdatePostFailedAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.error,
        post: null
      );


    // DELETE POST
    case DeletePostRequestSentAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.loading
      );
    case DeletePostSuccessAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.success
      );
    case DeletePostFailedAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.error
      );


    // ADD LIKE
    case AddLikeRequestSentAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.loading
      );
    case AddLikeSuccessAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.success
      );
    case AddLikeFailedAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.error
      );


    // REMOVE LIKE
    case RemoveLikeRequestSentAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.loading
      );
    case RemoveLikeSuccessAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.success
      );
    case RemoveLikeFailedAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.error
      );


    // GET
    // POST BY ID
    case GetPostRequestSentAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.loading,
        post: null
      );
    case GetPostSuccessAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.success,
        post: action.post
      );
    case GetPostFailedAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.error,
        post: null
      );


    // POSTS BY ID
    case GetUserPostsByIdRequestSentAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.loading,
        posts: []
      );
    case GetUserPostsByIdSuccessAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.success,
        posts: action.posts
      );
    case GetUserPostsByIdFailedAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.error,
        posts: null
      );

    
    // POSTS BY USERNAME
    case GetUserPostsByUsernameRequestSentAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.loading,
        posts: []
      );
    case GetUserPostsByUsernameSuccessAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.success,
        posts: action.posts
      );
    case GetUserPostsByUsernameFailedAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.error,
        posts: null
      );


    // LIKED POSTS BY USER_ID
    case GetUserLikedPostsByIdRequestSentAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.loading,
        posts: []
      );
    case GetUserLikedPostsByIdSuccessAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.success,
        posts: action.posts
      );
    case GetUserLikedPostsByIdFailedAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.error,
        posts: null
      );


    // MENTIONED USER POSTS BY USERNAME
    case GetMentionedUserPostsRequestSentAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.loading,
        posts: []
      );
    case GetMentionedUserPostsSuccessAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.success,
        posts: action.posts
      );
    case GetMentionedUserPostsFailedAction:
      return state.copyWith(
        loadingStatus: LoadingStatus.error,
        posts: null
      );


    // DEFAULT
    default:
      return state;
  }
}
