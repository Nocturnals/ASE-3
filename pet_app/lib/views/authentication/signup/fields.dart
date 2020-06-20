// flutter imports
import 'package:flutter/material.dart';

// redux imports
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:pet_app/redux/state.dart';

// model imports
import 'package:pet_app/models/loadingStatus.dart';

// UI imports
import 'package:pet_app/widgets/cButtons.dart';
import 'package:pet_app/widgets/loader.dart';

// internal imports
import './registerViewModel.dart';

class Fields extends StatefulWidget {
  Fields({Key key}) : super(key: key);

  @override
  _FieldsState createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _username;
  String _email;
  String _password;

  void validateAndSubmit(RegisterViewModel registerViewModel) {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      // form is valid
      form.save();
      registerViewModel.register(
          email: _email, password: _password, username: _username);
    }
  }

  Widget _submitButton(RegisterViewModel registerViewModel) {
    return GestureDetector(
      onTap: () {
        validateAndSubmit(registerViewModel);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _emailPasswordWidget(RegisterViewModel registerViewModel) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Username',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color(0xfff3f3f4),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Username can\'t be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _username = value;
                  },
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color(0xfff3f3f4),
                    filled: true,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Email can\'t be empty';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter correct email address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value;
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Password',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color(0xfff3f3f4),
                    filled: true,
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Password can\'t be emply';
                    }
                    if (value.length < 6) {
                      return 'Password must be atleast 6 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value;
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RegisterViewModel>(
      converter: (Store<AppState> store) => RegisterViewModel.create(store),
      builder: (BuildContext context, RegisterViewModel registerViewModel) {
        return registerViewModel.state.loadingStatus == LoadingStatus.loading
            ? Center(
                child: Loader(),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: SizedBox(),
                    ),
                    cTitle2(context),
                    SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(registerViewModel),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(registerViewModel),
                    Expanded(
                      flex: 2,
                      child: SizedBox(),
                    )
                  ],
                ),
              );
      },
    );
  }
}
