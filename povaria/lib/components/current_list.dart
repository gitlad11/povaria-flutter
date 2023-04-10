import 'package:flutter/material.dart';
import 'package:povaria/components/catalogs.dart';
import 'package:povaria/store/catalog.dart';
import 'package:povaria/store/current_list.dart';
import 'package:provider/provider.dart';
import 'package:povaria/api/get_request.dart';
import 'package:html/parser.dart' as parser;
import 'package:povaria/styles/current.dart';
import 'package:povaria/components/loading.dart';

import 'item_card.dart';

class Current_list extends StatefulWidget{
  Current_list({ this.selectItem });
  var selectItem;
  
  @override
  State<Current_list> createState() => _Current_listState();
}

class _Current_listState extends State<Current_list> {
  final ScrollController _scrollController = ScrollController();

  onScrollEvent(){
    final offset = _scrollController.offset;
    Provider.of<Catalog_store>(context, listen: false).set_offset(offset);
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(onScrollEvent);
  }

  @override
  void dispose() {
    _scrollController.removeListener(onScrollEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<Current_list_store, Catalog_store>(
      builder: (context, current, catalog, child) {
        return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: MediaQuery.of(context).size.width,
            height: catalog.offset ? MediaQuery.of(context).size.height - 117 : MediaQuery.of(context).size.height - 297,
            padding: const EdgeInsets.only(top : 15, left: 15, right: 15),
            child: current.loading ?
            Loading() :
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(current.name, style: title_style),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  height: catalog.offset ? MediaQuery.of(context).size.height - 161 : MediaQuery.of(context).size.height - 341 ,
                  child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: current.current.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Ink(
                          child: InkWell(
                            onTap: () { widget.selectItem(current.current[index]['link']); },
                            child: Card_item(title: current.current[index]['title'],
                                             time: current.current[index]['time'],
                                             image: current.current[index]['image'],
                                             rate: current.current[index]['rate'])
                          ),
                        );
                      }
                  ),
                )
              ],
            ),
        );
      }
    );
  }
}