import 'package:flutter/material.dart';
import 'package:intro_flutter/widget/card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, Hori ",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Welcome Back",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: null,
                          icon: Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    // 1 card
                    Cards(),
                    Cards(),
                    Cards(),
                    Cards(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
