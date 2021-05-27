import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/screens/Feed/FeedUtils.dart';
import 'package:thesocial/screens/Feed/FeedServices.dart';
import 'package:thesocial/services/Authentication.dart';

class FeedHelpers extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 100),
        child: Container(
          padding: const EdgeInsets.only(
            top: 8.0,
            left: 8.0,
            right: 8.0,
            bottom: 60,
          ),
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              )),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: SizedBox(
                  height: 500,
                  width: 400,
                  child: Lottie.asset('assets/animations/loading.json'),
                ));
              } else {
                return ListView(
                  children: snapshot.data.docs
                      .map<Widget>((DocumentSnapshot documentSnapshot) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 20),
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    documentSnapshot.get('userimage'),
                                  ),
                                  radius: 20.0,
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      documentSnapshot.get('caption'),
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          documentSnapshot.get('username') +
                                              ' , ',
                                          style: TextStyle(
                                              color: constantColors.blueColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '12 hours ago',
                                          style: TextStyle(
                                            color: constantColors.lightColor
                                                .withOpacity(0.8),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.46,
                            width: MediaQuery.of(context).size.width,
                            child: FittedBox(
                              child: Image.network(
                                documentSnapshot.get('postimage'),
                                scale: 2,
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                      child: Icon(
                                    FontAwesomeIcons.heart,
                                    color: constantColors.redColor,
                                  )),
                                  SizedBox(width: 7),
                                  Text(
                                    '0',
                                    style: TextStyle(
                                        color: constantColors.whiteColor),
                                  )
                                ],
                              ),
                              SizedBox(width: 15),
                              Row(
                                children: [
                                  GestureDetector(
                                      child: Icon(
                                    FontAwesomeIcons.comment,
                                    color: constantColors.blueColor,
                                  )),
                                  SizedBox(width: 7),
                                  Text(
                                    '0',
                                    style: TextStyle(
                                        color: constantColors.whiteColor),
                                  )
                                ],
                              ),
                              SizedBox(width: 15),
                              Row(
                                children: [
                                  GestureDetector(
                                      child: Icon(
                                    FontAwesomeIcons.award,
                                    color: constantColors.yellowColor,
                                  )),
                                  SizedBox(width: 7),
                                  Text('0',
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                      ))
                                ],
                              ),
                              Spacer(),
                              //conditional tree dots
                              documentSnapshot.get('useruid') ==
                                      Provider.of<Authentication>(context)
                                          .getUserUid
                                  ? IconButton(
                                      icon: Icon(EvaIcons.moreVertical),
                                      color: constantColors.whiteColor,
                                      onPressed: () {},
                                    )
                                  : Container(
                                      height: 0,
                                      width: 0,
                                    )
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 140),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Camera',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Provider.of<FeedUtils>(context, listen: false)
                            .pickPostImage(context, ImageSource.camera)
                            .whenComplete(() {
                          Provider.of<FeedServices>(context, listen: false)
                              .showPostImage(context);
                        });
                      },
                    ),
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Provider.of<FeedUtils>(context, listen: false)
                            .pickPostImage(context, ImageSource.gallery)
                            .whenComplete(() {
                          Provider.of<FeedServices>(context, listen: false)
                              .showPostImage(context);
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
