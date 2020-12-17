import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateUserProfilePage extends StatefulWidget {
  @override
  _UpdateUserProfilePageState createState() => _UpdateUserProfilePageState();
}

class _UpdateUserProfilePageState extends State<UpdateUserProfilePage> {
  String _userNickName, _userProfilePhoto, _userAbout;
  String _updateNickName, _updateAbout;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        centerTitle: true,
        title: Text(
          'Update Profile',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            FlatButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Change Nick Name',
                    ),
                    actions: <Widget>[
                      IconButton(
                        onPressed: () async {
                          await Firestore.instance.collection('users').document(_firebaseUser.uid).updateData({
                            'nickname': _updateNickName,
                          }).then((value) {
                            Toast.show('Nick Name Updated', context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
                            getCurrentUserDataFromCloudFirestore();
                            Navigator.pop(context);
                          }).catchError((e) {
                            print(e);
                          });
                        },
                        icon: Icon(
                          Icons.done,
                        ),
                      ),
                    ],
                    content: TextField(
                      onChanged: (value) {
                        _updateNickName = value;
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _userNickName == null ? LinearProgressIndicator() : ListTile(
                  title: Text(
                    'Nick Name ->',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text(
                    _userNickName,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  trailing: Icon(
                    Icons.edit,
                  ),
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Change About',
                    ),
                    actions: <Widget>[
                      IconButton(
                        onPressed: () async {
                          await Firestore.instance.collection('users').document(_firebaseUser.uid).updateData({
                            'aboutuser': _updateAbout,
                          }).then((value) {
                            Toast.show('About Updated', context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
                            getCurrentUserDataFromCloudFirestore();
                            Navigator.pop(context);
                          }).catchError((e) {
                            print(e);
                          });
                        },
                        icon: Icon(
                          Icons.done,
                        ),
                      ),
                    ],
                    content: TextField(
                      onChanged: (value) {
                        _updateAbout = value;
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _userNickName == null ? LinearProgressIndicator() : ListTile(
                  title: Text(
                    'About ->',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text(
                    _userAbout,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  trailing: Icon(
                    Icons.edit,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
