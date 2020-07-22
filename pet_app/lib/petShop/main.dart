import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_app/petShop/model/notifiers/brands_notifier.dart';
import 'package:pet_app/petShop/model/notifiers/cart_notifier.dart';
import 'package:pet_app/petShop/model/notifiers/products_notifier.dart';
import 'package:pet_app/petShop/model/notifiers/userData_notifier.dart';
import 'package:pet_app/petShop/model/services/auth_service.dart';
import 'package:pet_app/petShop/screens/getstarted_screens/intro_screen.dart';
import 'package:pet_app/petShop/screens/getstarted_screens/splash_screen.dart';
import 'package:pet_app/petShop/screens/tab_screens/home.dart';
import 'package:pet_app/petShop/screens/tab_screens/settings.dart';
import 'package:pet_app/petShop/screens/register_screens/login_screen.dart';
import 'package:pet_app/petShop/screens/register_screens/registration_screen.dart';
import 'package:pet_app/petShop/screens/register_screens/reset_screen.dart';
import 'package:pet_app/petShop/screens/settings_screens/cards.dart';
import 'package:pet_app/petShop/screens/settings_screens/changePassword.dart';
import 'package:pet_app/petShop/screens/settings_screens/passwordSecurity.dart';
import 'package:pet_app/petShop/utils/colors.dart';
import 'package:pet_app/petShop/widgets/provider.dart';
import 'package:pet_app/petShop/widgets/tabsLayout.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(PetShopApp());
}

final routes = {
  '/Registration': (BuildContext context) => RegistrationScreen(),
  '/Homescreen': (BuildContext context) => HomeScreen(),
  '/Login': (BuildContext context) => LoginScreen(),
  '/Reset': (BuildContext context) => ResetScreen(),
  '/home': (BuildContext context) => HomeController(),
  '/Settings': (BuildContext context) => SettingsScreen(),
  '/Security': (BuildContext context) => SecurityScreen(),
  '/ChangePassword': (BuildContext context) => ChangePasswordScreen(),
  '/Cards': (BuildContext context) => Cards(),
  '/MyTabs': (BuildContext context) => TabsLayout(),
};

class HomeController extends StatefulWidget {
  const HomeController({Key key}) : super(key: key);

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class PetShopApp extends StatelessWidget {
  const PetShopApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyProvider(
      auth: AuthService(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: HomeController(),
      ),
    );
  }
}

class _HomeControllerState extends State<HomeController> {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = MyProvider.of(context).auth;

    return StreamBuilder(
        stream: auth.onAuthStateChanged,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final bool signedIn = snapshot.hasData;
            return MaterialApp(
              title: "Pet Shop",
              theme: ThemeData(
                accentColor: MColors.primaryPurple,
                primaryColor: MColors.primaryPurple,
              ),
              debugShowCheckedModeBanner: false,
              home: signedIn
                  ? MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                          create: (context) => ProductsNotifier(),
                        ),
                        ChangeNotifierProvider(
                          create: (context) => BrandsNotifier(),
                        ),
                        ChangeNotifierProvider(
                          create: (context) => CartNotifier(),
                        ),
                        ChangeNotifierProvider(
                          create: (context) => UserDataProfileNotifier(),
                        ),
                        ChangeNotifierProvider(
                          create: (context) => UserDataAddressNotifier(),
                        ),
                      ],
                      child: TabsLayout(),
                    )
                  : IntroScreen(),
            );
          }
          return SplashScreen();
        });
  }
}
