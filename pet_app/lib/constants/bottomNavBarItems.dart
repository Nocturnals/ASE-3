import 'package:flutter/material.dart';

// navigation ar items
List<BottomNavigationBarItem> bottomNavBarItems = <BottomNavigationBarItem>[
  // Home Item
  BottomNavigationBarItem(
    icon: new Icon(Icons.home),
    title: new Text('Home'),
    activeIcon: new Icon(Icons.home, color: Colors.black,),
  ),

  // Create Post Item
  BottomNavigationBarItem(
    icon: new Icon(Icons.add_circle),
    title: new Text('Create Post'),
    activeIcon: new Icon(Icons.add_circle, color: Colors.black,),
  ),

  // Profile Item
  BottomNavigationBarItem(
    icon: Icon(Icons.person),
    title: Text('Profile'),
    activeIcon: new Icon(Icons.person, color: Colors.black,),
  )
];


// indices of nav item
const Map<String, int> indexOfNavItem = {
  "home": 0,
  "createPost": 1,
  "profile": 2
};


// routes of nav item index
const Map<int, String> routeOfNavItemIndex = {
  0: "home",
  1: "createPost",
  2: "profile",
};