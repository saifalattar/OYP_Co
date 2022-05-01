import 'package:OYP/cubit/bloc.dart';
import 'package:OYP/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikePage extends StatefulWidget {
  const LikePage({Key? key}) : super(key: key);

  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OYP(),
      child: BlocConsumer<OYP, states>(
          builder: (context, state) {
            return Scaffold(appBar: AppBar(), body: Container());
          },
          listener: (context, state) {}),
    );
  }
}
