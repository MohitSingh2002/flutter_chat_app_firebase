import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermochat/homePage/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttermochat/authentication/signup.dart';
import 'package:toast/toast.dart';

class LoginAuth extends StatefulWidget {
  @override
  _LoginAuthState createState() => _LoginAuthState();
}

class _LoginAuthState extends State<LoginAuth> {
  String _emailLogin, _passwordLogin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green.shade300,
        centerTitle: true,
        title: Text(
          'LOGIN',
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
                        _emailLogin = value;
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
                        _passwordLogin = value;
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'Password should be more than 6 letters',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            FlatButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailLogin);
                                Toast.show('Password change email sent to your registered email', context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                              },
                              child: Text(
                                'Forgot Password',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 70, right: 70,),
                      child: RaisedButton(
                        color: Colors.green.shade200,
                        onPressed: () {
                          final user = FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailLogin, password: _passwordLogin);
                          if (user != null) {
                            Toast.show('Login Success', context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
                          }
                        },
                        child: Center(
                          child: Text(
                            'Login',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Don\'t have account?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    width: 1,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpAuth()));
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
