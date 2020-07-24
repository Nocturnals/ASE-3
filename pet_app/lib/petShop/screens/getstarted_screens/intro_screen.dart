import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_app/petShop/screens/register_screens/login_screen.dart';
import 'package:pet_app/petShop/screens/register_screens/registration_screen.dart';
import 'package:pet_app/petShop/utils/colors.dart';
import 'package:pet_app/petShop/utils/strings.dart';
import 'package:pet_app/petShop/widgets/allWidgets.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        AlertDialog alertDialog = AlertDialog(
          title: Center(
            child: Text('Are you sure'),
          ),
          content: Text('  want to close the app?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Not Yet'),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                // return exit(0);
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
          ],
        );
        return showDialog(
          context: context,
          builder: (_) {
            return alertDialog;
          },
        );
      },
      child: Scaffold(
        body: primaryContainer(
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: SvgPicture.asset(
                    "assets/images/pets.svg",
                    height: 200,
                  ),
                ),
                SizedBox(height: 30.0),
                Container(
                  child: Text(
                    "Welcome to PetS",
                    style: boldFont(MColors.textDark, 30.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  child: Text(
                    Strings.onBoardTitle_sub1,
                    style: normalFont(MColors.textGrey, 18.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 150.0,
          color: MColors.primaryWhite,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              primaryButtonPurple(
                Text(
                  "Sign in",
                  style: boldFont(MColors.primaryWhite, 16.0),
                ),
                () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => LoginScreen(),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              primaryButtonWhiteSmoke(
                Text(
                  "Create an account",
                  style: boldFont(MColors.primaryPurple, 16.0),
                ),
                () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => RegistrationScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
