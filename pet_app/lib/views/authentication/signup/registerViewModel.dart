// dart imports
import 'dart:convert' as convert;

// flutter imports
import 'package:flutter/material.dart';

// networking imports
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// redux imports
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'package:pet_app/redux/auth/authActions.dart';
import 'package:pet_app/redux/auth/authState.dart' show AuthState;
import 'package:pet_app/redux/state.dart' show AppState;

// navigation imports
import 'package:pet_app/constants/routeNames.dart';
import 'package:pet_app/constants/keys.dart';

class RegisterViewModel {
  final AuthState state;
  final Function(
      {@required String username,
      @required String email,
      @required String password}) register;

  RegisterViewModel({@required this.state, @required this.register});

  factory RegisterViewModel.create(Store<AppState> store) {
    _onRegister(
        {@required String username,
        @required String email,
        @required String password}) {
      store.dispatch(_register(
        username: username,
        email: email,
        password: password,
      ));
    }

    return RegisterViewModel(
        state: store.state.authState, register: _onRegister);
  }
}

ThunkAction _register(
    {@required String username, @required String email, @required password}) {
  return (Store store) async {
    Future<void>(() async {
      // set the loading to is loading for request is sent
      store.dispatch(RegisterRequestSentAction());

      // create the json data as request body
      Map data = {'username': username, 'password': password, 'email': email};
      var body = convert.jsonEncode(data);

      // send the request
      http.Response response = await http.post(
          '${DotEnv().env['localhost']}/api/auth/register',
          headers: {"Content-Type": "application/json"},
          body: body);

      // check if the response is a success
      if (response.statusCode == 200) {
        // store the success message and notify
        store.dispatch(
            RegisterSuccessAction(message: 'Successfully registered !!'));

        // navigate to login page
        Keys.navKey.currentState.pushNamedAndRemoveUntil(
            RouteNames.loginPage, (Route<dynamic> route) => false);
      }
      // the request is a failure
      else {
        var jsonResponse = convert.json.decode(response.body);
        store.dispatch(RegisterFailedAction(message: jsonResponse['message']));
      }
    });
  };
}
