


import 'package:flutter/material.dart';

// ✅ CORRECTION : Utilisation de l'importation par package pour plus de robustesse.
// Elle suppose que votre projet s'appelle 'travel_app'.
import 'package:travel_app/screens/root_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Travel App',
      // ➡️ RootScreen() est maintenant correctement importé
      home: const RootScreen(),
    );
  }
}