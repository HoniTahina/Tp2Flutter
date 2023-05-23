import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../services/auth-service.dart';

class Boutonfb extends StatefulWidget {
  final String imagePath;
  Boutonfb({super.key, required this.imagePath});

  @override
  State<Boutonfb> createState() => _BoutonfbState();
}

class _BoutonfbState extends State<Boutonfb> {
  String userEmail = "";

  Future<UserCredential> _logInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance
        .login(permissions: ['email', 'public_profil', 'user_birthday']);

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    final userData = await FacebookAuth.instance.getUserData();
    userEmail = userData['email'];
    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  @override
  Widget build(BuildContext context) {
    Service authClass = Service();
    return InkWell(
      onTap: () {
        _logInWithFacebook();
        setState(() {});
      },
      child: Container(
        // ignore: prefer_const_constructors
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 26, 0, 255),
            ),
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[200]),
        child: Image.asset(
          widget.imagePath,
          height: 40,
        ),
      ),
    );
  }
}
