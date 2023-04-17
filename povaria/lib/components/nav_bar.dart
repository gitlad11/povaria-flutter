import 'package:flutter/material.dart';
import 'package:povaria/styles/catalog.dart';

class Navbar extends StatefulWidget{
  Navbar({ this.title, this.btns });
  var title;
  var btns;

  @override
  State<Navbar> createState() => _Navbar_state();
}

class _Navbar_state extends State<Navbar> {
    @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 6,bottom: 10),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title, style: navbar_title_style),
          widget.btns
        ],
      ),
    );
  }
}
