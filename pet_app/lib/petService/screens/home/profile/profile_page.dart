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
import 'package:pet_app/widgets/loader.dart';

import '../../login/login_page.dart';

class ProfilePage extends StatefulWidget {
  static final routeName = '/user-profile';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
          if (snapshot.hasData) {
            final User currentUser = snapshot.data;
            return Center(
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
                          Navigator.of(context).pushNamed(MyPetsPage.routeName);
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
                        ServiceProviderWidget(),
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
