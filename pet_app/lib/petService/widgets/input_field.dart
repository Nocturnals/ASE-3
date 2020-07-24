import 'package:flutter/material.dart';
import 'package:pet_app/widgets/inputFields.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool isObscure;

  const InputField(
      {Key key,
      this.controller,
      this.hintText,
      this.isObscure = false,
      this.keyboardType = TextInputType.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        keyboardType: keyboardType,
        autocorrect: false,
        controller: controller,
        decoration: inputTextfieldDecoration.copyWith(labelText: hintText),
        obscureText: isObscure,
      ),
    );
  }
}
