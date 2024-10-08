import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:vas/event/event_db.dart';
import 'package:vas/event/event_pref.dart';
import 'package:vas/models/activity.dart';
import 'package:vas/models/bulk_document.dart';
import 'package:vas/models/document_type.dart';
import 'package:vas/models/single_document.dart';
import 'package:vas/screens/loading.dart';
import 'package:vas/screens/stamp/single_stamp.dart';
import 'package:vas/screens/view_document/view_single_document.dart';
import 'package:vas/widgets/components.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../main.dart';

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

Future<void> showNotification(String? payload) async {
  // Android notification details
  const AndroidNotificationDetails androidNotificationDetails =
  AndroidNotificationDetails(
    icon: ('vas_logo'),
    'channel_id',             // Required for Android 8.0+ (Oreo) and above
    'channel_name',           // Name of the notification channel
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  // Platform-specific notification details
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidNotificationDetails);

  // Show notification
  await flutterLocalNotificationsPlugin.show(
    0,
    'Download Success',
    'The file has been downloaded successfully. You can find it in your library.',
    platformChannelSpecifics,
    payload: payload,
  );
}


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

  Future<Activity?>? fetchActivity;
  List<ActivityElement> activityData = [];

  int lastIndex = 0;
  int? lastPage = null;

  final ItemScrollController scrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  List<ListTypeDocument>? docType;
  var selectedDocTypeId;
  var selectedDocType;

  bool isLoading = false;
  bool isLoadData = false;

  List<Map<String, dynamic>> docVersion = [];




  Future<void> getData() async {

    setState(() {
      isLoading = true;
    });

    token = (await EventPref.getCredential())?.data.token;
    singleDoc = await EventDB.getDetailDocument(token, widget.docId, widget.isFolder);
    fetchActivity = EventDB.getActivity(token, singleDoc!.docId, null, page);

    if (singleDoc!.versions.isNotEmpty) {
      docVersion = List<Map<String, dynamic>>.from(singleDoc!.versions);
    }

    docType = await EventDB.getDocumentType(token);

    setState(() {
      isLoading = false;
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
                                  ModalDownload(token, context, docVersion, widget.docId);
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewSingleDocument(docId: widget.docId)));
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
                    height: 120,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Last Stamp Activity",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            singleDoc!.stampInProgress.stampStatus == 3?
                                Container(
                                  width: 120,
                                  height: 25,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          width: 1,
                                          color: bluePrimary
                                        ),
                                      ),
                                      backgroundColor: Colors.white
                                    ),
                                    onPressed: () async {
                                      String? result = await EventDB.RetrySingleStampDocument(token, singleDoc!.docId);
                                      if (result == 'success') {
                                        singleDoc = await EventDB.getDetailDocument(token, widget.docId, widget.isFolder);
                                      }
                                      setState(() {

                                      });
                                      print(result);
                                    },
                                    child: Text(
                                      "Retry Stamp",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: bluePrimary
                                      ),
                                    ),
                                  ),
                                ):Container(),
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
                        singleDoc!.stampInProgress.stampStatus == 2 ?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: 15,
                              child: LinearProgressIndicator(
                                borderRadius: BorderRadius.circular(5),
                                value: 100/100,
                                color: Colors.green,
                                backgroundColor: Colors.green.withOpacity(0.3),
                              ),
                            ),
                            Text(
                              "2/2",
                            ),
                          ],
                        ): singleDoc!.stampInProgress.stampStatus == 1?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: 15,
                              child: LinearProgressIndicator(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.green,
                                backgroundColor: Colors.green.withOpacity(0.3),
                              ),
                            ),
                            Text(
                              "2/2",
                            ),
                          ],
                        ):
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: 15,
                              child: LinearProgressIndicator(
                                borderRadius: BorderRadius.circular(5),
                                value: 0/100,
                                color: Colors.green,
                                backgroundColor: Colors.green.withOpacity(0.3),
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
                                    future: fetchActivity,
                                    builder: (BuildContext context, snapshot) {
                                      if(snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(child: CircularProgressIndicator());
                                      } else if(snapshot.hasError) {
                                        return Center(child: Text('Error: ${snapshot.error}'));
                                      } else if(!snapshot.hasData || snapshot.data!.data.isEmpty) {


                                        if (isLoadData == true) {
                                          print("P:${activityData.length}-lastIndex");
                                          if(stepperData.length > lastIndex) {
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              if (scrollController.isAttached) {
                                                scrollController.jumpTo(index: lastIndex);
                                                isLoadData = false;
                                              }
                                            });
                                          }
                                        } else {
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            if (scrollController.isAttached) {
                                              scrollController.jumpTo(index: 0);
                                            }
                                          });
                                        }

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

                                        for (var i = 0; i < snapshot.data!.data.length; i++) {
                                          ActivityElement activityData = snapshot.data!.data[i];

                                          bool alreadyExists = stepperData.any((step) =>
                                          step.title!.text == "${activityData.activity ?? ''} - ${activityData.docName ?? ''}" &&
                                              step.subtitle!.text == DateFormat('yyyy-MM-dd, HH:mm:ss').format(activityData.createdAt!.toLocal())
                                          );

                                          if (!alreadyExists) {
                                            stepperData.add(
                                              StepperData(
                                                title: StepperText(
                                                  "${activityData.activity ?? ''} - ${activityData.docName ?? ''}",
                                                  textStyle: const TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                subtitle: StepperText(
                                                  DateFormat('yyyy-MM-dd, HH:mm:ss').format(activityData.createdAt!.toLocal()),
                                                ),
                                                iconWidget: Container(
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xff07418C),
                                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        }

                                        return NotificationListener<ScrollNotification>(
                                          onNotification: (ScrollNotification scrollInfo) {
                                            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !isLoading && lastPage != page) {
                                              setState(() {
                                                isLoading = true;
                                                page++;
                                                print("Page: $page");
                                                print("${stepperData.length} . ${lastIndex}");
                                              });

                                              EventDB.getActivity(token, singleDoc!.docId, null, page).then((checkActivity) {
                                                if (checkActivity != null && checkActivity.data.isNotEmpty) {
                                                  setState(() {
                                                    fetchActivity = Future.value(checkActivity);
                                                    lastIndex+= 10;
                                                    print(lastIndex);
                                                    isLoadData = true;

                                                    isLoading = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    page--;
                                                    isLoading = false;
                                                    lastPage = page;
                                                  });

                                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                                    if (scrollController.isAttached) {
                                                      scrollController.jumpTo(index: stepperData.length - 1);
                                                    }
                                                  });
                                                }
                                              }).catchError((error) {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              });
                                            }
                                            return true;
                                          },
                                          child: Scrollbar(
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
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal) {
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
                        SizedBox(height: 30.0),
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
                                selectedDocType = value.nama;
                                print('Selected ID: ${value.id}, Name: ${value.nama}');
                              }
                              setState(() {

                              });
                            },
                            hint: Text('Select document type', style: TextStyle(fontSize: 12),),
                            value: selectedDocTypeId,
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
                                  selectedDocTypeId = null;
                                  selectedDocType   = null;
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
                                  if (selectedDocType != null) {
                                    Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleStamp(docType: selectedDocType, docId: singleDoc!.docId, isfolder: widget.isFolder, docName: singleDoc!.docName, statuschips: widget.statusChip,)));
                                  }
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
      },
    );
  }

}


