import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:pet_app/src/landing_page.dart';

import 'package:pet_app/constants/themeData.dart';
import 'package:pet_app/views/authentication/login/loginScreen.dart';

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
        '/': (BuildContext context) => LoginScreen(),
      },
      initialRoute: '/',
    );
  }
}
