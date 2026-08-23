import 'package:flutter/material.dart';
import 'package:summer_shop/features/home/widget/product_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: .start,
              crossAxisAlignment: .start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Text(
                        "Hi, Munana",
                        style: TextStyle(fontSize: 28, fontWeight: .bold),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.shopping_cart),
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                // Search fields
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Search product, categories,...",
                    prefixIcon: Icon(Icons.search),
                  ),
                  onTap: () {
                    // context.push("/search");
                  },
                ),
                SizedBox(height: 12),
                Text(
                  "All Product",
                  style: TextStyle(fontSize: 18, fontWeight: .normal),
                ),
                SizedBox(height: 12),
                // Product Container card
                ProductWidget(),
                ProductWidget(),
                ProductWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
