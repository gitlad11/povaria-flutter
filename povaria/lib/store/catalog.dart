import 'package:flutter/cupertino.dart';

class Catalog_store with ChangeNotifier  {
  List _catalogs = [];
  bool _offset = false;

  set_data(List data){
    _catalogs = data;
    notifyListeners();
  }
  set_offset(double offset){
    if(offset > 60){
      _offset = true;
    } else {
      _offset = false;
    }
    notifyListeners();
  }
  bool get offset => _offset;
  List get catalogs => _catalogs;
}