import 'package:flutter/material.dart';

class TexteArea extends StatelessWidget {
  final String hintText;
  final controlleur;
  late  String? note;

  TexteArea({required this.note, super.key, required this.hintText, required this.controlleur});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: controlleur,
        onChanged: (value) {
            note = value;
        },
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
        ),
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
