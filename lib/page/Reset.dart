import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tp2/composants/resetBouton.dart';

import '../composants/champDeSaisie.dart';

class Reset extends StatefulWidget {
  const Reset({super.key});

  @override
  State<Reset> createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  final utilisateurControlleur = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color.fromARGB(255, 28, 64, 115),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Text(
              "Réinitialiser le mot de passe",
              style: TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 100,
            ),
            champDeSaisie(
              hintText: 'Votre Email',
              controlleur: utilisateurControlleur,
              obscureText: false,
            ),
            SizedBox(height: 50),
            ResetBoutton(onTap: () {
              FirebaseAuth.instance
                  .sendPasswordResetEmail(email: utilisateurControlleur.text)
                  .then((value) => Navigator.of(context).pop());
            }),
            SizedBox(
              height: 50,
            ),
            Text(
              "Copyright@Groupe7",
              style: TextStyle(
                  fontSize: 12,
                  color: const Color.fromARGB(255, 255, 255, 255)),
            )
          ],
        ),
      )),
    );
  }
}
