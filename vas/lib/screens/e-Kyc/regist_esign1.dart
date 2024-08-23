import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/event/event_db.dart';
import 'package:vas/widgets/components.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:io' as io;

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


  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var phoneNumber = TextEditingController();
  var eMail = TextEditingController();
  var nik = TextEditingController();
  var npwp = TextEditingController();
  var gender = TextEditingController();
  var dateOfBirth = TextEditingController();
  var province = TextEditingController();
  var district = TextEditingController();
  var village = TextEditingController();
  var address = TextEditingController();
  var rt = TextEditingController();
  var rw = TextEditingController();
  var office = TextEditingController();
  var departement = TextEditingController();
  var role = TextEditingController();

  var formKey = GlobalKey<FormState>();

  late Size size;
  late double widthScreen, heightScreen;
  var alertImage = false;

  var imagesBytes;

  String ktpBase64 = "";
  String npwpBase64 = "";
  String selfieBase64 = "";

  Map? bodyCollection;



  File? imageKTP, imageNPWP, imageSelfie;


  Future<void> _pickImageKTP() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    const formatFile = ['.jpg', '.jpeg', '.pdf'];

    if (pickedFile != null) {
      File filePath = File(pickedFile.path);
      final extensionImage = path.extension(filePath.path);
      final sizeImage = await pickedFile.length();
      const maxFormatImages = 1 * 1024 * 1024; // 1 MB



      // Read the image bytes
      Uint8List imagesBytes = await filePath.readAsBytes();


      setState(() {
        imageKTP = File(pickedFile.path);

        // Encode image bytes to Base64
        ktpBase64 = base64.encode(imagesBytes);

        // Store the Base64 string
        print("Base64 KTP: $ktpBase64");
        print("File KTP: $imagesBytes");

        // Check file format and size
        if (sizeImage < maxFormatImages) {
          if (formatFile.contains(extensionImage)) {
            alertImage = false;
          } else {
            alertImage = true;
          }
        } else {
          alertImage = true;
          imageKTP = null;
        }
      });
    }
  }

  Future<void> _pickImageNPWP() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    const formatFile = ['.jpg', '.jpeg', '.pdf'];

    if (pickedFile != null) {
      File filePath = File(pickedFile.path);
      final extensionImage = path.extension(filePath.path);
      final sizeImage = await pickedFile.length();
      const maxFormatImages = 1 * 1024 * 1024; // 1 MB



      // Read the image bytes
      Uint8List imagesBytes = await filePath.readAsBytes();


      setState(() {
        imageNPWP = File(pickedFile.path);

        // Encode image bytes to Base64
        npwpBase64 = base64.encode(imagesBytes);

        // Store the Base64 string
        print("Base64 KTP: $npwpBase64");
        print("File KTP: $imagesBytes");

        // Check file format and size
        if (sizeImage < maxFormatImages) {
          if (formatFile.contains(extensionImage)) {
            alertImage = false;
          } else {
            alertImage = true;
          }
        } else {
          alertImage = true;
          imageKTP = null;
        }
      });
    }
  }

  Future<void> _pickImageSelfie() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    const formatFile = ['.jpg', '.jpeg', '.pdf'];

    if (pickedFile != null) {
      File filePath = File(pickedFile.path);
      final extensionImage = path.extension(filePath.path);
      final sizeImage = await pickedFile.length();
      const maxFormatImages = 1 * 1024 * 1024; // 1 MB



      // Read the image bytes
      Uint8List imagesBytes = await filePath.readAsBytes();


      setState(() {
        imageSelfie = File(pickedFile.path);

        // Encode image bytes to Base64
        selfieBase64 = base64.encode(imagesBytes);

        // Store the Base64 string
        print("Base64 KTP: $selfieBase64");
        print("File KTP: $imagesBytes");

        // Check file format and size
        if (sizeImage < maxFormatImages) {
          if (formatFile.contains(extensionImage)) {
            alertImage = false;
          } else {
            alertImage = true;
          }
        } else {
          alertImage = true;
          imageKTP = null;
        }
      });
    }
  }





  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    widthScreen = size.width;
    heightScreen = size.height;



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
            Form(
              key: formKey,
              child: Column(
                children: [
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
                              imageKTP==null?
                              Image.asset("assets/images/card.png", width: 200,):
                              Container(
                                width: 300,
                                height: 200,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(imageKTP!),
                                    )
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Format : jpg, jpeg, pdf | Max : 1 Mb",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              alertImage==true? Text("Maximal file 1 MB or Follow the format file.", style: TextStyle(color: Colors.red),): Container(),
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
                                  onPressed: ()=>_pickImageKTP(),
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
                              imageNPWP==null?
                              Image.asset("assets/images/card.png", width: 200,):
                              Container(
                                width: 300,
                                height: 200,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(imageNPWP!),
                                    )
                                ),
                              ),
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
                              TextFormField(
                                initialValue: npwpBase64,
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
                                  onPressed: _pickImageNPWP,
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
                              imageSelfie==null?
                              Image.asset("assets/images/selfie.png", width: 200,):
                              Container(
                                width: 300,
                                height: 200,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(imageSelfie!),
                                    )
                                ),
                              ),
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
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 20,
                                              ),
                                              ListTile(
                                                leading: new Icon(Icons.file_upload_outlined),
                                                title: new Text('Upload File'),
                                                onTap: _pickImageSelfie,
                                              ),
                                              ListTile(
                                                leading: new Icon(Icons.camera_alt_outlined),
                                                title: new Text('Camera'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        });
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
                              setState(() {
                                bodyCollection = {
                                  'firstName': firstName.text,
                                  'lastName': lastName.text,
                                  'phoneNumber': phoneNumber.text,
                                  'eMail': eMail.text,
                                  'nik': nik.text,
                                  'npwp': npwp.text,
                                  'gender': gender.text,
                                  'dateOfBirth': dateOfBirth.text,
                                  'province': province.text,
                                  'district': district.text,
                                  'village': village.text,
                                  'address': address.text,
                                  'rt': rt.text,
                                  'rw': rw.text,
                                  'office': office.text,
                                  'departement': departement.text,
                                  'role': role.text,
                                  'ktp_photo': ktpBase64,
                                  'npwp_photo': npwpBase64,
                                  'selfie_photo': selfieBase64,
                                };
                              });
                              EventDB.check(bodyCollection);
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
          ],
        ),
      ),
    );
  }

}
