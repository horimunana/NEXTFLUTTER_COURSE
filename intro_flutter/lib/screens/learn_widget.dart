import 'package:flutter/material.dart';
import 'package:intro_flutter/widget/all_tab.dart';
import 'package:intro_flutter/widget/drawer_side_page.dart';
import 'package:intro_flutter/widget/learn_flex_expand.dart';

class LearnWidget extends StatelessWidget {
  const LearnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Learn Text"),
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: "All"),
              Tab(text: "Favorites"),
              Tab(text: "Learn flex,expa"),
            ],
          ),
        ),
        drawer: DrawerSidePage(),
        body: SafeArea(
          child: TabBarView(
            children: [
              AllTab(),
              Center(child: Text("Favorites")),
              LearnFlexExpand(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Business',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.school), label: 'School'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
