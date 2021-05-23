import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/screens/HomePage/HomePage.dart';

import '../../constants/Constantcolors.dart';
import '../../services/Authentication.dart';

class LandingServices extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Widget passwordLessSignIn(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.40,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('allUsers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return new ListView(
                children: snapshot.data.docs
                    .map<Widget>((DocumentSnapshot documentSnapshot) {
              return ListTile(
                trailing: IconButton(
                  icon: Icon(FontAwesomeIcons.trashAlt),
                  onPressed: () {},
                ),
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(documentSnapshot.get('userimage')),
                ),
                title: Text(
                  documentSnapshot.get('username'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: constantColors.greenColor,
                    fontSize: 12.0,
                  ),
                ),
                subtitle: Text(
                  documentSnapshot.get('useremail'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: constantColors.greenColor,
                    fontSize: 12.0,
                  ),
                ),
              );
            }).toList());
          }
        },
      ),
    );
  }

  Future signInSheet(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _usernameController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 140),
                child: Divider(
                  thickness: 4.0,
                  color: constantColors.whiteColor,
                ),
              ),
              CircleAvatar(
                backgroundColor: constantColors.redColor,
                radius: 70.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter Email ...',
                    hintStyle: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Enter Username ...',
                    hintStyle: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Enter Password ...',
                    hintStyle: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                  backgroundColor: constantColors.redColor,
                  child: Icon(
                    FontAwesomeIcons.check,
                    color: constantColors.whiteColor,
                  ),
                  onPressed: () {
                    if (_emailController.text.isNotEmpty) {
                      Provider.of<Authentication>(context, listen: false)
                          .registerAccount(
                            _emailController.text,
                            _passwordController.text,
                          )
                          .whenComplete(() => {
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: HomePage(),
                                        type: PageTransitionType.leftToRight))
                              });
                    } else {
                      showWarning(context, "please fill the email input");
                    }
                  })
            ]),
          );
        });
  }

  Future loginSheet(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 140),
                child: Divider(
                  thickness: 4.0,
                  color: constantColors.whiteColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter Email ...',
                    hintStyle: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Enter Password ...',
                    hintStyle: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                  backgroundColor: constantColors.blueColor,
                  child: Icon(
                    FontAwesomeIcons.check,
                    color: constantColors.whiteColor,
                  ),
                  onPressed: () {
                    if (_emailController.text.isNotEmpty) {
                      Provider.of<Authentication>(context, listen: false)
                          .logIntoAccount(
                            _emailController.text,
                            _passwordController.text,
                          )
                          .whenComplete(() => {
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: HomePage(),
                                        type: PageTransitionType.leftToRight))
                              });
                    } else {
                      showWarning(context, "please fill the email input");
                    }
                  })
            ]),
          );
        });
  }

  Future showWarning(BuildContext context, String warning) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
                child: Text(
              warning,
              style: TextStyle(
                color: constantColors.whiteColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            )),
          );
        });
  }
}
