// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donate/pages/home_screen.dart';
import 'package:donate/pages/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  static const routName = "/signUp";

  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool showPassword = false;
  final _fb = FirebaseFirestore.instance.collection('Users');

  final _auth = FirebaseAuth.instance;
  final _signUpKey = GlobalKey<FormState>();

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    emailController.dispose();

    super.dispose();
  }

  Future<void> _onSave() async {
    final name = userNameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    if (!_signUpKey.currentState!.validate()) {
      return;
    } else {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
            (value) => _fb.doc(value.user!.uid).set({
              "name": name,
              "email": email,
            }),
          );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => Welcome()),
          (route) => false,
        ),
        backgroundColor: Color.fromARGB(255, 240, 155, 180),
        child: Icon(Icons.home),
      ),
      appBar: AppBar(
        title: Text(
          "Sign up",
          style: TextStyle(
            fontSize: 30,
            fontFamily: "myfont",
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 165, 5, 58),
      ),
      body: Form(
        key: _signUpKey,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 240, 155, 180),
                  borderRadius: BorderRadius.circular(66),
                ),
                width: 266,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 165, 5, 58),
                    ),
                    hintText: "Username : ",
                    border: InputBorder.none,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter valid name';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 17,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 240, 155, 180),
                  borderRadius: BorderRadius.circular(66),
                ),
                width: 266,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 165, 5, 58),
                    ),
                    hintText: "Your Email :",
                    border: InputBorder.none,
                  ),
                  validator: (val) {
                    if (val == null || !val.contains('@')) {
                      return 'Please enter valid email';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 17,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 240, 155, 180),
                  borderRadius: BorderRadius.circular(66),
                ),
                width: 266,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: showPassword,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      style: ButtonStyle(
                        padding: null,
                      ),
                      icon: Icon(
                        Icons.visibility,
                        color: Color.fromARGB(255, 165, 5, 58),
                      ),
                      onPressed: () => setState(() {
                        showPassword = !showPassword;
                      }),
                    ),
                    icon: Icon(
                      Icons.lock,
                      color: Color.fromARGB(255, 165, 5, 58),
                      size: 19,
                    ),
                    hintText: "Password :",
                    border: InputBorder.none,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter valid password';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 17,
              ),
              ElevatedButton(
                onPressed: _onSave,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 165, 5, 58),
                  ),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 91, vertical: 10),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                  ),
                ),
                child: Text(
                  "Sign up",
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
