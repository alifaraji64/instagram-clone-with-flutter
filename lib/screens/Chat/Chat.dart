import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/screens/Chat/ChatHelpers.dart';

class Chat extends StatelessWidget {
  final String profileImage;
  final String userUid;
  final String myUid;
  Chat({
    @required this.profileImage,
    @required this.userUid,
    @required this.myUid,
  });

  final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: constantColors.blueGreyColor,
          title: Row(
            children: [
              CircleAvatar(
                child: Image.network(this.profileImage),
                radius: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Spiderman',
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                EvaIcons.moreVertical,
                color: constantColors.whiteColor,
              ),
              onPressed: () {},
            )
          ],
        ),
        body: Provider.of<ChatHelpers>(context, listen: false)
            .chatBody(context, this.profileImage, this.userUid, this.myUid));
  }
}
