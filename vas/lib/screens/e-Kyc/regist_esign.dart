import 'package:flutter/material.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/widgets/components.dart';

class RegistEsign extends StatefulWidget {
  const RegistEsign({super.key});

  @override
  State<RegistEsign> createState() => _RegistEsignState();
}

class _RegistEsignState extends State<RegistEsign> {

  int page = 1;
  int counter = 2;
  List list = [0,1,2];

  late Size size;
  late double widthScreen, heightScreen;



  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    widthScreen = size.width;
    heightScreen = size.height;


    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        shadowColor: Colors.black87,
        title: Text("Registration e-Kyc",style: TextStyle(fontSize: 18),),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.close
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                width: 310,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: FlutterStepIndicator(
                          height: 40,
                          paddingLine: const EdgeInsets.symmetric(horizontal: 0),
                          positiveColor: bluePrimary,
                          progressColor: const Color(0xFFEA9C00),
                          negativeColor: const Color(0xFFD5D5D5),
                          padding: const EdgeInsets.all(4),
                          list: list,division: counter,
                          onChange: (i) {},
                          page: page,
                          onClickItem: (p0) {
                            setState(() {
                              page = p0;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Personal\nInformation",
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Office\nInformation",
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Upload\nDocument",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("*First Name"),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: size.height * 0.065,
                        width: size.width* 0.9,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("*Last Name"),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: size.height * 0.065,
                        width: size.width* 0.9,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("*Phone Number"),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: size.height * 0.065,
                        width: size.width* 0.9,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("*E-mail"),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: size.height * 0.065,
                        width: size.width* 0.9,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("*Gender"),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: size.height * 0.065,
                        width: size.width* 0.9,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("*Date of Birth"),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: size.height * 0.065,
                        width: size.width* 0.9,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("*Province"),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: size.height * 0.065,
                        width: size.width* 0.9,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("*District"),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: size.height * 0.065,
                        width: size.width* 0.9,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("*Village"),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: size.height * 0.065,
                        width: size.width* 0.9,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("*Address"),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: size.height * 0.065,
                        width: size.width* 0.9,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("*RT"),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: size.height * 0.065,
                            width: size.width* 0.35,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("*RT"),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: size.height * 0.065,
                            width: size.width* 0.35,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: size.height * 0.06,
              width: size.width * 0.9,
              child: ElevatedButton(
                onPressed: (){

                },
                child: Text(
                    "Next",
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14
                    )
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff0081F1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
