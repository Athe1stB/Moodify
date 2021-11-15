import 'package:android_intent/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moodify/constants.dart';

class FavChannels extends StatefulWidget {
  const FavChannels({Key? key}) : super(key: key);

  @override
  _FavChannelsState createState() => _FavChannelsState();
}

class _FavChannelsState extends State<FavChannels> {
  String currentUserEmail = '';
  dynamic items = [];
  dynamic favChannel = [];

  void getList() async {
    dynamic tempusercurrent = FirebaseAuth.instance.currentUser;
    currentUserEmail = tempusercurrent.email.toString();
    CollectionReference ref = FirebaseFirestore.instance.collection('Users');

    await ref.doc(currentUserEmail).get().then((value) {
      if (value.exists) {
        setState(() {
          print('name ' + value['name']);
          favChannel = (value['favChannel'] == null) ? {} : value['favChannel'];
        });
      } else
        print('not found');
    });

    setState(() {
      items = favChannel;
    });
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    var ltList = <Widget>[];
    Widget temp;
    if (items == null || items.isEmpty)
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
        title: Text(items[i]['channelTitle']),
        onTap: () {
          // add this song to the current mood
          String key = 'https://youtube.com/channel/' + items[i]['channelID'];
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
          'Channels',
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
