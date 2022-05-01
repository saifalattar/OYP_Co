import 'package:OYP/Auth/Signup.dart';
import 'package:OYP/Classes/shared.dart';
import 'package:flutter/material.dart';
import 'package:OYP/Auth/Login.dart';
import 'package:OYP/mainScreens/home.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future isSignedIn() async {
  bool isSigned = false;
  SharedPreferences localData = await localDataBase;
  if (localData.getString('token') == null ||
      localData.getString('token')!.isEmpty) {
    return isSigned;
  } else {
    return !isSigned;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    runApp(MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      home: await isSignedIn() ? Home() : LogIn(),
    ));
  });
}
