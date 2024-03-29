import 'package:flutter/material.dart';
import 'package:pet_app/petService/helpers/app_dialogs.dart';
import 'package:pet_app/petService/helpers/error_messages.dart';
import 'package:pet_app/petService/screens/home/home_page.dart';
import 'package:pet_app/petService/screens/login/login_form.dart';
import 'package:pet_app/petService/services/auth/auth_service.dart';
import 'package:pet_app/petService/services/services.dart';
import 'package:pet_app/petService/widgets/profile_picture.dart';

class LoginPage extends StatefulWidget {
  static final routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = services.get<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          new Container(
            height: 170.0,
            width: 170.0,
            margin: const EdgeInsets.all(30),
            decoration: new BoxDecoration(
              image: DecorationImage(
                image: new AssetImage('assets/logo.png'),
                fit: BoxFit.fill,
              ),
              shape: BoxShape.rectangle,
            ),
          ),
          Container(
            decoration: BoxDecoration(
//              color: Color(0xFFF4EDE2),
              borderRadius: const BorderRadius.all(const Radius.circular(20)),
            ),
            margin: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                LoginForm(loginHandler: (email, password) async {
                  _authService
                      .signIn(email, password)
                      .then((value) => Navigator.of(context)
                          .pushReplacementNamed(HomePage.routeName))
                      .catchError((error, stackTrace) {
                    AppDialogs.showAlertDialog(context, "Login failed",
                        ErrorMessages.getErrorMessage(error));
                  });
                }),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushReplacementNamed("/register"),
                  child: Text("Don't have an account?"),
                )
              ],
            ),
          ),
        ])),
      ],
    ));
  }
}
