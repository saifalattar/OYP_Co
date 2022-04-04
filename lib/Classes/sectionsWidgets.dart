// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';
import 'dart:ui';

import 'package:OYP/cubit/bloc.dart';
import 'package:OYP/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SectionWidget {
  String title = "";

  SectionWidget({String this.title = "---"}) {}

  GestureDetector show(void Function() onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 220,
        margin: EdgeInsets.all(20),
        height: 200,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            ClipRRect(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: Container(child: Image.asset("oyp/worldMAp.jpg")),
                ),
                borderRadius: BorderRadius.circular(20.0)),
            Text(
              this.title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            )
          ],
        ),
      ),
    );
  }
}

List<Program> programs = [];

class FullScreen extends StatefulWidget {
  String title = "";
  String Collection = '';
  FullScreen({Key? key, this.title = "", this.Collection = ""})
      : super(key: key);

  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OYP(),
      child: BlocConsumer<OYP, states>(
          builder: (context, state) {
            OYP.GET(context).getApps(widget.Collection, context);
            return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    widget.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 36),
                  ),
                  backgroundColor: Colors.black,
                ),
                body: ListView.separated(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width -
                            (MediaQuery.of(context).size.width - 15)),
                    itemBuilder: (context, index) {
                      return programs[index];
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 35,
                      );
                    },
                    itemCount: programs.length));
          },
          listener: (context, state) {}),
    );
  }
}

class Program extends StatefulWidget {
  String name;
  String Description;
  int Likes;
  List<String> images;
  String mainImage;
  double price;
  void Function() onTap;
  void likeFunction;
  String collection, doc;

  Program(
      {Key? key,
      this.name = "no name",
      this.Description = "no description",
      this.Likes = 0,
      this.images = const [],
      this.mainImage = "",
      required this.onTap,
      this.collection = "",
      this.doc = "",
      this.price = 0.0})
      : super(key: key);

  @override
  _ProgramState createState() => _ProgramState();
}

class _ProgramState extends State<Program> {
  // دي هتكون شكل البروجرتم من بره
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OYP(),
      child: BlocConsumer<OYP, states>(
          builder: (context, state) {
            return GestureDetector(
              onTap: widget.onTap,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        width: 1.5, color: Colors.white.withOpacity(0.7)),
                    color: Colors.black,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                          child: ClipRRect(
                        child: Image.network(
                          widget.mainImage,
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(19)),
                      )),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  widget.name,
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "${widget.Description}",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.7)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.favorite_border_outlined,
                                  color: Colors.red[900],
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  "${widget.Likes}",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.6)),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          listener: (context, state) {}),
    );
  }
}

class FullProgramScreen extends StatefulWidget {
  String name;
  String Description;
  int Likes;
  List<String> images;
  double price;
  String collection, doc;

  FullProgramScreen(
      {Key? key,
      this.name = "no name",
      this.Description = "no description",
      this.collection = "",
      this.doc = "",
      this.Likes = 0,
      this.images = const [],
      this.price = 0.0})
      : super(key: key);

  @override
  _FullProgramScreenState createState() => _FullProgramScreenState();
}

int value = 1;
bool isFav = false;
String getCurrency(int value) {
  switch (value) {
    case 1:
      return "USD";
    case 2:
      return "EUR";
    default:
      return "EGP";
  }
}

