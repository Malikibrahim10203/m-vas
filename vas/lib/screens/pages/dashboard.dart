import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:vas/event/event_camerapref.dart';
import 'package:vas/event/event_db.dart';
import 'package:vas/event/event_pref.dart';
import 'package:vas/models/module.dart';
import 'package:vas/models/user_log_activity.dart';
import 'package:vas/screens/management_doc/sign_management.dart';
import 'package:vas/screens/loading.dart';
import 'package:vas/screens/management_doc/stamp_management.dart';
import 'package:vas/screens/upload_document/upload_bulk.dart';
import 'package:vas/screens/upload_document/upload_single.dart';
import 'package:vas/services/UserProvider.dart';
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

  var heightMenu;

  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');

  int certificate = 0;

  int currentIndex = 0;

  int _selectedIndex = 2;

  Future<UserLogActivity?>? dataLog;
  List<StepperData> stepperData = [];

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

    dataLog = EventDB.getLogActivity(token);


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

    final userProvider = Provider.of<Userprovider>(context);

    if (userProvider.user == null || module == null) {
      return Center(
        child: Loading(),
      );
    }

    fullName = userProvider.user?.fullName;
    officeName = userProvider.user?.officeName;
    deptName = userProvider.user?.deptName;

    signCertStatus = userProvider.user?.signCertStatus != null
        ? int.tryParse(userProvider.user!.signCertStatus!)
        : null;
    statusRegistrationPeruri = userProvider.user?.statusRegistrationPeruri;

    // Handle different certificate status conditions
    if (statusRegistrationPeruri == null) {
      certificateStatusWidget = CertificateStatusNotActive(heightScreen, widthScreen, context);
      heightMenu = heightScreen * 0.68;
    } else if (statusRegistrationPeruri > 2 && signCertStatus == null) {
      certificateStatusWidget = CertificateStatusProgress(heightScreen, widthScreen);
      heightMenu = heightScreen * 0.65;
    } else if (statusRegistrationPeruri > 2 && (signCertStatus == 0 || signCertStatus == 2)) {
      certificateStatusWidget = CertificateStatusActive(heightScreen, widthScreen);
      heightMenu = heightScreen * 0.63;
    } else if (statusRegistrationPeruri > 2 && signCertStatus == 1) {
      certificateStatusWidget = CertificateStatusExpired(heightScreen, widthScreen);
      heightMenu = heightScreen * 0.63;
    } else {
      certificateStatusWidget = Container();
      heightMenu = heightScreen * 0.53;
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
                  height: heightMenu,
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
                          stampM==true?Menu("assets/images/emet.png","Stamp e-Materai", StampManagement()): Container(),
                          SizedBox(height: 3,),
                          Menu("assets/images/tera.png","Stamp Tera", SignManagement()),
                          SizedBox(height: 3,),
                          Menu("assets/images/recap.png","Recapitulation", SignManagement()),
                          SizedBox(height: 3,),
                          Menu("assets/images/contact-us.png","Contact Us", SignManagement()),
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
                          onTap: () {

                          },
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
                      height: 10,
                    ),
                    Container(
                      height: heightScreen * 0.316,
                      child: Column(
                        children: [
                          Expanded(
                            child: FutureBuilder<UserLogActivity?>(
                              future: dataLog,
                              builder: (BuildContext context, snapshot) {
                                if(snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if(snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                } else if(!snapshot.hasData || snapshot.data!.data.isEmpty) {
                                  return Center(
                                    child: Stack(
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
                                    ),
                                  );
                                } else {
                                  for(var i = 0; i < snapshot.data!.data.length; i++) {
                                    DataLogActivity dataLogActivity = snapshot.data!.data[i];
                                    stepperData.add(
                                      StepperData(
                                        title: StepperText(
                                          "${dataLogActivity.activity??''} - ${dataLogActivity.creator??''}",
                                          textStyle: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        subtitle: StepperText(DateFormat('yyyy-MM-dd, HH:mm:ss').format(dataLogActivity.createdAt!)),
                                        iconWidget: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: Color(0xff07418C),
                                            borderRadius: BorderRadius.all(Radius.circular(30),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return Scrollbar(
                                    child: ListView.builder(
                                      itemCount: 1,
                                      itemBuilder: (context, index) {

                                        return AnotherStepper(
                                          stepperList: stepperData,
                                          stepperDirection: Axis.vertical,
                                          verticalGap: 25,
                                          inActiveBarColor: Colors.black.withOpacity(0.1)
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
            showMaterialModalBottomSheet(
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
  // Menu NotActive
  Widget Menu(logo,name, route) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>route));
        print("object");
      },
      child: Container(
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
      ),
    );
  }
}