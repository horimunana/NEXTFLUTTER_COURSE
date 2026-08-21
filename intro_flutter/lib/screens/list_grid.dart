import 'package:flutter/material.dart';

class ListGrid extends StatelessWidget {
  const ListGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("List Grid")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(child: Text("${index + 1}")),
                  title: Text("Item ${index + 1}"),
                  subtitle: Text("Subtitle ${index + 1}"),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemCount: 19,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.blue[100 * ((index % 8) + 1)],
                  child: Center(child: Text("Grid Item ${index + 1}")),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
