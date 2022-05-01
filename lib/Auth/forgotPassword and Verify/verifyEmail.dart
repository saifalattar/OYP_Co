import 'package:OYP/Auth/Signup.dart';
import 'package:OYP/cubit/bloc.dart';
import 'package:OYP/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// a class to enter user email to wether verify account or forgot password

class Verify extends StatefulWidget {
  String? title;
  String? buttonTitle;
  void onPressed;
  Verify({Key? key, this.title, this.onPressed, this.buttonTitle})
      : super(key: key);

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => OYP(),
        child: BlocConsumer<OYP, states>(
            builder: (context, states) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                      )),
                ),
                body: Column(
                  children: [
                    Center(
                      child: Text(
                        "${widget.title}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                        style: TextStyle(color: Colors.white),
                        controller: resetPassword,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.password_rounded,
                              color: Colors.white,
                            ),
                            labelStyle: TextStyle(color: Colors.white),
                            labelText: "E-mail",
                            filled: true,
                            fillColor: Colors.grey[700],
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusColor: Colors.white,
                            hoverColor: Colors.white)),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (resetPassword.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Email field is empty"),
                            backgroundColor: Colors.red,
                          ));
                        } else {
                          widget.onPressed;
                        }
                      },
                      child: Text(
                        "${widget.buttonTitle}",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey[300]),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                    )
                  ],
                ),
              );
            },
            listener: (context, states) {}));
  }
}
