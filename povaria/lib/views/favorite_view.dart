import 'package:flutter/material.dart';
import 'package:povaria/views/recipe_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/item_card.dart';
import '../components/nav_bar.dart';
import '../store/recipe.dart';

class Favorite_view extends StatefulWidget{
  @override
  State<Favorite_view> createState() => _Favorite_viewState();
}

class _Favorite_viewState extends State<Favorite_view> {
  bool loading = false;
  List items = [];

  parseString(String s) async {
    var values = s.split('--');
    Map object = {};
    int index = 0;
    for(var val in values){
      if(val == ' : '){
        object[values[index - 1]] = values[index + 1];
      }
      index = index + 1;
    }
    return object;
  }

  initDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList('history');
    var it = [];
    for(var item in data!){
      var i = await parseString(item);
      it.add(i);
    }
    setState(() {
      items = it;
    });
  }
  selectItem(String url){
    Provider.of<Recipe_store>(context, listen: false).set_url(url);
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Recipe_view()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Navbar(title: 'История',btns: Container()),
            Container(
              height: MediaQuery.of(context).size.height - 86,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Ink(
                      child: InkWell(
                        onTap: (){ selectItem(items[index]['link']); },
                        child: Card_item(title: items[index]['name'],
                                    image: items[index]['image'],
                                    time: items[index]['time']
                                  ),
                      ),
                    );
                  }),
              ),
          ],
        ),
      ),
    );
  }
}