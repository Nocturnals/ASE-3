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
  final String message;

  LoginFailedAction({@required this.message});
}
class RegisterRequestSentAction {
  RegisterRequestSentAction();
}

class RegisterFailedAction {
  final String message;

  RegisterFailedAction({@required this.message});
}

class RegisterSuccessAction {
  RegisterSuccessAction();
}

class ResetMessageAction {
  ResetMessageAction();
}