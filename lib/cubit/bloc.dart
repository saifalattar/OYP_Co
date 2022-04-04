import 'dart:math';

import 'package:OYP/Auth/Signup.dart';
import 'package:OYP/Classes/sectionsWidgets.dart';
import 'package:OYP/cubit/states.dart';
import 'package:OYP/mainScreens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OYP extends Cubit<states> {
  OYP() : super(initialState());

  static OYP GET(context) => BlocProvider.of(context);

  Future<void> ResetPassword(BuildContext context) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: resetPassword.text.trim())
        .then((value) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Check your email to create your new password",
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 16,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG);
    }).catchError((e) {
      switch (e.code) {
        case "user-not-found":
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Email address not exists"),
            backgroundColor: Colors.red,
          ));

        default:
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "There is something error or check your network connection and try again later",
            ),
            backgroundColor: Colors.red,
          ));
      }
    });
  }

  Future<void> createAccount(
      BuildContext context, String email, String password) async {
    var user = FirebaseAuth.instance;
    user
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      var userDatabase = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.uid);

      userDatabase.doc("Liked").set({});

      await user.currentUser!.sendEmailVerification().then((value) async {
        await Fluttertoast.showToast(
            msg: "Please check your Email address to verify your account",
            backgroundColor: Colors.grey[700]);
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignIn()));
      });
    }).catchError((e) async {
      print(e);
      print(user.currentUser?.emailVerified);
      if (user.currentUser!.emailVerified == false ||
          user.currentUser!.emailVerified == null) {
        Fluttertoast.showToast(
            msg: "Verification email sent \n Please verify Your email address",
            toastLength: Toast.LENGTH_LONG,
            fontSize: 17);
      } else {
        switch (e.code) {
          case "email-already-in-use":
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline),
                  SizedBox(width: 20),
                  Text("Email address already exists"),
                ],
              ),
              backgroundColor: Colors.red,
            ));
            break;
          case "weak-password":
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline),
                  SizedBox(width: 20),
                  Text(
                      "Weak password\nPassword must be more than 8 characters"),
                ],
              ),
              backgroundColor: Colors.red,
            ));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline),
                  SizedBox(width: 20),
                  Text(
                      "There is something error or check your network connection and try again later"),
                ],
              ),
              backgroundColor: Colors.red,
            ));
        }
      }
    });
  }

  Future<void> signIN(BuildContext context) async {
    var user = await FirebaseAuth.instance;
    user
        .signInWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim())
        .then((value) async {
      FirebaseAuth.instance.currentUser!.emailVerified
          ? Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => Home()), (route) => false)
          : Fluttertoast.showToast(msg: "Plaese verify you email");
      await FirebaseAuth.instance.currentUser?.reload();
    }).catchError((e) {
      switch (e.code) {
        case "user-not-found":
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline),
                SizedBox(
                  width: 20,
                ),
                Text("Email address not exists"),
              ],
            ),
            backgroundColor: Colors.red,
          ));
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "There is something error or check your network connection and try again later",
            ),
            backgroundColor: Colors.red,
          ));
      }
    });
  }

  Future<void> likeFunction(String collection, var element, bool isPlus) async {
    int likes = 0;
    var data = await FirebaseFirestore.instance
        .collection(collection)
        .doc(element)
        .get();

    data.data()?.forEach((key, value) {
      if (key == "likes") {
        likes = value;
      }
    });
    await FirebaseFirestore.instance.collection(collection).doc(element).set(
        {"likes": isPlus ? likes + 1 : likes - 1},
        SetOptions(merge: true)).then((value) async {
      isPlus
          ? await FirebaseFirestore.instance
              .collection(FirebaseAuth.instance.currentUser!.uid)
              .doc("Liked")
              .set({element: true}, SetOptions(merge: true))
          : await FirebaseFirestore.instance
              .collection(FirebaseAuth.instance.currentUser!.uid)
              .doc("Liked")
              .update({element: false});
    }).catchError((onError) => Fluttertoast.showToast(
        msg: "There is something error", backgroundColor: Colors.red));
  }

  Future<void> getApps(String collection, BuildContext context) async {
    var allApps = await FirebaseFirestore.instance.collection(collection).get();
    programs.clear();

    allApps.docs.forEach((element) {
      Program temp = Program(
          onTap: () async {
            isFav = false;
            value = 1;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FullProgramScreen(
                          name: element["title"],
                          collection: collection,
                          doc: element.id,
                          Likes: element["likes"],
                          price: element["price"],
                        )));
          },
          name: element["title"],
          price: element["price"],
          Likes: element["likes"],
          mainImage: element["mainImage"]);
      programs.add(temp);

      try {
        emit(GetApps());
      } catch (e) {
        return;
      }
    });
  }

  Future<bool> getLikedPrograms(String programName) async {
    var liked = await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc("Liked")
        .get();
    bool b = false;

    liked.data()?.forEach((key, value) {
      if (key == programName && value) {
        b = true;
      }
    });

    return b;
  }

  Future<SharedPreferences> userLikes = SharedPreferences.getInstance();

  List<Program> likedPrograms = [];
}
