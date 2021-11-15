import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moodify/constants.dart';
import 'package:moodify/screens/Dashboard.dart';
import 'package:moodify/screens/GetMood.dart';
import 'package:moodify/screens/homePage.dart';

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

    dynamic cameras, firstCamera;

    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    firstCamera = cameras.first;

    if (currentUserSigned != null) {
      String currentEmail = currentUserSigned.email.toString();

      // FirebaseAuth.instance.signOut();
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => DashBoard(cameras)));
      SystemNavigator.pop();
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => HomePage(cameras)));
      SystemNavigator.pop();
    }
  }

  @override
  void initState() {
    super.initState();
    initialisefire();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SpinKitSpinningLines(
          color: Colors.red,
          size: 80,
        ),
        SizedBox(height: 10),
        Text(
          'Moodify',
          style: TextStyle(
              fontSize: 30, color: Colors.red, fontFamily: 'luckiestGuy'),
        ),
      ],
    );
  }
}
