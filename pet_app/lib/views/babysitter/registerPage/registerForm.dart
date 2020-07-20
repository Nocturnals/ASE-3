import 'package:flutter/material.dart';
import 'package:pet_app/widgets/containers.dart';
import 'package:pet_app/widgets/inpurtFields.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // address varailbles
  String _lane;
  String _street;
  String _city;
  String _state;
  String _country;
  int _pinCode;

  Widget _buildTextField(String labelText, Function validator, Function onSaved,
      String initialValue,
      [bool obscureText = false]) {
    return TextFormField(
      initialValue: initialValue,
      decoration: inputTextfieldDecoration.copyWith(
        labelText: labelText,
        fillColor: Colors.grey.withOpacity(0.1),
        filled: true,
      ),
      keyboardType: TextInputType.text,
      onSaved: onSaved,
      validator: validator,
      obscureText: obscureText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: elevatedBoxDecoration,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // address text
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: Theme.of(context).primaryColor),
                width: double.infinity,
                height: 35,
                alignment: Alignment.center,
                child: Text('Address'),
              ),

              // lane field
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: _buildTextField(
                  'Lane',
                  (String value) {
                    if (value.isEmpty)
                      return 'Please provide your address lane';
                    return null;
                  },
                  (value) {
                    _lane = value;
                  },
                  _lane,
                ),
              ),

              // street field
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: _buildTextField(
                  'Street',
                  (String value) {
                    if (value.isEmpty)
                      return 'Please provide your address street';
                    return null;
                  },
                  (value) {
                    _street = value;
                  },
                  _street,
                ),
              ),

              // city field
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: _buildTextField(
                  'City',
                  (String value) {
                    if (value.isEmpty)
                      return 'Please provide your address city';
                    return null;
                  },
                  (value) {
                    _city = value;
                  },
                  _city,
                ),
              ),

              // state field
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: _buildTextField(
                  'State',
                  (String value) {
                    if (value.isEmpty)
                      return 'Please provide your address state';
                    return null;
                  },
                  (value) {
                    _state = value;
                  },
                  _state,
                ),
              ),

              // country field
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: _buildTextField(
                  'Country',
                  (String value) {
                    if (value.isEmpty) return 'Please provide your country';
                    return null;
                  },
                  (value) {
                    _country = value;
                  },
                  _country,
                ),
              ),

              // pin code field
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                child: _buildTextField(
                  'pin code',
                  (String value) {
                    if (value.isEmpty)
                      return 'Please provide your address lane';
                    if (value.length != 6)
                      return 'Please provide correct pin code';
                    if (int.tryParse(value) == null)
                      return 'Pin code must only contain numbers';
                    return null;
                  },
                  (String value) {
                    _pinCode = int.parse(value);
                  },
                  _pinCode.toString(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
