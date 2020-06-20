// flutter imports
import 'package:flutter/material.dart';

// redux imports
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:pet_app/redux/state.dart' show AppState;

// model imports
import 'package:pet_app/models/loadingStatus.dart';
import 'package:pet_app/widgets/loader.dart';

// UI imports
import 'package:pet_app/widgets/cButtons.dart';
import 'package:pet_app/constants/routeNames.dart';

// internal imports
import 'loginViewModel.dart';

class Fields extends StatefulWidget {
  Fields({Key key}) : super(key: key);

  @override
  _FieldsState createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _username;
  String _password;

  void validateAndSubmit(LoginViewModel loginViewModel) {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      // form is valid
      form.save();
      loginViewModel.login(username: _username, password: _password);
    }
  }

  Widget _submitButton(LoginViewModel loginViewModel) {
    return GestureDetector(
      onTap: () {
        validateAndSubmit(loginViewModel);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xfffbb448),
              Color(0xfff7892b),
            ],
          ),
        ),
        child: Text(
          'Login',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _usernamePasswordWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          //  email field
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Username',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
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
                      return 'Username can\'t be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _username = value;
                  },
                ),
              ],
            ),
          ),

          // passwword field
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoginViewModel>(
      converter: (Store<AppState> store) => LoginViewModel.create(store),
      builder: (BuildContext context, LoginViewModel loginVeiwModel) =>
          loginVeiwModel.state.loadingStatus == LoadingStatus.loading
              ? Center(
                  child: Loader(),
                )
              : Container(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: Container(
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
                          _usernamePasswordWidget(),
                          SizedBox(
                            height: 20,
                          ),
                          _submitButton(loginVeiwModel),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(RouteNames.forgotPassword);
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color: Color(0xfff79c4f),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
