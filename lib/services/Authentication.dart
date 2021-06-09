import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String errorMsg;
  String userUid;
  String get getUserUid => userUid;

  Future logIntoAccount(String email, String password) async {
    errorMsg = null;
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      User user = userCredential.user;
      userUid = user.uid;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case 'user-not-found':
          errorMsg = 'this email is not registered';
          break;
        case 'wrong-password':
          errorMsg = 'password is wrong';
          break;
        default:
          errorMsg = 'some unknown error occured';
      }
      return false;
    } catch (e) {
      errorMsg = 'some unknown error occured';
      return false;
    }
  }

  Future registerAccount(String email, String password) async {
    errorMsg = null;
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      userUid = user.uid;
      print('user registered =>' + userUid);
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case 'invalid-email':
          errorMsg = 'please enter a valid email';
          break;
        case 'email-already-in-use':
          errorMsg = 'this email is already in use';
          break;
        default:
          errorMsg = 'some unknown error occured';
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future logoutViaEmail() {
    return firebaseAuth.signOut();
  }

  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(authCredential);

      final User user = userCredential.user;
      userUid = user.uid;
      print('GOOGLE USER UIDDDD =>' + userUid);
      notifyListeners();
    } catch (e) {
      print('THIS IS ERROR FROM GOOGLE LOGIN');
      print(e);
    }
  }

  Future signOutWithGoogle() async {
    return googleSignIn.signOut();
  }
}
