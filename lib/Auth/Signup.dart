import 'package:OYP/Auth/forgotPassword%20and%20Verify/verifyEmail.dart';
import 'package:OYP/Classes/shared.dart';
import 'package:OYP/cubit/bloc.dart';
import 'package:OYP/cubit/states.dart';
import 'package:OYP/mainScreens/home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUP extends StatefulWidget {
  const SignUP({Key? key}) : super(key: key);

  @override
  _SignUPState createState() => _SignUPState();
}

var username = TextEditingController();
var email = TextEditingController();
var password = TextEditingController();
var resetPassword = TextEditingController();
var otp = TextEditingController();
String userOTP = "";

class _SignUPState extends State<SignUP> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => OYP(),
        child: BlocConsumer<OYP, states>(
            builder: (context, state) {
              return Scaffold(
                  extendBody: true,
                  body: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("oyp/signup.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: SingleChildScrollView(
                          child: Column(children: [
                            SizedBox(
                              height: 110,
                            ),
                            Text(
                              "Sign Up now \n and join ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),
                            ),
                            Container(
                              child: Image.asset("oyp/oyp gray.png"),
                              width: 100,
                            ),
                            SizedBox(
                              height: 100,
                            ),
                            TextFormField(
                                controller: username,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                    labelText: "Username",
                                    labelStyle: TextStyle(color: Colors.white),
                                    fillColor: Colors.grey[700],
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                                    focusColor: Colors.white,
                                    hoverColor: Colors.white)),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: email,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.white,
                                    ),
                                    labelText: "E-mail",
                                    labelStyle: TextStyle(color: Colors.white),
                                    fillColor: Colors.grey[700],
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.white,
                                    )),
                                    focusColor: Colors.white,
                                    hoverColor: Colors.white)),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                                style: TextStyle(color: Colors.white),
                                controller: password,
                                obscureText: true,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.password_rounded,
                                      color: Colors.white,
                                    ),
                                    labelStyle: TextStyle(color: Colors.white),
                                    labelText: "Password",
                                    filled: true,
                                    fillColor: Colors.grey[700],
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    focusColor: Colors.white,
                                    hoverColor: Colors.white)),
                            const SizedBox(
                              height: 50,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.6,
                              child: RaisedButton(
                                onPressed: () async {
                                  OYP.GET(context).signUp(context, email.text,
                                      password.text, username.text);
                                },
                                child: const Text("Create Your Account"),
                                color: Colors.grey[100],
                              ),
                            )
                          ]),
                        ),
                      )));
            },
            listener: (context, state) {}));
  }
}

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OYP(),
      child: BlocConsumer<OYP, states>(
          builder: (context, state) {
            return Scaffold(
                extendBody: true,
                body: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("oyp/signup.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          SizedBox(
                            height: 110,
                          ),
                          Text(
                            "Log In to your acount ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28),
                          ),
                          Container(
                            child: Image.asset("oyp/oyp gray.png"),
                            width: 100,
                          ),
                          SizedBox(
                            height: 100,
                          ),
                          TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: email,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                  labelText: "E-mail",
                                  labelStyle: TextStyle(color: Colors.white),
                                  fillColor: Colors.grey[700],
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.white,
                                  )),
                                  focusColor: Colors.white,
                                  hoverColor: Colors.white)),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                              style: TextStyle(color: Colors.white),
                              controller: password,
                              obscureText: true,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.password_rounded,
                                    color: Colors.white,
                                  ),
                                  labelStyle: TextStyle(color: Colors.white),
                                  labelText: "Password",
                                  filled: true,
                                  fillColor: Colors.grey[700],
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusColor: Colors.white,
                                  hoverColor: Colors.white)),
                          SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Verify(
                                              title: "Forgot Password",
                                              onPressed: OYP
                                                  .GET(context)
                                                  .forgotPassword(context,
                                                      resetPassword.text),
                                              buttonTitle:
                                                  "Send email with OTP",
                                            )));
                              },
                              child: Text("Forgot your password ?",
                                  style: TextStyle(
                                      color: Colors.grey[300],
                                      decoration: TextDecoration.underline))),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.6,
                            child: RaisedButton(
                              onPressed: () async {
                                OYP
                                    .GET(context)
                                    .logIn(context, email.text, password.text);
                              },
                              child: Text("Log In"),
                              color: Colors.grey[100],
                            ),
                          )
                        ]),
                      ),
                    )));
          },
          listener: (context, state) {}),
    );
  }
}
