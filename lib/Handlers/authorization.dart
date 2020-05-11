import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:order/Models/user.dart';

Future<User> getUserWithUid(String uid) async {
  try {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('users')
        .document(uid)
        .snapshots()
        .first;
    return User.fromSnapshot(snapshot);
  } catch (err) {
    return User.empty();
  }
}

// Future<User> getCurrentUser() async {
//   try {
//     final user = await FirebaseAuth.instance.currentUser();

//   } catch (err) {}
// }

Future<String> loginWithEmail(
    BuildContext context, String email, password) async {
  try {
    FirebaseUser user = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password))
        .user;
    return user.uid;
  } catch (error) {
    switch (error.code) {
      case "ERROR_USER_NOT_FOUND":
        {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("User doesn't exist")));
        }
        break;
      case "ERROR_WRONG_PASSWORD":
        {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("Wrong password")));
        }
        break;
      default:
        {}
    }
    return null;
  }
}

Future<bool> validateEmailAndPhone(
    BuildContext context, String email, String phone) async {
  try {
    final Firestore _instance = Firestore.instance;
    QuerySnapshot docs = await _instance
        .collection('users')
        .where('email', isEqualTo: email)
        .getDocuments();
    if (docs.documents.length > 0) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Email already exist')));
      return false;
    }
    docs = await _instance
        .collection('users')
        .where('phone', isEqualTo: phone)
        .getDocuments();
    if (docs.documents.length > 0) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Phone number already exist')));
      return false;
    }
  } catch (error) {
    return false;
  }
  return true;
}

Future<String> linkPhoneWithUser(
    String email, String password, AuthCredential phoneCredential) async {
  try {
    AuthCredential emailCredential =
        EmailAuthProvider.getCredential(email: email, password: password);
    FirebaseUser user =
        (await FirebaseAuth.instance.signInWithCredential(emailCredential))
            .user;
    await user.linkWithCredential(phoneCredential);
    await Firestore.instance
        .collection('users')
        .document(user.uid)
        .updateData({'phoneVerified': true});
    return user.uid;
  } on PlatformException catch (err) {
    return null;
  } on Exception catch (e) {
    return null;
  }
}

Future<bool> registerNewUser(BuildContext context, String name, String email,
    String phone, String password) async {
  try {
    FirebaseUser user = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password))
        .user;
    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await user.updateProfile(userUpdateInfo);
    await Firestore.instance.collection('users').document(user.uid).setData(
        {'email': email, 'name': name, 'phone': phone, 'phoneVerified': false});
    return true;
  } catch (error) {
    switch (error.code) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
        {
          final snackBar = SnackBar(content: Text('Email already in use.'));
          Scaffold.of(context).showSnackBar(snackBar);
        }
        break;
      case "ERROR_WEAK_PASSWORD":
        {
          final snackBar = SnackBar(content: Text('Weak Password.'));
          Scaffold.of(context).showSnackBar(snackBar);
        }
        break;
      default:
        {}
    }
    return false;
  }
}

void verifyUserWithOTP(BuildContext context, String phone, Function onSuccess,
    Function onFail, Function onSent, Function onRetrieval) async {
  try {
    print(phone);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 5),
        verificationCompleted: (authCredential) => onSuccess(authCredential),
        verificationFailed: (authException) => onFail(authException),
        codeAutoRetrievalTimeout: (verificationId) =>
            onRetrieval(verificationId, context),
        // called when the SMS code is sent
        codeSent: (verificationId, [code]) =>
            onSent(verificationId, [code], context));
  } catch (error) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(error.code)));
  }
}
