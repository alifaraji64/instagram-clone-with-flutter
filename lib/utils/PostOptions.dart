import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/services/FirebaseOperations.dart';

class PostOptions extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  showPostOptions(BuildContext context, String caption) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text(
              'what do you wanna do?',
              style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  MaterialButton(
                      child: Text('Edit the Caption',
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          )),
                      onPressed: () {
                        Navigator.pop(context);
                        showEditCaptionDialog(context, caption);
                      }),
                  MaterialButton(
                      color: constantColors.redColor,
                      child: Text('Delete the Post',
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          )),
                      onPressed: () {
                        print('post delete pressed');
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .deletePost(caption)
                            .whenComplete(() {
                          print('post deleted');
                          Navigator.pop(context);
                        });
                      }),
                ],
              )
            ],
          );
        });
  }

  showEditCaptionDialog(BuildContext context, String oldCaption) {
    TextEditingController _captionController = TextEditingController();
    _captionController.text = oldCaption;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text(
              'Edit the caption',
              style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            actions: [
              Container(
                  width: 380,
                  child: Column(children: [
                    Container(
                      width: 220,
                      child: TextField(
                        controller: _captionController,
                        style: TextStyle(color: constantColors.whiteColor),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: constantColors.blueColor,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    MaterialButton(
                        color: constantColors.blueColor,
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          if (_captionController.text == oldCaption) {
                            print('it is not changed');
                          } else {
                            print('it is changed apply the changes to db');
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .editPostCaption(
                                    oldCaption, _captionController.text)
                                .whenComplete(() {
                              print('caption updated');
                              Navigator.pop(context);
                            });
                          }
                        }),
                  ]))
            ],
          );
        });
  }
}
