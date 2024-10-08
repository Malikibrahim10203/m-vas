import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:vas/event/event_db.dart';
import 'package:vas/event/event_pref.dart';

class ViewSingleDocument extends StatefulWidget {
  const ViewSingleDocument({super.key, required this.docId});

  final docId;

  @override
  State<ViewSingleDocument> createState() => _ViewSingleDocumentState();
}

class _ViewSingleDocumentState extends State<ViewSingleDocument> {


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


  int stampCount = 0;
  bool isButtonEnabled = true;

  bool isConfirm = false;

  var fileBase64;
  Uint8List? filePdf;
  var token;

  Future<void> getData() async {
    token = (await EventPref.getCredential())?.data.token;
    fileBase64 = await EventDB.getPreviewDocument(token, int.parse(widget.docId));
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
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
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
    );
  }
}
