import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tp2/composants/cardTache.dart';
import 'package:tp2/page/ajout_tache.dart';
import 'package:tp2/page/signin.dart';
import 'package:tp2/services/auth-service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection('Tache').snapshots();
  Service authClass = Service();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1040CC),
      appBar: AppBar(
        backgroundColor: Color(0xff1040CC),
        title: Text(
          'Liste des taches',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('lib/images/herbidev.jpg'),
          ),
          SizedBox(
            height: 25,
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
                'Samedi 15 avril',
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
        backgroundColor: Color(0xff1040CC),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
              color: Colors.white,
            ),
            label: 'Accueil',
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
                      Color(0xff00aeef),
                      Color(0xff2d388a),
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
            icon: Icon(
              Icons.settings,
              size: 32,
              color: Colors.white,
            ),
            label: 'Réglages',
          ),
        ],
      ),
      body: StreamBuilder(
          stream: _stream,
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
                switch (tache['categorie']) {
                  case 'Divertissement':
                    icon = Icons.movie;
                    couleurIcon = Color(0xff35DA00);
                    break;
                  case 'Travail':
                    icon = Icons.business;
                    couleurIcon = Color(0xffFB6E72);
                    break;

                  case 'Etude':
                    icon = Icons.school;
                    couleurIcon = Color(0xffEE973A);
                    break;

                  case 'Famille':
                    icon = Icons.people;
                    couleurIcon = Color(0xff56D0DE);
                    break;

                  default:
                    icon = Icons.task;
                    couleurIcon = Color(0xffffffff);
                    break;
                }
                return CardTache(
                  libelleTache: tache['libelle'],
                  heure: '07h25',
                  icon: icon,
                  couleurIcon: Colors.white,
                  bgIcon: couleurIcon,
                  coche: false,
                );
              },
            );
          }),
    );
  }
}
