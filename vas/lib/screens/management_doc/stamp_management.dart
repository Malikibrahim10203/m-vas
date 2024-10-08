import "dart:convert";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:ionicons/ionicons.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "package:scrollable_positioned_list/scrollable_positioned_list.dart";
import "package:vas/event/event_db.dart";
import "package:vas/event/event_pref.dart";
import "package:vas/models/bulk_document.dart";
import "package:vas/models/document.dart";
import "package:vas/models/user_log_activity.dart";
import "package:vas/screens/document/document_bulk_detail.dart";
import "package:vas/screens/document/document_single_detail.dart";
import "package:vas/widgets/components.dart";
import "package:vas/models/office.dart";

class StampManagement extends StatefulWidget {
  const StampManagement({super.key});

  @override
  State<StampManagement> createState() => _StampManagementState();
}

class _StampManagementState extends State<StampManagement> {
  var heightScreen;
  var widthScreen;

  var searchController = TextEditingController();

  var filterOfficeController = TextEditingController();
  var filterStatusController = TextEditingController();
  var filterOrderByController = TextEditingController();
  var filterOrderByTypeController = TextEditingController();

  var checkDocument;

  List<Datum> fetchedData = [];

  final ItemScrollController scrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  int lastIndex = 0;
  int lastPage = 0;

  var isLoadData = false;

  var token;

  var saldoEMet;
  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');
  var radioType, ascType, descType;
  int currentIndex = 0;
  int _selectedIndex = 2;

  List<Datum> filteredData = [];

  List<Office>? fetchOffice = [];

  var selectedStatus;
  var selectedOffice;




  bool isLoading = false;
  int page = 1;
  bool hasMore = true;

  List<DropdownButton> listStatus = [];

  Future<Document?>? document;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    token = (await EventPref.getCredential())?.data.token;

    document = EventDB.getDocuments(token, page,searchController.text, filterOrderByController.text, filterOrderByTypeController.text, filterOfficeController.text, '', '');

    final quotaFuture = EventDB.getQuota(token, "1");

    saldoEMet = (await quotaFuture)?.remaining;

    fetchOffice = await EventDB.getOffice(token);

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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    heightScreen = MediaQuery.of(context).size.height;
    widthScreen = MediaQuery.of(context).size.width;

