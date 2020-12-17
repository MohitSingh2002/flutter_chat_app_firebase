import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttermochat/homePage/homePage.dart';
import 'package:fluttermochat/authentication/login.dart';

class AuthHandle {
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return Homepage();
        } else {
          return LoginAuth();
        }
      },
    );
  }
}
