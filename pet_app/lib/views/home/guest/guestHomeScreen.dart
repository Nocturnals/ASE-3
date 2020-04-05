import 'package:flutter/material.dart';

import 'package:pet_app/widgets/toolNav.dart';
import 'package:pet_app/widgets/cWidgets.dart';

class GuestHomeScreen extends StatefulWidget {
  GuestHomeScreen({Key key}) : super(key: key);

  @override
  _GuestHomeScreenState createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),

      drawer: drawer(context),

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
            icon: Icon(Icons.person),
            title: Text('Profile')
          )
        ],
      ),
    );
  }
}
