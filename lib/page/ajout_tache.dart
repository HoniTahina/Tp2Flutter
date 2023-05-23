// ignore_for_file: unused_element

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tp2/composants/button.dart';
import 'package:tp2/composants/champDate.dart';
import 'package:tp2/composants/chipBox.dart';
import 'package:tp2/composants/label.dart';
import 'package:tp2/composants/textfield.dart';
import 'package:tp2/composants/texteArea.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:http/http.dart' as http;

class PageAjout extends StatefulWidget {
  PageAjout({super.key});

  @override
  State<PageAjout> createState() => _PageAjoutState();
}

String? _dateFin;
String? _dateDebut;
String? tacheCategori;
String? _description;
String? _libelle;
String? tachePriorit;

Future<void> store() async {
  String url = 'http://10.0.2.2:8000/api/Ajouter';

  Map<String, dynamic> data = {
    'date_fin': _dateFin,
    'date_debut': _dateDebut,
    'categorie': tacheCategori,
    'description': _description,
    'libelle': _libelle,
    'priorite': tachePriorit
  };

  // Convert the data to JSON
  String jsonData = jsonEncode(data);

  // Set the headers
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // Send the POST request
  http.Response response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonData,
  );

  print(response);

  // Check the response status code
  if (response.statusCode == 200) {
    print('Data sent successfully.');
  } else {
    print('Error sending data. Status code: ${response.statusCode}');
  }
}

class _PageAjoutState extends State<PageAjout> {
  final _libelleControlleur = TextEditingController();
  final _dateDebutControl = TextEditingController();
  final _dateFinControl = TextEditingController();
  final _descriptionControlleur = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  String tachePriorite = "";
  String tacheCategorie = "";
  late DateTime dateD;
  late DateTime dateF;

  Future<void> _Ajouter() async {
    setState(() {
      _dateFin = _dateFinControl.text;
      _dateDebut = _dateDebutControl.text;
      tacheCategorie = tacheCategorie;
      _description = _descriptionControlleur.text;
      _libelle = _libelleControlleur.text;
      tachePriorite = tachePriorite;
    });

    await store();
    FirebaseFirestore.instance.collection('Tache').add({
      'id': firebaseAuth.currentUser!.uid,
      'date_fin': _dateFinControl.text,
      'date_debut': _dateDebutControl.text,
      'categorie': tacheCategorie,
      'description': _descriptionControlleur.text,
      'libelle': _libelleControlleur.text,
      'priorite': tachePriorite
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 45),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    CupertinoIcons.arrow_left,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                Text(
                  'Nouvelle tâche',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  label('Libellé'),
                  SizedBox(height: 15),
                  ChampDeTexte(
                    hintText: 'Libellé de la tâche',
                    controlleur: _libelleControlleur,
                    note: _libelle,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  label('Priorité'),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      priorite('Urgent', 0XffFF3336),
                      SizedBox(
                        width: 12,
                      ),
                      priorite('Important', 0xff2664fa),
                      SizedBox(
                        width: 12,
                      ),
                      priorite('Plannifié', 0xfff4127ae),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  label('Description'),
                  SizedBox(
                    height: 12,
                  ),
                  TexteArea(
                    hintText: 'Description',
                    controlleur: _descriptionControlleur, note: _description,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  label('Catégorie'),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      categorie('Privée', 0xff00FF00),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      categorie('Publique', 0Xffff6d6e),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(height: 15),
                  label('Date début'),
                  SizedBox(height: 15),
                  champDate(
                    hintText: 'dd/mm/yyyy',
                    dateControlleur: _dateDebutControl, note: _dateDebut,
                    // date: dateD,
                  ),
                  SizedBox(height: 15),
                  label('Date fin'),
                  SizedBox(height: 15),
                  champDate(
                    hintText: 'dd/mm/yyyy',
                    dateControlleur: _dateFinControl, note: _dateFin,
                    // date: dateF,
                  ),
                  SizedBox(height: 15),
                  buton(onTap: _Ajouter),
                  SizedBox(height: 15),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget priorite(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          tachePriorite = label;
          tachePriorit = label;
        });
      },
      child: Chip(
        backgroundColor: tachePriorite == label ? Colors.black : Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        label: Text(
          label,
          style: TextStyle(
            color: tachePriorite == label ? Colors.white : Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.8,
        ),
      ),
    );
  }

  Widget categorie(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          tacheCategorie = label;
          tacheCategori = label;
        });
      },
      child: Chip(
        backgroundColor: tacheCategorie == label ? Colors.black : Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        label: Text(
          label,
          style: TextStyle(
            color: tacheCategorie == label ? Colors.white : Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.8,
        ),
      ),
    );
  }
}
