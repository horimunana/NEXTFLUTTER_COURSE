import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Summer Shop')),
      body: const Center(child: Text('Welcome to Summer Shop!')),
    );
  }
}
