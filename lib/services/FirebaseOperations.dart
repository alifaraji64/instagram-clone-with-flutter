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
  String get getUserEmail => useremail;
  String get getUserName => username;
  String get getUserImage => userimage;

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
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set(data);
  }

  Future fetchUserProfileInfo(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
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

  Future addPostData(String postId, dynamic data) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Future deleteAccount(String userUid) async {
    await FirebaseFirestore.instance.collection('users').doc(userUid).delete();
  }

  Future addLike(BuildContext context, String postId, String subDocId) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'username': this.username,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': this.userimage,
      'useremail': this.useremail,
      'time': Timestamp.now()
    });
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      'username': this.username,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': this.userimage,
      'useremail': this.useremail,
      'time': Timestamp.now()
    });
  }

  Future addReward(
      BuildContext context, String rewardUrl, String postId) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('rewards')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set({'image': rewardUrl});
  }

  //postId is the caption of post
  Future deletePost(postId) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
  }

  Future editPostCaption(String oldCaption, String newCaption) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(oldCaption)
        .update({'caption': newCaption});
  }

  Future followUser(
      String followingUid,
      String followingDocId,
      dynamic followingData,
      String followerUid,
      String followerDocId,
      dynamic followerData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followerUid)
        .set(followerData);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(followerUid)
        .collection('followings')
        .doc(followingUid)
        .set(followingData);

    print('followed!!!');
  }

  Future unFollowUser(String unfollowingUid, String beingUnfollowed) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(beingUnfollowed)
        .collection('followers')
        .doc(unfollowingUid)
        .delete();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(unfollowingUid)
        .collection('followings')
        .doc(beingUnfollowed)
        .delete();
  }
}
