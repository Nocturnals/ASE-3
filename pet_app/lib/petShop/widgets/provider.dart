import 'package:flutter/material.dart';
import 'package:pet_app/petShop/model/services/auth_service.dart';

class MyProvider extends InheritedWidget {
  final AuthService auth;
  MyProvider({
    Key key,
    Widget child,
    this.auth,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static MyProvider of(BuildContext context) =>
      // ignore: deprecated_member_use
      (context.inheritFromWidgetOfExactType(MyProvider) as MyProvider);
}
