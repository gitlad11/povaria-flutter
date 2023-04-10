import 'package:http/http.dart' as http;

get_source(){
  return "https://povar.ru";
}

get_request(url) async {
  var result = await http.Client().get(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
  return result;
}