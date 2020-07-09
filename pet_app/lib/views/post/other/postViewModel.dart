import 'dart:convert' as convert;

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pet_app/models/post.dart';
import 'package:pet_app/models/user.dart';
import 'package:pet_app/redux/state.dart' show AppState;
import 'package:pet_app/redux/post/postState.dart' show PostState;

class PostViewModel {
  final PostState state;
  final Function({ @required String postId }) addLike;
  final Function({ @required String postId }) removeLike;
  final bool isAuthed;
  final User loggedUser;

  PostViewModel({
    @required this.state,
    @required this.addLike,
    @required this.removeLike,
    @required this.isAuthed,
    @required this.loggedUser,
  });

  factory PostViewModel.create(Store<AppState> store) {
    _onAddLike({ @required String postId }) { store.dispatch(_addLike(postId: postId)); }
    _onRemoveLike({ @required String postId }) { store.dispatch(_removeLike(postId: postId)); }

    return PostViewModel(
      state: store.state.postState,
      addLike: _onAddLike,
      removeLike: _onRemoveLike,
      isAuthed: store.state.authState.loggedUser.id != null ? true : false,
      loggedUser: store.state.authState.loggedUser.id != null ? store.state.authState.loggedUser : null,
    );
  }
}

// ADD LIKE
ThunkAction _addLike({ @required String postId }) {
  return (Store store) async {
    Future(() async {
      // store the Jtoken in the shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('JToken');

      // create the json data as the request body
      Map data = {'post_id': postId};
      var body = convert.jsonEncode(data);

      // send the request
      http.Response response = await http.post(
          '${DotEnv().env['localhost']}/api/post/like',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: body
      );
    });
  };
}

// REMOVE LIKE
ThunkAction _removeLike({ @required String postId }) {
  return (Store store) async {
    Future(() async {
      // store the Jtoken in the shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('JToken');

      // create the json data as the request body
      Map data = {'post_id': postId};
      var body = convert.jsonEncode(data);

      // send the request
      http.Response response = await http.post(
          '${DotEnv().env['localhost']}/api/post/unlike',
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: body
      );
    });
  };
}


