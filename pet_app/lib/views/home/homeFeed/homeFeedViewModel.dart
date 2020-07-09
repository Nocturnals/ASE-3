import 'dart:convert' as convert;

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pet_app/models/post.dart';
import 'package:pet_app/redux/state.dart' show AppState;
import 'package:pet_app/redux/homeFeed/homeFeedActions.dart';
import 'package:pet_app/redux/homeFeed/homeFeedState.dart' show HomeFeedState;

class HomeFeedViewModel {
  final HomeFeedState state;
  final bool isAuthed;
  final Function() getHomeFeed;

  HomeFeedViewModel({
    @required this.state,
    @required this.isAuthed,
    @required this.getHomeFeed,
  });

  factory HomeFeedViewModel.create(Store<AppState> store) {
    _onGetUserHomeFeed() { store.dispatch(_getUserHomeFeed(
                                            isAuthed: store.state.authState.loggedUser.id != null 
                                                        ? true 
                                                        : false,
                                            following: store.state.authState.loggedUser.following)); }

    return HomeFeedViewModel(
      state: store.state.homeFeedState,
      isAuthed: store.state.authState.loggedUser != null ? true : false,
      getHomeFeed: _onGetUserHomeFeed(),
    );
  }
}

ThunkAction _getUserHomeFeed({ @required bool isAuthed, @required List following }) {
  return (Store store) async {
    // store the Jtoken in the shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('JToken');

    Future(() async {
      if (isAuthed) {
        // set the loading to is loading for request is sent
        store.dispatch(GetLoggedUserHomeFeedRequestAction());

        // create the json data as the request body
        Map data = {'following': following};
        var body = convert.jsonEncode(data);

        // send the request
        http.Response response = await http.post(
            '${DotEnv().env['localhost']}/api/home/feed/logged_user',
            body: body,
            headers: {"Authorization": "Bearer $token",},
        );

        // check if the request is a success
        if (response.statusCode == 200) {
          // convert the response to json object
          var jsonResponse = convert.json.decode(response.body);

          // create post model and set the new state 
          List<Post> posts = [];
          List res = jsonResponse['posts'];
          for (var i = 0; i < res.length; i++)
            posts.add(Post.fromMap(res[i]));

          store.dispatch(GetLoggedUserHomeFeedSuccessAction(posts: posts));
        }
        // the request is a failure
        else {
          var jsonResponse = convert.json.decode(response.body);
          store.dispatch(GetLoggedUserHomeFeedFailedAction(message: jsonResponse['message']));
        }
      } else {
        // set the loading to is loading for request is sent
        store.dispatch(GetGuestUserHomeFeedRequestAction());

        // send the request
        http.Response response = await http.post(
            '${DotEnv().env['localhost']}/api/home/feed/guest_user',
        );

        // check if the request is a success
        if (response.statusCode == 200) {
          // convert the response to json object
          var jsonResponse = convert.json.decode(response.body);

          // create post model and set the new state 
          List<Post> posts = [];
          List res = jsonResponse['posts'];
          for (var i = 0; i < res.length; i++)
            posts.add(Post.fromMap(res[i]));

          store.dispatch(GetGuestUserHomeFeedSuccessAction(posts: posts));
        }
        // the request is a failure
        else {
          var jsonResponse = convert.json.decode(response.body);
          store.dispatch(GetGuestUserHomeFeedFailedAction(message: jsonResponse['message']));
        }
      }
    });
  };
}