Future<String?> savePdfFromBase64(String base64String, String fileName) async {
  // Request permission to write to external storage
  var status = await Permission.storage.request();

  if (status.isGranted) {
    try {
      // Decode the Base64 string
      final decodedBytes = base64Decode(base64String);

      // Get the Downloads directory
      final directory = Directory('/storage/emulated/0/Download'); // Direct path to Downloads

      // Construct the file path
      final filePath = '${directory.path}/$fileName.pdf';

      // Create a file and write the bytes
      final file = File(filePath);
      await file.writeAsBytes(decodedBytes);

      // Print success message
      return filePath;
    } catch (e) {
      // Handle exceptions and print error message
      return null;
    }
  } else {
    print('Permission denied to write to external storage');
  }
}


Future<void> ModalDownload(token, BuildContext context, List<Map<String, dynamic>> docVersions, id) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          height: docVersions.length <= 2? MediaQuery.of(context).size.height * 0.3: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Document Now",
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        var dataDocVersions = docVersions[index];
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 200,
                                height: 40,
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[200],
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: Image.asset(
                                        "assets/images/pdf.png",
                                        width: 25,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dataDocVersions['doc_name'],
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 12
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  dataDocVersions['date'],
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(Icons.circle, size: 5,),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "STAMPED",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 12
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 50,
                                child: IconButton(
                                  onPressed: () async {
                                    String? base64StringData = await EventDB.DownloadDocument(token, dataDocVersions['doc_id']);
                                    if (base64StringData != null) {
                                      String? locatePdf = await savePdfFromBase64(base64StringData!, dataDocVersions['doc_name']);
                                      showNotification(locatePdf);
                                    }
                                  },
                                  icon: Icon(CupertinoIcons.cloud_download, color: Colors.black.withOpacity(0.5),),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Version History",
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: docVersions.length<= 1? MediaQuery.of(context).size.height * 0.08: MediaQuery.of(context).size.height * 0.25,
                    child: ListView.builder(
                      itemCount: docVersions.length,
                      itemBuilder: (context, index) {
                        var dataDocVersions = docVersions[index];
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 200,
                                height: 40,
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[200],
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: Image.asset(
                                        "assets/images/pdf.png",
                                        width: 25,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dataDocVersions['doc_name'],
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 12
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  dataDocVersions['date'],
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(Icons.circle, size: 5,),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "STAMPED",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 12
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 50,
                                child: IconButton(
                                  onPressed: () async {
                                    String? base64StringData = await EventDB.DownloadDocument(token, dataDocVersions['doc_id']);
                                    if (base64StringData != null) {
                                      String? locatePdf = await savePdfFromBase64(base64StringData!, dataDocVersions['doc_name']);
                                      showNotification(locatePdf);
                                    }
                                  },
                                  icon: Icon(CupertinoIcons.cloud_download, color: Colors.black.withOpacity(0.5),),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          )
        ),
      );
    },
  );
}
