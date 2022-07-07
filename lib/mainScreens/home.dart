import 'package:OYP/Auth/Login.dart';
import 'package:OYP/Auth/Signup.dart';
import 'package:OYP/Classes/designsPage.dart';
import 'package:OYP/Classes/sectionsWidgets.dart';
import 'package:OYP/Classes/shared.dart';
import 'package:OYP/cubit/bloc.dart';
import 'package:OYP/cubit/states.dart';
import 'package:OYP/userSettings/likesPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    print(userToken);
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
                          onPressed: () => OYP.GET(context).signOut(context),
                          icon: Icon(Icons.person))
                    ],
                    backgroundColor: Colors.black,
                    title: Image.asset(
                      "iyp/IYP.png",
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
                              SectionWidget(image: "iyp/iyp apps b.png")
                                  .show(() {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return FullScreen(
                                    title: "Mobile apps",
                                    document: "apps",
                                  );
                                }));
                              }),
                              SectionWidget(image: "iyp/iyp programs b.png")
                                  .show(() {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return FullScreen(
                                    document: "console",
                                    title: "Console Applications",
                                  );
                                }));
                              }),
                              SectionWidget(image: "iyp/iyp designs b.png")
                                  .show(() {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return DesignPage();
                                }));
                              })
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
            },
            listener: (context, states) {}));
  }
}
