import 'dart:math';

import 'package:OYP/Auth/Login.dart';
import 'package:OYP/Auth/Signup.dart';
import 'package:OYP/Auth/forgotPassword%20and%20Verify/verifyEmail.dart';
import 'package:OYP/Auth/forgotPassword%20and%20Verify/validateOTP.dart';
import 'package:OYP/Classes/schemas.dart';
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
      userToken = value.data['token'].toString();
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
      userOTP = value.data['otp'];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ValidateOTP(
                    isForgot: true,
                  )));
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${onError.response.data['failure']}"),
        backgroundColor: Colors.red,
      ));
    });
  }

  void verifyUser(context, String email, String password) async {
    await Dio().post("$BASE_URL/verifyuser",
        data: {"email": email, "password": password}).then((value) {
      userOTP = value.data['otp'];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ValidateOTP(
                    isForgot: false,
                  )));
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${onError.response.data['failure']}"),
        backgroundColor: Colors.red,
      ));
    });
  }

  void changePassword(context, String newPassword) async {
    await Dio().put("$BASE_URL/forgotpassword/changepassword", data: {
      "email": resetPassword.text,
      "password": newPassword
    }).then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignIn()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(Icons.done),
            SizedBox(
              width: 20,
            ),
            Text("Password updated successfully"),
          ],
        ),
        backgroundColor: Colors.green,
      ));
    });
  }

  Future<List> getAllApps(String token, String document) async {
    switch (document) {
      case "console":
        if (programs.isEmpty) {
          await Dio()
              .get("$BASE_URL/oyp/allApps/$document/$token")
              .then((value) {
            value.data.forEach((app) {
              programs.add(app);
            });
          });
        }
        return programs;
      case "apps":
        if (apps.isEmpty) {
          await Dio()
              .get("$BASE_URL/oyp/allApps/$document/$token")
              .then((value) {
            value.data.forEach((app) {
              apps.add(app);
            });
          });
        }
        return apps;
      default:
        if (designs.isEmpty) {
          await Dio()
              .get("$BASE_URL/oyp/allApps/$document/$token")
              .then((value) {
            value.data.forEach((app) {
              designs.add(app);
            });
          });
        }
        return designs;
    }
  }

  Future getDesigns(String token) async {
    designs.clear();
    await Dio().get("$BASE_URL/oyp/allApps/designs/$token").then((value) {
      value.data.forEach((app) {
        designs.add(
            Design(app["image"], app["title"], app["artist"], app["link"]));
      });
    });
    return designs;
  }

  Future likeApp(String category, String appId, int likes, bool isAdd) async {
    await Dio().put("$BASE_URL/oyp/$category/$appId",
        data: {"likes": likes, "add": isAdd}).then((value) {
      return value.data;
    });
  }
}
