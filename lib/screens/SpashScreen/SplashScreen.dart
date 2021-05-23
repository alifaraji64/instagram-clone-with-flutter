import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/screens/LandingPage/LandingPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        PageTransition(
          child: LandingPage(),
          type: PageTransitionType.leftToRight,
          duration: Duration(milliseconds: 500),
        ),
      ),
    );
  }

  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: Center(
        child: RichText(
          text: TextSpan(
              text: 'the',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: constantColors.whiteColor,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                    text: 'Social',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: constantColors.blueColor,
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                    ))
              ]),
        ),
      ),
    );
  }
}
