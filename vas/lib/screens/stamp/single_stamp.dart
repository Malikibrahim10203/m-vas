import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:vas/widgets/components.dart';

class SingleStamp extends StatefulWidget {
  const SingleStamp({super.key, required this.docType, required this.docFile});

  final docType, docFile;

  @override
  State<SingleStamp> createState() => _SingleStampState();
}

class _SingleStampState extends State<SingleStamp> {
  late PdfViewerController _pdfViewerController;
  int _currentPage = 1;
  final int _totalPages = 10;
  double _scale = 30;

  List<Stamp> stamps = [];
  int stampCount = 1;
  bool isButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF6FAFF),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Stamp E-Materai', style: TextStyle(color: Colors.black.withOpacity(0.5)),),
            IconButton(
              onPressed: () {

              },
              icon: Icon(Icons.message_outlined, color: Colors.black.withOpacity(0.5),),
            ),
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
                Container(
                  height: 650,
                  child: SfPdfViewer.asset(
                    'assets/document/sample.pdf',
                    controller: _pdfViewerController,
                    scrollDirection: PdfScrollDirection.horizontal,
                    enableDoubleTapZooming: false,
                    onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                      // Set total pages dynamically if needed
                    },
                    onPageChanged: (PdfPageChangedDetails details) {
                      setState(() {
                        _currentPage = details.newPageNumber;
                      });
                    },
                  ),
                ),
                ...stamps.map((stamp) {
                  return Positioned(
                    left: stamp.left,
                    top: stamp.top,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                stamp.left = max(0, stamp.left + details.delta.dx);
                                stamp.top = max(0, stamp.top + details.delta.dy);
                              });
                            },
                            child: Image.asset("assets/images/materai.jpg", height: _scale),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onPanUpdate: (details) {
                                  setState(() {
                                    _scale += details.delta.dy;
                                    if(_scale >= 100) _scale = 100;
                                    if(_scale <= 20) _scale = 20;
                                  });
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.red
                                  ),
                                  child: Icon(
                                    Icons.zoom_out_map,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                )
                              ),
                            ],
                          ),
                        ],
                      )
                    )
                  );
                }).toList(),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 70,
            child: Row(
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
          ),
        ],
      ),
      floatingActionButton: Container(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
            ),
            FloatingActionButton(
              backgroundColor: textAlertRedColor3,
              onPressed: () {
                setState(() {
                  stamps.add(Stamp(left: 104.376, top: 161.919));
                  stampCount++;
                  isButtonEnabled = false;
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
            onPressed: () {},
            child: Text('Sumbit'),
          ),
        ),
      ),
    );
  }
}

class Stamp {
  double left;
  double top;
  bool isDisable = true;

  Stamp({required this.left, required this.top});
}

