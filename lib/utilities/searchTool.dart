import 'dart:convert';
import 'package:http/http.dart' as http;

const String initial = 'https://api.openweathermap.org/data/2.5/weather';
const String apiKey = 'f25b745350a76e56e8c9257349245223';

class SearchTool {
  late Uri url;

  SearchTool(String surl) {
    url = Uri.parse(surl);
  }

  Future getData() async {
    try {
      http.Response response = await http.get(url);

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        String data = response.body;
        dynamic searchData = jsonDecode(data);
        return searchData;
      } else {
        print('Error');
      }
    }
    catch(e){
      print(e);}
  }
}
