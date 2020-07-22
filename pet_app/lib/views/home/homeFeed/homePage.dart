// flutter imports
import 'package:flutter/material.dart';

// redux imports
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:pet_app/redux/state.dart';

// navigation imports
import 'package:pet_app/services/authVerify/checkLoggedUser.dart';

// UI imports
import 'package:pet_app/widgets/cWidgets.dart';
import 'package:pet_app/widgets/toolNav.dart';
import 'package:pet_app/widgets/loader.dart';

class HomeScreen extends StatefulWidget {
  final WidgetBuilder devReduxBuilder;

  const HomeScreen({Key key, this.devReduxBuilder}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading;

  Future<void> checkUserState() async {
    // check if user is logged in and valid
    await CheckLoggedUser().checkUserStatus(context: context);

    // return isloading to false
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    // set the is loadint to true as we get the user validated
    setState(() {
      _isLoading = true;
    });

    // check the user and validate
    Future.delayed(Duration(milliseconds: 100), checkUserState);
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      builder: (BuildContext context, Store<AppState> store) {
        return _isLoading
            ? Center(child: Loader())
            : Scaffold(
                appBar: appBar(context),
                drawer: drawer(context, store: store),
                endDrawer: widget.devReduxBuilder != null
                    ? widget.devReduxBuilder(context)
                    : null,
                body: ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    // Map post = posts[index];
                    return PostItem(
                      dp: 'assets/image.jpg',
                      descr: '... Description ...',
                      postImage: 'assets/image.jpg',
                      name: 'Neelakanta Sriram',
                      username: 'neelakanta.sriram',
                      time: '3d',
                    );
                  },
                ),
                bottomNavigationBar: BottomNavigationBar(
                  onTap: null,
                  currentIndex: 0, // this will be set when a new tab is tapped
                  items: [
                    BottomNavigationBarItem(
                      icon: new Icon(Icons.home),
                      title: new Text('Home'),
                    ),
                    BottomNavigationBarItem(
                      icon: new Icon(Icons.mail),
                      title: new Text('Messages'),
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person), title: Text('Profile'))
                  ],
                ),
              );
      },
    );
  }
}
