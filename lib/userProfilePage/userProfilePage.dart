import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';
import 'package:fluttermochat/userProfilePage/updateUserProfilePage.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String _userNickName, _userProfilePhoto, _userAbout;
  FirebaseUser _firebaseUser;
  void getCurrentUser() async {
    var userType0 = await FirebaseAuth.instance.currentUser();
    if (userType0 != null) {
      setState(() {
        _firebaseUser = userType0;
      });
      print(_firebaseUser.uid);
    }
  }
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getCurrentUserDataFromCloudFirestore();
  }
  getCurrentUserDataFromCloudFirestore() async {
    var userType1 = await FirebaseAuth.instance.currentUser();
    if (userType1 != null) {
      await Firestore.instance.collection('users').document(userType1.uid).get().then((value) {
        setState(() {
          _userNickName = value.data['nickname'];
          _userProfilePhoto = value.data['photourl'];
          _userAbout = value.data['aboutuser'];
        });
      }).catchError((e) {
        print(e);
      });
    }
  }
  void handleUpdateProfile(String value) {
    switch (value) {
      case 'Update Profile':
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateUserProfilePage()));
        }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<String> (
            onSelected: handleUpdateProfile,
            itemBuilder: (context) {
              return {'Update Profile'}.map((String choice) {
                return PopupMenuItem<String> (
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
        backgroundColor: Colors.green.shade200,
        centerTitle: true,
        title: _userNickName == null ? Container() : Text(
          _userNickName+'\'s Profile',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: Colors.green,
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2), () {
              getCurrentUserDataFromCloudFirestore();
            });
          },
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: _userProfilePhoto == null ? Container() : CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        radius: 100,
                        child: Image.network(_userProfilePhoto),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Nick Name:',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        _userNickName == null ? LinearProgressIndicator() : Text(
                          _userNickName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'About:',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          _userAbout == null ? LinearProgressIndicator() : Text(
                            _userAbout,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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
}
