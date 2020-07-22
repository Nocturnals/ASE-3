import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pet_app/petShop/main.dart';
import 'package:pet_app/petShop/model/notifiers/userData_notifier.dart';
import 'package:pet_app/petShop/model/services/auth_service.dart';
import 'package:pet_app/petShop/model/services/user_management.dart';
import 'package:pet_app/petShop/screens/settings_screens/cards.dart';
import 'package:pet_app/petShop/screens/settings_screens/editProfile.dart';
import 'package:pet_app/petShop/screens/settings_screens/passwordSecurity.dart';
import 'package:pet_app/petShop/utils/colors.dart';
import 'package:pet_app/petShop/widgets/allWidgets.dart';
import 'package:pet_app/petShop/widgets/provider.dart';
import 'package:provider/provider.dart';

import 'checkout_screens/enterAddress.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future profileFuture;
  Future addressFuture;

  @override
  void initState() {
    UserDataProfileNotifier profileNotifier =
        Provider.of<UserDataProfileNotifier>(context, listen: false);
    profileFuture = getProfile(profileNotifier);

    UserDataAddressNotifier addressNotifier =
        Provider.of<UserDataAddressNotifier>(context, listen: false);
    addressFuture = getAddress(addressNotifier);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserDataProfileNotifier profileNotifier =
        Provider.of<UserDataProfileNotifier>(context);
    var checkUser = profileNotifier.userDataProfileList;
    var user;
    if (profileNotifier.userDataProfileList.isNotEmpty)
      user = profileNotifier.userDataProfileList.first;

    UserDataAddressNotifier addressNotifier =
        Provider.of<UserDataAddressNotifier>(context);
    var checkaddressList = addressNotifier.userDataAddressList;
    var addressList;
    checkaddressList.isEmpty || checkaddressList == null
        ? addressList = null
        : addressList = checkaddressList;

    return FutureBuilder(
      future: Future.wait([
        profileFuture,
        addressFuture,
      ]),
      builder: (c, s) {
        switch (s.connectionState) {
          case ConnectionState.active:
            return progressIndicator(MColors.primaryPurple);
            break;
          case ConnectionState.done:
            return checkUser.isEmpty || checkUser == null
                ? progressIndicator(MColors.primaryPurple)
                : showSettings(user, addressList);

            break;
          case ConnectionState.waiting:
            return progressIndicator(MColors.primaryPurple);
            break;
          default:
            return progressIndicator(MColors.primaryPurple);
        }
      },
    );
  }

  Widget showSettings(user, addressList) {
    var _checkAddress;
    addressList == null || addressList.isEmpty
        ? _checkAddress = null
        : _checkAddress = addressList.first;
    var _address = _checkAddress;

    final listTileIcons = [
      "assets/images/password.svg",
      "assets/images/icons/Wallet.svg",
      "assets/images/icons/Location.svg",
      "assets/images/gift.svg",
      "assets/images/help.svg",
      "assets/images/question.svg",
    ];

    final listTileNames = [
      "Security",
      "Cards",
      "Address",
      "Invite a friend",
      "Help",
      "FAQs",
    ];

    final listTileActions = [
      () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SecurityScreen(),
          ),
        );
      },
      () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => Cards1(),
          ),
        );
      },
      () async {
        var navigationResult = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => Address(_address, addressList),
          ),
        );
        if (navigationResult == true) {
          UserDataAddressNotifier addressNotifier =
              Provider.of<UserDataAddressNotifier>(context, listen: false);

          setState(() {
            getAddress(addressNotifier);
          });
          showSimpleSnack(
            "Address has been updated",
            Icons.check_circle_outline,
            Colors.green,
            _scaffoldKey,
          );
        }
      },
      () {
        shareWidget();
      },
      () {},
      () {},
    ];

    return Scaffold(
      backgroundColor: MColors.primaryWhiteSmoke,
      key: _scaffoldKey,
      body: primaryContainer(
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: SvgPicture.asset(
                              "assets/images/femaleAvatar.svg",
                              height: 90,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MColors.dashPurple,
                            ),
                          ),
                        ),
                      ),
                      RawMaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 0.0,
                        hoverElevation: 0.0,
                        focusElevation: 0.0,
                        highlightElevation: 0.0,
                        onPressed: () async {
                          UserDataProfileNotifier profileNotifier =
                              Provider.of<UserDataProfileNotifier>(context,
                                  listen: false);
                          var navigationResult =
                              await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditProfile(user),
                            ),
                          );
                          if (navigationResult == true) {
                            setState(() {
                              getProfile(profileNotifier);
                            });
                            showSimpleSnack(
                              "Profile has been updated",
                              Icons.check_circle_outline,
                              Colors.green,
                              _scaffoldKey,
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      user.name,
                                      style:
                                          boldFont(MColors.primaryPurple, 16.0),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      user.email,
                                      style: normalFont(MColors.textGrey, 14.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                width: 100,
                                height: 18.0,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  color: MColors.dashPurple,
                                ),
                                child: Center(
                                  child: Text("EDIT PROFILE",
                                      style: normalFont(
                                          MColors.primaryPurple, 12.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Divider(
                  height: 1.0,
                ),
                Container(
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: listTileNames.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return FutureBuilder(
                          future: addressFuture,
                          builder: (c, s) {
                            return Container(
                              child: Column(
                                children: <Widget>[
                                  listTileButton(
                                    listTileActions[i],
                                    listTileIcons[i],
                                    listTileNames[i],
                                    MColors.primaryPurple,
                                  ),
                                  Divider(
                                    height: 1.0,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: Column(
          children: <Widget>[
            Container(
              child: listTileButton(
                () {
                  _showLogOutDialog();
                },
                "assets/images/logout.svg",
                "Sign out",
                Colors.redAccent,
              ),
            ),
            Container(
              child: Center(
                child: Text(
                  "Version 0.0.1",
                  style: normalFont(MColors.textGrey, 14.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogOutDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              "Are you sure you want to sign out?",
              style: normalFont(MColors.textGrey, 14.0),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: normalFont(MColors.textGrey, 14.0),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  try {
                    Navigator.of(context).pop();

                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => PetShopApp(),
                      ),
                    );
                    print("Signed out.");
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text(
                  "Sign out",
                  style: normalFont(Colors.redAccent, 14.0),
                ),
              ),
            ],
          );
        });
  }
}
