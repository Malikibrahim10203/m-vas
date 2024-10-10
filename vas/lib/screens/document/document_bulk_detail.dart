import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:vas/event/event_db.dart';
import 'package:vas/event/event_pref.dart';
import 'package:vas/main.dart';
import 'package:vas/models/activity.dart';
import 'package:vas/models/bulk_document.dart';
import 'package:vas/models/document/document_folder_version.dart';
import 'package:vas/models/document_type.dart';
import 'package:vas/models/single_document.dart';
import 'package:vas/screens/document/document_single_detail.dart';
import 'package:vas/screens/loading.dart';
import 'package:vas/screens/stamp/bulk_stamp.dart';
import 'package:vas/widgets/components.dart';

class DocumentBulkDetail extends StatefulWidget {
  const DocumentBulkDetail({super.key, required this.docId, required this.isFolder, required this.statusChip});
  final docId, isFolder, statusChip;

  @override
  State<DocumentBulkDetail> createState() => _DocumentBulkDetailState();
}

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


class _DocumentBulkDetailState extends State<DocumentBulkDetail> {
  var page = 1;

  var token;

  List listSteps = [1,2,3];
  Bulkdocument? bulkdocument;

  Future<Activity?>? fetchActivity;
  List<ActivityElement> activityData = [];

  bool isLoading = false;
  bool isLoadData = false;

  final ItemScrollController scrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  int lastIndex = 0;
  int? lastPage = null;

  var selectedDocTypeId;
  var selectedDocType;

  var heightModal = 0.3;

  List<ListTypeDocument>? docType;

  List<Map<String, dynamic>> docVersion = [];

  List<DocumentFolderVersionElement>? docVersionFolder;

  Future<void> getData() async {
    token = (await EventPref.getCredential())?.data.token;
    bulkdocument = await EventDB.getDetailDocument(token, widget.docId, widget.isFolder);
    docVersionFolder = await EventDB.getDocumentFolderVersion(token, widget.docId);

    if(bulkdocument != null) {
      fetchActivity = EventDB.getActivity(token, null, widget.docId, page);
    }

    if (bulkdocument!.versions!.isNotEmpty) {
      for (var version in bulkdocument!.versions!) {
        // Add the version to the list as a map
        docVersion.add({
          'id': version.id,
          'name': version.name,
          'description': version.description,
          'created_at': version.createdAt.toLocal(),
          'version': version.version,
          'stamp_status': version.stampStatus,
          'docs': version.docs,
        });
      }
    }

    if (docVersion.length >= 2) {
      setState(() {
        heightModal += 0.5;
      });
    }

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

    double widgetHeight = MediaQuery.of(context).size.height;
    double widgetWidth = MediaQuery.of(context).size.width;

    return bulkdocument != null?
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
          title: Text("Document Detail Bulk", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),),
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
                              bulkdocument!.name??"",
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
                                    DateFormat('yyyy-MM-dd, HH:mm:ss').format(bulkdocument!.createdAt!),
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
                                    bulkdocument!.officeName!,
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
                                      bulkdocument!.description!,
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
                                  ModalDownload(token, context, docVersionFolder, widget.docId);
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
                                onPressed: () async {

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
                            bulkdocument!.stampInProgress != null?
                            bulkdocument!.stampInProgress!.stampStatus == 3?
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
                                  String? result = await EventDB.RetrySingleStampDocument(token, bulkdocument!.id);
                                  if (result == 'success') {
                                    bulkdocument = await EventDB.getDetailDocument(token, widget.docId, widget.isFolder);
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
                            ):Container():Container(),
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
                              DateFormat('yyyy-MM-dd, HH:mm:ss').format(bulkdocument!.createdAt!.toLocal()),
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
                        bulkdocument!.stampInProgress != null?
                        bulkdocument!.stampInProgress!.stampStatus == 2 && bulkdocument!.stampInProgress != null ?
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
                        ): bulkdocument!.stampInProgress!.stampStatus == 1 && bulkdocument!.stampInProgress != null ?
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
                        ): Row(
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

                                              EventDB.getActivity(token, null, widget.docId, page).then((checkActivity) {
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
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>BulkStamp(docType: selectedDocType, docId: widget.docId, isfolder: widget.isFolder,)));
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
  Future<void> ModalDownload(token, BuildContext context, List<DocumentFolderVersionElement>? docVersions, id) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.56,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20)
          ),
          child: ListView.builder(
            itemCount: docVersions?.length ?? 0,
            itemBuilder: (context, index) {
              var listDocVersion = docVersions?[index];

              print(docVersions?.length??0);

              List<Map<String,dynamic>> datumListDocVersion = [];

              if (docVersions!.isNotEmpty) {
                for (var version in listDocVersion!.docs) {
                  datumListDocVersion.add({
                    "doc_id": version.docId,
                    "doc_name": version.docName,
                    "description": version.description,
                    "date": version.date,
                    "created_at": version.createdAt,
                    "updated_at": version.updatedAt,
                    "version": version.version,
                    "version_from": version.versionFrom,
                    "original_name": version.originalName
                  });
                }
              }
              return Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.28,
                    padding: EdgeInsets.all(20),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "${listDocVersion!.name} ${listDocVersion!.version}",
                              style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: ListView.builder(
                            itemCount: datumListDocVersion.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> dataDocMap = datumListDocVersion[index];
                              return Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 200,
                                      height: 60,
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
                                                    dataDocMap['doc_name'],
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 12
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${dataDocMap['description']}",
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
                                          String? base64StringData = await EventDB.DownloadDocument(token, dataDocMap['doc_id']);
                                          if (base64StringData != null) {
                                            String? locatePdf = await savePdfFromBase64(base64StringData!, dataDocMap['doc_name']);
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
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}


