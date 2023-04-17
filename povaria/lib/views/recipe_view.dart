import 'package:flutter/material.dart';
import 'package:povaria/api/get_request.dart';
import 'package:html/parser.dart' as parser;
import 'package:povaria/store/recipe.dart';
import 'package:provider/provider.dart';
import 'package:povaria/styles/recipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Recipe_view extends StatefulWidget{

  @override
  State<Recipe_view> createState() => _Recipe_viewState();
}

class _Recipe_viewState extends State<Recipe_view> {
  bool loading = true;
  bool full_screen = false;
  late ScrollController controller;

  saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ///prefs.remove('history');
    List<String>? history = prefs.getStringList('history');
    history ??= [];
    var object = Provider.of<Recipe_store>(context, listen: false).recipe;
    var link = Provider.of<Recipe_store>(context, listen: false).url;
    String shared = '{ --name-- : --${object['name']}--, --image-- : --${object['image']}--, --link-- : --$link--, --time-- : --${object['time']}-- }';
    history?.add(shared);
    await prefs.setStringList('history', history!);
  }

  saveFavory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ///prefs.remove('history');
    List<String>? favorite = prefs.getStringList('favorite');
    favorite ??= [];
    var object = Provider.of<Recipe_store>(context, listen: false).recipe;
    var link = Provider.of<Recipe_store>(context, listen: false).url;
    String shared = '{ --name-- : --${object['name']}--, --image-- : --${object['image']}--, --link-- : --$link--, --time-- : --${object['time']}-- }';
    favorite?.add(shared);
    await prefs.setStringList('history', favorite!);
  }

  getData() async {
    var item = {};
    var url = Provider.of<Recipe_store>(context, listen: false).url;
    var result = await get_request(get_source() + url);
    if(result.statusCode == 200){
      var document = parser.parse(result.body);
      String? name = '';
      String? image = '';
      String? description = '';
      String? time = '';
      List? ingrid = [];
      List? nutritions = [];
      List? instructions = [];
      
      name = document.getElementsByTagName('h1')[0].innerHtml;
      description = document.getElementsByClassName('detailed_full')[0].innerHtml.trim();
      time = document.getElementsByClassName('duration')[0].innerHtml.split('>')[2];
      image = document.getElementsByClassName('photo')[0].attributes['src'];
      
      List? vals = document.getElementsByClassName('ingredient');
      for(var val in vals){
          var item = {
            'name' : val.getElementsByClassName('name')[0].innerHtml,
            'count' : val.getElementsByClassName('value').length > 0 ? val.getElementsByClassName('value')[0].innerHtml : '',
            'unit' : val.getElementsByClassName('u-unit-name')[0].innerHtml,
          };
          ingrid.add(item);
      }
      
      vals = document.getElementsByClassName('calories_info');
      var index = 0;
      for(var val in vals){
        List? values = val.getElementsByTagName('span');
        List? names = val.getElementsByTagName('p');
        nutritions.add({ 'name' : names![index].innerHtml, 'value' : values![index].innerHtml });
        index = index + 1;
      }
      
      vals = document.getElementsByClassName('instruction');

      for(var val in vals){
        String image = val.getElementsByTagName('img').length > 0 ? val.getElementsByTagName('img')[0].attributes['src'] : '';
        String instruction = val.getElementsByClassName('detailed_step_description_big')[0].innerHtml;
        instructions.add({ 'image' : image, 'instruction' : instruction });
      }
      
      var recipe = { 'image' : image, 'time': time, 'name': name,
                     'description': description, 'instructions' : instructions,
                     'ingrid': ingrid, 'nutrition' : nutritions };
      await Provider.of<Recipe_store>(context, listen: false).set_data(recipe);
      setState(() {
        loading = false;
      });
    } else {
      print(result.statusCode);
    }
  }

  onScrollEvent(){
    final offset = controller.offset;
    setState(() {
      full_screen = offset > 50;
    });
  }

  void initData() async {
    await getData();
    await saveHistory();
  }

  @override
  void initState() {
    initData();
    controller = ScrollController();
    controller.addListener(onScrollEvent);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(onScrollEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Recipe_store>(
        builder: (context, recipe, child) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: loading ? const Center(child: CircularProgressIndicator(color: Colors.redAccent)) :
                Column(
                  children: [
                    Stack(children: [
                      AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity:full_screen ? 0.6 : 1,
                          child: Image.network(recipe.recipe['image'], width: MediaQuery.of(context).size.width)
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: !full_screen ? 215 : 90,
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: full_screen ? MediaQuery.of(context).size.height - 90 :
                                                MediaQuery.of(context).size.height - 215,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:  BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                              boxShadow:  [
                                BoxShadow(
                                  color: Colors.black54,
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                  offset: Offset(0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 6),
                                Text(recipe.recipe['name'], style: title_style, textAlign: TextAlign.center,),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.timelapse, color: Colors.black54), SizedBox(width: 4),
                                    Text(recipe.recipe['time'],style: time_style)
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: ListView(
                                    controller: controller,
                                    scrollDirection: Axis.vertical,
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: false,
                                    children: [
                                      Row(
                                        children: const [
                                          Text('Описание:', style: description_title_style),
                                        ],
                                      ),
                                      Text(recipe.recipe['description'], style: description_style),
                                      const SizedBox(height: 20),

                                      ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: recipe.recipe['nutrition'].length,
                                      itemBuilder: (BuildContext context, int index) {
                                          return Container(
                                                height: 40,
                                                width: 120,
                                                margin: const EdgeInsets.only(top: 4, bottom: 4),
                                                padding:const EdgeInsets.all(9),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.blueGrey.shade100,

                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(recipe.recipe['nutrition'][index]['name'] + ": ", style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500, color: Colors.black87)),
                                                    Text(recipe.recipe['nutrition'][index]['value'], style: TextStyle(fontSize: 18,color: Colors.black87, fontWeight: FontWeight.w500)),

                                                  ],
                                                ),
                                          );
                                      }),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          const Text('Ингридиенты:', style: description_title_style),
                                        ],
                                      ),
                                      ListView.builder(
                                          physics: const BouncingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: recipe.recipe['ingrid'].length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Container(
                                              height: 46,
                                              width: 120,
                                              margin: const EdgeInsets.only(top: 4, bottom: 4),
                                              padding:const EdgeInsets.all(9),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.blueAccent.shade200,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    blurRadius: 2,
                                                    offset: Offset(1, 3), // Shadow position
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(recipe.recipe['ingrid'][index]['name'].trim() , style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500, color: Colors.white)),
                                                  const Spacer(),
                                                  Text(recipe.recipe['ingrid'][index]['count'].trim() + ' ', style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.w400)),
                                                  Text(recipe.recipe['ingrid'][index]['unit'].trim(), style: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.w400)),
                                                ],
                                              ),
                                            );
                                          }),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          const Text('Этапы:', style: description_title_style),
                                        ],
                                      ),

                                      ListView.builder(
                                          physics: const BouncingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: recipe.recipe['instructions'].length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Column(
                                              children: [
                                                Container(
                                                  height: 40,
                                                  width: 40,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.blueAccent.shade100,
                                                      width: 2,
                                                    ),
                                                    color: Colors.white
                                                  ),
                                                  child: Text(index.toString(), style: TextStyle(fontSize: 20,color: Colors.black87, fontWeight: FontWeight.w500)),
                                                ),
                                                Container(
                                                  clipBehavior: Clip.hardEdge,
                                                  alignment: Alignment.topCenter,
                                                  width: MediaQuery.of(context).size.width - 10,
                                                  margin: const EdgeInsets.only(top: 15, bottom: 15),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(
                                                      color: Colors.grey.shade200,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Image.network(recipe.recipe['instructions'][index]['image'], width: MediaQuery.of(context).size.width, fit: BoxFit.fill),
                                                      Container(
                                                          padding: const EdgeInsets.all(5),
                                                          child: Text(recipe.recipe['instructions'][index]['instruction'],style: instruction_style)
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Positioned(
                        top: 30,
                        left: 10,
                        child: IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 32,
                          shadows: <Shadow>[Shadow(color: Colors.black, blurRadius: 15.0)],
                          color: Colors.white,)
                        ),
                      ),
                      Positioned(
                        top: 30,
                        right: 10,
                        child: IconButton(onPressed: saveFavory,
                            icon: Icon(
                          Icons.favorite_border,
                          size: 32,
                          shadows: <Shadow>[Shadow(color: Colors.black, blurRadius: 15.0)],
                          color: Colors.white,)
                        ),
                      ),
                    ]
                    )
                  ],
                )
          );
        }
      )
    );
  }
}