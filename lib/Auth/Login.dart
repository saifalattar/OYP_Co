import 'package:OYP/Auth/Signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:OYP/mainScreens/home.dart';

class LogIn extends StatelessWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Slide> slides = [
      Slide(
          title: "Welcome To",
          backgroundColor: Colors.redAccent,
          backgroundImage: "oyp/173815.png",
          widgetDescription: Center(
            child: Text(
              "Build Your Future",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          centerWidget: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                ),
                Container(
                  child: Image.asset("oyp/oyp black white.png"),
                ),
              ],
            ),
            width: 200,
          )),
      Slide(
          title: "Join Our Community",
          backgroundImage: "oyp/peakpx.jpg",
          centerWidget: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  """And start browsing on the program you need to start a new journey in your path and order it
              """,
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 100,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: SignInButton(
                    Buttons.Email,
                    text: "Sign up with Email",
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUP()));
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: SignInButton(
                    Buttons.Email,
                    text: "Log In with Email",
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignIn()));
                    },
                  ),
                )
              ],
            ),
          ))
    ];
    return Scaffold(
        body: IntroSlider(
      slides: slides,
      showDoneBtn: false,
      colorDot: Colors.white,
      showSkipBtn: false,
    ));
  }
}
