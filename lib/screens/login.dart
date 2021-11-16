import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moodify/constants.dart';
import 'package:moodify/screens/Dashboard.dart';

class LoginPage extends StatefulWidget {
  LoginPage(this.cameras);
  final dynamic cameras;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '', password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/loginPagejpg.jpg'),
                fit: BoxFit.cover)),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "LOGIN",
              style: styleBoldWhite,
            ),
            SizedBox(
              height: 50,
            ),
            Column(
              children: [
                TextField(
                  key: Key('login_email'),
                  onChanged: (value) {
                    email = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    suffix: Icon(
                      Icons.edit,
                      color: Colors.red,
                      size: 20,
                    ),
                    icon: Icon(
                      Icons.mail_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                    hintText: "Enter Email",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  key: Key('login_password'),
                  onChanged: (value) {
                    password = value;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      suffix: Icon(
                        Icons.edit,
                        color: Colors.red,
                        size: 20,
                      ),
                      icon: Icon(
                        Icons.lock_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                      hintText: "Enter Password",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      )),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: email, password: password)
                        .then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DashBoard(widget.cameras)));
                    });
                    Navigator.pop(context);
                  },
                  child: Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(width: 2, color: Colors.white),
                    ),
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Login',
                        style: elementwhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
