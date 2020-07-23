import 'package:flutter/material.dart';
import 'package:pet_app/constants/keys.dart';
import 'package:pet_app/constants/routeNames.dart';
import 'package:pet_app/petService/model/user.dart';
import 'package:pet_app/petService/screens/home/profile/edit_profile_page.dart';
import 'package:pet_app/petService/screens/home/profile/service_provider_profile_widget.dart';
import 'package:pet_app/petService/screens/pets/my_pets/my_pets_page.dart';
import 'package:pet_app/petService/services/auth/auth_service.dart';
import 'package:pet_app/petService/services/services.dart';
import 'package:pet_app/petService/services/user/user_service.dart';
import 'package:pet_app/petService/widgets/profile_picture.dart';
import 'package:pet_app/widgets/card.dart';
import 'package:pet_app/widgets/loader.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../login/login_page.dart';

class ProfilePage extends StatefulWidget {
  static final routeName = '/user-profile';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _showNewUI = true;
  final UserService _userService = services.get<UserService>();
  final AuthService _authService = services.get<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Account"),
      ),
      body: FutureBuilder(
        future: _userService.getUser(_authService.currentUserUid),
        builder: (context, snapshot) {
          print(_showNewUI);
          if (snapshot.hasData) {
            final User currentUser = snapshot.data;
            return _showNewUI
                ? _Dashboard(currentUser: currentUser)
                : Center(
                    child: ListView(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            ProfilePicture(
                                image: null,
                                pictureUrl: currentUser.pictureUrl,
                                placeholderImageUri: "assets/blank_profile.png",
                                imageGetter: null),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              currentUser.username,
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            RaisedButton(
                              child: Text("Edit Profile"),
                              onPressed: () => Navigator.of(context).pushNamed(
                                  EditProfilePage.routeName,
                                  arguments: currentUser),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            RaisedButton(
                              child: Text("My Pets"),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(MyPetsPage.routeName);
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            RaisedButton(
                              onPressed: () {
                                Keys.navKey.currentState
                                    .pushNamed(RouteNames.petShop);
                              },
                              child: Text('PetShop'),
                            ),
                            if (currentUser.isServiceProvider)
                              ServiceProviderWidget(newUI: false),
                            SizedBox(
                              height: 20,
                            ),
                            RaisedButton(
                              child: Text("Log out"),
                              onPressed: () {
                                _authService.signOut();
                                Navigator.of(context)
                                    .pushReplacementNamed(LoginPage.routeName);
                              },
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ],
                    ),
                  );
          }
          return Center(
            child: Loader(),
          );
        },
      ),
    );
  }
}

class _Dashboard extends StatefulWidget {
  static const routeName = '/dashboard';
  final User currentUser;

  _Dashboard({Key key, @required this.currentUser}) : super(key: key);

  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<_Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: <Widget>[
          // SliverToBoxAdapter(
          //   child: Container(
          //     height: 136,
          //     margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: <Widget>[
          //         Text(
          //           'Your Pet\'s',
          //           style: TextStyle(fontSize: 45, fontWeight: FontWeight.w500),
          //         ),
          //         Text(
          //           'is here now!',
          //           style: TextStyle(fontSize: 45, fontWeight: FontWeight.w500),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SliverGrid.count(
            crossAxisCount: 2,
            children: <Widget>[
              card(
                context,
                'MyProfile',
                'svg',
                'My Profile',
                () => Navigator.of(context).pushNamed(EditProfilePage.routeName,
                    arguments: widget.currentUser),
              ),
              card(
                context,
                'MyPets',
                'svg',
                'My Pets',
                () {
                  Navigator.of(context).pushNamed(MyPetsPage.routeName);
                },
              ),
              card(
                context,
                'cart',
                'png',
                'Pet accessories',
                () {
                  Keys.navKey.currentState.pushNamed(RouteNames.petShop);
                },
              ),
              if (widget.currentUser.isServiceProvider)
                ServiceProviderWidget(newUI: true),
              card(
                context,
                'logout',
                'png',
                'Logout',
                () {
                  final AuthService _authService = services.get<AuthService>();
                  _authService.signOut();
                  Navigator.of(context)
                      .pushReplacementNamed(LoginPage.routeName);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
