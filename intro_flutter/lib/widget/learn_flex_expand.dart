import 'package:flutter/material.dart';

class LearnFlexExpand extends StatelessWidget {
  const LearnFlexExpand({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.red,
                child: Text(
                  "Hello sir, i would like to inform that i will never come again ",
                ),
              ), // 1/2 of the space
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.blue,
                child: Text(
                  "Hello ma'am, i hope you are good, i hqve one more question, what if i give the gift from",
                ),
              ), // 1/2 of the space
            ),
          ],
        ),
      ],
    );
  }
}
