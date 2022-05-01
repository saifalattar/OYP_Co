import 'package:OYP/cubit/bloc.dart';
import 'package:OYP/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// a class to let the user enters his new password and updates it

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => OYP(),
        child: BlocConsumer<OYP, states>(
            builder: (context, states) {
              return Scaffold();
            },
            listener: (context, states) {}));
  }
}
