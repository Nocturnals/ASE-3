import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:pet_app/petService/screens/home/home_page.dart';

class IntroPage extends StatefulWidget {
  static final routeName = '/intro';

  @override
  _IntroPageState createState() => new _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  List<Slide> slides = new List();

  Function goToTab;

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "PET APP",
        styleTitle: TextStyle(
            color: Color(0xFFFCAA7B),
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'NanumGothic'),
        description: "Welcome to pet app!",
        styleDescription: TextStyle(
          color: Color(0xFFF27730),
          fontSize: 20.0,
          fontFamily: 'Georgia',
        ),
        pathImage: "assets/intro_images/pet_friends.png",
      ),
    );
    slides.add(
      new Slide(
        title: "PETS HOME ALONE?",
        styleTitle: TextStyle(
            color: Color(0xFFFCAA7B),
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'NanumGothic'),
        description: "Now it's easy to find a pet sitter that can help",
        styleDescription: TextStyle(
          color: Color(0xFFF27730),
          fontSize: 20.0,
          fontFamily: 'Georgia',
        ),
        pathImage: "assets/intro_images/pet_sitter.png",
      ),
    );
    slides.add(
      new Slide(
        title: "BREEDING",
        styleTitle: TextStyle(
            color: Color(0xFFFCAA7B),
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'NanumGothic'),
        description: "Choose the perfect mate for your pet",
        styleDescription: TextStyle(
          color: Color(0xFFF27730),
          fontSize: 20.0,
          fontFamily: 'Georgia',
        ),
        pathImage: "assets/intro_images/dog_breeding.png",
      ),
    );
    slides.add(
      new Slide(
        title: "CHAT",
        styleTitle: TextStyle(
            color: Color(0xFFFCAA7B),
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'NanumGothic'),
        description: "Connect with pet owners and pet sitters",
        styleDescription: TextStyle(
          color: Color(0xFFF27730),
          fontSize: 20.0,
          fontFamily: 'Georgia',
        ),
        pathImage: "assets/intro_images/chat.png",
      ),
    );
  }

  void onDonePress() {
//    this.goToTab(0);
    Navigator.of(context).pushNamed(HomePage.routeName);
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Color(0xFF3EB7B5),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Color(0xFF3EB7B5),
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Color(0xFF3EB7B5),
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
          child: ListView(
            children: <Widget>[
              Container(
                child: Text(
                  currentSlide.title,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
              Container(
                child: GestureDetector(
                    child: Image.asset(
                  currentSlide.pathImage,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.contain,
                )),
                margin: EdgeInsets.only(top: 100.0),
              ),
              Container(
                child: Text(
                  currentSlide.description,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(top: 100.0, right: 20.0, left: 20.0),
              ),
            ],
          ),
        ),
      ));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // List slides
      slides: this.slides,

      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: Color(0xFFB9E5E4),
      highlightColorSkipBtn: Color(0xFF3EB7B5),

      // Next button
      renderNextBtn: this.renderNextBtn(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      colorDoneBtn: Color(0xFFB9E5E4),
      highlightColorDoneBtn: Color(0xFF3EB7B5),

      // Dot indicator
      colorDot: Color(0xFFB9E5E4),
      sizeDot: 13.0,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

      // Tabs
      listCustomTabs: this.renderListCustomTabs(),
      backgroundColorAllSlides: Color(0xFFFFF7EF),
      refFuncGoToTab: (refFunc) {
        this.goToTab = refFunc;
      },

      // Show or hide status bar
      shouldHideStatusBar: true,

      // On tab change completed
      onTabChangeCompleted: this.onTabChangeCompleted,
    );
  }
}
