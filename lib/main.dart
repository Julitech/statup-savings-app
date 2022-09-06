import 'package:flutter/material.dart';
import '/screens/login_pin.dart';
import '/screens/onboarding/onboarding_one.dart';
import '/screens/tab_in.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Notif received ${message.messageId}');
}

void main() async {
  await Hive.initFlutter();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await Hive.openBox("statup");

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
    if (GetPlatform.isIOS) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'StatUp',
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            primarySwatch: Colors.blue,

            //   scaffoldBackgroundColor: Colors.transparent,
            appBarTheme: const AppBarTheme(
              color: Colors.transparent,
              elevation: 0,
            ),
          ),
          home:
              loggedIn == null ? const OnboardingOne() : const PinLoginScreen(),
        );
      },
      //child: const HomePage(title: 'First Method'),
    );

    /*GetMaterialApp(
      //for navigation dont forget to use GetMaterialApp
      title: 'StatUp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: loggedIn == null ? const OnboardingOne() : const PinLoginScreen(),
    );*/

    //const Login();
  }
}
