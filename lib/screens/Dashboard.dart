import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodify/constants.dart';
import 'package:moodify/screens/PredictedSongs.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late String currentUserEmail;
  String name = 'name', mood = 'sad', email = 'email';
  int age = 0;
  late Map<int, dynamic> favVideos;
  late Map<String, dynamic> favChannel;

  void initializeAllParams() async {
    dynamic tempusercurrent = FirebaseAuth.instance.currentUser;
    currentUserEmail = tempusercurrent.email.toString();
    CollectionReference ref = FirebaseFirestore.instance.collection('Users');

    await ref.doc(currentUserEmail).get().then((value) {
      if (value.exists) {
        setState(() {
          print(value['name']);
          name = value['name'];
          email = value['email'];
          age = value['age'];
          favChannel = value['favChannel'];
          favChannel = value['favVideos'];
        });
      } else
        print('not found');
    });

    
  }

  @override
  void initState() {
    super.initState();
    initializeAllParams();
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (BuildContext context) => predictedSongs()));
  }

  @override
  Widget build(BuildContext context) {
    final one = Container(
      margin: EdgeInsets.all(5),
      height: 50,
      child: Center(
        child: Text('One'),
      ),
      color: Colors.amber,
    );
    final two = Container(
      margin: EdgeInsets.all(5),
      height: 50,
      child: Center(
        child: Text('Two'),
      ),
      color: Colors.pink,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.grey[600],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text('Query'),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 3, horizontal: 0.0),
                color: Colors.grey,
                height: 20,
                child: Center(
                  child: Icon(
                    Icons.camera_alt_outlined,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text('Recent Searches'),
            ),
            Expanded(
              flex: 5,
              child: ListView(
                shrinkWrap: true,
                children: [one, one, one, one, one, one, one, one, one, one],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text('Others'),
            ),
            Expanded(
              flex: 5,
              child: ListView(
                shrinkWrap: true,
                children: [two, two, two, two, two],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
