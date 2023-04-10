import 'package:flutter/cupertino.dart';

class Current_list_store with ChangeNotifier  {
  List _current = [];
  List _history = [];
  String _name = '';
  String _url = '/list/goryachie_bliuda/';
  String _search = '';
  bool _loading = true;

  set_data(List data){
    _current = data;
    notifyListeners();
  }
  set_name(String name){
    _name = name;
    notifyListeners();
  }
  set_url(String url){
    _url = url;
    notifyListeners();
  }
  set_loading(bool loading){
    _loading = loading;
    notifyListeners();
  }

  String get search => _search;
  bool get loading => _loading;
  String get url => _url;
  String get name => _name;
  List get current => _current;
  List get history => _history;
}