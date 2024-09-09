import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:vas/screens/loading.dart';
import 'package:vas/widgets/components.dart';

class DocumentDetail extends StatefulWidget {
  const DocumentDetail({super.key});

  @override
  State<DocumentDetail> createState() => _DocumentDetailState();
}

class _DocumentDetailState extends State<DocumentDetail> {

  var page = 1;

  List listSteps = [1,2,3];

  List<StepperData> stepperData = [
    StepperData(
      title: StepperText(
        "Read Document Info",
        textStyle: const TextStyle(
          color: Colors.grey,
        ),
      ),
      subtitle: StepperText("05/09/2024, 10:55:07"),
      iconWidget: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xff07418C),
          borderRadius: BorderRadius.all(Radius.circular(30),
          ),
        ),
      ),
    ),
    StepperData(
      title: StepperText(
        "Read Document Info",
        textStyle: const TextStyle(
          color: Colors.grey,
        ),
      ),
      subtitle: StepperText("05/09/2024, 10:55:07"),
      iconWidget: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xff07418C),
          borderRadius: BorderRadius.all(Radius.circular(30),
          ),
        ),
      ),
    ),
    StepperData(
      title: StepperText(
        "Read Document Info",
        textStyle: const TextStyle(
          color: Colors.grey,
        ),
      ),
      subtitle: StepperText("05/09/2024, 10:55:07"),
      iconWidget: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xff07418C),
          borderRadius: BorderRadius.all(Radius.circular(30),
          ),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close, color: Colors.black,),
        ),
        title: Text("Document Detail", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),),
        shadowColor: Colors.black,
        elevation: 2.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                width: 450,
                height: 275,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 5,
                          blurRadius: 15
                      ),
                    ],
                    color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Surat Perjanjian",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        Text(
                          "draft",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.black.withOpacity(0.1),
                      height: 20,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        chipTag("E-Materai", false),
                        SizedBox(
                          width: 10,
                        ),
                        chipTag("E-Sign", false),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Create Date: ",
                                style: TextStyle(),
                              ),
                              Text(
                                "06 Juli 2023 - 15:45",
                                style: TextStyle(),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Office: ",
                                style: TextStyle(),
                              ),
                              Text(
                                "Bank Jateng Pusat",
                                style: TextStyle(),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Description: ",
                                style: TextStyle(),
                              ),
                              Text(
                                "Surat Perjanjian Kerjasama",
                                style: TextStyle(),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: primaryColor2,
                              padding: EdgeInsets.all(10),
                            ),
                            onPressed: () {

                            },
                            child: Icon(Icons.download, color: Colors.white, size: 20,),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: primaryColor2, width: 1.5)
                                ),
                                padding: EdgeInsets.all(10),
                                backgroundColor: Colors.white
                            ),
                            onPressed: () {

                            },
                            child: Icon(Icons.remove_red_eye, color: primaryColor2, size: 20,),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 450,
                height: 110,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 20.0,
                          spreadRadius: 5.0,
                          offset: Offset(5.0, 5.0)
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Last Stamp Activity",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Published Date : ",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey
                          ),
                        ),
                        Text(
                          "07/11/2024 - 10:43",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 15,
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(5),

                          ),
                        ),
                        Text(
                          "2/2",
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
                width: 450,
                height: 400,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 20.0,
                          spreadRadius: 5.0,
                          offset: Offset(5.0, 5.0)
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Document Activity",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.black.withOpacity(0.1),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AnotherStepper(
                      stepperList: stepperData,
                      stepperDirection: Axis.vertical,
                      verticalGap: 25,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
      floatingActionButton: Container(
        width: 70,
        height: 70,
        child: SpeedDial(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          spacing: 10,
          backgroundColor: Colors.white,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: primaryColor2
            ),
            child: Icon(Icons.add, size: 20, color: Colors.white,),
          ),
          children: [
            SpeedDialChild(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Loading()));
              },
              child: Icon(Icons.person),
              label: "Single Stamp",
            ),
            SpeedDialChild(
              onTap: () {},
              child: Icon(Icons.group),
              label: "Stamp with the other",
            ),
            SpeedDialChild(
              onTap: () {},
              child: Icon(Icons.share),
              label: "Request stamp",
            )
          ],
        ),
      )
    );
  }
}
