import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:learn_flower/pages/Flower/addFlower.dart';

import 'package:learn_flower/splash_screen.dart';
// import 'package:my_garden_app/view.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:learn_flower/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Garden',
      home: Splash(),
    );
  }
}
