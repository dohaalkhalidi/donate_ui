import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/images/slide3.jpg",
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Welcome",
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(
                height: 160,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/login");
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 175, 62, 71),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(
                      horizontal: 79,
                      vertical: 10,
                    ),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                  ),
                ),
                child: const Text(
                  "Log in",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(
                height: 17,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/signup");
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 175, 62, 71),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(
                      horizontal: 77,
                      vertical: 13,
                    ),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                  ),
                ),
                child: const Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color.fromARGB(255, 252, 250, 250),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
