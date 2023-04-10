import 'package:async/async.dart';
import 'package:flutter/material.dart';


class Input extends StatefulWidget{
  Input({required this.getSearch});
  String text = '';
  Function getSearch;

  @override
  Input_state createState() => Input_state();
}

class Input_state extends State<Input>{
  bool show = false;
  String validate = '';
  /// var controller = TextEditingController();

  ///@override
  ///void dispose() {
  ///удаляет прототип контроллера когда данный виджет unmounted
  ///controller.dispose();
  ///super.dispose();
  ///}

  @override
  Widget build(BuildContext context) {

    return TextFieldContainer(
      validate: validate,
      child :  TextFormField(
        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
        onChanged: (value){ setState(() {
          widget.text = value;
        });
        },
        validator: (String? value){},
        cursorColor: Colors.blueGrey,
        decoration: InputDecoration(
          hintText: widget.text,
          suffixIcon: GestureDetector(
            onTap: (){ widget.getSearch(widget.text); },
            child: const Icon(
              Icons.search,
              color: Colors.blueGrey,
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}


class TextFieldContainer extends StatelessWidget {
  final Widget child;
  String validate;
  TextFieldContainer({
    required this.child,
    required this.validate
  }) : super();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 10, right: 10),
          padding: const EdgeInsets.only(left: 6),
          width: size.width ,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(29),
          ),
          child: child,
        ),
      ],
    );
  }
}