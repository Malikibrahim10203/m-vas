import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:vas/event/event_db.dart';
import 'package:vas/event/event_pref.dart';
import 'package:vas/screens/document/document_single_detail.dart';
import 'package:vas/screens/management_doc/stamp_management.dart';
import 'package:vas/widgets/components.dart';

class SingleStamp extends StatefulWidget {
  const SingleStamp({super.key, required this.docType, required this.docId, required this.isfolder, required this.docName, required this.statuschips});

  final docType, docId, isfolder, docName, statuschips;

  @override
  State<SingleStamp> createState() => _SingleStampState();
}

class _SingleStampState extends State<SingleStamp> {
  late PdfViewerController _pdfViewerController;
  int _currentPage = 1;

  Size? pageSize;
  Size? viewSize;
  Size? renderedSize;

  double containerWidth = 0;
  double containerHeight = 0;

  double zoomLevel = 1.0;

  int _totalPage = 0;
  bool isDisable = false;
  
  List<StampData> coordinateActive = [];

  List<Map<String, dynamic>> stamps = [];

  Size? calculateRenderedSize() {
    if (pageSize != null && viewSize != null) {
      double scaleFactorWidth = viewSize!.width / pageSize!.width;
      double scaleFactorHeight = viewSize!.height / pageSize!.height;
      double scaleFactor = scaleFactorWidth < scaleFactorHeight ? scaleFactorWidth : scaleFactorHeight;

      double renderedWidth = pageSize!.width * scaleFactor;
      double renderedHeight = pageSize!.height * scaleFactor;

      return Size(renderedWidth, renderedHeight);
    }
    return null;
  }

  double getScaledX(double x) {
    if (renderedSize == null || pageSize == null) return 0;
    return (x / renderedSize!.width) * pageSize!.width;
  }

  double getScaledY(double y) {
    if (renderedSize == null || pageSize == null) return 0;
    return (y / renderedSize!.height) * pageSize!.height;
  }

  double getLLX(Map<String, dynamic> stamp) => getScaledX(stamp['x']!);
  double getLLY(Map<String, dynamic> stamp) => getScaledY(containerHeight - stamp['y']! - stamp['height']!);
  double getURX(Map<String, dynamic> stamp) => getScaledX(stamp['x']! + stamp['width']!);
  double getURY(Map<String, dynamic> stamp) => getScaledY(containerHeight - stamp['y']!);

  String printCoordinates(int index) {
    double llx = getLLX(stamps[index]);
    double lly = getLLY(stamps[index]);
    double urx = getURX(stamps[index]);
    double ury = getURY(stamps[index]);
    return 'Stamp $index -> llx = $llx, lly = $lly, urx = $urx, ury = $ury';
  }

  void addStamp() {
    setState(() {

      if (stamps.isNotEmpty) {
        stamps[stamps.length - 1]['isDisabled'] = true;
      }

      stamps.add({
        'x': ((containerWidth - 100) / 2).toDouble(),
        'y': ((containerHeight - 100) / 2).toDouble(),
        'width': 100.toDouble(),
        'height': 100.toDouble(),
        'page': _currentPage,
        'isDisabled': false,
      });
    });
  }

  int stampCount = 0;
  bool isButtonEnabled = true;

  bool isConfirm = false;

  var fileBase64;
  Uint8List? filePdf;
  var token;

  Future<void> getData() async {
    token = (await EventPref.getCredential())?.data.token;
    fileBase64 = await EventDB.getPreviewDocument(token, widget.docId);
    filePdf = base64Decode(fileBase64);

    setState(() {

    });
  }

  List<Map<String, dynamic>> stampList = [];

