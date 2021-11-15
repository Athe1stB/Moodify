import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodify/constants.dart';
import 'package:moodify/screens/GetMood.dart';
import 'package:moodify/screens/PredictedSongs.dart';
import 'package:moodify/screens/favChannels.dart';
import 'package:moodify/screens/favVideos.dart';
import 'package:moodify/screens/favouritedList.dart';
import 'package:moodify/screens/listSongs.dart';

class DashBoard extends StatefulWidget {
  DashBoard(this.cameras);
  final dynamic cameras;

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late String currentUserEmail;
  String name = 'name',
      mood = 'sad',
      email = 'email',
      query = '',
      finalQuery = '',
      msg = '';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Moodify',
                  style: TextStyle(
                      fontFamily: 'luckiestGuy',
                      fontSize: 60,
                      color: Colors.teal),
                ),
                Divider(
                  height: 20,
                  thickness: 2,
                  color: Colors.teal,
                ),
                Text(
                  'Hi ' + name + ', Hope you are doing fine!',
                  style: TextStyle(
                      fontFamily: 'kanit', fontSize: 20, color: Colors.black),
                ),
                Divider(
                  height: 20,
                  thickness: 2,
                  color: Colors.teal,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  color: Colors.blueAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        //capture Image
                        GestureDetector(
                          onTap: () async {
                            String temp = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        GetMood(cameras: widget.cameras)));

                            setState(() {
                              mood = (temp == 'neutral') ? 'trending' : temp;
                              msg = 'You look ' + temp;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 0.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            height: 40,
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.blue[900],
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Let's see how are you !",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blue,
                                      fontFamily: 'kanit'),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          msg,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'pacifico',
                          ),
                        ),
                      ],
                    ),
                  ),
                  elevation: 0,
                ),
                Divider(
                  height: 10,
                  thickness: 2,
                  color: Colors.blue[900],
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      query = value;
                    });
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    suffix: Icon(
                      Icons.edit,
                      color: Colors.blue,
                      size: 18,
                    ),
                    icon: Icon(
                      Icons.info_outline_rounded,
                      size: 30,
                      color: Colors.blue[700],
                    ),
                    hintText: "Any extra filters?",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                FavouritedList(mood)));
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                    decoration: BoxDecoration(
                        color: Colors.blue[900],
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    margin: EdgeInsets.all(6),
                    child: Center(
                      child: Text(
                        'Recommended for you',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.blue[100],
                            fontFamily: 'luckiestGuy'),
                      ),
                    ),
                  ),
                ),
                // based on mood
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ListSongs(query, mood, 'all')));
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                    decoration: BoxDecoration(
                        color: Colors.blue[900],
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    margin: EdgeInsets.all(6),
                    child: Center(
                      child: Text(
                        'Based On Your Mood',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.blue[100],
                            fontFamily: 'luckiestGuy'),
                      ),
                    ),
                  ),
                ),
                //Favourite Videos
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => FavVideos()));
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                    decoration: BoxDecoration(
                        color: Colors.blue[900],
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    margin: EdgeInsets.all(6),
                    child: Center(
                      child: Text(
                        'Favourite Videos',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.blue[100],
                            fontFamily: 'luckiestGuy'),
                      ),
                    ),
                  ),
                ),
                // fav channel
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => FavChannels()));
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                    decoration: BoxDecoration(
                        color: Colors.blue[900],
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    margin: EdgeInsets.all(6),
                    child: Center(
                      child: Text(
                        'Favourite Channels',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.blue[100],
                            fontFamily: 'luckiestGuy'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
