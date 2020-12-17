import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';
import 'package:fluttermochat/searchUsersProfiles/seeSearchedUserProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttermochat/chatScreen/chatScreen.dart';

class SearchUsersProfile extends StatefulWidget {
  @override
  _SearchUsersProfileState createState() => _SearchUsersProfileState();
}

class _SearchUsersProfileState extends State<SearchUsersProfile> {
  String _nickNameLoggedUser;
  FirebaseUser _firebaseUser;
  bool isUserNameSearched = false;
  QuerySnapshot _querySnapshot;
  String _searchUserFromCloudFirestore;
  void getCurrentUser() async {
    final user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      setState(() {
        _firebaseUser = user;
      });
      print(_firebaseUser.uid);
    }
  }
  getLoggedUserNameFromCloudFirestore() async {
    final _user = await FirebaseAuth.instance.currentUser();
    if (_user != null) {
      await Firestore.instance.collection('users').document(_user.uid).get().then((value) {
        setState(() {
          _nickNameLoggedUser = value.data['nickname'];
        });
      }).catchError((e) {
        print(e);
      });
    }
  }
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getLoggedUserNameFromCloudFirestore();

  }
  searchData(String userName) async {
    await Firestore.instance.collection('users').where('nickname', isGreaterThanOrEqualTo: _searchUserFromCloudFirestore).getDocuments().then((value) {
      _querySnapshot = value;
      print(_querySnapshot.toString());
      setState(() {
        isUserNameSearched = true;
      });
    }).catchError((e) {
      print(e);
    });
  }
  sendMessage(String userName) {
    List<String> connectedUsers = [_nickNameLoggedUser, userName];
    String roomId = getChatRoomId(_nickNameLoggedUser, userName);
    Map<String, dynamic> room = {
      "users": connectedUsers,
      "roomId": roomId,
    };
    addChatRoomToCloudFirestore(roomId, room);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(
      roomID: roomId,
    )));
  }
  Future<bool> addChatRoomToCloudFirestore(roomID, room) {
    Firestore.instance.collection('chatroom').document(roomID).setData(room).catchError((e) {
      print(e);
    });
  }
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
  Widget usersList() {
    return isUserNameSearched == true ? ListView.builder(
      shrinkWrap: true,
      itemCount: _querySnapshot.documents.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _querySnapshot.documents[index].data['nickname'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        _querySnapshot.documents[index].data['email'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SeeSearchedUserProfile(
                        nickName: _querySnapshot.documents[index].data['nickname'],
                        about: _querySnapshot.documents[index].data['aboutuser'],
                        email: _querySnapshot.documents[index].data['email'],
                        photo: _querySnapshot.documents[index].data['photourl'],
                      )));
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.account_circle,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage(_querySnapshot.documents[index].data['nickname']);
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.message,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ) : Container();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        centerTitle: true,
        title: Text(
          'Search Users',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 1
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(5),
                        child: TextField(
                          onChanged: (value) {
                           _searchUserFromCloudFirestore = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter complete user name',
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Toast.show('Searching, please wait...', context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP,);
                        searchData(_searchUserFromCloudFirestore);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                            colors: [
                              Colors.green,
                              Colors.green.shade100,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.search,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: usersList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
