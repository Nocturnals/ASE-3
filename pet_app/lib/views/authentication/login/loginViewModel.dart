import 'dart:convert' as convert;

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:pet_app/models/user.dart' show User;
import 'package:pet_app/redux/state.dart' show AppState;
import 'package:pet_app/redux/auth/authActions.dart';
import 'package:pet_app/redux/auth/authState.dart' show AuthState;

class LoginViewModel {
  final AuthState state;
  final Function({@required String username, @required String password}) login;

  LoginViewModel({
    @required this.state,
    @required this.login,
  });

  factory LoginViewModel.create(Store<AppState> store) {
    _onLogin({@required String username, @required String password}) {
      store.dispatch(loginUser(
        username: username,
        password: password,
      ));
    }

    return LoginViewModel(
      state: store.state.authState,
      login: _onLogin,
    );
  }
}

ThunkAction loginUser({@required String username, @required String password}) {
  return (Store store) async {
    Future(() async {
      // set the loading to is loading for request is sent
      store.dispatch(LoginRequestSentAction());

      // create the json data as the request body
      Map data = {'username': username, 'password': password};
      var body = convert.jsonEncode(data);

      // send the request
      http.Response response = await http.post(
          '${DotEnv().env['localhost']}/api/auth/login',
          headers: {"Content-Type": "application/json"},
          body: body);

      // check if the request is a success
      if (response.statusCode == 200) {
        // convert the response to json object
        var jsonResponse = convert.json.decode(response.body);

        User authUser = User.fromMap(jsonResponse['user']);
        store.dispatch(LoginSuccessAction(user: authUser));
      }
      // the request is a failure
      else {
        // debugPrint(response.body);
        store.dispatch(LoginFailedAction());
      }
    });
  };
}
