import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert ;

String apiKey = DotEnv().env['API_KEY'];
class DataFetcher { 
  final String url ;
  DataFetcher({this.url});

  Future<dynamic> getData() async{
    print(this.url);
    http.Response res = await http.get(this.url,headers :{
      'x-ba-key' : apiKey
    });
    var json = convert.jsonDecode(res.body);
    return json;
  }

}