import 'package:OYP/Auth/Signup.dart';
import 'package:OYP/Auth/forgotPassword%20and%20Verify/changePassword.dart';
import 'package:OYP/Auth/forgotPassword%20and%20Verify/verifyEmail.dart';
import 'package:OYP/Classes/shared.dart';
import 'package:OYP/cubit/bloc.dart';
import 'package:OYP/cubit/states.dart';
import 'package:OYP/mainScreens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

//to confirm if the OTP the user gets is validate or not

class ValidateOTP extends StatefulWidget {
  final bool isForgot;
  ValidateOTP({Key? key, required this.isForgot}) : super(key: key);

  @override
  State<ValidateOTP> createState() => _ValidateOTPState();
}

class _ValidateOTPState extends State<ValidateOTP> {
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
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_ios)),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: Text(
                            "Confirm OTP",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "Check your email \" ${widget.isForgot ? resetPassword.text : email.text} \" fot the OTP to login , if you didn't receive any mails ",
                          style: TextStyle(
                            color: Colors.grey[200],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                            onPressed: () {
                              widget.isForgot
                                  ? OYP.GET(context).forgotPassword(
                                      context, resetPassword.text)
                                  : OYP.GET(context).verifyUser(
                                      context, email.text, password.text);
                            },
                            child: Text("resend email")),
                        SizedBox(
                          height: 50,
                        ),
                        PinCodeTextField(
                            appContext: context,
                            length: 6,
                            textStyle: TextStyle(color: Colors.white),
                            onChanged: (code) {
                              if (code.length == 6 &&
                                  code.toString() == userOTP.toString()) {
                                widget.isForgot
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChangePassword()))
                                    : OYP.GET(context).signUp(
                                        context,
                                        email.text,
                                        password.text,
                                        username.text);
                              } else if (code.length == 6 &&
                                  code.toString() != userOTP.toString()) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Invalid OTP"),
                                  backgroundColor: Colors.red,
                                ));
                              }
                            })
                      ],
                    ),
                  ),
                ),
              );
            },
            listener: (context, states) {}));
  }
}
