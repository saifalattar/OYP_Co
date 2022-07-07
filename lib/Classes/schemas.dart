import 'package:OYP/cubit/bloc.dart';
import 'package:OYP/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:url_launcher/url_launcher.dart';

class Program extends StatefulWidget {
  String name;
  String Description;
  List<dynamic> images;
  double price;
  void Function() onTap;
  void likeFunction;

  Program(
      {Key? key,
      this.name = "no name",
      this.Description = "no description",
      this.images = const [],
      required this.onTap,
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
                        child: Hero(
                          tag: widget.name,
                          child: Image.network(
                            widget.images[0],
                            fit: BoxFit.cover,
                          ),
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
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
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
                                Text(
                                  "${widget.price} \$",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                SizedBox(
                                  width: 15,
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

class Design extends StatelessWidget {
  String image = "", title = "", artist = "", link = "";
  Design(this.image, this.title, this.artist, this.link, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        Center(child: Image.network("${this.image}")),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    "${this.title}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  IconButton(
                      onPressed: () async {
                        await ImageDownloader.downloadImage("${this.image}")
                            .then((value) => Fluttertoast.showToast(
                                msg: "(${this.title}) downloaded successfully",
                                backgroundColor: Colors.green))
                            .catchError((onError) => Fluttertoast.showToast(
                                msg:
                                    "(${this.title}) can't be downloaded \n Try again later",
                                backgroundColor: Colors.red));
                      },
                      icon: Icon(
                        Icons.download_for_offline_rounded,
                        color: Colors.white,
                      ))
                ],
              ),
              Text(
                "By",
                style: TextStyle(color: Colors.white),
              ),
              TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse("${this.link}"));
                  },
                  child: Text("${this.artist}",
                      style: TextStyle(fontSize: 16, color: Colors.white)))
            ],
          ),
        )
      ],
    );
  }
}