  @override
  void initState() {
    super.initState();
    getData();
    _pdfViewerController = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {

    double widgetHeight = MediaQuery.of(context).size.height;
    double widgetWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor: Color(0xffF6FAFF),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Stamp E-Materai", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),),
            IconButton(onPressed: () {}, icon: Image.asset("assets/images/contact-us.png", width: 20,))
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Expanded(
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    viewSize = Size(constraints.maxWidth, constraints.maxHeight);

                    if (filePdf != null) {
                      return SfPdfViewer.memory(
                        filePdf!,
                        controller: _pdfViewerController,
                        scrollDirection: PdfScrollDirection.horizontal,
                        enableDoubleTapZooming: false,
                        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                          pageSize = details.document.pages[0].size;

                          _totalPage =  details.document.pages.count;

                          renderedSize = calculateRenderedSize();
                          if (renderedSize != null) {
                            containerWidth = renderedSize!.width;
                            containerHeight = renderedSize!.height;
                            print('Rendered PDF Size on Screen: ${renderedSize?.width} x ${renderedSize?.height}');
                          }

                          setState(() {
                            zoomLevel = _pdfViewerController.zoomLevel;
                          });
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                Positioned(
                  left: (viewSize?.width ?? 0) / 2 - (containerWidth / 2),
                  top: (viewSize?.height ?? 0) / 2 - (containerHeight / 2),
                  child: Container(
                    width: containerWidth,
                    height: containerHeight,
                    color: Colors.transparent,
                    child: Stack(
                      children: List.generate(stamps.length, (index) {
                        final stamp = stamps[index];
                        // Adjust position based on zoom level
                        double adjustedX = stamp['x']! * zoomLevel;
                        double adjustedY = stamp['y']! * zoomLevel;

                        // Only show stamps for the current page
                        if (stamp['page'] == _currentPage) {
                          if (stamp['isDisabled'] == false) {
                            return Positioned(
                              left: adjustedX,
                              top: adjustedY,
                              child: GestureDetector(
                                onPanUpdate: (details) {
                                  setState(() {
                                    // Move the stamp
                                    stamp['x'] = (stamp['x']! + details.delta.dx)
                                        .clamp(0, containerWidth - stamp['width']!);
                                    stamp['y'] = (stamp['y']! + details.delta.dy)
                                        .clamp(0, containerHeight - stamp['height']!);
                                    printCoordinates(index);
                                  });
                                },
                                child: Container(
                                  width: stamp['width']! + 10,
                                  height: stamp['height']! + 10,
                                  child: Stack(
                                    children: [
                                      Container(
                                        child: DottedBorder(
                                          child: Image.asset(
                                            "assets/images/materai.jpg",
                                            width: stamp['width'],
                                            height: stamp['height'],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: GestureDetector(
                                          onPanUpdate: (details) {
                                            setState(() {
                                              double aspectRatio = stamp['width']! / stamp['height']!;
                                              double newWidth = stamp['width']! + details.delta.dx;
                                              double newHeight = newWidth / aspectRatio;

                                              newWidth = newWidth.clamp(20.0, containerWidth - stamp['x']!);
                                              newHeight = newHeight.clamp(20.0, containerHeight - stamp['y']!);

                                              stamp['width'] = newWidth;
                                              stamp['height'] = newHeight;

                                              if (stamp['x']! + stamp['width']! > containerWidth) {
                                                stamp['x'] = containerWidth - stamp['width']!;
                                              }
                                              if (stamp['y']! + stamp['height']! > containerHeight) {
                                                stamp['y'] = containerHeight - stamp['height']!;
                                              }

                                              printCoordinates(index);
                                            });
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color: Colors.red,
                                            ),
                                            child: Image.asset("assets/images/maximize.png"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Positioned(
                              left: adjustedX,
                              top: adjustedY,
                              child: GestureDetector(
                                onPanUpdate: (details) {
                                  setState(() {

                                  });
                                },
                                child: Container(
                                  width: stamp['width']! + 10,
                                  height: stamp['height']! + 10,
                                  child: Stack(
                                    children: [
                                      Container(
                                        child: Image.asset(
                                          "assets/images/materai.jpg",
                                          width: stamp['width'],
                                          height: stamp['height'],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        } else {
                          return SizedBox.shrink();
                        }
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 100,
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isButtonEnabled && !isConfirm?
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (stamps.isNotEmpty && isButtonEnabled == true) {
                            stamps.removeLast();
                            stampCount = stamps.length;
                            coordinateActive.removeLast();
                            if (stampCount > 0) {
                              stamps[stampCount - 1]['isDisabled'] = true;
                            }
                            print(stampCount);
                          }
                        });
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(1,5),
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 7,
                                  spreadRadius: 2
                              )
                            ]
                        ),
                        child: Icon(Icons.restart_alt, size: 15, color: Colors.black.withOpacity(0.5),),
                      ),
                    ): SizedBox(),
                    isConfirm? GestureDetector(
                      onTap: () {
                        setState(() {
                          isButtonEnabled = true;
                          isConfirm = false;
                          stamps[stampCount - 1]['isDisabled'] = true;
                          coordinateActive.insert(stampCount - 1, StampData(llx: getLLX(stamps[stampCount-1]), lly: getLLY(stamps[stampCount-1]), urx: getURX(stamps[stampCount-1]), ury: getURY(stamps[stampCount-1]), page: _currentPage));
                          print("llx = ${coordinateActive[0].llx}, lly = ${coordinateActive[0].lly}, urx = ${coordinateActive[0].urx}, ury = ${coordinateActive[0].ury}");
                          print(stampCount);
                        });
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green
                        ),
                        child: Icon(Icons.done, size: 15, color: Colors.white,),
                      ),
                    ):SizedBox()
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.zoom_out),
                              onPressed: () {
                                setState(() {
                                  zoomLevel = (zoomLevel - 0.5).clamp(1.0, 4.0);
                                  _pdfViewerController.zoomLevel = zoomLevel; // Update the PDF viewer's zoom level
                                });
                              },
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.zoom_in),
                              onPressed: () {
                                setState(() {
                                  zoomLevel = (zoomLevel + 0.5).clamp(1.0, 4.0);
                                  _pdfViewerController.zoomLevel = zoomLevel; // Update the PDF viewer's zoom level
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text('Page $_currentPage of $_totalPage'),
                      ),
                    ),
                    Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.navigate_before),
                              onPressed: () {
                                if (_currentPage > 1) {
                                  _pdfViewerController.jumpToPage(_currentPage - 1);
                                  _currentPage -= 1;
                                }
                                setState(() {

                                });
                              },
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.navigate_next),
                              onPressed: () {
                                if (_currentPage < _totalPage) {
                                  _pdfViewerController.jumpToPage(_currentPage + 1);
                                  _currentPage += 1;
                                }
                                setState(() {

                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
            ),
            isButtonEnabled && !isConfirm? FloatingActionButton(
              backgroundColor: textAlertColor2,
              onPressed: () {
                setState(() {
                  addStamp();
                  stampCount++;
                  isButtonEnabled = false;
                  isConfirm = true;
                  print(coordinateActive.length);
                });
              },
              child: Container(
                child: Center(
                  child: Icon(Icons.qr_code),
                ),
              ),
            ): FloatingActionButton(
              backgroundColor: textAlertRedColor3,
              onPressed: () {
                setState(() {

                });
              },
              child: Container(
                child: Center(
                  child: Icon(Icons.qr_code),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        child: Container(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              if(coordinateActive.length>=1) {
                ModalConfirmLocation(context, "route", "Confirmation Location", "For a more accurate data certificate in the document, turn on the device location.", token, widget.docId, widget.docType, "jakarta", null, widget.docName, coordinateActive);
              }
            },
            child: Text('Submit'),
          ),
        ),
      ),
    );
  }
}

class StampData {
  double llx;
  double lly;
  double urx;
  double ury;
  int page;

  StampData({
    required this.llx,
    required this.lly,
    required this.urx,
    required this.ury,
    required this.page,
  });
}

Future<void> ModalConfirmLocation(context, route, labelText, contentText, token, docId, docType, city, otp, docName, coordinateDoc) {
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
              padding: const EdgeInsets.all(20.0),
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
                    labelText,
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
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: tertiaryColor4,
                      border: Border.all(color: tertiaryColor50, width: 1)
                    ),
                    child: Text(
                      "$contentText",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w300
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  side: BorderSide(width: 1, color: bluePrimary)
                              )
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Back',
                            style: TextStyle(
                                color: bluePrimary
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: bluePrimary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                              )
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            ModalConfirmSubmit(context, "route", "Are you sure?", "Document Information", token, docId, docType, city, otp, docName, coordinateDoc);
                          },
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ],
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

Future<void> ModalConfirmSubmit(context, route, labelText, contentText, token, docId, docType, city, otp, docName, coordinateDoc) {
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
              padding: const EdgeInsets.all(20.0),
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
                    labelText,
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
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: tertiaryColor4,
                        border: Border.all(color: tertiaryColor50, width: 1)
                    ),
                    child: Text(
                      "$contentText",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w300
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Document Name : ",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.5)
                              ),
                            ),
                            Text(docName),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Stamp Category : ",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.5)
                              ),
                            ),
                            Text("Single Stamp"),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Document Type : ",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.5)
                              ),
                            ),
                            Text(docType),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  side: BorderSide(width: 1, color: bluePrimary)
                              )
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Back',
                            style: TextStyle(
                                color: bluePrimary
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: bluePrimary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                              )
                          ),
                          onPressed: () async {
                            Map<String, dynamic> data = await EventDB.StampingSingleDocument(token, docId, docType, city, otp, coordinateDoc);
                            Navigator.pop(context);
                            if(data['status'] == 'error') {
                              AlertFailed(context, "Error", data['error']);
                            } else {
                              // statuschip[0] = true;
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>DocumentSingleDetail(docId: docId.toString(), isFolder: isfolder, statusChip: statuschip)));
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>StampManagement()));
                            }
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ],
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
