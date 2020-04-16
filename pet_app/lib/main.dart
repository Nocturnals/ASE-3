import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:pet_app/constants/themeData.dart';
import 'package:pet_app/redux/state.dart';
import 'package:pet_app/redux/reducer.dart';

// ALL PAGES HERE
import 'package:pet_app/views/authentication/login/loginScreen.dart'
    show LoginScreen;
import 'package:pet_app/views/authentication/signup/signUpScreen.dart'
    show SignUpScreen;
import 'package:pet_app/views/authentication/forgotPassword/forgotPasswordScreen.dart'
    show ForgotPasswordScreen;
import 'package:pet_app/views/authentication/resetPassword/resetPasswordScreen.dart'
    show ResetPasswordScreen;
import 'package:pet_app/views/landingScreen/landingScreen.dart'
    show LandingPage;
import 'package:pet_app/views/home/guest/guestHomeScreen.dart'
    show GuestHomeScreen;
import 'package:pet_app/views/home/homeFeed/homePage.dart';

import 'package:pet_app/constants/keys.dart';

void main() async {
  // load the dot env file varaibles
  await DotEnv().load('.env');

  // define the global store of the application
  final Store<AppState> store = Store<AppState>(
    appStateReducer,
    initialState: AppState.initial(),
    middleware: [thunkMiddleware],
  );

  // run the actual application
  return runApp(PetSApp(
    store: store,
  ));
}

class PetSApp extends StatelessWidget {
  const PetSApp({Key key, @required this.store}) : super(key: key);
  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: this.store,
      child: MaterialApp(
        title: 'PetS',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        navigatorObservers: [],
        navigatorKey: Keys.navKey,
        routes: <String, WidgetBuilder>{
          // initail route
          '/landingPage': (BuildContext context) => LandingPage(),

          // auth routes
          '/login': (BuildContext context) => LoginScreen(),
          '/signup': (BuildContext context) => SignUpScreen(),
          '/forgotPassword': (BuildContext context) => ForgotPasswordScreen(),
          '/resetPassword': (BuildContext context) => ResetPasswordScreen(),

          // home page routes
          '/guest': (BuildContext context) => GuestHomeScreen(),
          '/homePage': (BuildContext context) => HomeScreen(),
        },
        initialRoute: '/landingPage',
      ),
    );
  }
}
