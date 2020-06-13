// flutter imports
import 'package:flutter/material.dart';

// responsive app imports
import 'package:responsive_builder/responsive_builder.dart' hide WidgetBuilder;

// internal imports
import 'mobileView.dart';
import 'desktopTabletView.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key key, this.title, this.devReduxBuilder}) : super(key: key);

  final String title;
  final WidgetBuilder devReduxBuilder;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // Widget _label() {
  //   return Container(
  //       margin: EdgeInsets.only(top: 40, bottom: 20),
  //       child: Column(
  //         children: <Widget>[
  //           Text(
  //             'Quick login with Touch ID',
  //             style: TextStyle(color: Colors.white, fontSize: 17),
  //           ),
  //           SizedBox(
  //             height: 20,
  //           ),
  //           Icon(Icons.fingerprint, size: 90, color: Colors.white),
  //           SizedBox(
  //             height: 20,
  //           ),
  //           Text(
  //             'Touch ID',
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 15,
  //               decoration: TextDecoration.underline,
  //             ),
  //           ),
  //         ],
  //       ));
  // }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: widget.devReduxBuilder != null ? widget.devReduxBuilder(context) : null,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2),
            ],
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xfffbb448),
                Color(0xffe46b10),
              ],
            ),
          ),
          child: ScreenTypeLayout(
            mobile: MobileView(),
            tablet: DesktopTabletView(),
            desktop: DesktopTabletView(),
          ),
        ),
      ),
    );
  }
}
