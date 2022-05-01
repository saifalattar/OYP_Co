import 'package:OYP/Auth/Signup.dart';
import 'package:OYP/Auth/forgotPassword%20and%20Verify/changePassword.dart';
import 'package:OYP/Auth/forgotPassword%20and%20Verify/verifyEmail.dart';
import 'package:OYP/cubit/bloc.dart';
import 'package:OYP/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

//to confirm if the OTP the user gets is validate or not

class ValidateOTP extends StatefulWidget {
  const ValidateOTP({Key? key}) : super(key: key);

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
                body: Column(
                  children: [
                    Center(
                      child: Text("Confirm OTP"),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    PinCodeTextField(
                        appContext: context,
                        length: 6,
                        onChanged: (code) {
                          if (code.length == 6 &&
                              code.toString() == otp.toString()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChangePassword()));
                          }
                        })
                  ],
                ),
              );
            },
            listener: (context, states) {}));
  }
}
