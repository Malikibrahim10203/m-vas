import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/event/event_camerapref.dart';
import 'package:vas/event/event_db.dart';
import 'package:vas/event/event_pref.dart';
import 'package:vas/models/module.dart';
import 'package:vas/models/quota.dart';
import 'package:vas/models/users.dart';
import 'package:vas/screens/e-Kyc/regist_esign.dart';
import 'package:vas/screens/upload_document/upload_bulk.dart';
import 'package:vas/screens/upload_document/upload_single.dart';
import 'package:vas/widgets/components.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.token});

  final token;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {


  var size;
  var widthScreen, heightScreen;
  String? fullName;
  String? officeName;
  String? email;
  String? password;
  String? token;
  var statusRegistrationPeruri;
  var data;
  var province_id;
  var deptName;
  var signCertStatus;

  ModuleData? module;
  bool? signM, stampM, officeM;

  var saldoEMet;
  var saldoESign;

  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');

  int certificate = 0;

  int currentIndex = 0;

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> getData() async {
    token = (await EventPref.getCredential())?.data.token;
    email = (await EventPref.getCredential())?.email;
    password = (await EventPref.getCredential())?.password;

    Future.delayed(Duration(seconds: 2), () async {
      if(fullName==null) {
        data = await EventDB.getlogin(email??'', password??'');
        token = data.data.token;
        print(data.data.token);
      }
    });

    User? user = await EventDB.getUser(token??'', email??'', password??'');
    fullName = user?.fullName;
    officeName = user?.officeName;
    deptName = user?.deptName;

    signCertStatus = int.parse(user!.signCertStatus!);
    statusRegistrationPeruri = user!.statusRegistrationPeruri;

    print("statusRegistrationPeruri: $statusRegistrationPeruri");
    print("signCertStatus: $signCertStatus");


    // Get Module
    // token = (await EventPref.getCredential())?.data.token;
    module = (await EventDB.getModule(token??''));
    signM = module!.signM;
    stampM = module!.stampM;

    // Get Quota
    // token = (await EventPref.getCredential())?.data.token;
    saldoEMet = (await EventDB.getQuota(token??'', "1"))?.remaining;
    saldoESign = (await EventDB.getQuota(token??'', "2"))?.remaining;

    certificate = 1;

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  void initState() {
    // TODO: implement initState
    getData();
    CameraPref.clearCameraPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    widthScreen = size.width;
    heightScreen = size.height;

    Widget certificateStatusWidget;

    if (statusRegistrationPeruri == null) {
      certificateStatusWidget = CertificateStatusNotActive(heightScreen, widthScreen, context);
    } else if (statusRegistrationPeruri > 2 && signCertStatus == null) {
      certificateStatusWidget = CertificateStatusProgress(heightScreen, widthScreen);
    } else if (statusRegistrationPeruri > 2 && (signCertStatus == 0 || signCertStatus == 2)) {
      certificateStatusWidget = CertificateStatusActive(heightScreen, widthScreen);
    } else if (statusRegistrationPeruri > 2 && signCertStatus == 1) {
      certificateStatusWidget = CertificateStatusExpired(heightScreen, widthScreen);
    } else {
      certificateStatusWidget = Text("data");
    }

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Color(0xffF4F4F4),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: size.width * 1,
                height: 165,
                decoration: BoxDecoration(
                    color: bluePrimary,
                    image: DecorationImage(
                        image: AssetImage("assets/images/bg-db.png"),
                        fit: BoxFit.cover
                    ),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))
                ),
                child: Container(
                  padding: EdgeInsets.only(top: 25),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 75,
                                    height: 75,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white
                                    ),
                                  ),
                                  Container(
                                    width: 70,
                                    height: 70,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset("assets/images/user.png",),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Good Morning!",
                                        style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
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
                                        fullName??'',
                                        style: GoogleFonts.roboto(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
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
                                        officeName??'',
                                        style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  EventDB.LogOut();
                                },
                                icon: Icon(
                                  Icons.notifications_active,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.all(15),
                  width: size.width * 1,
                  height: 640,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: size.width * 0.9,
                        height: 100,
                        padding: EdgeInsets.only(top: heightScreen * 0.03),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/box-seal-db.png"),
                                fit: BoxFit.cover
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
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
                                  width: 10,
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
                                          ):Text("0"),
                                          Icon(
                                            Icons.warning,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
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
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "E-Sign Per-Sign",
                                          style: TextStyle(
                                            fontSize: widthScreen*0.03,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
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
                                          ):Text("0"),
                                          Icon(
                                            Icons.warning,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // signM==true?
                      // statusRegistrationPeruri==null?CertificateStatusNotActive(heightScreen, widthScreen, context):
                      // statusRegistrationPeruri==1?CertificateStatusProgress(heightScreen, widthScreen):
                      // CertificateStatusProgress(heightScreen, widthScreen): Container(),

                      certificateStatusWidget,

                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            "Quick Action",
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          signM==true?MenuActive():Container(),
                          SizedBox(height: 3,),
                          stampM==true?Menu("assets/images/emet.png","Stamp e-Materai"): Container(),
                          SizedBox(height: 3,),
                          Menu("assets/images/tera.png","Stamp Tera"),
                          SizedBox(height: 3,),
                          Menu("assets/images/recap.png","Recapitulation"),
                          SizedBox(height: 3,),
                          Menu("assets/images/contact-us.png","Contact Us"),
                          SizedBox(height: 3,),
                        ],
                      )
                    ],
                  )
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(15),
                width: size.width * 1,
                height: size.height * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Activity History",
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        GestureDetector(
                          onTap: (){},
                          child: Text(
                            "view all",
                            style: TextStyle(
                                color: primaryColor2,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Stack(
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: () async {
            // AlertSuccess(context, RegistEsign(), 'Registration Success', 'You have submit the data! Please check your email to activate your account');
            showModalBottomSheet(
                context: context,
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
                        leading: new Icon(
                            Icons.file_copy),
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
                        leading: new Icon(
                            Icons.file_copy),
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
              _bottomAppBar(0, Icons.home, "Home"),
              SizedBox(width: 5),
              _bottomAppBar(1, Icons.folder, "Document"),
              SizedBox(width: 48), // Space for the FAB
              _bottomAppBar(2, Icons.chat_outlined, "Chat"),
              SizedBox(width: 5),
              _bottomAppBar(3, Icons.settings, "Setting"),
            ],
          ),
        ),
      ),
    );
  }
  Widget _bottomAppBar(item,icon,text) {
    return GestureDetector(
      onTap: () => _onItemTapped(item),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: item!=_selectedIndex?greyColor3:primaryColor2,
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
  // Menu NotActive
  Widget Menu(logo,name) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 20,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: greyColor6,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Image.asset(logo),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${name}'),
          ],
        ),
      ),
    );
  }
}