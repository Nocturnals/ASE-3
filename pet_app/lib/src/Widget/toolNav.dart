import 'package:flutter/material.dart';

import 'package:pet_app/src/Widget/cButtons.dart';

// App Bar
Widget appBar(BuildContext context) {
  return AppBar(
    centerTitle: true,
    title: cTitle(context),
    backgroundColor: Color(0xfff99100),
  );
}

// Side Drawer
Widget drawer(BuildContext context) {
  var a = false;
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
          child: () {
            if (a) {
              return Text('Username');
            }
            else {
              return Center(
                child: RaisedButton(
                  onPressed: () {},
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
              );
            }
          } (),
        ),
        ListTile(
          title: Text('Item 1'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Item 2'),
          onTap: () {
            // Update the state of the app
            // ...
            // Then close the drawer
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
