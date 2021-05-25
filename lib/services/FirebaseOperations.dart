import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/screens/LandingPage/LandingUtils.dart';
import 'package:thesocial/services/Authentication.dart';

class FirebaseOperations extends ChangeNotifier {
  String useremail;
  String username;
  String userimage;
  Future uploadUserAvatar(BuildContext context) async {
    final provider = Provider.of<LandingUtils>(context, listen: false);
    UploadTask imageUploadTask;
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('userProfileAvatar/${TimeOfDay.now()}');

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

  Future fetchUserProfileInfo(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('allUsers')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((doc) {
      this.useremail = doc.get('useremail');
      this.username = doc.get('username');
      this.userimage = doc.get('userimage');
      print(this.useremail + ' ' + this.username + ' ' + this.userimage);
      notifyListeners();
    });
  }
}
