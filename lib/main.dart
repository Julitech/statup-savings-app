import 'package:flutter/material.dart';
import 'package:statup/screens/login_pin.dart';
import 'package:statup/screens/onboarding/onboarding_one.dart';
import 'package:statup/screens/tab_in.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("statup");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Statup',
      theme: ThemeData(
        fontFamily: 'fontlero',
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Statup Savings & Goals'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? loggedIn = Hive.box("statup").get("access_token");

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      //for navigation dont forget to use GetMaterialApp
      title: 'StatUp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: loggedIn == null ? const OnboardingOne() : const PinLoginScreen(),
    );

    //const Login();
  }
}