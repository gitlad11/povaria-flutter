import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';


class Recipe_store with ChangeNotifier  {
  Map _recipe = {};
  String _url = '';

  set_data(Map data){
    _recipe = data;
    notifyListeners();
  }

  set_url(String url){
    _url = url;
    notifyListeners();
  }

  String get url => _url;
  Map get recipe => _recipe;
}