    return document!=null?
    Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close, color: Colors.black,),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Stamp E-Materai",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
            ),
            IconButton(onPressed: () {}, icon: Image.asset("assets/images/contact-us.png", width: 20,))
          ],
        ),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                width: widthScreen * 0.9,
                height: heightScreen * 0.095,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: bluePrimary,
                    image: DecorationImage(
                        image: AssetImage("assets/images/box-seal-management.png"),
                        fit: BoxFit.cover
                    )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: greyColor6,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              "E-Materai Per-Seal",
                              style: TextStyle(
                                fontSize: widthScreen*0.03,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              saldoEMet!=null?
                              Text(
                                "${numberFormat.format(double.parse(saldoEMet))}",
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ):Text(
                                "Null",
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: widthScreen * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: widthScreen * 0.7,
                      height: heightScreen * 0.05,
                      child: CupertinoSearchTextField(
                        prefixInsets: EdgeInsets.symmetric(horizontal: 15),
                        suffixInsets: EdgeInsets.symmetric(horizontal: 15),
                        padding: EdgeInsets.zero,
                        controller: searchController,
                        onSubmitted: (value) {
                          searchController.text = value!;
                          fetchedData.clear();
                          document = EventDB.getDocuments(token, 1,searchController.text, filterOrderByController.text, filterOrderByTypeController.text, filterOfficeController.text, '', filterStatusController.text);
                          setState(() {

                          });
                        },
                        onSuffixTap: () {
                          searchController.clear();
                          fetchedData.clear();
                          document = EventDB.getDocuments(token, 1,searchController.text, filterOrderByController.text, filterOrderByTypeController.text, filterOfficeController.text, '', filterStatusController.text);
                          setState(() {

                          });
                        },
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                spreadRadius: 1,
                                blurRadius: 15,
                              )
                            ],
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                    ),
                    Container(
                        width: widthScreen * 0.12,
                        height: heightScreen * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                        ),
                        child: InkWell(
                          onTap: () async {
                            return showMaterialModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, StateSetter setSetter) {
                                    return Container(
                                      height: 570,
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                      Ionicons.filter
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    'FILTER',
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 16
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(Icons.close),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Office",
                                                style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.w500
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 55,
                                            child: DropdownButtonFormField<int>(
                                              value: selectedOffice,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 1),
                                                      borderRadius: BorderRadius.circular(10))),
                                              items: fetchOffice!.map((value) {
                                                return DropdownMenuItem<int>(
                                                  value: value.officeId,
                                                  child: Text(
                                                    value.officeName,
                                                    style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w400,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              hint: Text("-- Status Document --"),
                                              onChanged: (newValue) {
                                                setSetter(() {
                                                  selectedOffice = newValue;
                                                  filterOfficeController.text = selectedOffice.toString();
                                                  print(selectedOffice);
                                                });
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Status",
                                                style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.w500
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 55,
                                            child: DropdownButtonFormField<String>(
                                              value: selectedStatus,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 1),
                                                      borderRadius: BorderRadius.circular(10))),
                                              items: <String>['Draft', 'On Progress', 'Done', 'Un Done']
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              hint: Text("-- Status Document --"),
                                              onChanged: (value) {
                                                setSetter(() {
                                                  selectedStatus = value; // Update the state variable on selection
                                                  if (value == 'Draft') {
                                                    filterStatusController.text = '0';
                                                  } else if (value == 'On Progress') {
                                                    filterStatusController.text = '1';
                                                  } else if (value == 'Done') {
                                                    filterStatusController.text = '2';
                                                  } else {
                                                    filterStatusController.text = '3';
                                                  }
                                                  print(filterStatusController.text);
                                                });
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Order By",
                                                style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.w500
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 55,
                                            child: DropdownButtonFormField(
                                              value: filterOrderByController.text.isEmpty? null:filterOrderByController.text,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          width: 1
                                                      ),
                                                      borderRadius: BorderRadius.circular(10)
                                                  )
                                              ),
                                              items: <String>['created_at','doc_name', 'status'].map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              hint: Text("-- Order By --"),
                                              onChanged: (value) {
                                                setSetter(() {
                                                  filterOrderByController.text = value!;
                                                });
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Order By Type",
                                                style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.w500
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Radio<String>(
                                                value: "asc",
                                                groupValue: radioType,
                                                onChanged: (String? value) {
                                                  setSetter(() {
                                                    radioType = value;
                                                    ascType = true;  // Set ascending to true
                                                    descType = false; // Set descending to false
                                                    print(radioType);
                                                    filterOrderByTypeController.text = value!; // Set the controller text
                                                  });
                                                },
                                              ),
                                              Text("Asc"),

                                              Radio<String>(
                                                value: "desc",
                                                groupValue: radioType,
                                                onChanged: (String? value) {
                                                  setSetter(() {
                                                    radioType = value;
                                                    ascType = false;
                                                    descType = true;
                                                    print(radioType);
                                                    filterOrderByTypeController.text = value!; // Set the controller text
                                                  });
                                                },
                                              ),
                                              Text("Desc"),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: widthScreen * 0.25,
                                                height: 50,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                          side: BorderSide(width: 1, color: Colors.black.withOpacity(0.1))
                                                      ),
                                                      backgroundColor: Colors.white
                                                  ),
                                                  onPressed: () {
                                                    setSetter(() {
                                                      filterOfficeController.clear();
                                                      filterStatusController.clear();
                                                      filterOrderByController.clear();
                                                      filterOrderByTypeController.clear();
                                                      selectedStatus = null;
                                                      selectedOffice = null;
                                                      radioType = null;
                                                    });

                                                    setState(() {
                                                      page = 1;
                                                      fetchedData.clear();
                                                      document = EventDB.getDocuments(token, page,searchController.text, filterOrderByController.text, filterOrderByTypeController.text, filterOfficeController.text, '', filterStatusController.text);
                                                    });
                                                  },
                                                  child: Text(
                                                    "Reset",
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 12,
                                                        color: Colors.black
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: widthScreen * 0.6,
                                                height: 50,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10)
                                                      )
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();  // Close the modal

                                                    setState(() {

                                                      page = 1;

                                                      // Apply office filter
                                                      fetchedData.clear();

                                                      if (filterOfficeController.text.isNotEmpty) {
                                                        document = EventDB.getDocuments(token, page,searchController.text, filterOrderByController.text, filterOrderByTypeController.text, filterOfficeController.text, '', filterStatusController.text);
                                                      }

                                                      // Apply status filter
                                                      if (filterStatusController.text.isNotEmpty) {
                                                        document = EventDB.getDocuments(token, page,searchController.text, filterOrderByController.text, filterOrderByTypeController.text, filterOfficeController.text, '', filterStatusController.text);
                                                      }

                                                      // Apply sorting based on filterOrderByController
                                                      if (filterOrderByController.text.isNotEmpty) {
                                                        String orderBy = filterOrderByController.text.toLowerCase();

                                                        if(filterOrderByTypeController.text.isNotEmpty) {
                                                          document = EventDB.getDocuments(token, page,searchController.text, orderBy, filterOrderByTypeController.text, filterOfficeController.text, '', filterStatusController.text);
                                                        }
                                                      }
                                                    });
                                                  },
                                                  child: Text("Apply"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Image.asset("assets/images/filter.png",),
                          ),
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 400,
                height: heightScreen * 0.7,
                child: Column(
                  children: [
                    Expanded(
                      child: FutureBuilder<Document?>(
                        future: document,
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                            return Center(child: Text('No documents available.'));
                          } else {
                            List<Datum> newDocData = snapshot.data!.data;

                            // if (searchController.text.isNotEmpty || filterOfficeController.text.isNotEmpty || filterStatusController.text.isNotEmpty || filterOrderByController.text.isNotEmpty) {
                            //   fetchedData.clear();
                            // }

                            // Update fetchedData to include new documents without duplicates
                            for (var datum in newDocData) {
                              if (!fetchedData.any((existing) => existing.docId == datum.docId)) {
                                fetchedData.add(datum);
                              }
                            }

                            // Apply filters to fetchedData
                            filteredData = List.from(fetchedData);


                            if (isLoadData == true) {
                              print("P:${fetchedData.length}-$lastIndex");
                              if(fetchedData.length > lastIndex) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  if (scrollController.isAttached) {
                                    scrollController.jumpTo(index: lastIndex);
                                    isLoadData = false;
                                  }
                                });
                              } else if(newDocData.length < 15) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  if (scrollController.isAttached) {
                                    scrollController.jumpTo(index: 1);
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

                            return NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && hasMore && !isLoading) {
                                  setState(() {
                                    isLoading = true;
                                    page++;
                                    print("Page: $page");
                                  });

                                  // Ensure this method is marked as async so you can await the Future
                                  EventDB.getDocuments(token, page, searchController.text, filterOrderByController.text, filterOrderByTypeController.text, filterOfficeController.text, '', '').then((checkDocument) {
                                    if (checkDocument != null && checkDocument.data.isNotEmpty) {
                                      setState(() {
                                        // Assign the resolved value directly to the document variable
                                        document = Future.value(checkDocument); // Assign Future<Document?>? properly
                                        lastIndex += 13;
                                        print(lastIndex);
                                        isLoadData = true;
                                        print("PP:${fetchedData.length}+${filteredData.length}");
                                      });

                                      setState(() {
                                        isLoading = false;
                                      });
                                    } else {
                                      setState(() {
                                        page--;
                                        isLoading = false;
                                      });

                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        if (scrollController.isAttached) {
                                          scrollController.jumpTo(index: filteredData.length);
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
                              child: ScrollablePositionedList.builder(
                                itemScrollController: scrollController,
                                itemPositionsListener: itemPositionsListener,
                                itemCount: filteredData.length,
                                itemBuilder: (context, index) {

                                  if (index == filteredData.length) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  Datum datum = filteredData[index];

                                  return GestureDetector(
                                    onTap: () async {
                                      print(datum.docId);

                                      List statusChip = [
                                        datum.isStamped,
                                        datum.isSigned,
                                        datum.isTera,
                                      ];

                                      if (datum.isFolder) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DocumentBulkDetail(
                                              docId: datum.docId,
                                              isFolder: datum.isFolder,
                                              statusChip: statusChip,
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DocumentSingleDetail(
                                              docId: datum.docId,
                                              isFolder: datum.isFolder,
                                              statusChip: statusChip,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: cardListDocument(
                                        widthScreen,
                                        heightScreen,
                                        datum.docName,
                                        datum.createdAt.toLocal(),
                                        datum.isFolder,
                                        datum.isStamped,
                                        datum.isSigned,
                                        datum.isTera,
                                        datum.stampStatus
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        child: Column(
          children: [
            SizedBox(
              height: heightScreen * 0.9,
            ),
            FloatingActionButton(
              shape: CircleBorder(),
              onPressed: () async {
                searchController.text==null?
                print("null"):print("not null");
                print(searchController.text);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Color(0xff0081F1),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Icon(
                  Icons.file_upload_outlined,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              backgroundColor: Color(0xffEFF5FF),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    ):
    Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}