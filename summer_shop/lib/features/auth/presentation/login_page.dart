import 'package:flutter/material.dart';
import 'package:summer_shop/utils/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  String? email;
  String? password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .start,
            spacing: 4,
            children: [
              // Text(
              //   "Here to Get ",

              //   style: TextStyle(fontSize: 32, fontWeight: .bold),
              // ),
              Text(
                "Welcomed Back",

                style: TextStyle(fontSize: 32, fontWeight: .bold),
              ),
              SizedBox(height: 24),
              // TextFormField(
              //   initialValue: username,
              //   keyboardType: TextInputType.name,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(),
              //     labelText: "Enter username",
              //   ),
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       return "Username is required";
              //     }
              //     return null;
              //   },
              //   onSaved: (value) => username = value,
              // ),
              // SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter email",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Email is required";
                  }
                  return null;
                },
                onSaved: (value) => email = value,
              ),
              SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter password",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password is required";
                  }
                  return null;
                },
                onSaved: (value) => password = value,
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: .center,
                children: [
                  Text(
                    "Don't you have an account? Sign Up",
                    textAlign: TextAlign.center,

                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              SizedBox(height: 12),
              InkWell(
                onTap: () {
                  if (formkey.currentState!.validate()) {
                    formkey.currentState!.save();
                    debugPrint("$email, $password");
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  color: ThemeColor.primary,
                  child: Text("Sign In", textAlign: TextAlign.center),
                ),
              ),
              // ElevatedButton(onPressed: () {}, child: Text("Login")),
            ],
          ),
        ),
      ),
    );
  }
}
