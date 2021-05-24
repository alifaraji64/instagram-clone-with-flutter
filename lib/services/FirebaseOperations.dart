import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/screens/LandingPage/LandingUtils.dart';
import 'package:thesocial/services/Authentication.dart';

class FirebaseOperations extends ChangeNotifier {
  Future uploadUserAvatar(BuildContext context) async {
    final provider = Provider.of<LandingUtils>(context, listen: false);
    UploadTask imageUploadTask;
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileAvatar/${Provider.of<LandingUtils>(context, listen: false).getUserAvatar.path}/${TimeOfDay.now()}');

    imageUploadTask = imageReference.putFile(provider.getUserAvatar);

    await imageUploadTask.whenComplete(() {
      print('Image uploaded');
    });

    imageReference.getDownloadURL().then((url) {
      print('user profile avatar URL' + url.toString());
      provider.userAvatarUrl = url.toString();
    });
  }

  Future addUserToCollection(BuildContext context, dynamic data) async {
    return await FirebaseFirestore.instance
        .collection('allUsers')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set(data);
  }
}
