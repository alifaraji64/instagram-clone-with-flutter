import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/services/Authentication.dart';
import 'package:thesocial/services/FirebaseOperations.dart';

class AltProfileHelpers extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget headerAltProfile(BuildContext context,
      AsyncSnapshot<DocumentSnapshot> snapshot, String userUid) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.37,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 200,
                  width: 180,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: CircleAvatar(
                          backgroundColor: constantColors.transperant,
                          radius: 60,
                          backgroundImage:
                              NetworkImage(snapshot.data.get('userimage')),
                        ),
                        onTap: () {},
                      ),
                      SizedBox(height: 5),
                      Text(
                        snapshot.data.get('username'),
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            EvaIcons.email,
                            color: constantColors.greenColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            snapshot.data.get('useremail'),
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          //getting the number of followers
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userUid)
                                  .collection('followers')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return GestureDetector(
                                    child: profileDetailBox('Followers',
                                        snapshot.data.docs.length.toString()),
                                    onTap: () {
                                      //print('show list of the followers');
                                    },
                                  );
                                }
                              }),
                          SizedBox(
                            width: 10,
                          ),
                          //getting the number of followings
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userUid)
                                  .collection('followings')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return GestureDetector(
                                      child: profileDetailBox('Followings',
                                          snapshot.data.docs.length.toString()),
                                      onTap: () {
                                        showFollowingsSheet(context, snapshot);
                                      });
                                }
                              }),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [profileDetailBox('Posts', '0')],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            //follow and message buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userUid)
                        .collection('followers')
                        .doc(Provider.of<Authentication>(context, listen: false)
                            .getUserUid)
                        .snapshots(),
                    builder: (context, snapshot_v2) {
                      if (snapshot_v2.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        //user is not followd
                        if (!snapshot_v2.hasData || !snapshot_v2.data.exists)
                          return MaterialButton(
                            color: constantColors.blueColor,
                            child: Text(
                              'Follow',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .followUser(
                                userUid,
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                                {
                                  'username': snapshot.data.get('username'),
                                  'useremail': snapshot.data.get('useremail'),
                                  'userimage': snapshot.data.get('userimage'),
                                  'userid': snapshot.data.get('userid'),
                                  'time': Timestamp.now()
                                },
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                                userUid,
                                {
                                  'username': Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false)
                                      .getUserName,
                                  'useremail': Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false)
                                      .getUserEmail,
                                  'userimage': Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false)
                                      .getUserImage,
                                  'userid': Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserUid,
                                  'time': Timestamp.now()
                                },
                              )
                                  .whenComplete(() {
                                return ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    backgroundColor: constantColors.yellowColor,
                                    duration: Duration(seconds: 1),
                                    content: Text(
                                      '${snapshot.data.get('username')} has been followed',
                                      style: TextStyle(
                                        color: constantColors.darkColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              });
                            },
                          );

                        //user is followed
                        else
                          return MaterialButton(
                            child: Text('Unfollow',
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                )),
                            color: constantColors.redColor,
                            onPressed: () {
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .unFollowUser(
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid,
                                      userUid)
                                  .whenComplete(() {
                                return ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    backgroundColor: constantColors.redColor,
                                    duration: Duration(seconds: 1),
                                    content: Text(
                                      '${snapshot.data.get('username')} has been UnFollowed',
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              });
                            },
                          );
                      }
                    }),
                MaterialButton(
                  color: constantColors.blueColor,
                  child: Text(
                    'Message',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ));
  }

  Widget divider(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Divider(
          thickness: 3,
          color: constantColors.whiteColor.withOpacity(0.2),
        ),
      ),
    );
  }

  Widget middleProfile(BuildContext context, dynamic snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              Icon(
                FontAwesomeIcons.userAstronaut,
                color: constantColors.yellowColor,
                size: 16,
              ),
              Text(
                'Recently Added',
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 70,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(15.0),
          ),
        )
      ],
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: Image.asset('assets/images/empty.png'),
      decoration:
          BoxDecoration(color: constantColors.darkColor.withOpacity(0.4)),
    );
  }

  Widget profileDetailBox(String title, String value) {
    return Container(
      height: 70,
      width: 80,
      decoration: BoxDecoration(
          color: constantColors.darkColor,
          borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$title',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Future showFollowingsSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              color: constantColors.redColor,
              child: SingleChildScrollView(
                child: Column(
                    children: snapshot.data.docs
                        .map<Widget>((DocumentSnapshot documentSnapshot) {
                  return Text(documentSnapshot.get('username'));
                }).toList()),
              ));
        });
  }
}
