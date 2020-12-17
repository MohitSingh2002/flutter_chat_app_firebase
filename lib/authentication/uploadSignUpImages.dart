//import 'dart:html';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttermochat/homePage/homePage.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toast/toast.dart';


class UploadSignUpImages extends StatefulWidget {
  @override
  _UploadSignUpImagesState createState() => _UploadSignUpImagesState();
}

class _UploadSignUpImagesState extends State<UploadSignUpImages> {
  bool _aboutTextField = false;
  String _aboutUser;
  bool _continueButton = false;
  File _userProfilePhoto;
  String _userProfilePhotoURL;
  FirebaseUser _firebaseUser;
  void getCurrentUser() async {
    final user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      setState(() {
        _firebaseUser = user;
      });
      print(_firebaseUser.uid);
    }
  }
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green.shade200,
        centerTitle: true,
        title: Text(
          'Upload Photo',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  'Upload Profile Photo',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: Divider(
                  color: Colors.green,
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                            ),
                          ),
                          child: userPhoto(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _userProfilePhoto == null ? RaisedButton(
                      color: Colors.green.shade200,
                      onPressed: () async {
                        File file = await FilePicker.getFile();
                        setState(() {
                          _userProfilePhoto = file;
                        });
                        userPhoto();
                      },
                      child: Center(
                        child: Text(
                          'Pick Image from Gallery',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ) : Container(),
                    _userProfilePhoto == null ? Container() : RaisedButton(
                      color: Colors.green.shade200,
                      onPressed: () async {
                        StorageReference storageReference = FirebaseStorage.instance.ref().child('users/${_firebaseUser.uid}/${Path.basename(_userProfilePhoto.path)}');
                        StorageUploadTask uploadTask = storageReference.putFile(_userProfilePhoto);
                        Toast.show('Please wait', context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                        await uploadTask.onComplete;
                        print('File Uploaded');
                        Toast.show('Photo Uploaded', context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                        storageReference.getDownloadURL().then((value) {
                          setState(() {
                            _userProfilePhotoURL = value;
                            _aboutTextField = true;
                          });
                        });
                      },
                      child: Center(
                        child: Text(
                          'Upload Photo',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _aboutTextField == false ? Container() : TextField(
                      onTap: () {
                        _continueButton = true;
                      },
                      onChanged: (value) {
                        _aboutUser = value;
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Set an about',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      color: Colors.green.shade200,
                      onPressed: () {
                        Firestore.instance.collection('users').document(_firebaseUser.uid).updateData({
                          'photourl': _userProfilePhotoURL,
                          'aboutuser': _aboutUser,
                        }).then((value) {
                          Toast.show('Sign Up Success', context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
                        }).catchError((e) {
                          print(e);
                        });
                      },
                      child: Center(
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget userPhoto() {
    return _userProfilePhoto != null ? Image.asset(_userProfilePhoto.path) : Container();
  }
}
