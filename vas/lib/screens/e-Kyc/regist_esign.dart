import 'package:flutter/material.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/widgets/components.dart';

class RegistEsign extends StatefulWidget {
  const RegistEsign({super.key});

  @override
  State<RegistEsign> createState() => _RegistEsignState();
}

class _RegistEsignState extends State<RegistEsign> {

  int page = 0;
  int counter = 2;
  List list = [0,1,2];

  bool isPersonalInformation = true;
  bool isOfficeInformation = false;
  bool isUploadDocument = false;

  var firstName, lastName, phoneNumber, eMail, nik, npwp, gender, dateOfBirth, province, district, village, address, rt, rw, office, departement, role;

  late Size size;
  late double widthScreen, heightScreen;





  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    widthScreen = size.width;
    heightScreen = size.height;

    firstName = TextEditingController();
    lastName = TextEditingController();
    phoneNumber = TextEditingController();
    eMail = TextEditingController();
    nik = TextEditingController();
    npwp = TextEditingController();
    gender = TextEditingController();
    dateOfBirth = TextEditingController();
    province = TextEditingController();
    district = TextEditingController();
    village = TextEditingController();
    address = TextEditingController();
    rt = TextEditingController();
    rw = TextEditingController();
    office = TextEditingController();
    departement = TextEditingController();
    role = TextEditingController();


    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        shadowColor: Colors.black87,
        title: Text("Registration e-Kyc",style: TextStyle(fontSize: 18),),
        leading: IconButton(
          onPressed: () {
            if (page == 0) {
              Navigator.pop(context);
            } else {
              setState(() {
                page--;
                if (page == 1) {
                  isUploadDocument = false;
                  isOfficeInformation = true;
                } else if (page == 0) {
                  isOfficeInformation = false;
                  isPersonalInformation = true;
                }
              });
            }
          },
          icon: Icon(
            Icons.close
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                width: 310,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: FlutterStepIndicator(
                          height: 40,
                          paddingLine: const EdgeInsets.symmetric(horizontal: 0),
                          positiveColor: bluePrimary,
                          progressColor: const Color(0xFFEA9C00),
                          negativeColor: const Color(0xFFD5D5D5),
                          padding: const EdgeInsets.all(4),
                          list: list,division: counter,
                          onChange: (i) {},
                          page: page,
                          onClickItem: (p0) {
                            setState(() {
                              page = p0;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Personal\nInformation",
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Office\nInformation",
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Upload\nDocument",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Visibility(
              visible: isPersonalInformation,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("First Name"),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: size.height * 0.065,
                              width: size.width* 0.9,
                              child: TextFormField(
                                controller: firstName,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Last Name"),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: size.height * 0.065,
                              width: size.width* 0.9,
                              child: TextFormField(
                                controller: lastName,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Phone Number"),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: size.height * 0.065,
                              width: size.width* 0.9,
                              child: TextFormField(
                                controller: phoneNumber,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("E-mail"),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: size.height * 0.065,
                              width: size.width* 0.9,
                              child: TextFormField(
                                controller: eMail,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("* ", style: TextStyle(color: Colors.red)),
                            Text("NIK"),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: size.height * 0.065,
                              width: size.width* 0.9,
                              child: TextFormField(
                                controller: nik,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("NPWP"),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: size.height * 0.065,
                              width: size.width* 0.9,
                              child: TextFormField(
                                controller: npwp,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("* ", style: TextStyle(color: Colors.red)),
                            Text("Gender"),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: size.height * 0.065,
                              width: size.width* 0.9,
                              child: TextFormField(
                                controller: gender,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("* ", style: TextStyle(color: Colors.red)),
                            Text("Date of Birth"),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: size.height * 0.065,
                              width: size.width* 0.9,
                              child: TextFormField(
                                controller: dateOfBirth,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("* ", style: TextStyle(color: Colors.red)),
                            Text("Province"),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: size.height * 0.065,
                              width: size.width* 0.9,
                              child: TextFormField(
                                controller: province,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("* ", style: TextStyle(color: Colors.red)),
                            Text("District"),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: size.height * 0.065,
                              width: size.width* 0.9,
                              child: TextFormField(
                                controller: district,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("* ", style: TextStyle(color: Colors.red)),
                            Text("Village"),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: size.height * 0.065,
                              width: size.width* 0.9,
                              child: TextFormField(
                                controller: village,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("* ", style: TextStyle(color: Colors.red)),
                            Text("Address"),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: size.height * 0.065,
                              width: size.width* 0.9,
                              child: TextFormField(
                                controller: address,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text("RT"),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: size.height * 0.065,
                                  width: size.width* 0.4,
                                  child: TextFormField(
                                    controller: rt,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text("RW"),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: size.height * 0.065,
                                  width: size.width* 0.4,
                                  child: TextFormField(
                                    controller: rw,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: size.height * 0.06,
                    width: size.width * 0.9,
                    child: ElevatedButton(
                      onPressed: (){
                        setState(() {
                          isPersonalInformation = false;
                          isOfficeInformation = true;
                          page = 1;
                        });
                      },
                      child: Text(
                          "Next",
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14
                          )
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff0081F1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isOfficeInformation,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Office"),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: size.height * 0.065,
                              width: size.width* 0.9,
                              child: TextFormField(
                                controller: office,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Departement"),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: size.height * 0.065,
                              width: size.width* 0.9,
                              child: TextFormField(
                                controller: departement,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("* ", style: TextStyle(color: Colors.red)),
                            Text("Role"),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: size.height * 0.065,
                              width: size.width* 0.9,
                              child: TextFormField(
                                controller: role,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1.5, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: size.height * 0.06,
                    width: size.width * 0.9,
                    child: ElevatedButton(
                      onPressed: (){
                        setState(() {
                          isOfficeInformation = false;
                          isUploadDocument = true;
                          page = 2;
                        });
                      },
                      child: Text(
                          "Next",
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14
                          )
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff0081F1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isUploadDocument,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("*", style: TextStyle(color: Colors.red)),
                            Text(" Upload KTP"),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Image.asset("assets/images/card.png", width: 200,),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Format : jpg, jpeg, pdf | Max : 1 Mb",
                          style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: widthScreen * 0.9,
                          height: heightScreen * 0.05,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  side: BorderSide(
                                      color: bluePrimary,
                                      width: 1
                                  )
                              ),
                            ),
                            onPressed: () {

                            },
                            child: Text("Upload KTP", style: TextStyle(color: bluePrimary),),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: widthScreen * 1,
                    height: heightScreen * 0.005,
                    decoration: BoxDecoration(
                        color: Colors.black12
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Upload NPWP"),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Image.asset("assets/images/card.png", width: 200,),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Format : jpg, jpeg, pdf | Max : 1 Mb",
                          style: TextStyle(
                              fontWeight: FontWeight.w500
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: widthScreen * 0.9,
                          height: heightScreen * 0.05,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  side: BorderSide(
                                      color: bluePrimary,
                                      width: 1
                                  )
                              ),
                            ),
                            onPressed: () {

                            },
                            child: Text("Upload NPWP", style: TextStyle(color: bluePrimary),),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: widthScreen * 1,
                    height: heightScreen * 0.005,
                    decoration: BoxDecoration(
                      color: Colors.black12
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("*", style: TextStyle(color: Colors.red)),
                            Text(" Upload Selfie Photo"),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Image.asset("assets/images/selfie.png", width: 200,),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Format : jpg, jpeg, pdf | Max : 1 Mb",
                          style: TextStyle(
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: widthScreen * 0.9,
                          height: heightScreen * 0.05,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                side: BorderSide(
                                  color: bluePrimary,
                                  width: 1
                                )
                              ),
                            ),
                            onPressed: () {

                            },
                            child: Text("Upload Selfie", style: TextStyle(color: bluePrimary),),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: widthScreen * 1,
                    height: heightScreen * 0.005,
                    decoration: BoxDecoration(
                        color: Colors.black12
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: size.height * 0.06,
                    width: size.width * 0.9,
                    child: ElevatedButton(
                      onPressed: (){

                      },
                      child: Text(
                          "Submit",
                          style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14
                          )
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff0081F1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
