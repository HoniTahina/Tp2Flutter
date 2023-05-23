import 'package:flutter/material.dart';
import 'package:tp2/page/tacheDetails.dart';

class ChampDeTexte extends StatelessWidget {
  final String hintText;
  final controlleur;
  late  String? note;

  ChampDeTexte({required this.note, super.key, required this.hintText, required this.controlleur});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
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
          fontSize: 20,
        ),
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
