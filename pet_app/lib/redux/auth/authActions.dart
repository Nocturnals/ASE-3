import 'package:flutter/foundation.dart';

import 'package:pet_app/models/user.dart';

class LoginRequestSentAction {
  LoginRequestSentAction();
}

class LoginSuccessAction {
  final User user;

  LoginSuccessAction({@required this.user});
}

class LoginFailedAction {
  LoginFailedAction();
}