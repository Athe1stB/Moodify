import 'package:android_intent/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moodify/constants.dart';

class FavVideos extends StatefulWidget {
  const FavVideos({Key? key}) : super(key: key);

  @override
  _FavVideosState createState() => _FavVideosState();
}

class _FavVideosState extends State<FavVideos> {
  String currentUserEmail = ' ';
  dynamic favVideos = {};
  dynamic items = [];

  void getList() async {
    dynamic tempusercurrent = FirebaseAuth.instance.currentUser;
    currentUserEmail = tempusercurrent.email.toString();
    CollectionReference ref = FirebaseFirestore.instance.collection('Users');

    await ref.doc(currentUserEmail).get().then((value) {
      if (value.exists) {
        setState(() {
          print('name ' + value['name']);
          favVideos = (value['favVideos'] == null) ? {} : value['favVideos'];
        });
      } else
        print('not found');
    });

    setState(() {
      // prepare list
      dynamic moods = [
        'angry',
        'disgust',
        'fear',
        'happy',
        'sad',
        'surprise',
        'trending'
      ];

      for (int i = 0; i < 7; i++) {
        for (int j = 0; j < favVideos[moods[i]].length; j++) {
          items.add(favVideos[moods[i]][j]);
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    var ltList = <Widget>[];
    Widget temp;
    if (items.isEmpty)
      temp = SpinKitSpinningLines(color: Colors.teal);
    else
      temp = ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(16),
        children: ltList,
      );

    for (int i = 0; i < items.length; i++) {
      ltList.add(new ListTile(
        tileColor: Colors.teal.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(width: 2, color: Colors.teal.shade900),
        ),
        title: Text(items[i]['title']),
        subtitle: Text(items[i]['channelTitle']),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(items[i]['thumbnail']),
        ),
        onTap: () {
          String key = 'https://youtu.be/' + items[i]['ID'];
          final AndroidIntent intent = AndroidIntent(
            action: 'action_view',
            data: key,
          );
          intent.launch();
        },
      ));
      ltList.add(SizedBox(height: 8));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Videos',
          style: styleBoldBlackMedium,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: temp,
            ),
          ],
        ),
      ),
    );
  }
}
