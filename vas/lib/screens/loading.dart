import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  var widthScreen;

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: CardLoading(
              height: 165,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: CardLoading(
              height: 100,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: CardLoading(
              height: 100,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: CardLoading(
                  width: 150,
                  height: 30,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: CardLoading(
                  width: widthScreen * 0.9,
                  height: 30,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: CardLoading(
                  width: widthScreen * 0.9,
                  height: 30,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: CardLoading(
                  width: widthScreen * 0.9,
                  height: 30,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: CardLoading(
                  width: widthScreen * 0.9,
                  height: 30,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: CardLoading(
              height: 100,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
