// dart imports
import 'dart:convert' as convert;

// flutter imports
import 'package:flutter/material.dart';

// networking imports
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

// UI imports
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_app/widgets/containers.dart';
import 'package:pet_app/widgets/inputFields.dart';
import 'package:pet_app/widgets/loader.dart';

class AddPetView extends StatefulWidget {
  const AddPetView({Key key}) : super(key: key);

  @override
  _AddPetViewState createState() => _AddPetViewState();
}

class _AddPetViewState extends State<AddPetView> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _petName;
  String _animalType;
  DateTime _dob = DateTime.now();

  // add pet function
  void _addpet() async {
    // validate the form
    if (_formKey.currentState.validate()) {
      // save the form
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });

      try {
        // create the map data of the body of the request
        Map mapData = {
          "petName": _petName,
          "animalType": _animalType,
          "dob": _dob.toString()
        };

        // get the jsontoken of the current user
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String jToken = prefs.getString('JToken');

        // send the request
        http.Response response = await http.post(
          '${DotEnv().env['localhost']}/api/pet/register',
          headers: {
            "authorization": 'bearer $jToken',
            "Content-Type": "application/json",
          },
          body: convert.jsonEncode(mapData),
        );

        var jsonResponse = convert.jsonDecode(response.body);
        // check if the response if success
        if (response.statusCode == 200) {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('Successfully added $_petName')));
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
            .showSnackBar(SnackBar(content: Text('Internal server error')));
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

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
      margin: EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 20),
      width: MediaQuery.of(context).size.width,
      decoration: elevatedBoxDecoration,
      child: SingleChildScrollView(
        child: _isLoading
            ? Center(
                child: Loader(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // add pet text
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: Colors.blue,
                    ),
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        'App Pet',
                        style: GoogleFonts.bangers(
                          color: Colors.deepPurple,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),

                  // form container
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // petname field
                          _buildTextField(
                            'Pet name',
                            (String value) {
                              if (value.isEmpty)
                                return 'Please provide your pet name';
                              return null;
                            },
                            (newValue) {
                              _petName = newValue;
                            },
                            _petName,
                          ),

                          SizedBox(
                            height: 20,
                          ),

                          // animalType field
                          _buildTextField(
                            'Animal type',
                            (String value) {
                              if (value.isEmpty)
                                return 'Please provide animal type';
                              return null;
                            },
                            (String newValue) {
                              _animalType = newValue.toLowerCase();
                            },
                            _animalType,
                          ),

                          SizedBox(
                            height: 25,
                          ),

                          // date picker
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RaisedButton(
                                  onPressed: () {
                                    // show the date picker
                                    showDatePicker(
                                            context: context,
                                            initialDate: _dob,
                                            firstDate: DateTime(1950),
                                            lastDate: DateTime.now())
                                        .then((value) {
                                      if (value != null) _dob = value;
                                    });
                                  },
                                  child: Text('Date of birth'),
                                ),

                                // show picked date
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.calendar_today),
                                      Container(
                                        width: 5,
                                      ),
                                      Text(
                                        _dob.day.toString() +
                                            '/' +
                                            _dob.month.toString() +
                                            '/' +
                                            _dob.year.toString(),
                                        style: GoogleFonts.aBeeZee(),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 45,
                          ),

                          // button to submit
                          RaisedButton(
                            color: Colors.deepOrange[300],
                            onPressed: () {
                              _addpet();
                            },
                            child: Text('Add pet'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
