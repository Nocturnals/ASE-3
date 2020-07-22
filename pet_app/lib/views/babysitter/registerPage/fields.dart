// dart imports
import 'dart:convert' as convert;

// flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_redux/flutter_redux.dart';

// networking imports
import 'package:http/http.dart' as http;
import 'package:pet_app/constants/routeNames.dart';
import 'package:pet_app/redux/auth/authActions.dart';
import 'package:pet_app/redux/state.dart';

// UI imports
import 'package:pet_app/widgets/inputFields.dart';
import 'package:pet_app/widgets/loader.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Fields extends StatefulWidget {
  const Fields({Key key}) : super(key: key);

  @override
  _FieldsState createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // address varaibles
  String _lane;
  String _street;
  String _city;
  String _state;
  String _country;
  int _pinCode;

  // contact number
  int _contactNo;

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
    return SingleChildScrollView(
      child: _isLoading
          ? Center(
              child: Loader(),
            )
          : Form(
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
                          return 'Please provide your address pin code';
                        if (value.length != 6)
                          return 'Please provide correct pin code';
                        if (int.tryParse(value) == null)
                          return 'Pin code must only contain numbers';
                        return null;
                      },
                      (String value) {
                        _pinCode = int.parse(value);
                      },
                      _pinCode == null ? null : _pinCode.toString(),
                    ),
                  ),

                  SizedBox(
                    height: 25,
                  ),

                  // contact text
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text('Contact No'),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),

                  // contanct number field
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: _buildTextField(
                      'Mobile number',
                      (String value) {
                        if (value.isEmpty)
                          return 'Please provide your mobile number';
                        if (value.length != 10)
                          return 'Please provide correct mobile number';
                        if (int.tryParse(value) == null)
                          return 'Mobile number must only contain numbers';
                        return null;
                      },
                      (String value) {
                        _contactNo = int.parse(value);
                      },
                      _contactNo == null ? null : _contactNo.toString(),
                    ),
                  ),

                  // submit button
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: RaisedButton(
                      onPressed: registerUser,
                      color: Colors.blue,
                      child: Text('Register'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> registerUser() async {
    // check to validate the form
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // set loading to true
      setState(() {
        _isLoading = true;
      });
      try {
        // create the address instance
        Map mapData = {
          "lane": _lane,
          "street": _street,
          "city": _city,
          "state": _state,
          "country": _country,
          "postal_code": _pinCode.toString(),
          "contact_no": _contactNo,
        };

        // get the jsontoken of the current user
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String jToken = prefs.getString('JToken');

        // send the request
        http.Response response = await http.post(
          '${DotEnv().env['localhost']}/api/babysitter/register',
          // '${DotEnv().env['localhost']}/testing/',
          headers: {
            "authorization": 'bearer $jToken',
            "Content-Type": "application/json",
          },
          body: convert.jsonEncode(mapData),
        );

        var jsonResponse = convert.jsonDecode(response.body);
        // check if the response if success
        if (response.statusCode == 200) {
          Store<AppState> store = StoreProvider.of<AppState>(context);
          store.dispatch(AddMessageAction(message: jsonResponse['message']));
          // return Navigator.of(context)
          //     .pushReplacementNamed(RouteNames.babysitterPage);
        } else {
          print(
              'Error response with status code: ${response.statusCode} \nand message: ${jsonResponse['message']}');
          // show the error message
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(jsonResponse['message'])));
        }
      } catch (e) {
        print(e);
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Server problem')));
      }

      // set the isloading to false
      setState(() {
        _isLoading = false;
      });
    }
  }
}
