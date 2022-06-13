import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:workoutlogger/pages/login_screen.dart';
import 'package:workoutlogger/pages/my_exercise.dart';
import 'package:workoutlogger/pages/preferences.dart';
import 'package:workoutlogger/pages/line_chart.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(
        title: "Log In",
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
