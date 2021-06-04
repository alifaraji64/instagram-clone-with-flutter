import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/services/Authentication.dart';
import 'package:thesocial/services/FirebaseOperations.dart';

class GlobalWidgets extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Widget conditionalFollowButtons(
      BuildContext context, dynamic snapshot, String userUid) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userUid)
            .collection('followers')
            .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
            .snapshots(),
        builder: (context, snapshot_v2) {
          if (snapshot_v2.connectionState == ConnectionState.waiting) {
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
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                onPressed: () {
                  Provider.of<FirebaseOperations>(context, listen: false)
                      .followUser(
                    userUid,
                    Provider.of<Authentication>(context, listen: false)
                        .getUserUid,
                    {
                      //snapshot we are getting from the bottomsheets have the type of DocumentSnapshot but the one we are getting from the header is AsyncSnapshot so based on the type we are getting the data differently. in DocumentSnapshot we don't have a data property so we have to use snapshot.get('')
                      'username': snapshot.runtimeType.toString() ==
                              '_JsonQueryDocumentSnapshot'
                          ? snapshot.get('username')
                          : snapshot.data.get('username'),
                      'useremail': snapshot.runtimeType.toString() ==
                              '_JsonQueryDocumentSnapshot'
                          ? snapshot.get('useremail')
                          : snapshot.data.get('useremail'),
                      'userimage': snapshot.runtimeType.toString() ==
                              '_JsonQueryDocumentSnapshot'
                          ? snapshot.get('userimage')
                          : snapshot.data.get('userimage'),
                      'userid': snapshot.runtimeType.toString() ==
                              '_JsonQueryDocumentSnapshot'
                          ? snapshot.get('userid')
                          : snapshot.data.get('userid'),
                      'time': Timestamp.now()
                    },
                    Provider.of<Authentication>(context, listen: false)
                        .getUserUid,
                    userUid,
                    {
                      'username': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getUserName,
                      'useremail': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getUserEmail,
                      'userimage': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getUserImage,
                      'userid':
                          Provider.of<Authentication>(context, listen: false)
                              .getUserUid,
                      'time': Timestamp.now()
                    },
                  )
                      .whenComplete(() {
                    return ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: constantColors.yellowColor,
                        duration: Duration(seconds: 1),
                        content: Text(
                          '${snapshot.runtimeType.toString() == "_JsonQueryDocumentSnapshot" ? snapshot.get("username") : snapshot.data.get("username")} has been followed',
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
                  Provider.of<FirebaseOperations>(context, listen: false)
                      .unFollowUser(
                          Provider.of<Authentication>(context, listen: false)
                              .getUserUid,
                          userUid)
                      .whenComplete(() {
                    return ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: constantColors.redColor,
                        duration: Duration(seconds: 1),
                        content: Text(
                          '${snapshot.runtimeType.toString() == "_JsonQueryDocumentSnapshot" ? snapshot.get("username") : snapshot.data.get("username")} has been Unfollowed',
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
        });
  }

  Future showFollowingsSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              color: constantColors.blueGreyColor,
              child: SingleChildScrollView(
                child: Column(
                    children: snapshot.data.docs
                        .map<Widget>((DocumentSnapshot documentSnapshot) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: constantColors.darkColor,
                      backgroundImage:
                          NetworkImage(documentSnapshot.get('userimage')),
                    ),
                    title: Text(
                      '${documentSnapshot.get("username")}',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '${documentSnapshot.get("useremail")}',
                      style: TextStyle(
                        color: constantColors.yellowColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    trailing: Container(
                        width: 100,
                        //not showing the follow button for the user itself
                        child: documentSnapshot.get('userid') !=
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid
                            ? Provider.of<GlobalWidgets>(context, listen: false)
                                .conditionalFollowButtons(
                                context,
                                documentSnapshot,
                                documentSnapshot.get('userid'),
                              )
                            : Container(
                                width: 0,
                                height: 0,
                              )),
                  );
                }).toList()),
              ));
        });
  }
}
