import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttermochat/authentication/login.dart';
import 'package:fluttermochat/chatScreen/chatScreen.dart';
import 'package:fluttermochat/chatScreen/getChatsHelper.dart';
import 'package:fluttermochat/userProfilePage/userProfilePage.dart';
import 'package:fluttermochat/searchUsersProfiles/searchUsersProfile.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Stream chatsMessages;
  String _nickName, _userProfileImage;
  FirebaseUser _firebaseUser;
  void handleSignOut(String value) {
    switch (value) {
      case 'Logout' :
        {
          FirebaseAuth.instance.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginAuth()));
        }
    }
  }
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
    getCurrentUserDataFromCloudFirestore();
    getChats();
  }
  getCurrentUserDataFromCloudFirestore() async {
    var userType = await FirebaseAuth.instance.currentUser();
    if (userType != null) {
      await Firestore.instance.collection('users').document(userType.uid).get().then((value) {
        setState(() {
          _nickName = value.data['nickname'];
          _userProfileImage = value.data['photourl'];
        });
      }).catchError((e) {
        print(e);
      });
    }
  }
  getChats() {
    DatabaseCloudFirestore().getUserChatsMessages(_nickName).then((value) {
      setState(() {
        chatsMessages = value;
      });
    });
  }
  Widget chatsMessagesTiles() {
    return StreamBuilder(
      stream: chatsMessages,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return ChatRooms(
              chatRoomId: snapshot.data.documents[index].data['roomId'],
              userName: snapshot.data.documents[index].data['roomId'].toString().replaceAll('_', '').replaceAll(_nickName, ''),
            );
          },
        ) : Container();
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: _userProfileImage == null ? CircularProgressIndicator() : CircleAvatar(
                backgroundColor: Colors.green.shade100,
                backgroundImage: NetworkImage(_userProfileImage),
              ),
              accountName: _nickName == null ? LinearProgressIndicator() : Text(
                _nickName,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              accountEmail: _firebaseUser == null ? LinearProgressIndicator() : Text(
                _firebaseUser.email,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                border: Border.symmetric(
                  vertical: BorderSide(
                    width: 1,
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage()));
              },
              leading: Icon(
                Icons.person,
              ),
              title: Text(
                'Profile',
              ),
              subtitle: _nickName == null ? LinearProgressIndicator() : Text(
                '(${_nickName}\'s Profile)',
              ),
            ),
            Divider(
              color: Colors.black,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleSignOut,
            itemBuilder: (context) {
              return {'Logout'}.map((String choice) {
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
        title: Text(
          'Flutter Chat',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Search Users',
        backgroundColor: Colors.green.shade200,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchUsersProfile()));
        },
        child: Icon(
          Icons.search,
        ),
      ),
      body: SafeArea(
        child: Container(
          child: chatsMessagesTiles(),
        ),
      ),
    );
  }
}

class ChatRooms extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRooms({this.userName,@required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ChatScreen(
              roomID: chatRoomId,
            )
        ));
      },
      child: Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 12,
            ),
            Text(
              userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w300,
               ),
            ),
          ],
        ),
      ),
    );
  }
}
