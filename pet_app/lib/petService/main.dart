import 'package:flutter/material.dart';
import 'package:pet_app/petService/screens/home/chat/chat_page.dart';
import 'package:pet_app/petService/screens/home/home_page.dart';
import 'package:pet_app/petService/screens/home/profile/edit_profile_page.dart';
import 'package:pet_app/petService/screens/home/splash_page.dart';
import 'package:pet_app/petService/screens/intro/intro_page.dart';
import 'package:pet_app/petService/screens/login/login_page.dart';
import 'package:pet_app/petService/screens/pet-sitter/pet_sitter_profile_page.dart';
import 'package:pet_app/petService/screens/pets/add-edit-pet/add-edit_pet_page.dart';
import 'package:pet_app/petService/screens/pets/my_pets/my_pets_page.dart';
import 'package:pet_app/petService/screens/pets/pet-profile/pet_profile.dart';
import 'package:pet_app/petService/screens/register/register_page.dart';
import 'package:pet_app/petService/screens/services/add-edit-service/add-edit_service_page.dart';
import 'package:pet_app/petService/screens/services/my-services/my_services_page.dart';
import 'package:pet_app/petService/screens/services/service-profile/service_profile.dart';
import 'package:pet_app/petService/services/services.dart';

void main() {
  initServices();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Color(0xFFFCAA7B),
          primaryColorLight: Color(0xFFFCBA94),
          primaryColorDark: Color(0xFFF27730),
          primaryColorBrightness: Brightness.dark,
          accentColor: Color(0xFFF27730),
          accentColorBrightness: Brightness.dark,
          backgroundColor: Color(0xFFF4EDE6),
          scaffoldBackgroundColor: Color(0xFFF4EBE1),
          dialogBackgroundColor: Color(0xFFF4EBE1),
          disabledColor: Color(0xFFCECECC),
          errorColor: Color(0xFFFF5242),
          primaryTextTheme: TextTheme(
            button: TextStyle(color: Colors.white),
          ),

          // Define the default font family.
          fontFamily: 'Georgia',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline5: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Color(0xFFB9E5E4),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(6.0),
                side: BorderSide(color: Color(0xFFB9E5F8))),
            textTheme: ButtonTextTheme.accent,
            colorScheme: Theme.of(context)
                .colorScheme
                .copyWith(secondary: Colors.black45),
            minWidth: 150.0,
            padding: EdgeInsets.all(15.0),
            alignedDropdown: true,
          )),
      title: 'Pet App',
      initialRoute: SplashPage.routeName,
      // initialRoute: 'dataBaseGetter',
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        RegisterPage.routeName: (context) => RegisterPage(),
        HomePage.routeName: (context) => HomePage(),
        EditProfilePage.routeName: (context) => EditProfilePage(),
        AddEditPetPage.routeName: (context) => AddEditPetPage(),
        MyPetsPage.routeName: (context) => MyPetsPage(),
        AddEditServicePage.routeName: (context) => AddEditServicePage(),
        MyServicesPage.routeName: (context) => MyServicesPage(),
        ServiceProfile.routeName: (context) => ServiceProfile(),
        SplashPage.routeName: (context) => SplashPage(),
        IntroPage.routeName: (context) => IntroPage(),
        PetSitterProfilePage.routeName: (context) => PetSitterProfilePage(),
        PetProfile.routeName: (context) => PetProfile(),
        ChatPage.routeName: (context) => ChatPage()
      },
    );
  }
}
