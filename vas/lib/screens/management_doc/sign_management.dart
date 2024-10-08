import "dart:convert";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "package:vas/event/event_db.dart";
import "package:vas/event/event_pref.dart";
import "package:vas/models/document.dart";
import "package:vas/screens/document/document_bulk_detail.dart";
import "package:vas/screens/document/document_single_detail.dart";
import "package:vas/widgets/components.dart";

class SignManagement extends StatefulWidget {
  const SignManagement({super.key});

  @override
  State<SignManagement> createState() => _SignManagementState();
}

class _SignManagementState extends State<SignManagement> {

  var heightScreen;
  var widthScreen;

  var searchController = TextEditingController();

  var token;
  int page = 1;

  var saldoESign;

  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');

  int currentIndex = 0;

  int _selectedIndex = 2;

  var filterOfficeController = TextEditingController();
  var filterStatusController = TextEditingController();
  var filterOrderByController = TextEditingController();
  var filterOrderByTypeController = TextEditingController();

  Future<Document?>? document;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> getData() async {
    token = (await EventPref.getCredential())?.data.token;

    saldoESign = (await EventDB.getQuota(token, "2"))?.remaining;
    document = EventDB.getDocuments(token, page,searchController.text, filterOrderByController.text, filterOrderByTypeController.text, filterOfficeController.text, '', '');

    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
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
                              "E-Sign Per-Seal",
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
                              saldoESign!=null?
                              Text(
                                "${numberFormat.format(double.parse(saldoESign))}",
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
                          setState(() {

                          });
                        },
                        onChanged: (value) {
                          searchController.text = value!;
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
                                return Container(
                                  height: 550,
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "search",
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w500
                                            ),
                                          ),
                                          Text(
                                            "Reset",
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black.withOpacity(0.2)
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Text("Office"),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 55,
                                        child: TextFormField(
                                          controller: filterOfficeController,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 1
                                                  ),
                                                  borderRadius: BorderRadius.circular(10)
                                              )
                                          ),
                                          onEditingComplete: () {
                                            setState(() {

                                            });
                                          },
                                          onTapOutside: (value) {
                                            setState(() {

                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Text("Status"),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 55,
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 1
                                                  ),
                                                  borderRadius: BorderRadius.circular(10)
                                              )
                                          ),
                                          items: <String>['Draft', 'On Progress', 'Done', 'Un Done'].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          hint: Text("-- Status Document --"),
                                          onChanged: (value) {
                                            if (value == 'Draft') {
                                              filterStatusController.text = '0';
                                            } else if (value == 'On Progress') {
                                              filterStatusController.text = '1';
                                            } else if (value == 'Done') {
                                              filterStatusController.text = '2';
                                            } else {
                                              filterStatusController.text = '3';
                                            }
                                            setState(() {
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
                                          Text("Order By"),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 55,
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 1
                                                  ),
                                                  borderRadius: BorderRadius.circular(10)
                                              )
                                          ),
                                          items: <String>['Document Name', 'Status'].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          hint: Text("-- Status Document --"),
                                          onChanged: (value) {
                                            filterOrderByController.text = value as String;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Text("Order By Type"),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          RadioMenuButton(value: (), groupValue: context, onChanged: (value) { filterOrderByTypeController.text = value as String; }, child: Text("Asc")),
                                          RadioMenuButton(value: (), groupValue: context, onChanged: (value) { filterOrderByTypeController.text = value as String; }, child: Text("Desc")),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width: 300,
                                        height: 50,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10)
                                              )
                                          ),
                                          onPressed: () {},
                                          child: Text("Apply"),
                                        ),
                                      ),
                                    ],
                                  ),
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
                            List<Datum> docData = snapshot.data!.data;
                            List<Datum> filteredData = docData;

                            // Apply search filter if there's text in the search field
                            if (searchController.text.isNotEmpty) {

                              filteredData = filteredData.where((datum) =>
                                  datum.docName.toLowerCase().contains(searchController.text.toLowerCase())).toList();
                            }

                            // Apply office filter if there's text in the office field
                            if (filterOfficeController.text.isNotEmpty) {
                              filteredData = filteredData.where((datum) =>
                                  datum.officeName.toLowerCase().contains(filterOfficeController.text.toLowerCase())).toList();
                            }

                            // Apply status filter if there's text in the status field
                            if (filterStatusController.text.isNotEmpty) {
                              filteredData = filteredData.where((datum) =>
                              datum.stampStatus == int.parse(filterStatusController.text)).toList();
                            }

                            return ListView.separated(
                              separatorBuilder: (BuildContext context, index) {
                                return SizedBox(
                                  height: 1,
                                );
                              },
                              itemCount: filteredData.length,
                              itemBuilder: (context, index) {
                                Datum datum = filteredData[index];

                                return GestureDetector(
                                  onTap: () async {
                                    print(datum.docId);

                                    List statusChip = [datum.isStamped, datum.isSigned, datum.isTera];

                                    datum.isFolder
                                        ? Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentBulkDetail(docId: datum.docId, isFolder: datum.isFolder, statusChip: statusChip,)))
                                        : Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentSingleDetail(docId: datum.docId, isFolder: datum.isFolder, statusChip: statusChip,)));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: cardListDocument(widthScreen, heightScreen, datum.docName, datum.createdAt.toString(), datum.isFolder, datum.isStamped, datum.isSigned, datum.isTera, datum.stampStatus),
                                  ),
                                );
                              },
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
                  // Assume `token` is already defined and passed correctly
                  Document? document = await EventDB.getDocuments(token, page,searchController.text, filterOrderByController.text, filterOrderByTypeController.text, filterOfficeController.text, '', '');

                  if (document != null && document.data.isNotEmpty) {
                    Datum firstDatum = document.data[2];

                    // Convert the first Datum to JSON for better readability
                    String datumJson = jsonEncode(firstDatum.toJson());

                    // Print the full data of the first Datum
                    print('First Datum: $datumJson');
                  } else {
                    print("Failed to retrieve document data or no data available.");
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Color(0xff0081F1),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Icon(
                    Icons.pending_outlined,
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