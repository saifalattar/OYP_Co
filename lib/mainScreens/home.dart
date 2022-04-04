import 'package:OYP/Auth/Login.dart';
import 'package:OYP/Auth/Signup.dart';
import 'package:OYP/Classes/sectionsWidgets.dart';
import 'package:OYP/cubit/bloc.dart';
import 'package:OYP/cubit/states.dart';
import 'package:OYP/userSettings/likesPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => OYP(),
        child: BlocConsumer<OYP, states>(
            builder: (context, states) {
              return Scaffold(
                  appBar: AppBar(
                    actions: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LikePage()));
                          },
                          icon: Icon(Icons.favorite_border)),
                      IconButton(
                          onPressed: () async {
                            await FirebaseAuth.instance
                                .signOut()
                                .then((value) => Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LogIn()),
                                    (route) => false))
                                .catchError((onError) {
                              return const SnackBar(
                                content: Text("there is something error"),
                                backgroundColor: Colors.red,
                              );
                            });
                          },
                          icon: Icon(Icons.person))
                    ],
                    backgroundColor: Colors.black,
                    title: Image.asset(
                      "oyp/oyp black white.png",
                      width: 110,
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SectionWidget(title: "Mobile Apps").show(() {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return FullScreen(
                                    title: "Mobile Apps",
                                    Collection: "MobileApps",
                                  );
                                }));
                              }),
                              SectionWidget(title: "Console \n Applications")
                                  .show(() {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return FullScreen(
                                    title: "Console Applications",
                                    Collection: "ConsoleApps",
                                  );
                                }));
                              })
                            ],
                          ),
                        )
                      ],
                    ),
                  ));
            },
            listener: (context, states) {}));
  }
}
