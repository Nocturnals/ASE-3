import 'package:flutter/foundation.dart';

import 'package:pet_app/models/post.dart';

// GET LOGGED USER HOME FEED
class GetLoggedUserHomeFeedRequestAction {
  GetLoggedUserHomeFeedRequestAction();
}
class GetLoggedUserHomeFeedSuccessAction {
  final List<Post> posts;

  GetLoggedUserHomeFeedSuccessAction({ @required this.posts });
}
class GetLoggedUserHomeFeedFailedAction {
  final String message;
  GetLoggedUserHomeFeedFailedAction({ @required this.message });
}

// GET GUEST USER HOME FEED
class GetGuestUserHomeFeedRequestAction {
  GetGuestUserHomeFeedRequestAction();
}
class GetGuestUserHomeFeedSuccessAction {
  final List<Post> posts;

  GetGuestUserHomeFeedSuccessAction({ @required this.posts });
}
class GetGuestUserHomeFeedFailedAction {
  final String message;
  GetGuestUserHomeFeedFailedAction({ @required this.message });
}