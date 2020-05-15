import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:pet_app/constants/keys.dart';
import 'package:redux/redux.dart';

import 'package:pet_app/redux/state.dart' show AppState;
import 'package:pet_app/models/loadingStatus.dart';
import 'package:pet_app/widgets/loader.dart';
import 'package:pet_app/widgets/cButtons.dart';

import 'package:pet_app/constants/bottomNavBarItems.dart';

import 'homeFeedViewModel.dart';

import 'package:pet_app/views/post/postScreen.dart';

class Fields extends StatefulWidget {
  Fields({Key key}) : super(key: key);

  @override
  _FieldsState createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  // bottom navigation bar index
  int _currentIndex;

  ScrollController _scrollController = ScrollController();

  void initState() {
    super.initState();

    _currentIndex = indexOfNavItem["home"];
  }

  // initializing state
  Widget _initialState(HomeFeedViewModel homeFeedViewModel) {
    homeFeedViewModel.getHomeFeed();

    return SizedBox(width: 0, height: 0,);
  }

  // function to change bottom navigation bar selected index
  void _navigate({ @required int index }) {
    if (_currentIndex != indexOfNavItem["createPost"]) {
      Keys.navKey.currentState.pushNamedAndRemoveUntil('/${routeOfNavItemIndex[index]}', (Route<dynamic> route) => false);
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // App Bar
    Widget _appBar(BuildContext context) {
      return AppBar(
        centerTitle: true,
        title: cTitle(context),
        backgroundColor: Color(0xfff99100),
      );
    }

    // login button
    Widget _loginButtonField() {
      return FlatButton(
        onPressed: () {
          Keys.navKey.currentState.pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        },
        color: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: EdgeInsets.zero,
        child: Text(
          "LOG IN", 
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      );
    }

    // signup button
    Widget _signupButtonField() {
      return FlatButton(
        onPressed: () {
          Keys.navKey.currentState.pushNamedAndRemoveUntil('/signup', (Route<dynamic> route) => false);
        },
        color: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: EdgeInsets.zero,
        child: Text(
          "SIGN UP", 
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      );
    }

    // Side Drawer
    Widget _drawer(BuildContext context) {
      return Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xfffbb448), Color(0xffe46b10)])),
              child: () {
                return Center(
                  child: Row(
                    children: <Widget>[
                      _loginButtonField(),
                      _signupButtonField(),
                    ],
                  ),
                );
              } (),
            ),
            // ListTile(
            //   title: Text('Item 1'),
            //   onTap: () {
            //     // Update the state of the app
            //     // ...
            //     // Then close the drawer
            //     Navigator.pop(context);
            //   },
            // ),
          ],
        ),
      );
    }

    return StoreConnector<AppState, HomeFeedViewModel>(
      converter: (Store<AppState> store) => HomeFeedViewModel.create(store),
      builder: (BuildContext context, HomeFeedViewModel homeFeedViewModel) =>
          Scaffold(
            appBar: _appBar(context),
            drawer: homeFeedViewModel.isAuthed ? null : _drawer(context),
            body: homeFeedViewModel.state.loadingStatus == LoadingStatus.idle 
                    ? _initialState(homeFeedViewModel)
                    : homeFeedViewModel.state.loadingStatus == LoadingStatus.loading
                          ? Center(
                              child: Loader(),
                            )
                          : homeFeedViewModel.state.loadingStatus == LoadingStatus.success 
                              ? ListView.builder(
                                  padding: EdgeInsets.all(0),
                                  controller: _scrollController,
                                  dragStartBehavior: DragStartBehavior.down,
                                  itemCount: 10,
                                  itemBuilder: (BuildContext context, int index) {
                                    return PostScreen(
                                      post: homeFeedViewModel.state.posts[index]
                                    );
                                  },
                                )
                              : SnackBar(content: Text("Couldn't update feed! Try again")),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                _navigate(index: index);
              },
              currentIndex: _currentIndex,
              items: bottomNavBarItems
            ),
          )
    );
  }
}