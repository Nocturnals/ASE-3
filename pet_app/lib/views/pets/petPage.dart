// flutter imports
import 'package:flutter/material.dart';

// navigation imports
import 'package:pet_app/services/authVerify/checkLoggedUser.dart';

// UI imports
import 'package:pet_app/widgets/loader.dart';

// internal imports
import 'addPet/addPetView.dart';
import 'ViewPets/ViewPetsView.dart';

class PetScreen extends StatefulWidget {
  final WidgetBuilder devReduxBuilder;
  const PetScreen({Key key, @required this.devReduxBuilder}) : super(key: key);

  @override
  _PetScreenState createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  bool _isLoading;
  int _currentPage = 0;
  final PageController _pageController = new PageController();

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
    return Scaffold(
      endDrawer: widget.devReduxBuilder == null
          ? null
          : widget.devReduxBuilder(context),
      appBar: AppBar(
        title: Text('Manage Your Pets'),
      ),
      body: _isLoading
          ? Center(
              child: Loader(),
            )
          : PageView(
              onPageChanged: (value) {
                setState(() {
                  _currentPage = value;
                });
              },
              controller: _pageController,
              children: [
                AddPetView(),
                ViewAllPetsView(),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          _pageController.animateToPage(value,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
          setState(() {
            _currentPage = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            title: Text('Add pet'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            title: Text('All pets'),
          ),
        ],
      ),
    );
  }
}
