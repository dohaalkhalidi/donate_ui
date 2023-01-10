import 'package:donate/pages/home_screen.dart';
import 'package:donate/pages/login.dart';
import 'package:donate/pages/sign_up.dart';
import 'package:donate/pages/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder:(context,snapshot){
          User? userData = snapshot.data as User?;
          if(userData != null){
            return const HomeScreen();
          }else{
            return const Welcome();
          }

        }
      ),

      routes: {
        '/welcome': (context) => const Welcome(),
        "/login": (context) => const LoginForm(),
        "/signup": (context) => const SignUp(),
        // "/donatet": (context) => const Donatet(),
      },
    );
  }
}
