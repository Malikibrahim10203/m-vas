import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vas/event/event_db.dart';
import 'package:vas/event/event_pref.dart';
import 'package:vas/models/activity.dart';
import 'package:vas/models/bulk_document.dart';
import 'package:vas/models/document_type.dart';
import 'package:vas/models/single_document.dart';
import 'package:vas/screens/loading.dart';
import 'package:vas/screens/stamp/single_stamp.dart';
import 'package:vas/widgets/components.dart';


class DocumentSingleDetail extends StatefulWidget {
  const DocumentSingleDetail({super.key, required this.docId, required this.isFolder, required this.statusChip});
  final docId, isFolder, statusChip;

  @override
  State<DocumentSingleDetail> createState() => _DocumentSingleDetailState();
}

class _DocumentSingleDetailState extends State<DocumentSingleDetail> {
  var page = 1;

  var token;

  List listSteps = [1,2,3];
  Singledocument? singleDoc;

  Future<Activity?>? activityList;
  List<ListTypeDocument>? docType;
  var selectedDocType;


  Future<void> getData() async {
    token = (await EventPref.getCredential())?.data.token;
    singleDoc = await EventDB.getDetailDocument(token, widget.docId, widget.isFolder);
    activityList = EventDB.getActivity(token, singleDoc!.docId, null);

    docType = await EventDB.getDocumentType(token);

    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  List<StepperData> stepperData = [];

  @override
  Widget build(BuildContext context) {
    return singleDoc != null?
    Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              setState(() {
                stepperData.clear();
              });
              Navigator.pop(context);
            },
            icon: Icon(Icons.close, color: Colors.black,),
          ),
          title: Text("Document Detail Single", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),),
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
                              singleDoc!.docName??"",
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
                            chipTag("E-Materai", widget.statusChip[0]),
                            SizedBox(
                              width: 10,
                            ),
                            chipTag("E-Sign", widget.statusChip[1]),
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
                                    DateFormat('yyyy-MM-dd, HH:mm:ss').format(singleDoc!.createdAt!.toLocal()),
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
                                    singleDoc!.officeName!,
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
                                  Container(
                                    width: 250,
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      singleDoc!.description!,
                                      style: TextStyle(),
                                      textAlign: TextAlign.end,
                                    ),
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
                              DateFormat('yyyy-MM-dd, HH:mm:ss').format(singleDoc!.updatedAt!.toLocal()),
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
                                value: 90/100,
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
                        Container(
                            height: 320,
                            child: Column(
                              children: [
                                Expanded(
                                  child: FutureBuilder<Activity?>(
                                    future: activityList,
                                    builder: (BuildContext context, snapshot) {
                                      if(snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(child: CircularProgressIndicator());
                                      } else if(snapshot.hasError) {
                                        return Center(child: Text('Error: ${snapshot.error}'));
                                      } else if(!snapshot.hasData || snapshot.data!.data.isEmpty) {
                                        return Center(
                                          child: Stack(
                                            children: [
                                              Column(
                                                children: [
                                                  Image.asset(
                                                    "assets/images/history.png",
                                                    width: 100,
                                                  ),
                                                  Text(
                                                    "No Activity History",
                                                    style: TextStyle(
                                                        color: Colors.black12
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        for(var i = 0; i < snapshot.data!.data.length; i++) {
                                          ActivityElement activityData = snapshot.data!.data[i];
                                          print(activityData.createdAt);
                                          stepperData.add(
                                            StepperData(
                                              title: StepperText(
                                                "${activityData.activity??''} - ${activityData.docName??''}",
                                                textStyle: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              subtitle: StepperText(DateFormat('yyyy-MM-dd, HH:mm:ss').format(activityData.createdAt!)),
                                              iconWidget: Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xff07418C),
                                                  borderRadius: BorderRadius.all(Radius.circular(30),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        return Scrollbar(
                                          child: ListView.builder(
                                            itemCount: 1,
                                            itemBuilder: (context, index) {
                                              return AnotherStepper(
                                                stepperList: stepperData,
                                                stepperDirection: Axis.vertical,
                                                verticalGap: 25,
                                                inActiveBarColor: Colors.black.withOpacity(0.1),
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )
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
                  DocumentType();
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleStamp()));
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
    ): Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> DocumentType() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: tertiaryColor50, width: 10)),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10))
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 30.0), // Add spacing for the floating icon
                    Text(
                      "Document Type",
                      style: GoogleFonts.roboto(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w600
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: 300,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1,color: tertiaryColor50),
                        color: tertiaryColor4,
                      ),
                      child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "Select Document Type",
                              style: GoogleFonts.roboto(
                                  fontSize: 10,
                                  color: tertiaryColor100
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: 300,
                      height: 55,
                      child: DropdownButtonFormField<ListTypeDocument>(
                        items: docType?.map((ListTypeDocument value) {
                          return DropdownMenuItem<ListTypeDocument>(
                            value: value,
                            child: Text(
                              value.nama,
                              style: TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (ListTypeDocument? value) {
                          // Handle dropdown selection
                          if (value != null) {
                            print('Selected ID: ${value.id}, Name: ${value.nama}');
                          }
                        },
                        hint: Text('Select document type', style: TextStyle(fontSize: 12),),
                        value: selectedDocType,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 130,
                          height: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(width: 1, color: bluePrimary)
                              ),
                              backgroundColor: Colors.white
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("No", style: TextStyle(color: bluePrimary),),
                          ),
                        ),
                        Container(
                          width: 130,
                          height: 35,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(width: 1, color: bluePrimary)
                              ),
                              backgroundColor: bluePrimary
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleStamp(docType: "Surat Berharga", docId: singleDoc!.docId,)));
                            },
                            child: Text("Yes"),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              // Floating Icon
              Positioned(
                top: -30.0,
                child: CircleAvatar(
                    backgroundColor: tertiaryColor100,
                    radius: 30.0,
                    child: Image.asset("assets/images/alert.png", width: 50,)
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
