import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/screens/Feed/Feed.dart';
import 'package:thesocial/screens/Chatroom/Chatroom.dart';
import 'package:thesocial/screens/Profile/Profile.dart';
import 'package:thesocial/screens/HomePage/HomePageHelpers.dart';
import 'package:thesocial/services/FirebaseOperations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<FirebaseOperations>(context, listen: false)
        .fetchUserProfileInfo(context);
  }

  ConstantColors constantColors = ConstantColors();
  final PageController homepageController = PageController();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: PageView(
        controller: homepageController,
        children: [Feed(), Chatroom(), Profile()],
        //physics: NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            pageIndex = page;
          });
        },
      ),
      bottomNavigationBar: Provider.of<HomePageHelpers>(context, listen: false)
          .bottomNavBar(context, pageIndex, homepageController),
    );
  }
}
