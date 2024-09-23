import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:vas/event/event_db.dart';
import 'package:vas/event/event_pref.dart';
import 'package:vas/widgets/components.dart';

class SingleStamp extends StatefulWidget {
  const SingleStamp({super.key, required this.docType, required this.docId});

  final docType, docId;

  @override
  State<SingleStamp> createState() => _SingleStampState();
}

class _SingleStampState extends State<SingleStamp> {
  late PdfViewerController _pdfViewerController;
  int _currentPage = 1;
  final int _totalPages = 10;
  double _scale = 30;

  double _pageHeight = 0.0;
  double _pageWidth = 0.0;

  List<Stamp> stamps = [];
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
                filePdf!=null?Container(
                  height: 650,
                  child: SfPdfViewer.memory(
                    filePdf!,
                    controller: _pdfViewerController,
                    scrollDirection: PdfScrollDirection.horizontal,
                    enableDoubleTapZooming: false,
                    onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                      // Set total pages dynamically if needed
                      final page = details.document.pages[_currentPage - 1];
                      _pageHeight = page.size.height;
                      _pageWidth = page.size.width;

                      setState(() {

                      });
                    },
                    onPageChanged: (PdfPageChangedDetails details) {

                      setState(() {
                        _currentPage = details.newPageNumber;
                      });
                    },
                  ),
                ):Center(
                  child: CircularProgressIndicator(),
                ),
                ...stamps.map((stamp) {
                  return Positioned(
                    left: stamp.left,
                    top: stamp.top,
                    child: Container(
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                              child: GestureDetector(
                                onPanUpdate: (details) {
                                  setState(() {
                                    if(stamp.isDisable == false){
                                      stamp.left = max(0, stamp.left + details.delta.dx);
                                      stamp.top = max(0, stamp.top + details.delta.dy);
                                      print(stamp.getBoundingBox(_pageHeight, _pageWidth, widgetHeight, widgetWidth));
                                      print("left: ${stamp.left}");
                                      print("top: ${stamp.top}");
                                      print("x: ${stamp.x}");
                                      print("y: ${stamp.y}");
                                    }
                                  });
                                },
                                child: Container(
                                    width: stamp.x,
                                    height: stamp.x,
                                    decoration: BoxDecoration(),
                                    child: Stack(
                                      children: [
                                        Visibility(
                                          visible: !stamp.isDisable,
                                          child: Container(
                                            child: DottedBorder(
                                              child: Image.asset("assets/images/materai.jpg", width: stamp.x, height: stamp.x,),
                                            ),
                                          )
                                        ),
                                        Visibility(
                                          visible: stamp.isDisable,
                                          child: Image.asset("assets/images/materai.jpg", width: stamp.x, height: stamp.x,),
                                        ),
                                      ],
                                    )
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Positioned(
                              left: stamp.x,
                              top: stamp.x,
                              child: Visibility(
                                visible: !stamp.isDisable,
                                child: GestureDetector(
                                    onPanUpdate: (details) {
                                      setState(() {
                                        stamp.x += details.delta.dx;
                                        stamp.y += details.delta.dy;
                                        if(stamp.x >=  100 || stamp.y >= 100)  {
                                          stamp.x = 100;
                                          stamp.y = 100;
                                        };
                                        if(stamp.x <= 20 || stamp.y <= 20) {
                                          stamp.x = 20;
                                          stamp.y = 20;
                                        };
                                      });
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: Colors.red
                                      ),
                                      child: Image.asset("assets/images/maximize.png"),
                                    )
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                  );
                }).toList(),
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
                    isButtonEnabled?GestureDetector(
                      onTap: () {
                        setState(() {
                          if(stamps.length > 0 && isButtonEnabled == true){
                            stampCount--;
                            stamps.clear();
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
                          stamps[stampCount-1].isDisable = true;
                          print(stamps[stampCount-1].x);
                          print(stamps[stampCount-1].y);
                          stampList.insert(0, stamps[0].getBoundingBox(_pageHeight, _pageHeight, widgetHeight, widgetWidth));
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
                                _pdfViewerController.zoomLevel = (_pdfViewerController.zoomLevel - 0.5).clamp(1.0, 4.0);
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
                                _pdfViewerController.zoomLevel = (_pdfViewerController.zoomLevel + 0.5).clamp(1.0, 4.0);
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
                        child: Text('Page $_currentPage of $_totalPages'),
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
                                }
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
                                if (_currentPage < _totalPages) {
                                  _pdfViewerController.jumpToPage(_currentPage + 1);
                                }
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
            isButtonEnabled == true? FloatingActionButton(
              backgroundColor: textAlertColor2,
              onPressed: () {
                if(stamps.length < 1) {
                  setState(() {
                    stamps.add(Stamp(left: 104.376, top: 161.919, x: _scale, y: _scale));
                    stampCount++;
                    isButtonEnabled = false;
                    isConfirm = true;
                  });
                }
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
              EventDB.StampingSingleDocument(token, widget.docId, widget.docType, "jakarta", null, stamps[0].getBoundingBox(_pageHeight, _pageWidth, widgetHeight, widgetWidth));
            },
            child: Text('Submit'),
          ),
        ),
      ),
    );
  }
}

class Stamp {
  double left;
  double top;
  double x;
  double y;
  bool isDisable = false;

  Stamp({
    required this.left,
    required this.top,
    required this.x,  // width
    required this.y,  // height
  });

  Map<String, dynamic> getBoundingBox(double pageHeight, double pageWidth, double widgetHeight, double widgetWidth) {
    // Hitung rasio skala
    double scaleFactorX = widgetWidth / pageWidth;
    double scaleFactorY = widgetHeight / pageHeight;

    // Penyesuaian jika ada padding atau margin
    double horizontalPadding = (widgetWidth - (pageWidth * scaleFactorX)) / 2;

    // Konversi koordinat dengan skala dan padding
    double llx = (left - horizontalPadding) / scaleFactorX;
    double lly = (pageHeight - top - y) / scaleFactorY;
    double urx = (left + x - horizontalPadding) / scaleFactorX;
    double ury = (pageHeight - top) / scaleFactorY;

    Map<String, dynamic> result = {
      'llx': llx,
      'lly': lly,
      'page': 1,
      'urx': urx,
      'ury': ury,
    };

    return result;
  }
}
