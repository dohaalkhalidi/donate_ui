import 'package:checkout_screen_ui/checkout_page.dart';
import 'package:donate/pages/payment_screen.dart';
import 'package:donate/pages/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const routName = "/homeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  final moneyController = TextEditingController();

  @override
  void dispose() {
    moneyController.dispose();
    super.dispose();
  }


  Future<void> logOut() async {
    await _auth.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const Welcome()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 165, 5, 58),
        title: const Text(
          "Donate Screen",
        ),
        actions: [
          IconButton(
            onPressed: logOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 50,
              ),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: moneyController,
                decoration: const InputDecoration(
                  labelText: "Enter Number to donate",
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 165, 5, 58),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 165, 5, 58),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 165, 5, 58),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 165, 5, 58),
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 165, 5, 58),
                ),
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MyDemoPage(
                    money: int.parse(moneyController.text),
                  ),
                ),
              ),
              child: const Text("donate here "),
            ),
          ],
        ),
      ),
    );
  }
}
