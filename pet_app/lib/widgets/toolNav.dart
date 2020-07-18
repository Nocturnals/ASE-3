// flutter imports
import 'package:flutter/material.dart';
import 'package:pet_app/constants/keys.dart';

// redux imports
import 'package:pet_app/redux/auth/authActions.dart';
import 'package:pet_app/redux/state.dart';
import 'package:redux/redux.dart';

// navigation imports
import 'package:pet_app/constants/routeNames.dart';
import 'package:shared_preferences/shared_preferences.dart';

// internal imports
import 'cButtons.dart';

// App Bar
Widget appBar(BuildContext context) {
  return AppBar(
    centerTitle: true,
    title: cTitle(context),
    backgroundColor: Color(0xfff99100),
  );
}

// Side Drawer
Widget drawer(BuildContext context, {@required Store<AppState> store}) {
  bool userLoggedIn = false;

  if (store.state.authState.loggedUser.id != null) {
    userLoggedIn = true;
  }

  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xfffbb448), Color(0xffe46b10)])),
          child: userLoggedIn
              ? Text(store.state.authState.loggedUser.username)
              : Center(
                  child: RaisedButton(
                    onPressed: () {
                      // navigate to login page
                      Keys.navKey.currentState.pushNamed(RouteNames.loginPage);
                    },
                    color: Colors.transparent,
                    elevation: 0,
                    highlightColor: Colors.transparent,
                    focusElevation: 0,
                    hoverElevation: 0,
                    highlightElevation: 0,
                    disabledElevation: 0,
                    padding: EdgeInsets.zero,
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
        ),

        // manage pets tile
        ListTile(
          leading: Icon(Icons.pets),
          title: Text('Your Pets'),
          onTap: () {
            // navigate to the pets page
            Navigator.of(context).pushNamed(RouteNames.petPage);
          },
        ),

        // babysitting
        ListTile(
          leading: Icon(Icons.child_friendly),
          title: Text('BabySitting'),
          onTap: () {
            // navigate to the babysitting page
            Navigator.of(context).pushNamed(RouteNames.babysitterPage);
          },
        ),

        // signout profile card
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Sign out'),
          onTap: () {
            // signout the user
            store.dispatch(LogOutAction());

            // remove the stored shared preference
            SharedPreferences.getInstance().then((instance) {
              instance.remove('JToken');
            });

            // navigate to login and remove all before pages
            Navigator.of(context).pushNamedAndRemoveUntil(
              RouteNames.loginPage,
              (Route<dynamic> route) => false,
            );
          },
        ),
      ],
    ),
  );
}
