import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moodify/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: defaultAppTheme,
      home: Scaffold(
        body: Center(child: Loading()),
      ),
    );
  }
}

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void initialisefire() async {
    await Firebase.initializeApp();

    FirebaseAuth mAuth = FirebaseAuth.instance;
    dynamic currentUserSigned = mAuth.currentUser;

    if (currentUserSigned != null) {
      String currentEmail = currentUserSigned.email.toString();

      // FirebaseAuth.instance.signOut();
      // TODO : proceed to dashboard
      // SystemNavigator.pop();
    } else {
      // TODO : goto login/signup
      // await Navigator.push(context,
      //     MaterialPageRoute(builder: (BuildContext context) => SelectUser()));
      // SystemNavigator.pop();
    }
  }

  @override
  void initState() {
    super.initState();
    initialisefire();
  }

  @override
  Widget build(BuildContext context) {
    return SpinKitSpinningLines(
      color: Colors.red,
      size: 80,
    );
  }
}
