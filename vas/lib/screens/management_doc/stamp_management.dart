import "dart:convert";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:vas/event/event_db.dart";
import "package:vas/event/event_pref.dart";
import "package:vas/models/document.dart";
import "package:vas/screens/document/document_bulk_detail.dart";
import "package:vas/screens/document/document_single_detail.dart";
import "package:vas/widgets/components.dart";


class StampManagement extends StatefulWidget {
  const StampManagement({super.key});

  @override
  State<StampManagement> createState() => _StampManagementState();
}

class _StampManagementState extends State<StampManagement> {
  var heightScreen;
  var widthScreen;

  var searchController = TextEditingController();

  var token;

  var saldoEMet;

  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');

  int currentIndex = 0;

  int _selectedIndex = 2;

  Future<Document?>? document;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> getData() async {
    token = (await EventPref.getCredential())?.data.token;

    saldoEMet = (await EventDB.getQuota(token, "1"))?.remaining;
    document = EventDB.getDocuments(token);

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
                          print(searchController.text);
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
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent,
                      ),
                      child: Image.asset("assets/images/filter.png",),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: 400,
                  height: heightScreen * 0.65,
                  child: Column(
                    children: [
                      Expanded(
                        child: FutureBuilder<Document?>(
                          future: document,
                          builder: (BuildContext context, snapshot) {

                            if(snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if(snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if(!snapshot.hasData || snapshot.data!.data.isEmpty) {
                              return Center(child: Text('No documents available.'));
                            } else {
                              return ListView.separated(
                                separatorBuilder: (BuildContext context, index){
                                  return SizedBox(
                                    height: 1,
                                  );
                                },
                                itemCount: snapshot.data!.data.length,
                                itemBuilder: (context, index) {
                                  Datum datum = snapshot.data!.data[index];
                                  return GestureDetector(
                                    onTap: () async {
                                      print(datum.docId);

                                      List statusChip = [datum.isStamped, datum.isSigned, datum.isTera];

                                      datum.isFolder?
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>DocumentBulkDetail(docId: datum.docId, isFolder: datum.isFolder, statusChip: statusChip,))):
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>DocumentSingleDetail(docId: datum.docId, isFolder: datum.isFolder, statusChip: statusChip,)));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: cardListDocument(widthScreen, heightScreen, datum.docName, datum.createdAt.toString(), datum.isFolder, datum.isStamped, datum.isSigned, datum.isTera),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () async {
          // Assume `token` is already defined and passed correctly
          Document? document = await EventDB.getDocuments(token);

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
            Icons.file_upload_outlined,
            color: Colors.white,
            size: 25,
          ),
        ),
        backgroundColor: Color(0xffEFF5FF),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _bottomAppBar(0, "bar-home", "Home", ""),
            SizedBox(width: 5),
            _bottomAppBar(1, "bar-doc", "Document", ""),
            SizedBox(width: 48),
            _bottomAppBar(2, "bar-chat", "Chat", ""),
            SizedBox(width: 5),
            _bottomAppBar(3, "bar-setting", "Setting", ""),
          ],
        ),
      ),
    ):
    Scaffold(
      body: CircularProgressIndicator(),
    );
  }

  Widget _bottomAppBar(item,icon,text,route) {
    return GestureDetector(
      onTap: () {
        _onItemTapped(item);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>route));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/$icon.png", width: 30,),
          SizedBox(
            height: 5,
          ),
          Text(
            "${text}",
            style: TextStyle(
              color: item!=_selectedIndex?greyColor3:primaryColor2,
            ),
          ),
        ],
      ),
    );
  }
}
