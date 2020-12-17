import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttermochat/authHandle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

void main() {
  runApp(FirstMainPage());
}

class FirstMainPage extends StatefulWidget {
  @override
  _FirstMainPageState createState() => _FirstMainPageState();
}

class _FirstMainPageState extends State<FirstMainPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      home: AuthHandle().handleAuth(),
    );
  }
}
