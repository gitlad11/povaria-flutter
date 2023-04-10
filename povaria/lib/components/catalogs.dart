import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:povaria/store/catalog.dart';
import 'package:povaria/api/get_request.dart';
import 'package:povaria/styles/catalog.dart';

import '../store/current_list.dart';

class Catalogs extends StatefulWidget{
  Catalogs({ this.getCurrent });
  var getCurrent;

  @override
  State<Catalogs> createState() => _CatalogsState();
}

class _CatalogsState extends State<Catalogs> {
  var images = ["images/free-icon-chicken-6334078.png",
                'images/free-icon-salad-4916600.png',
                'images/free-icon-nachos-541694.png',
                'images/free-icon-soup-6978177.png',
                'images/free-icon-apple-pie-2804554.png',
                'images/free-icon-cake-703107.png',
                'images/free-icon-soft-drinks-2600497.png'
                ];

  handleCurrent(url){
    Provider.of<Current_list_store>(context, listen: false).set_loading(true);
    widget.getCurrent(url);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Catalog_store>(
      builder: (context, catalog, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: catalog.offset ? 0 :180,
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              itemCount: catalog.catalogs.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return index < 7 ? Ink(
                  child: InkWell(
                    onTap: (){ handleCurrent(catalog.catalogs[index]['link']); },
                    child: Container(

                      width: 190,
                      clipBehavior: Clip.hardEdge,
                      decoration:  BoxDecoration(
                        color:  Colors.grey.shade200,
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(width: 1, color: Colors.grey.shade300),

                      ),
                      margin: const EdgeInsets.only(left: 6, right: 6, top: 12),
                      padding: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(images[index], height: 80),
                          Text(catalog.catalogs[index]['title'], style: catalog_style)
                        ],
                      ),
                    ),
                  ),
                ) : const SizedBox();
              }
          ),
        );
      }
    );
  }
}