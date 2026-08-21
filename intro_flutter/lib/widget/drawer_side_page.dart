import 'package:flutter/material.dart';
import 'package:intro_flutter/screens/Learn_constraints_screen.dart';

class DrawerSidePage extends StatelessWidget {
  const DrawerSidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text(' Learn constraints'),
            onTap: () {
              // Update the state of the app
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LearnConstraintsScreen(),
                ),
              );
              // Then close the drawer
              // Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
