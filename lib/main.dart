import 'package:autobuddy/auth/loginPage.dart';
import 'package:autobuddy/auth/signupPage.dart';
import 'package:autobuddy/firebase_options.dart';
import 'package:autobuddy/views/home_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AutoBuddy",
      debugShowCheckedModeBanner: false,
      home: SignUpPage(),
      routes: {HomePageView.routeName: (cntx) => const HomePageView()},
    );
  }
}
