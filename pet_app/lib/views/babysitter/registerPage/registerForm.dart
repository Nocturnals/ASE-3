// flutter imports
import 'package:flutter/material.dart';

// UI imports
import 'package:pet_app/widgets/containers.dart';

// internal imports
import './fields.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: elevatedBoxDecoration,
      child: Fields(),
    );
  }
}
