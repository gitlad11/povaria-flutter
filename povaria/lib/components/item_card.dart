import 'package:flutter/material.dart';

import '../styles/current.dart';

class Card_item extends StatefulWidget{
  Card_item({ this.title, this.image, this.time, this.rate });
  late var title;
  late var image;
  late var time;
  late var rate;

  @override
  State<Card_item> createState() => _Card_itemState();
}

class _Card_itemState extends State<Card_item> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color:  Colors.grey.shade200,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(width: 1, color: Colors.blueGrey.shade100),
      ),
      height: 110,
      child: Row(
        children: [
          Container(
              width: MediaQuery.of(context).size.width / 2 - 30,
              child: Image.network(widget.image,
                fit: BoxFit.fill,)
          ),
          Container(
              width: MediaQuery.of(context).size.width / 2 - 5,
              padding: const EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.title, style: item_style, textAlign: TextAlign.center),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.time != null ? Row(
                          children: [
                            const Icon(
                              Icons.timelapse,
                              color: Colors.black54,
                              size: 26,
                            ),
                            const SizedBox(width: 5),
                            Text(widget.time, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                          ],
                        ) : const SizedBox(),
                        widget.rate != null ? Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.black54,
                              size: 26,
                            ),
                            Text(widget.rate, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                          ],
                        ) : const SizedBox()
                      ],
                    ),
                  )
                ],
              )
          )
        ],
      ),
    );
  }
}