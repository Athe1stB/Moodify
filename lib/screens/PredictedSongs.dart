import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:moodify/utilities/searchTool.dart';

class predictedSongs extends StatefulWidget {
  const predictedSongs({Key? key}) : super(key: key);

  @override
  _predictedSongsState createState() => _predictedSongsState();
}

class _predictedSongsState extends State<predictedSongs> {
  String searchParams = "d";
  String surl = '';
  String u1 =
      'https://youtube.googleapis.com/youtube/v3/search?part=snippet&q=';
  String u2 = '&type=video&key=AIzaSyAJd9FlE9pWQkoUXn3628Luhml4ZBPSTkU';
  String randomShit = 'randomShit';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Songs for you',
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                key: Key('name'),
                onChanged: (value) {
                  setState(() {
                    searchParams = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Search Anything',
                ),
              ),
              TextButton(
                child: Text('search'),
                onPressed: () async {
                  setState(() {
                    surl = makeUrl(searchParams);
                  });
                  SearchTool searchTool = new SearchTool(surl);
                  dynamic searchData = await searchTool.getData();
                  setState(() {
                    randomShit = searchData['items'][1]['id']['videoId'];
                  });
                },
              ),
              Column(
                children: [
                  Text(randomShit),
                  TextButton(
                      onPressed: () {
                        String key = 'https://youtu.be/' + randomShit;
                        final AndroidIntent intent = AndroidIntent(
                          action: 'action_view',
                          data: key,
                        );
                        intent.launch();
                      },
                      child: Text("YouTube"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
