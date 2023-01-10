import 'package:donate/pages/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home_screen.dart';

class LoginForm extends StatefulWidget {
  static const routName = "/login";

  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool showPassword = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final email = emailController.text;
    final password = passwordController.text;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      await _auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (value) {
          if (value.user != null) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              ),
              (route) => false,
            );
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 165, 5, 58),
        //  foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Log in",
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                Image.asset(
                  "assets/images/slide1.jpg",
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 240, 155, 180),
                    borderRadius: BorderRadius.circular(66),
                  ),
                  width: 266,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.person,
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
                const SizedBox(
                  height: 23,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 240, 155, 180),
                    borderRadius: BorderRadius.circular(66),
                  ),
                  width: 266,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: showPassword,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          showPassword = !showPassword;
                        }),
                        icon: const Icon(
                          Icons.visibility,
                          color: Color.fromARGB(255, 165, 5, 58),
                        ),
                      ),
                      icon: const Icon(
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
                const SizedBox(
                  height: 17,
                ),
                ElevatedButton(
                  onPressed: _onSave,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 165, 5, 58),
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(
                        horizontal: 106,
                        vertical: 10,
                      ),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: _onSave,
                    child: const Text(
                      "login",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 17,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const SignUp()),
                        (route) => false,
                      ),
                      child: const Text(
                        " Sign up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
