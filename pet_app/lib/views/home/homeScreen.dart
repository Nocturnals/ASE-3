// import 'package:flutter/material.dart';
// import 'package:pet_app/constants/keys.dart';

// // import 'package:pet_app/widgets/toolNav.dart';
// import 'package:pet_app/views/appBar/homeFeedAppBar.dart';
// import 'package:pet_app/views/drawer/homeFeedDrawer.dart';
// import 'package:pet_app/views/appBar/createPostAppBar.dart';
// import 'package:pet_app/views/appBar/profileAppBar.dart';

// import 'package:pet_app/constants/bottomNavBarItems.dart';

// import 'package:pet_app/views/home/homeFeed/homeFeedScreen.dart';
// import 'package:pet_app/views/post/create/createPostScreen.dart';

// class HomeScreen extends StatefulWidget {
//   final WidgetBuilder devReduxBuilder;

//   HomeScreen({Key key, this.devReduxBuilder}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {

//   int _currentIndex;

//   // body widgets
//   static const List<Widget> _bodyWidgets = <Widget>[
//     Material( child: HomeFeed(), ),
//     Material( child: CreatePostScreen() ),
//     Material(),
//   ];

//   void initState() {
//     super.initState();

//     _currentIndex = indexOfNavItem["home"];
//   }

//   // function to change bottom navigation bar selected index
//   void _navigate({ @required int index }) {
//     Keys.navKey.currentState.pushNamedAndRemoveUntil('/${routeOfNavItemIndex[index]}', (Route<dynamic> route) => false);
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // app bar for different pages
//     Widget _appBar(BuildContext context) {
//       switch (_selectedIndex) {
//         // HOME FEED
//         case 0:
//           return homeFeedAppBar(context);
//           break;
//         // CREATE POST
//         case 1:
//           return createPostAppBar(context);
//         // PROFILE
//         case 2:
//           return profileAppBar(
//             context,
//             "https://images.pexels.com/photos/814499/pexels-photo-814499.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"
//           );

//         default:
//           return AppBar(
//             leading: null,
//           );
//       }
//     }

//     // drawer for profile page
//     Widget _drawer(BuildContext context) {
//       switch (_selectedIndex) {
//         // HOME FEED
//         case 0:
//           return homeFeedDrawer(context);
//           break;

//         default:
//           return null;
//       }
//     }

//     // 
//     return Scaffold(
//       appBar: _appBar(context),
//       drawer: _drawer(context),
//       endDrawer: widget.devReduxBuilder != null ? widget.devReduxBuilder(context) : null,
//       body: _bodyWidgets[_selectedIndex],

//       bottomNavigationBar: BottomNavigationBar(
//         onTap: (index) {
//           _navigate(index: index);
//         },
//         currentIndex: _currentIndex, // this will be set when a new tab is tapped
//         items: bottomNavBarItems,
//       ),
//     );
//   }
// }
