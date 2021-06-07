import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/screens/Chat/ChatHelpers.dart';
import 'package:thesocial/services/FirebaseOperations.dart';

class Chat extends StatelessWidget {
  final String profileImage;
  final String username;
  final String userUid;
  final String myUid;
  Chat({
    @required this.profileImage,
    @required this.username,
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
                backgroundImage: NetworkImage(this.profileImage),
                radius: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '${this.username}',
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          actions: [
            PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: GestureDetector(
                          child: Text('Delete the chat'),
                          onTap: () {
                            String chatDocUid;
                            if (this.userUid.compareTo(this.myUid) == 1) {
                              chatDocUid = this.userUid + this.myUid;
                            } else if (this.userUid.compareTo(this.myUid) ==
                                -1) {
                              chatDocUid = this.myUid + this.userUid;
                            }
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .deleteChatList(
                                    chatDocUid, this.myUid, this.userUid)
                                .whenComplete(() {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          },
                        ),
                      )
                    ])
          ],
        ),
        body: Provider.of<ChatHelpers>(context, listen: false).chatBody(context,
            this.profileImage, this.username, this.userUid, this.myUid));
  }
}
