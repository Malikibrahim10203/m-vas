import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:vas/widgets/components.dart';

class SingleStamp extends StatefulWidget {
  const SingleStamp({super.key, required this.docType});

  final docType;

  @override
  State<SingleStamp> createState() => _SingleStampState();
}

class _SingleStampState extends State<SingleStamp> {
  late PdfViewerController _pdfViewerController;
  int _currentPage = 1;
  final int _totalPages = 10; // This should be dynamically obtained from the document

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
      body: Container(
        child: ListView(
          children: [
            SizedBox(
              height: 50,
            ),
            Stack(
              children: [
                Container(
                  height: 650,
                  child: SfPdfViewer.network(
                    'https://koreascience.kr/article/CFKO202015463051450.pdf',
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
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Container(
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
                                  color: Colors.white
                              ),
                              child: IconButton(
                                icon: Icon(Icons.zoom_out),
                                onPressed: () {
                                  _pdfViewerController.zoomLevel = (_pdfViewerController.zoomLevel - 0.5).clamp(1.0, 4.0);
                                },
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.white
                              ),
                              child: IconButton(
                                icon: Icon(Icons.zoom_in),
                                onPressed: () {
                                  _pdfViewerController.zoomLevel = (_pdfViewerController.zoomLevel + 0.5).clamp(1.0, 4.0);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white
                        ),
                        child: Center(child: Text('Page $_currentPage of $_totalPages')),
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
                                  color: Colors.white
                              ),
                              child: IconButton(
                                icon: Icon(Icons.navigate_before),
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
                                  color: Colors.white
                              ),
                              child: IconButton(
                                icon: Icon(Icons.navigate_next),
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
                )
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
            ),
            FloatingActionButton(
              backgroundColor: textAlertRedColor3,
              onPressed: () {},
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

