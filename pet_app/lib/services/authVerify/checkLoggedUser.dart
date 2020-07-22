// dart imports
import 'dart:convert' as convert;

// flutter imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pet_app/constants/routeNames.dart';

// redux imports
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pet_app/redux/state.dart';
import 'package:pet_app/redux/auth/authActions.dart';

// model imports
import 'package:pet_app/models/user.dart';

// networking imports
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// navigation imports
import 'package:pet_app/constants/keys.dart';

/// To check the user is logged in or not
/// This checks the current status of the store
/// and if store is empty then checks the sharedpreferences
/// instance to get the token and then get the user info
class CheckLoggedUser {
  // singleton instance of the class
  static CheckLoggedUser _checkLoggedUser;

  // private constructor of this class
  CheckLoggedUser._create();

  /// returns a singleton instance of the class
  factory CheckLoggedUser() {
    if (_checkLoggedUser == null) {
      _checkLoggedUser = CheckLoggedUser._create();
    }

    return _checkLoggedUser;
  }

  /// This checks the current status of the store
  /// and if store is empty then checks the sharedpreferences
  /// instance to get the token and then get the user info
  Future<void> checkUserStatus({@required BuildContext context}) async {
    // get the store instance
    Store<AppState> store = StoreProvider.of<AppState>(context);

    // check if the user data is present in the store
    if (store.state.authState.loggedUser.id != null) {
      return;
    }

    // if the store is empty then check the for authorization token 'Jtoken' in the shared preferences
    // get the instance of shared preference
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // check if the authorization token exists
    if (prefs.containsKey('JToken')) {
      // get the value of JToken
      String jToken = prefs.getString('JToken');

      try {
        // check if the token is valid
        http.Response response = await http.get(
            '${DotEnv().env['localhost']}/api/auth/user',
            headers: {"authorization": 'bearer $jToken'});

        // convert the body of response from json object to dart dynamic map
        var jsonResponse = convert.json.decode(response.body);

        // check if the response if an success
        if (response.statusCode == 200) {
          // create user model and set the new state
          User authUser = User.fromMap(jsonResponse['user']);
          store.dispatch(LoginSuccessAction(user: authUser));

          return;
        } else {
          // get the error message
          store.dispatch(AddMessageAction(message: jsonResponse['message']));
        }
      } catch (e) {
        print(e);
        store.dispatch(AddMessageAction(message: 'Something crashed'));
      }
    } else {
      // navigate to the login screen as the user is not allowed to view
      // unauthorized contents

      // add the message to the state to login
      store.dispatch(AddMessageAction(
          message: 'You need to sign in to view this content'));
    }
    // navigate to the login screen
    Keys.navKey.currentState.pushReplacementNamed(RouteNames.loginPage);
    return;
  }
}
