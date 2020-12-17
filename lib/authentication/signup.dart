import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttermochat/authentication/uploadSignUpImages.dart';
import 'package:toast/toast.dart';

class SignUpAuth extends StatefulWidget {
  @override
  _SignUpAuthState createState() => _SignUpAuthState();
}

class _SignUpAuthState extends State<SignUpAuth> {
  String _nickname, _emailSignUp, _passwordSignUp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        centerTitle: true,
        title: Text(
          'Create Account',
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
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: <Widget>[
                    TextField(
                      onChanged: (value) {
                        _nickname = value;
                      },
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter Nick Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      onChanged: (value) {
                        _emailSignUp = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter E-mail',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      onChanged: (value) {
                        _passwordSignUp = value;
                      },
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Password should be more than 6 letters',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 50, right: 50,),
                        child: RaisedButton(
                          color: Colors.green.shade200,
                          onPressed: () {
                            FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailSignUp, password: _passwordSignUp).then((value) {
                              Firestore.instance.collection('users').document(value.user.uid).setData({
                                'nickname': _nickname,
                                'uid': value.user.uid,
                                'email': _emailSignUp,
                              }).then((value) {
                                Toast.show('Account Created', context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => UploadSignUpImages()));
                              }).catchError((e) {
                                print(e);
                              });
                            }).catchError((e) {
                              print(e);
                            });
                          },
                          child: Center(
                            child: Text(
                              'Sign Up',
                            ),
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
}
