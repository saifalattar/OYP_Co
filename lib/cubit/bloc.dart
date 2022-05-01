import 'dart:math';

import 'package:OYP/Auth/Login.dart';
import 'package:OYP/Auth/Signup.dart';
import 'package:OYP/Auth/forgotPassword and Verify/forgotPass.dart';
import 'package:OYP/Auth/forgotPassword%20and%20Verify/validateOTP.dart';
import 'package:OYP/Classes/sectionsWidgets.dart';
import 'package:OYP/Classes/shared.dart';
import 'package:OYP/cubit/states.dart';
import 'package:OYP/mainScreens/home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

String BASE_URL = "http://192.168.1.15:8000";

class OYP extends Cubit<states> {
  OYP() : super(initialState());

  static OYP GET(context) => BlocProvider.of(context);

  Future<void> signUp(
      context, String email, String password, String name) async {
    var data = await Dio().post("$BASE_URL/signup", data: {
      "email": email,
      "password": password,
      "name": name
    }).then((value) async {
      SharedPreferences localData = await localDataBase;
      localData
          .setString("token", value.data['token'])
          .then((value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (route) => false))
          .catchError((onError) {
        return Fluttertoast.showToast(
            msg: "${onError.data["failure"]}", backgroundColor: Colors.red);
      });
    });
  }

  void logIn(context, String email, String password) async {
    await Dio().post("$BASE_URL/login", data: {
      "email": email,
      "password": password,
    }).then((value) async {
      SharedPreferences localData = await localDataBase;
      localData.setString("token", value.data['token']).then((value) =>
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (route) => false));
    }).catchError((onError) {
      return Fluttertoast.showToast(
          msg: "${onError.response.data['failure']}",
          backgroundColor: Colors.red);
    });
  }

  void signOut(context) async {
    SharedPreferences localData = await localDataBase;
    await localData.remove("token").then((value) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => LogIn())));
  }

  void forgotPassword(context, String email) async {
    await Dio().post("$BASE_URL/forgotpassword", data: {
      "email": email,
    }).then((value) {
      otp = value.data['otp'];
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ValidateOTP()));
    }).catchError((onError) {
      print(onError);
      Fluttertoast.showToast(msg: "${onError}", backgroundColor: Colors.red);
    });
  }
}
