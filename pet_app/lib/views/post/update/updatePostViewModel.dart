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
  }) update;

  UpdatePostViewModel({
    @required this.state,
    @required this.update,
  });

  factory UpdatePostViewModel.create(Store<AppState> store) {
    _onPostUpdate({@required String description}) {
      store.dispatch(updatePost(
        description: description,
      ));
    }

    return UpdatePostViewModel(
      state: store.state.postState,
      update: _onPostUpdate,
    );
  }
}

// main function for creating post
ThunkAction updatePost({@required String description}) {
  return (Store store) async {
    Future(() async {
      // dispatch request sent action
      store.dispatch(UpdatePostRequestSentAction());

      // create the json data as the request body
      Map data = {'description': description};
      var body = convert.jsonEncode(data);

      // send post request
      http.Response response =
          await http.post(
            '${DotEnv().env['localhost']}/post/update',
            headers: {"Content-Type": "application/json"},
            body: body
          );

      // check the response status code
      if (response.statusCode == 200) {
        // convert response to json object
        var jsonResponse = convert.jsonDecode(response.body);
        debugPrint(jsonResponse);

        // dispatch success action
        store.dispatch(UpdatePostSuccessAction(post: Post.initial()));
      } else {
        // convert response to json object
        var jsonResponse = convert.json.decode(response.body);

        // dispatch failure action
        store.dispatch(UpdatePostFailedAction(message: jsonResponse["error"]));
      }
    });
  };
}
