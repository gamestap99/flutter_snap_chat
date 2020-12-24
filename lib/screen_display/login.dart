import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snap_chat/const.dart';
import 'package:flutter_snap_chat/home.dart';
import 'package:flutter_snap_chat/router.dart';
import 'package:flutter_snap_chat/widget/loading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();
  String username;
  String password;
  bool isLoading = false;
  bool isLoggedIn = false;
  User currentUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(currentUserId: prefs.getString('id'))),
      );
    }

    this.setState(() {
      isLoading = false;
    });
  }

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    User firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: firebaseUser.uid).get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {
        // Update data to server if new user
        FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set({'nickname': firebaseUser.displayName, 'photoUrl': firebaseUser.photoURL, 'id': firebaseUser.uid, 'createdAt': DateTime.now().millisecondsSinceEpoch.toString(), 'chattingWith': null});

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('nickname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoURL);
      } else {
        // Write data to local
        await prefs.setString('id', documents[0].data()['id']);
        await prefs.setString('nickname', documents[0].data()['nickname']);
        await prefs.setString('photoUrl', documents[0].data()['photoUrl']);
        await prefs.setString('aboutMe', documents[0].data()['aboutMe']);
      }
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(currentUserId: firebaseUser.uid)));
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Login",
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(hintText: 'username'),
                      onSaved: (value) {
                        username = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'password'),
                      onSaved: (value) {
                        password = value;
                      },
                    ),
                    MaterialButton(
                      onPressed: () {
                        onLogin();
                      },
                      color: Colors.red,
                      child: Text(
                        "Đăng nhập",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Center(
                      child: FlatButton(
                          onPressed: handleSignIn,
                          child: Text(
                            'SIGN IN WITH GOOGLE',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          color: Color(0xffdd4b39),
                          highlightColor: Color(0xffff7f7f),
                          splashColor: Colors.transparent,
                          textColor: Colors.white,
                          padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
                    ),
                  ],
                ),
              ),
            ),

            // Loading
            Positioned(
              child: isLoading ? const Loading() : Container(),
            ),
          ],
        ));
  }

  Future<void> onLogin() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      final User user = (await _auth.signInWithEmailAndPassword(
        email: username,
        password: password,
      ))
          .user;

      if (user != null) {
        // Check is already sign up
        final QuerySnapshot result = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: user.uid).get();
        final List<DocumentSnapshot> documents = result.docs;
        if (documents.length == 0) {
          // Update data to server if new user
          FirebaseFirestore.instance.collection('users').doc(user.uid).set({'nickname': user.displayName, 'photoUrl': user.photoURL, 'id': user.uid, 'createdAt': DateTime.now().millisecondsSinceEpoch.toString(), 'chattingWith': null});

          // Write data to local
          currentUser = user;
          await prefs.setString('id', currentUser.uid);
          await prefs.setString('nickname', currentUser.displayName);
          await prefs.setString('photoUrl', currentUser.photoURL);
        } else {
          // Write data to local
          await prefs.setString('id', documents[0].data()['id']);
          await prefs.setString('nickname', documents[0].data()['nickname']);
          await prefs.setString('photoUrl', documents[0].data()['photoUrl']);
          await prefs.setString('aboutMe', documents[0].data()['aboutMe']);
        }
        Fluttertoast.showToast(msg: "Sign in success");
        setState(() {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.chatDisplay, (route) => false, arguments: {"userId": user.uid});
          isLoading = false;
        });
      } else {
        Fluttertoast.showToast(msg: "Sign in fail");
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
