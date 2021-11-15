import 'package:android_intent/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moodify/constants.dart';
import 'package:moodify/utilities/searchTool.dart';

class ListSongs extends StatefulWidget {
  final String mood, query, topic;
  ListSongs(this.query, this.mood, this.topic);

  @override
  State<ListSongs> createState() => _ListSongsState();
}

class _ListSongsState extends State<ListSongs> {
  String currentUserEmail = '';
  String nextPageToken = ' ', prevPageToken = ' ';
  List items = [];
  String u1 =
      'https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&q=';
  String u2 = '&type=video&key=AIzaSyAJd9FlE9pWQkoUXn3628Luhml4ZBPSTkU';
  String randomShit = 'randomShit';
  dynamic favVideos = {};
  dynamic favChannel = [];

  String makeUrl(String q) {
    String temp = u1;
    String x = '';
    for (int i = 0; i < q.length; i++) {
      if (q[i] == ' ')
        x += '+';
      else
        x += q[i];
    }
    temp = temp + x + u2;
    return temp;
  }

  void getList(String surl) async {
    dynamic tempusercurrent = FirebaseAuth.instance.currentUser;
    currentUserEmail = tempusercurrent.email.toString();
    CollectionReference ref = FirebaseFirestore.instance.collection('Users');

    await ref.doc(currentUserEmail).get().then((value) {
      if (value.exists) {
        setState(() {
          print('name ' + value['name']);
          favVideos = (value['favVideos'] == null) ? {} : value['favVideos'];
          favChannel = (value['favChannel'] == null) ? {} : value['favChannel'];
        });
      } else
        print('not found');
    });

    SearchTool searchTool = new SearchTool(makeUrl(surl));
    dynamic searchData = await searchTool.getData();

    setState(() {
      nextPageToken = searchData['nextPageToken'];
      prevPageToken = (searchData['prevPageToken'] == null)
          ? ' '
          : searchData['prevPageToken'];
      print(nextPageToken);
      print(prevPageToken);
      int results = searchData['items'].length;
      items.clear();
      for (int i = 0; i < results; i++) {
        items.add({
          'ID': searchData['items'][i]['id']['videoId'],
          'channelID': searchData['items'][i]['snippet']['channelId'],
          'title': searchData['items'][i]['snippet']['title'],
          'channelTitle': searchData['items'][i]['snippet']['channelTitle'],
          'description': searchData['items'][i]['snippet']['description'],
          'thumbnail': searchData['items'][i]['snippet']['thumbnails']['high']
              ['url'],
          'publishedAt': searchData['items'][i]['snippet']['publishTime'],
        });
      }
    });
  }

  void updateEntry(dynamic temp) async {
    bool found = false;
    for (int i = 0; i < favVideos[widget.mood].length; i++)
      if (favVideos[widget.mood][i]['ID'] == temp['ID']) found = true;

    if (!found) {
      favVideos[widget.mood].add(temp);
      favChannel.add({
        'channelID': temp['channelID'],
        'channelTitle': temp['channelTitle'],
      });
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserEmail)
          .update({'favVideos': favVideos, 'favChannel': favChannel});
    }
  }

  @override
  void initState() {
    super.initState();
    getList(widget.query + widget.mood + ' songs');
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
        tileColor: Colors.teal[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(width: 2, color: Colors.black),
        ),
        title: Text(items[i]['title']),
        subtitle: Text(items[i]['channelTitle']),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(items[i]['thumbnail']),
        ),
        onTap: () {
          // add this song to the current mood
          updateEntry(items[i]);
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
          'For you',
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
            Container(
              margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (prevPageToken != ' ')
                        getList(widget.query + '&pageToken=' + prevPageToken);
                    },
                    child: Text('Back'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal[900],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (nextPageToken != ' ')
                        getList(widget.query + '&pageToken=' + nextPageToken);
                    },
                    child: Text('Next'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[900],
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
