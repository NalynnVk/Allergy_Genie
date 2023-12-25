import 'package:allergygenieapi/log_in.dart';
import 'package:allergygenieapi/screens/default/landing.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Start Page
class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Allergy Genie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black54,
        highlightColor: const Color.fromARGB(255, 46, 0, 125),
        fontFamily: 'Roboto',
      ),
      home: const LandingScreen(),
    );
  }
}
 