import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_snap_chat/database/user.dart';
import 'package:flutter_snap_chat/repositories/user_firebase.dart';
import 'package:flutter_snap_chat/utils/firebase_collection.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:flutter_snap_chat/models/user_model.dart';



/// Thrown if during the sign up process if a failure occurs.
class SignUpFailure implements Exception {}

/// Thrown during the login process if a failure occurs.
class LogInWithEmailAndPasswordFailure implements Exception {}

/// Thrown during the sign in with google process if a failure occurs.
class LogInWithGoogleFailure implements Exception {}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}


class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({
    firebase_auth.FirebaseAuth firebaseAuth,
    GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;


  Future<UserFirebase> getCurrentUser() async {
    UserFirebase currentUser;
    currentUser =  _firebaseAuth.currentUser.toUser;
    return currentUser;
  }

  Future<UserModel> getUserDetails() async {
    UserFirebase currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =await FirebaseCollection().userCollection.doc(currentUser.id).get();

    return UserModel.fromSnapShot(documentSnapshot);
  }

  Stream<UserFirebase> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? UserFirebase.empty : firebaseUser.toUser;
    });
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpFailure] if an exception occurs.
  Future<void> signUpFireBase({
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((value) {
        FirebaseFirestore.instance.collection('users').doc(value.user.uid).set({});

      });
    } on Exception {
      throw SignUpFailure();
    }
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<void> logInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on Exception {
      throw LogInWithGoogleFailure();
    }
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future logInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);

     var result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

     return result.user != null;

  }


  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }
}

extension on firebase_auth.User {
  UserFirebase get toUser {
    return UserFirebase(id: uid, email: email, name: displayName, photo: photoURL);
  }
}