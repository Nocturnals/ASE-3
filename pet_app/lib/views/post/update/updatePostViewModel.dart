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

class UpdatePostViewModel {
  final PostState state;

  final Function({
    @required String description
  }) create;

  UpdatePostViewModel({
    @required this.state,
    @required this.create,
  });

  factory UpdatePostViewModel.create(Store<AppState> store) {
    _onPostUpdate({@required String description}) {
      store.dispatch(updatePost(
        description: description,
      ));
    }

    return UpdatePostViewModel(
      state: store.state.postState,
      create: _onPostUpdate,
    );
  }
}

// main function for creating post
ThunkAction updatePost({@required String description}) {
  return (Store store) async {
    Future(() async {
      // dispatch request sent action
      store.dispatch(UpdatePostRequestSentAction());

      Map data = {'description': description};
      var body = convert.jsonEncode(data);
      http.Response response =
          await http.post('${DotEnv().env['localhost']}/post/update', headers: {"Content-Type": "application/json"}, body: body);

      debugPrint("request received");

      if (response.statusCode == 200) {
        // TODO: remove the log afterwards
        debugPrint('successfully updated post');
        var jsonResponse = convert.jsonDecode(response.body);
        debugPrint(jsonResponse);
        // dispatch success action
        store.dispatch(UpdatePostSuccessAction(post: Post.initial()));
      } else {
        debugPrint(response.body);
        // dispatch failure action
        store.dispatch(UpdatePostFailedAction());
      }
    });
  };
}
