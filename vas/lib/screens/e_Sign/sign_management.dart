import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_speed_dial/flutter_speed_dial.dart";
import "package:intl/intl.dart";
import "package:vas/event/event_db.dart";
import "package:vas/event/event_pref.dart";
import "package:vas/screens/document/document_detail.dart";
import "package:vas/screens/upload_document/upload_bulk.dart";
import "package:vas/screens/upload_document/upload_single.dart";
import "package:vas/widgets/components.dart";

class SignManagement extends StatefulWidget {
  const SignManagement({super.key});

  @override
  State<SignManagement> createState() => _SignManagementState();
}

class _SignManagementState extends State<SignManagement> {

  var heightScreen;
  var widthScreen;

  var token;

  var saldoEMet;

  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');

  int currentIndex = 0;

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> getData() async {
    token = (await EventPref.getCredential())?.data.token;

    saldoEMet = (await EventDB.getQuota(token, "1"))?.remaining;

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

    return Scaffold(
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
        )
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                width: widthScreen * 0.95,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: widthScreen * 0.7,
                    height: heightScreen * 0.05,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            spreadRadius: 1,
                            blurRadius: 15,
                          )
                        ]
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Icon(Icons.search),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Search.."),
                      ],
                    ),
                  ),
                  Container(
                    width: widthScreen * 0.12,
                    height: heightScreen * 0.05,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            spreadRadius: 1,
                            blurRadius: 15,
                          )
                        ]
                    ),
                    child: Icon(Icons.filter_list),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: widthScreen * 0.87,
                height: heightScreen * 0.12,
                padding: EdgeInsets.symmetric(vertical: 16,horizontal: 25),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 20,
                      )
                    ]
                ),
                child: Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: bluePrimary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Icon(Icons.file_present_sharp, color: bluePrimary,),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: widthScreen * 0.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Surat Perjanjian",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              Text(
                                "draf",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                "06 Juli 2023",
                                style: TextStyle(
                                    fontSize: 10
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                "Single",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              chipTag("E-Materai"),
                              SizedBox(
                                width: 10,
                              ),
                              chipTag("E-Sign"),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: widthScreen * 0.87,
                height: heightScreen * 0.12,
                padding: EdgeInsets.symmetric(vertical: 16,horizontal: 25),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 20,
                      )
                    ]
                ),
                child: Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: bluePrimary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Icon(Icons.file_present_sharp, color: bluePrimary,),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: widthScreen * 0.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Surat Perjanjian",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              Text(
                                "draf",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                "06 Juli 2023",
                                style: TextStyle(
                                    fontSize: 10
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                "Single",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              chipTag("E-Materai"),
                              SizedBox(
                                width: 10,
                              ),
                              chipTag("E-Sign"),
                            ],
                          )
                        ],
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
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () async {
          showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Upload Document",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Image.asset("assets/images/upload_single.png", width: 30,),
                      title: new Text('Single File'),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadSingle()));
                      },
                    ),
                    Divider(
                        height: 2,
                        color: Colors.grey
                    ),
                    ListTile(
                      leading: Image.asset("assets/images/upload_bulk.png", width: 30,),
                      title: new Text('Bulk File'),
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadBulk()));
                      },
                    ),
                  ],
                );
              });
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
            _bottomAppBar(0, "bar-home", "Home", DocumentDetail()),
            SizedBox(width: 5),
            _bottomAppBar(1, "bar-doc", "Document", DocumentDetail()),
            SizedBox(width: 48),
            _bottomAppBar(2, "bar-chat", "Chat", DocumentDetail()),
            SizedBox(width: 5),
            _bottomAppBar(3, "bar-setting", "Setting", DocumentDetail()),
          ],
        ),
      ),
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
