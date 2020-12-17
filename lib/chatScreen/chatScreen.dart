import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttermochat/chatScreen/getChatsHelper.dart';

class ChatScreen extends StatefulWidget {
  final String roomID;
  const ChatScreen({Key key, this.roomID}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  DatabaseCloudFirestore _databaseCloudFirestore = new DatabaseCloudFirestore();
  Stream<QuerySnapshot> chats;
  final _message = TextEditingController();
  String _nickNameLoggedUser;
  Widget chatsMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return MessageTile(
              message: snapshot.data.documents[index].data['message'],
              sendByMe: _nickNameLoggedUser == snapshot.data.documents[index].data['sendBy'],
            );
          },
        ) : Container();
      },
    );
  }
  @override
  void initState() {
    super.initState();
    getLoggedUserNameFromCloudFirestore();
    DatabaseCloudFirestore().getChats(widget.roomID).then((value) {
      setState(() {
        chats = value;
      });
    });
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
  addMessageToCloudFirestore(String message) {
    Map<String, dynamic> chatMessageArray = {
      "message": message,
      "sendBy": _nickNameLoggedUser,
      "timeStamp": DateTime.now().millisecondsSinceEpoch,
    };
    Firestore.instance.collection('chatroom').document(widget.roomID).collection('chats').add(chatMessageArray).catchError((e) {
      print(e);
    });
    _message.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        centerTitle: true,
        title: Text(
          'Chat Screen',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            chatsMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _message,
                        decoration: InputDecoration(
                          hintText: 'Type a message . . .',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: IconButton(
                        onPressed: () {
                          addMessageToCloudFirestore(_message.text);
                        },
                        icon: Icon(
                          Icons.send,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          color: sendByMe ? Colors.green.shade100 : Colors.grey.shade300,
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
