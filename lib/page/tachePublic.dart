import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tp2/composants/cardTache.dart';
import 'package:tp2/page/ajout_tache.dart';
import 'package:tp2/page/home.dart';
import 'package:tp2/page/signin.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:tp2/page/tacheDetails.dart';
import 'package:tp2/services/auth-service.dart';

import '../main.dart';

class TachePublic extends StatefulWidget {
  const TachePublic({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<TachePublic> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection('Tache').snapshots();
  List<Selectionner> selectionne = [];
  Service authClass = Service();
  DateTime jour = DateTime.now();
  String etat = 'en cours';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Taches publiques',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(MyApp.themeNotifier.value == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode),
              onPressed: () {
                MyApp.themeNotifier.value =
                    MyApp.themeNotifier.value == ThemeMode.light
                        ? ThemeMode.dark
                        : ThemeMode.light;
              }),
          SizedBox(
            height: 22,
          ),
          IconButton(
              onPressed: () async {
                await authClass.logOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => Login()),
                    (route) => false);
              },
              icon: Icon(
                Icons.logout,
              ))
        ],
        bottom: PreferredSize(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Text(
                DateFormat('dd/MM/yyyy').format(jour),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(34),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => HomePage()));
              },
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 239, 0, 119),
                      Color.fromARGB(255, 94, 3, 180),
                    ])),
                child: Icon(
                  Icons.person_3_sharp,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
            label: 'Private',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => PageAjout()));
              },
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 239, 0, 119),
                      Color.fromARGB(255, 94, 3, 180),
                    ])),
                child: Icon(
                  Icons.add,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
            label: 'Ajout',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => TachePublic()));
              },
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 239, 0, 119),
                      Color.fromARGB(255, 94, 3, 180),
                    ])),
                child: Icon(
                  Icons.people,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
            label: 'public',
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Tache')
              .where('categorie', isEqualTo: 'Publique')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> tache =
                    snapshot.data?.docs[index].data() as Map<String, dynamic>;
                IconData icon;
                Color couleurIcon;

                // if (tache['date_debut'] > DateTime.now()) {
                //   etat = 'En attente';
                // }
                // if (tache['date_debut'] < DateTime.now() &&
                //     tache['date_fin'] > DateTime.now()) {
                //   etat = 'En cours';
                // }

                switch (tache['categorie']) {
                  case 'Privée':
                    icon = Icons.business;
                    couleurIcon = Color(0xff35DA00);
                    break;
                  case 'Publique':
                    icon = Icons.business;
                    couleurIcon = Color.fromARGB(255, 237, 0, 8);
                    break;

                  default:
                    icon = Icons.task;
                    couleurIcon = Color(0xffffffff);
                }
                selectionne.add(Selectionner(
                    id: snapshot.data!.docs[index].id, check: false));
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => TacheDetails(
                          tache: tache,
                          id: snapshot.data!.docs[index].id,
                        ),
                      ),
                    );
                  },
                  child: CardTache(
                    libelleTache: tache['libelle'],
                    etat: etat,
                    icon: icon,
                    couleurIcon: Colors.white,
                    bgIcon: couleurIcon,
                    coche: selectionne[index].check,
                    index: index,
                    changementEtat: changementEtat,
                  ),
                );
              },
            );
          }),
    );
  }

  void changementEtat(int index) {
    setState(() {
      selectionne[index].check = !selectionne[index].check;
    });
  }
}

class Selectionner {
  String id;
  bool check = false;
  Selectionner({required this.id, required this.check});
}
