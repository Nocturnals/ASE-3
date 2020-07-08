// flutter imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// UI imports
import 'package:pet_app/widgets/containers.dart';
import 'package:pet_app/widgets/inpurtFields.dart';

class AddPetView extends StatefulWidget {
  const AddPetView({Key key}) : super(key: key);

  @override
  _AddPetViewState createState() => _AddPetViewState();
}

class _AddPetViewState extends State<AddPetView> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _petName;
  String _animalType;
  DateTime _dob = DateTime.now();

  Widget _buildTextField(String labelText, Function validator, Function onSaved,
      [bool obscureText = false]) {
    return TextFormField(
      initialValue: _petName,
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
        child: Column(
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
                      (value) {
                        if (value.isEmpty)
                          return 'Please provide your pet name';
                        return null;
                      },
                      (newValue) {
                        _petName = newValue;
                      },
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    // animalType field
                    _buildTextField(
                      'Animal type',
                      (value) {
                        if (value) return 'Please provide animal type';
                        return null;
                      },
                      (String newValue) {
                        _animalType = newValue.toLowerCase();
                      },
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
                      height: 600,
                    ),

                    // button to submit
                    RaisedButton(
                      onPressed: () {},
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
