import 'package:OYP/Classes/shared.dart';
import 'package:OYP/cubit/bloc.dart';
import 'package:OYP/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class DesignPage extends StatefulWidget {
  const DesignPage({Key? key}) : super(key: key);

  @override
  State<DesignPage> createState() => _DesignPageState();
}

class _DesignPageState extends State<DesignPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OYP(),
      child: BlocConsumer<OYP, states>(
          builder: (context, states) {
            return Scaffold(
              body: FutureBuilder(
                  future: OYP.GET(context).getDesigns(userToken),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      designs.shuffle();
                      return Stack(
                        children: [
                          LiquidPullToRefresh(
                            backgroundColor: Colors.black,
                            color: Colors.white,
                            onRefresh: () async {
                              designs.clear();
                            },
                            child: PageView(
                              scrollDirection: Axis.vertical,
                              children: designs,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Image.asset(
                              "iyp/iyp designs b.png",
                              width: 100,
                            ),
                          )
                        ],
                      );
                    }
                  }),
            );
          },
          listener: (context, states) {}),
    );
  }
}
