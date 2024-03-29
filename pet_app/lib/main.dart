// flutter imports
import 'package:flutter/material.dart';

// networking imports
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pet_app/constants/keys.dart';
import 'package:pet_app/constants/routeNames.dart';

// redux imports
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:pet_app/redux/state.dart';
import 'package:pet_app/redux/reducer.dart';

// UI imports
import 'package:pet_app/constants/themeData.dart';

// All Routes imports
import 'package:pet_app/petShop/main.dart';
import 'package:pet_app/petService/main.dart';
import 'package:pet_app/views/pets/petPage.dart';
import 'package:pet_app/petService/services/services.dart';
import 'package:pet_app/views/errorPages/RouteNotFound.dart';
import 'package:pet_app/views/babysitter/babysitterPage.dart';
import 'package:pet_app/views/authentication/login/loginScreen.dart'
    show LoginScreen;
import 'package:pet_app/views/authentication/signup/signUpScreen.dart'
    show SignUpScreen;
import 'package:pet_app/views/authentication/forgotPassword/forgotPasswordScreen.dart'
    show ForgotPasswordScreen;
import 'package:pet_app/views/authentication/resetPassword/resetPasswordScreen.dart'
    show ResetPasswordScreen;
import 'package:pet_app/views/landingScreen/landingScreen.dart'
    show LandingPage;
import 'package:pet_app/views/home/guest/guestHomeScreen.dart'
    show GuestHomeScreen;
import 'package:pet_app/views/home/homeFeed/homePage.dart';

void main() async {
  // intialize the services requeired to run with the pet service app
  initServices();

  // load the dot env file varaibles
  await DotEnv().load('.env');

  // define the global store of the application based on development mode
  if (DotEnv().env['Development'] != 'true') {
    final Store<AppState> store = Store<AppState>(
      appStateReducer,
      initialState: AppState.initial(),
      middleware: [thunkMiddleware],
    );

    // run the actual application
    return runApp(PetSApp(
      store: store,
    ));
  }
  // the app is in production mode
  else {
    final DevToolsStore<AppState> store = DevToolsStore<AppState>(
      appStateReducer,
      initialState: AppState.initial(),
      middleware: [thunkMiddleware],
    );

    return runApp(
      ReduxDevToolsContainer(
        store: store,
        child: PetSApp(
          store: store,
          devReduxBuilder: (context) => Drawer(
            child: Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: ReduxDevTools(store),
            ),
          ),
        ),
      ),
    );
    // return runApp(PetShopApp());
  }
}

class PetSApp extends StatelessWidget {
  const PetSApp({Key key, @required this.store, this.devReduxBuilder})
      : super(key: key);
  final Store<AppState> store;
  final WidgetBuilder devReduxBuilder;

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: this.store,
      child: MaterialApp(
        title: 'PetS',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        navigatorObservers: [],
        navigatorKey: Keys.navKey,
        onGenerateRoute: (RouteSettings settings) {
          // Get the arguments from settings
          final args = settings.arguments;

          switch (settings.name) {
            // Initail route
            case RouteNames.landingPage:
              return MaterialPageRoute(
                  builder: (BuildContext context) => PetShopApp());

            // auth routes
            case RouteNames.loginPage:
              return MaterialPageRoute(
                  builder: (BuildContext context) =>
                      LoginScreen(devReduxBuilder: devReduxBuilder));
            case RouteNames.signup:
              return MaterialPageRoute(
                  builder: (BuildContext context) =>
                      SignUpScreen(devReduxBuilder: devReduxBuilder));
            case RouteNames.forgotPassword:
              return MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ForgotPasswordScreen(devReduxBuilder: devReduxBuilder));
            case RouteNames.resetPassword:
              return MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ResetPasswordScreen(devReduxBuilder: devReduxBuilder));

            // pet managing routes
            case RouteNames.petPage:
              return MaterialPageRoute(
                  builder: (BuildContext context) =>
                      PetScreen(devReduxBuilder: devReduxBuilder));

            // babysitter routes
            case RouteNames.babysitterPage:
              return MaterialPageRoute(
                  builder: (context) =>
                      BabySitterScreen(devReduxBuilder: devReduxBuilder));

            // home page routes
            case RouteNames.homePage:
              return MaterialPageRoute(
                  builder: (BuildContext context) =>
                      HomeScreen(devReduxBuilder: devReduxBuilder));
            case RouteNames.guest:
              return MaterialPageRoute(
                  builder: (BuildContext context) =>
                      GuestHomeScreen(devReduxBuilder: devReduxBuilder));

            // pet shop app route
            case RouteNames.petShop:
              return MaterialPageRoute(builder: (context) => PetShopApp());

            // pet service app route
            case RouteNames.petService:
              return MaterialPageRoute(builder: (context) => PetServiceApp());

            default:
              return MaterialPageRoute(
                  builder: (BuildContext context) => PageNotFoundScreen(
                      devReduxBuilder: devReduxBuilder,
                      routeName: settings.name));
          }
        },
        // initialRoute: RouteNames.homePage,
        initialRoute: RouteNames.petService,
      ),
    );
  }
}
