// ignore_for_file: non_constant_identifier_names
import 'dart:ui';
import 'package:OYP/Classes/schemas.dart';
import 'package:OYP/Classes/shared.dart';
import 'package:OYP/cubit/bloc.dart';
import 'package:OYP/cubit/states.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SectionWidget {
  String image = "";

  SectionWidget({String this.image = "---"}) {}

  GestureDetector show(void Function() onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 160,
        margin: EdgeInsets.all(20),
        height: 200,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            ClipRRect(
              child: Container(child: Image.asset("${this.image}")),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreen extends StatefulWidget {
  String title = "";
  String document = "";

  FullScreen({Key? key, this.title = "", required this.document})
      : super(key: key);

  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  @override
  Widget build(BuildContext context) {
    print(userToken);
    return BlocProvider(
      create: (context) => OYP(),
      child: BlocConsumer<OYP, states>(
          builder: (context, state) {
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
                body: FutureBuilder(
                    future: OYP
                        .GET(context)
                        .getAllApps(userToken.toString(), widget.document),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 20,
                                ),
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Program(
                                onTap: () async {
                                  await Dio()
                                      .get(
                                          "$BASE_URL/oyp/likes/${snapshot.data[index]["_id"]}/isliked")
                                      .then((value) {
                                    isFav = value.data as bool;

                                    Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                            transitionDuration: Duration(
                                                seconds: 1, milliseconds: 500),
                                            pageBuilder: (context, a1, a2) =>
                                                FullProgramScreen(
                                                    name: snapshot
                                                        .data[index]['name'],
                                                    appId:
                                                        snapshot.data[index]
                                                            ["_id"],
                                                    likes: snapshot.data[index]
                                                        ['likes'],
                                                    images: snapshot.data[index]
                                                        ['images'],
                                                    category: widget.document,
                                                    Description:
                                                        snapshot.data[index]
                                                            ['description'],
                                                    price: snapshot.data[index]
                                                        ['price'])));
                                  });
                                },
                                name: snapshot.data[index]['name'],
                                images: snapshot.data[index]['images'],
                                Description: snapshot.data[index]
                                    ['description'],
                                price: snapshot.data[index]['price'],
                              );
                            });
                      }
                    }));
          },
          listener: (context, state) {}),
    );
  }
}

class FullProgramScreen extends StatefulWidget {
  String name;
  String Description;
  List<dynamic> images;
  String category;
  String appId;
  double price;
  int likes;

  FullProgramScreen(
      {Key? key,
      this.category = "",
      this.appId = "",
      this.name = "no name",
      this.Description = "no description",
      this.images = const [],
      this.likes = 0,
      this.price = 0.0})
      : super(key: key);

  @override
  _FullProgramScreenState createState() => _FullProgramScreenState();
}

class _FullProgramScreenState extends State<FullProgramScreen> {
  int value = 1;

  Map getCurrency(int value) {
    switch (value) {
      case 1:
        return {1: "USD", 2: widget.price.floor()};
      default:
        return {1: "EUR", 2: (widget.price * 0.88).floor()};
    }
  }

  List<Widget> getImages() {
    List<Widget> images = [];
    widget.images.forEach((element) {
      images.add(Image.network(element));
    });

    return images;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => OYP(),
        child: BlocConsumer<OYP, states>(
            builder: (context, state) {
              return Scaffold(
                  appBar: AppBar(),
                  body: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: widget.name,
                            child: Container(
                              height: 300,
                              child: CarouselSlider(
                                  items: getImages(),
                                  options: CarouselOptions(
                                    enableInfiniteScroll: false,
                                    enlargeCenterPage: true,
                                    autoPlay: true,
                                  )),
                            ),
                          ),
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
                                  onPressed: () {
                                    try {
                                      OYP
                                          .GET(context)
                                          .likeApp(
                                              widget.category,
                                              widget.appId,
                                              widget.likes,
                                              !isFav)
                                          .then((value) {
                                        setState(() {
                                          isFav
                                              ? widget.likes--
                                              : widget.likes++;
                                          isFav = !isFav;
                                        });
                                      });
                                    } catch (e) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "There is something error \n Try again later",
                                          backgroundColor: Colors.red);
                                    }
                                  },
                                  icon: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
                                    color: Colors.red,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.grey[100])),
                                  onPressed: () {
                                    var info = getCurrency(value);
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
                                                      "total": "${info[2]}",
                                                      "currency": info[1],
                                                      "details": {
                                                        "subtotal":
                                                            "${info[2]}",
                                                        "shipping": '0',
                                                        "shipping_discount": 0
                                                      }
                                                    },
                                                    "description":
                                                        "A payment for OYP to order program",
                                                    // "payment_options": {
                                                    //   "allowed_payment_method":
                                                    //       "INSTANT_FUNDING_SOURCE"
                                                    // },
                                                    "item_list": {
                                                      "items": [
                                                        {
                                                          "name": " program",
                                                          "quantity": 1,
                                                          "price": '${info[2]}',
                                                          "currency": info[1]
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
                                ],
                                onChanged: (valuee) {
                                  setState(() {
                                    value = valuee;
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
