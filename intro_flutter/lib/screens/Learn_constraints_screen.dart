import 'package:flutter/material.dart';

class LearnConstraintsScreen extends StatelessWidget {
  const LearnConstraintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learn Constraints')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 200,
                minHeight: 100,
                maxWidth: 300,
                maxHeight: 200,
              ),
              child: Container(
                color: Colors.blue,
                child: const Text(
                  'This is a constrained box hbfdgvn fbkgjb fg jl gf rgfdbssdijv fekdhirtjglmtirjg. gbf vijbdf',
                ),
              ),
            ),
            // It is crash when the child is bigger than the constraints, so we can use OverflowBox to avoid crash
            UnconstrainedBox(
              child: Container(
                width: 200, // No restriction!
                height: 100,
                color: Colors.orange,
              ),
            ),
            // Now for overflowing child, we can use OverflowBox to avoid crash
            // OverflowBox: similar, but silences overflow warnings
            // OverflowBox(
            //   maxWidth: 300,
            //   child: Container(
            //     width: 200, // No restriction!
            //     height: 100,
            //     color: Colors.orange,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
