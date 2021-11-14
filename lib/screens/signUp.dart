import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moodify/constants.dart';
import 'package:moodify/screens/Dashboard.dart';
import 'package:moodify/utilities/user.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email = '', password = '';
  String name = '';
  int age = 0;
  late FirebaseAuth mAuth;

  @override
  void initState() {
    mAuth = FirebaseAuth.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/signUpPagejpg.jpg'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "SignUp",
              style: styleBoldWhite,
            ),
            SizedBox(
              height: 50,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    key: Key('signUp_name'),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      suffix: Icon(
                        Icons.edit,
                        color: Colors.white70,
                        size: 20,
                      ),
                      icon: Icon(
                        Icons.mail_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                      hintText: "Enter Name",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    key: Key('signUp_age'),
                    onChanged: (value) {
                      setState(() {
                        age = int.parse(value);
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      suffix: Icon(
                        Icons.edit,
                        color: Colors.white70,
                        size: 20,
                      ),
                      icon: Icon(
                        Icons.mail_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                      hintText: "Enter Age",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    key: Key('signUp_email'),
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      suffix: Icon(
                        Icons.edit,
                        color: Colors.white70,
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
                  SizedBox(height: 20),
                  TextField(
                    key: Key('signUp_password'),
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
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
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      await mAuth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      Profile newUser = new Profile(name, age);
                      await newUser.addToCloud();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => DashBoard()));
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
                          'SignUp',
                          style: elementwhite,
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
    );
  }
}