class _FullProgramScreenState extends State<FullProgramScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => OYP(),
        child: BlocConsumer<OYP, states>(
            builder: (context, state) {
              void getBOOL() async {
                var usrlike = await OYP.GET(context).userLikes;
                if (usrlike.getBool(
                            "${FirebaseAuth.instance.currentUser?.uid}" +
                                "${widget.doc}") ==
                        false ||
                    usrlike.getBool(
                            "${FirebaseAuth.instance.currentUser?.uid}" +
                                "${widget.doc}") ==
                        null) {
                  setState(() {
                    isFav = false;
                  });
                } else {
                  setState(() {
                    isFav = true;
                  });
                }
              }

              getBOOL();
              return Scaffold(
                  appBar: AppBar(),
                  body: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.Description,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 25),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    var usrlike =
                                        await OYP.GET(context).userLikes;

                                    if (usrlike.getBool(
                                                "${FirebaseAuth.instance.currentUser?.uid}" +
                                                    "${widget.doc}") ==
                                            false ||
                                        usrlike.getBool(
                                                "${FirebaseAuth.instance.currentUser?.uid}" +
                                                    "${widget.doc}") ==
                                            null) {
                                      await OYP
                                          .GET(context)
                                          .likeFunction(widget.collection,
                                              widget.doc, true)
                                          .then((value) async {
                                        usrlike
                                            .setBool(
                                                "${FirebaseAuth.instance.currentUser?.uid}" +
                                                    "${widget.doc}",
                                                true)
                                            .then((value) => isFav = true);
                                        OYP.GET(context).getApps(
                                            widget.collection, context);
                                        widget.Likes += 1;
                                        OYP.GET(context).emit(LikeState());
                                      });
                                    } else {
                                      await OYP
                                          .GET(context)
                                          .likeFunction(widget.collection,
                                              widget.doc, false)
                                          .then((value) async {
                                        usrlike
                                            .setBool(
                                                "${FirebaseAuth.instance.currentUser?.uid}" +
                                                    "${widget.doc}",
                                                false)
                                            .then((value) => isFav = false);
                                        OYP.GET(context).getApps(
                                            widget.collection, context);
                                        widget.Likes -= 1;
                                        OYP.GET(context).emit(LikeState());
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
                                    color: Colors.red,
                                  )),
                              Text(
                                "${widget.Likes}",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UsePaypal(
                                                sandboxMode: true,
                                                clientId:
                                                    "AW1TdvpSGbIM5iP4HJNI5TyTmwpY9Gv9dYw8_8yW5lYIbCqf326vrkrp0ce9TAqjEGMHiV3OqJM_aRT0",
                                                secretKey:
                                                    "EHHtTDjnmTZATYBPiGzZC_AZUfMpMAzj2VZUeqlFUrRJA_C0pQNCxDccB5qoRQSEdcOnnKQhycuOWdP9",
                                                returnURL:
                                                    "https://samplesite.com/return",
                                                cancelURL:
                                                    "https://samplesite.com/cancel",
                                                transactions: [
                                                  {
                                                    "amount": {
                                                      "total":
                                                          "${widget.price}",
                                                      "currency":
                                                          getCurrency(value),
                                                      "details": {
                                                        "subtotal":
                                                            "${widget.price}",
                                                        "shipping": '0',
                                                        "shipping_discount": 0
                                                      }
                                                    },
                                                    "description":
                                                        "A payment for OYP to order ${widget.doc} program",
                                                    // "payment_options": {
                                                    //   "allowed_payment_method":
                                                    //       "INSTANT_FUNDING_SOURCE"
                                                    // },
                                                    "item_list": {
                                                      "items": [
                                                        {
                                                          "name":
                                                              "${widget.doc} program",
                                                          "quantity": 1,
                                                          "price":
                                                              '${widget.price}',
                                                          "currency":
                                                              getCurrency(value)
                                                        }
                                                      ]
                                                    }
                                                  }
                                                ],
                                                note:
                                                    "Contact us for any questions on your order.",
                                                onSuccess: (Map params) async {
                                                  print("onSuccess: $params");
                                                },
                                                onError: (error) {
                                                  print("onError: $error");
                                                },
                                                onCancel: (params) {
                                                  print('cancelled: $params');
                                                })));
                                  },
                                  child: const Text(
                                    "Order only APK + Source Code",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  )),
                              DropdownButton<dynamic>(
                                value: value,
                                items: [
                                  DropdownMenuItem(
                                      value: 1,
                                      onTap: () {
                                        setState(() {
                                          value = 1;
                                        });
                                      },
                                      child: Text(
                                        "${(widget.price).floor()}  \$",
                                        style: TextStyle(
                                            color: Colors.blueGrey[200],
                                            fontSize: 18),
                                      )),
                                  DropdownMenuItem(
                                      value: 2,
                                      onTap: () {
                                        setState(() {
                                          value = 2;
                                        });
                                      },
                                      child: Text(
                                        "${(widget.price * 0.88).floor()}  €",
                                        style: TextStyle(
                                            color: Colors.blueGrey[200],
                                            fontSize: 18),
                                      )),
                                  DropdownMenuItem(
                                      value: 3,
                                      onTap: () {
                                        setState(() {
                                          value = 2;
                                        });
                                      },
                                      child: Text(
                                        "${(widget.price * 15.71).floor()}  EGP",
                                        style: TextStyle(
                                            color: Colors.blueGrey[200],
                                            fontSize: 18),
                                      )),
                                ],
                                onChanged: (valuee) {
                                  setState(() {
                                    value = valuee;
                                    print(value);
                                  });
                                },
                                dropdownColor: Colors.grey[900],
                                elevation: 24,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ));
            },
            listener: (context, state) {}));
  }
}
