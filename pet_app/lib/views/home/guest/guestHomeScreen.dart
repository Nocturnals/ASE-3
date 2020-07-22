// flutter imports
import 'package:flutter/material.dart';

// redux imports
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pet_app/redux/state.dart';
import 'package:redux/redux.dart';

// UI imports
import 'package:pet_app/widgets/toolNav.dart';
import 'package:pet_app/widgets/cWidgets.dart';

class GuestHomeScreen extends StatefulWidget {
  final WidgetBuilder devReduxBuilder;

  GuestHomeScreen({Key key, this.devReduxBuilder}) : super(key: key);

  @override
  _GuestHomeScreenState createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  Widget build(BuildContext context) {
    return StoreBuilder(builder: (BuildContext context, Store<AppState> store) {
      return Scaffold(
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
    });
  }
}
