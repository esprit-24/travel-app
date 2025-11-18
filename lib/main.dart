import 'package:flutter/material.dart';
import 'package:travel_app/screens/home_screen.dart';
import 'package:travel_app/screens/restaurants_screen.dart';
import 'package:travel_app/screens/voyages_screen.dart';
import 'package:travel_app/screens/voyages_screen.dart';

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
      home: TripsPage(),
    );
  }
}
