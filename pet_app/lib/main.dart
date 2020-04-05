import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:pet_app/src/landing_page.dart';

import 'package:pet_app/constants/themeData.dart';

// ALL PAGES HERE
import 'package:pet_app/views/authentication/login/loginScreen.dart';
import 'package:pet_app/views/authentication/signup/signUpScreen.dart';
import 'package:pet_app/views/authentication/forgotPassword/forgotPasswordScreen.dart';
import 'package:pet_app/views/authentication/resetPassword/resetPasswordScreen.dart';

void main() async {
  await DotEnv().load('.env');
  return runApp(PetSApp());
}

class PetSApp extends StatelessWidget {
  const PetSApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetS',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      navigatorObservers: [],
      routes: <String, WidgetBuilder>{
        // auth routes
        '/login': (BuildContext context) => LoginScreen(),
        '/signup': (BuildContext context) => SignUpScreen(),
        '/forgotPassword': (BuildContext context) => ForgotPasswordScreen(),
        '/resetPassword': (BuildContext context) => ResetPasswordScreen(),
      },
      initialRoute: '/resetPassword',
    );
  }
}
