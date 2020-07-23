import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget card(
    context, String image, String imageType, String text, Function onTap) {
  print(imageType);
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 20.0,
            spreadRadius: 0.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          imageType == 'svg'
              ? SvgPicture.asset('assets/images/$image.svg')
              : Image.asset('assets/images/$image.png'),
          SizedBox(height: 20),
          Text(
            text,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
  );
}
