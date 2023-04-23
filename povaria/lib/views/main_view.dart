import 'package:flutter/material.dart';
import 'package:povaria/api/get_request.dart';

import 'package:html/parser.dart' as parser;
import 'package:povaria/components/catalogs.dart';
import 'package:povaria/components/current_list.dart';
import 'package:povaria/store/catalog.dart';
import 'package:povaria/store/recipe.dart';
import 'package:povaria/views/favorite_view.dart';
import 'package:povaria/views/history_view.dart';
import 'package:povaria/views/recipe_view.dart';
import 'package:provider/provider.dart';
import 'package:povaria/components/nav_bar.dart';
import 'package:povaria/components/search.dart';
import '../store/current_list.dart';


class Main_view extends StatefulWidget{

  @override
  State<Main_view> createState() => _Main_viewState();
}

class _Main_viewState extends State<Main_view> {

  getCatalogs() async {
    try{
      var items = [];
      var result = await get_request('https://povar.ru/list/');
      if(result.statusCode == 200){
        var document = parser.parse(result.body);
        List elements = document.getElementsByClassName('itemHdr');
        for (var el in elements){
          String? item = el.getElementsByClassName('ingredientItemH2')[0].innerHtml.split(">")[1];
          String? link = el.attributes['href'];
          items.add({ 'title' : item, 'link' : link });
        }
        Provider.of<Catalog_store>(context, listen: false).set_data(items);
      } else {
        print(result.statusCode);
      }
    } on Exception catch(e){
        print(e);
    }
  }

  getSearch(String text) async {
    if(text.length > 0){
      await getCurrent('/xmlsearch?query=' + text);
    } else {
      getCurrent(Provider.of<Current_list_store>(context, listen: false).url);
    }
  }
  getCurrent(String url) async {
    var items = [];
    String name = '';
    var result = await get_request(get_source() + url);
    var document = parser.parse(result.body);

    var recipe_list = document.getElementsByClassName('recipe');

    for(var el in recipe_list){
      String? link = '';
      String? name = '';
      String? image = '';
      String? time = '';
      String? rate = '';
      image = el.getElementsByClassName('thumb')[0].getElementsByTagName('img')[0].attributes['src'];
      link = el.getElementsByClassName('listRecipieTitle')[0].attributes['href'];
      time = el.getElementsByClassName('cook-time')[0].getElementsByTagName('span')[0].innerHtml.trim();
      name = el.getElementsByClassName('listRecipieTitle')[0].innerHtml;
      rate = el.getElementsByClassName('rate')[0].innerHtml.split('>')[1].trim();
      items.add({ 'title' : name, 'link' : link, 'image' : image, 'time' : time, 'rate': rate });
    }

    var title = document.getElementsByClassName('cat_sect_h')[0];
    name = title.getElementsByTagName('h1')[0].innerHtml;

    Provider.of<Current_list_store>(context, listen: false).set_name(name);
    Provider.of<Current_list_store>(context, listen: false).set_data(items);
    Provider.of<Current_list_store>(context, listen: false).set_loading(false);
  }

  selectItem(String url){
    Provider.of<Recipe_store>(context, listen: false).set_url(url);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Recipe_view()));
  }
  onHistory(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => History_view()));
  }
  onFavorite(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Favorite_view()));
  }

  void initState(){
    getCatalogs();
    getCurrent(Provider.of<Current_list_store>(context, listen: false).url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
              height: MediaQuery.of(context).size.height - 25,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: [
                  Navbar(title: 'Категории', btns: Row(
                children: [
                  IconButton(
                    onPressed: onHistory,
                    icon: const Icon(
                      Icons.history,
                      color: Colors.black54,
                      size: 30.0,
                    ),
                  ),
                  IconButton(
                    onPressed: onFavorite,
                    icon: const Icon(
                      Icons.star_border_outlined,
                      color: Colors.black54,
                      size: 30.0,
                    ),
                  ),
                ],
              )),
                  Input(getSearch: getSearch),
                  Catalogs(getCurrent: getCurrent),
                  Current_list(selectItem: selectItem)
                ],
              ),
            )
      ),
    );
  }
}