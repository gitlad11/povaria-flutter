import 'package:flutter/material.dart';
import 'package:povaria/components/nav_bar.dart';
import 'package:povaria/views/recipe_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/item_card.dart';
import '../store/recipe.dart';

class History_view extends StatefulWidget{
  History_view({super.key});

  @override
  State<History_view> createState() => _History_viewState();
}

class _History_viewState extends State<History_view> {
  bool loading = false;
  List items = [];

  deleteHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('history');
    prefs.setStringList('history', []);
    setState(() {
      items = [];
    });
  }
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
  void initState() {
    initDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height - 25,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Navbar(title: 'История', btns: IconButton(
              onPressed: deleteHistory,
              icon: const Icon(Icons.delete, size: 28, color: Colors.black54),
            )),
            ListView.builder(
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
                                    ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
