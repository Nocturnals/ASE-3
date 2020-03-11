import 'package:flutter/material.dart';
import 'package:pet_app/src/Widget/sideNavBar.dart';

class GuestHomePage extends StatefulWidget {
  GuestHomePage({Key key}) : super(key: key);

  @override
  GuestHomePageState createState() => GuestHomePageState();
}

class GuestHomePageState extends State<GuestHomePage> {
  Widget build(BuildContext context) {
    return sideNavBar(context);
  }
}
