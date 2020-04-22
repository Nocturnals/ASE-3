import 'dart:convert' as convert;

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:pet_app/models/post.dart' show Post;
import 'package:pet_app/redux/state.dart' show AppState;
import 'package:pet_app/redux/post/postActions.dart';
import 'package:pet_app/redux/post/postState.dart' show PostState;

class CreatePostViewModel {
  final PostState state;

  final Function({
    @required String description,
    @required List<String> mediaUrls
  }) create;

  CreatePostViewModel({
    @required this.state,
    @required this.create,
  });

  factory CreatePostViewModel.create(Store<AppState> store) {
    _onPostCreate({@required String description, @required List<String> mediaUrls}) {
      store.dispatch(createPost(
        description: description,
        mediaUrls: mediaUrls,
      ));
    }

    return CreatePostViewModel(
      state: store.state.postState,
      create: _onPostCreate,
    );
  }
}

// main function for creating post
ThunkAction createPost({@required String description, @required List<String> mediaUrls}) {
  return (Store store) async {
    Future(() async {
      // dispatch request sent action
      store.dispatch(CreatePostRequestSentAction());

      Map data = {'description': description, 'media_urls': mediaUrls};
      var body = convert.jsonEncode(data);
      http.Response response =
          await http.post('${DotEnv().env['localhost']}/post/create', headers: {"Content-Type": "application/json"}, body: body);

      debugPrint("request received");

      if (response.statusCode == 200) {
        // TODO: remove the log afterwards
        debugPrint('successfully created post');
        var jsonResponse = convert.jsonDecode(response.body);
        debugPrint(jsonResponse);
        // dispatch success action
        store.dispatch(CreatePostSuccessAction(post: Post.initial()));
      } else {
        debugPrint(response.body);
        // dispatch failure action
        store.dispatch(CreatePostFailedAction());
      }
    });
  };
}
