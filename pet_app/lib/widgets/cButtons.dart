import 'package:flutter/material.dart';
import 'package:pet_app/src/landing_page.dart';

import 'package:google_fonts/google_fonts.dart';

Widget cTitle(BuildContext context) {
  var a = false;
  return InkWell(
    onTap: () {
      if (a) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LandingPage()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LandingPage()));
      }
    },
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'pet',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          children: [
            TextSpan(
              text: 'S',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ]),
    ),
  );
}
Widget cTitle2(BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(
            context, MaterialPageRoute(builder: (context) => LandingPage()));
    },
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'pet',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'S',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ]),
    ),
  );
}


Widget cBackButton(BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.pop(context);
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
            child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
          )
        ],
      ),
    ),
  );
}
