import 'package:OYP/Auth/Signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:OYP/Auth/Login.dart';
import 'package:OYP/mainScreens/home.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: AppBarTheme(color: Colors.transparent),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
            ))),
        home: FirebaseAuth.instance.currentUser != null
            ? FirebaseAuth.instance.currentUser!.emailVerified
                ? Home()
                : LogIn()
            : LogIn()));
  });
}
