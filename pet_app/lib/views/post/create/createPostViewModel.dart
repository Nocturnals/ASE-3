import 'dart:convert' as convert;

import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pet_app/constants/keys.dart';
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
      // store the Jtoken in the shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('JToken');

      // dispatch request sent action
      store.dispatch(CreatePostRequestSentAction());

      // navigate to home page
      Keys.navKey.currentState.pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);

      // create the json data as the request body
      Map data = {'description': description, 'media_urls': mediaUrls};
      var body = convert.jsonEncode(data);

      // send post request
      http.Response response =
          await http.post(
            '${DotEnv().env['localhost']}/api/post/create',
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
            body: body
          );

      // check the response status code
      if (response.statusCode == 200) {
        // convert response to json object
        var jsonResponse = convert.jsonDecode(response.body);
        debugPrint(jsonResponse);

        // dispatch success action
        store.dispatch(CreatePostSuccessAction(message: jsonResponse['message']));
      }
      else {
        // convert response to json object
        var jsonResponse = convert.json.decode(response.body);

        // dispatch failure action
        store.dispatch(CreatePostFailedAction(message: jsonResponse['error']));
      }
    });
  };
}
