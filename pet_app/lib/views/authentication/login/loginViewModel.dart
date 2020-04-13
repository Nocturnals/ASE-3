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
      store.dispatch(LoginRequestSentAction());
      Map data = {'username': username, 'password': password};
      var body = convert.jsonEncode(data);
      http.Response response =
          await http.post('${DotEnv().env['localhost']}/api/auth/login', headers: {"Content-Type": "application/json"}, body: body);
      debugPrint("request received");
      if (response.statusCode == 200) {
        // TODO: remove the log afterwards
        debugPrint('successfully logged in');
        var jsonResponse = convert.jsonDecode(response.body);
        debugPrint(jsonResponse);
        store.dispatch(LoginSuccessAction(user: User.initial()));
      } else {
        debugPrint(response.body);
        store.dispatch(LoginFailedAction());
      }
    });
  };
}
