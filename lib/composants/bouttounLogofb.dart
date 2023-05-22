import 'package:flutter/material.dart';

import '../services/auth-service.dart';

class Boutonfb extends StatelessWidget {
  final String imagePath;

  const Boutonfb({super.key, required this.imagePath});
  @override
  Widget build(BuildContext context) {
    Service authClass = Service();
    return InkWell(
      onTap: () {},
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
          imagePath,
          height: 40,
        ),
      ),
    );
  }
}
