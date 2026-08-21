import 'package:flutter/material.dart';

class ExpandPage extends StatelessWidget {
  const ExpandPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.grey[200],
                width: double.infinity,
                height: screenHeight * 0.4,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      "Welcome Back",
                      style: TextStyle(fontSize: 38, fontWeight: .bold),
                    ),
                    Text(
                      "you should sign in to app",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: .bold,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                // height: 200,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 40,
                  ),
                  child: Column(
                    children: [
                      // 1 field
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email",
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 14),
                      // 2 field
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Password",
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 14),
                      // 1 button
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Sign in",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, letterSpacing: 3),
                          ),
                        ),
                      ),
                      SizedBox(height: 14),

                      // 2 button
                      Row(
                        mainAxisAlignment: .spaceEvenly,
                        crossAxisAlignment: .center,
                        children: [
                          // 1 google
                          Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                "Google",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  letterSpacing: 3,
                                ),
                              ),
                            ),
                          ),
                          // 2 facebook
                          Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                "Facebook",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  letterSpacing: 3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
