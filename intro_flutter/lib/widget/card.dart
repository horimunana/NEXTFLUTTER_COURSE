import 'package:flutter/material.dart';

class Cards extends StatelessWidget {
  const Cards({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // color: Colors.blue,
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 79, 33, 243),
            Color.fromARGB(255, 211, 218, 70),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
    );
  }
}
