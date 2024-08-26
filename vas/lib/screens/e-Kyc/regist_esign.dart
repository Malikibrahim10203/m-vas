import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vas/event/event_camerapref.dart';
import 'package:vas/event/event_db.dart';
import 'package:vas/event/event_pref.dart';
import 'package:vas/models/district.dart';
import 'package:vas/models/province.dart';
import 'package:vas/screens/pages/camera_picture.dart';
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
  List list = [0, 1, 2];

  bool isPersonalInformation = true;
  bool isOfficeInformation = false;
  bool isUploadDocument = false;

  var firstName;
  var lastName;
  var phoneNumber;
  var eMail;
  var nik = TextEditingController();
  var npwp = TextEditingController();
  var gender;
  var dateOfBirth = TextEditingController();
  var district;
  var village = TextEditingController();
  var address = TextEditingController();
  var rt = TextEditingController();
  var rw = TextEditingController();
  var office = TextEditingController();
  var departement = TextEditingController();
  var role = TextEditingController();
  var placeOfBirth = TextEditingController();

  var formKey = GlobalKey<FormState>();

  late Size size;
  late double widthScreen, heightScreen;
  var alertImage = false;

  var imagesBytes;

  String ktpBase64 = "";
  String npwpBase64 = "";
  String selfieBase64 = "";

  var check = "check";

  Map? bodyCollection;

  File? imageKTP, imageNPWP, imageSelfie;


  String? email;
  String? password;
  String? token;
  var tokenPeruri;

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

  List<Province>? regionProvinces;
  int? selectedProvince;

  void _fetchProvinces() async {
    List<Province>? regionsData = await EventDB.getProvinces();
    setState(() {
      regionProvinces = regionsData;
    });
  }

  List<District>? regionDistrict;
  int? selectedDistrict;

  void _fetchDistrict(int province_id) async {
    List<District>? regionsData = await EventDB.getDistrict(province_id);
    setState(() {
      regionDistrict = regionsData;
    });
  }

  Future<void> getUser() async {
    token = (await EventPref.getCredential())?.data.token;
    email = (await EventPref.getCredential())?.email;
    password = (await EventPref.getCredential())?.password;
    var _firstname = (await EventDB.getUser(token??'', email??'', password??''))?.firstName;
    var _lastname = (await EventDB.getUser(token??'', email??'', password??''))?.lastName;
    var _phonenumber = (await EventDB.getUser(token??'', email??'', password??''))?.phone;
    var _email = (await EventDB.getUser(token??'', email??'', password??''))?.email;

    if(firstName==null) {
      var data = await EventDB.getlogin(email??'', password??'');
      token = data!.data.token;
      print(data.data.token);
    }

    if(token != null){
      tokenPeruri = (await EventDB.getPeruriJWTToken(token??''))?.tokenPeruriSign;
    }

    setState(() {
      firstName = _firstname;
      lastName = _lastname;
      phoneNumber = _phonenumber;
      eMail = _email;
    });
  }



  var cameraImage;

  void getCameraImage() async {
    cameraImage = (await CameraPref.getCamera())?.cameraPath;

    if(cameraImage != null) {
      setState(() {
        imageSelfie = File(cameraImage);
        Uint8List imagesBytes = imageSelfie!.readAsBytesSync();
        selfieBase64 = base64Encode(imagesBytes);


        print("P: $selfieBase64");
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getUser();
    _fetchProvinces();
    getCameraImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    widthScreen = size.width;
    heightScreen = size.height;

    const List<String> list = <String>['One', 'Two', 'Three', 'Four'];
    String province = list.first;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        shadowColor: Colors.black87,
        title: Text(
          "Registration e-Kyc",
          style: TextStyle(fontSize: 18),
        ),
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
          icon: Icon(Icons.close),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
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
                          paddingLine:
                          const EdgeInsets.symmetric(horizontal: 0),
                          positiveColor: bluePrimary,
                          progressColor: const Color(0xFFEA9C00),
                          negativeColor: const Color(0xFFD5D5D5),
                          padding: const EdgeInsets.all(4),
                          list: list,
                          division: counter,
                          onChange: (i) {},
                          page: page,
                          onClickItem: (p0) {
                            setState(() {
                              page = p0;
                              if (page == 0) {
                                isPersonalInformation = true;
                                isOfficeInformation = false;
                                isUploadDocument = false;
                              } else if (page == 1) {
                                isPersonalInformation = false;
                                isOfficeInformation = true;
                                isUploadDocument = false;
                              } else if (page == 2) {
                                isPersonalInformation = false;
                                isOfficeInformation = false;
                                isUploadDocument = true;
                              }
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
              height: 20,
            ),
            Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(
                    visible: isPersonalInformation,
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 18),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text("First Name"),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: size.height * 0.065,
                                              width: size.width * 0.4,
                                              child: TextFormField(
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  hintText: firstName,
                                                  fillColor: Colors.black12,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1.5,
                                                        color: Color(0xffB8B8B8)),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10)),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Color(0xffB8B8B8)),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10)),
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
                                    padding: EdgeInsets.only(right: 25),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text("Last Name"),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: size.height * 0.065,
                                              width: size.width * 0.4,
                                              child: TextFormField(
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  hintText: lastName,
                                                  fillColor: Colors.black12,
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1.5,
                                                        color: Color(0xffB8B8B8)),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10)),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Color(0xffB8B8B8)),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10)),
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
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("Phone Number"),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.065,
                                    width: size.width * 0.905,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: phoneNumber,
                                        fillColor: Colors.black12,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1.5,
                                              color: Color(0xffB8B8B8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color(0xffB8B8B8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
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
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("E-mail"),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.065,
                                    width: size.width * 0.905,
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        hintText: eMail,
                                        fillColor: Colors.black12,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1.5,
                                              color: Color(0xffB8B8B8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color(0xffB8B8B8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
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
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("* ",
                                      style: TextStyle(color: Colors.red)),
                                  Text("NIK"),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.065,
                                    width: size.width * 0.905,
                                    child: TextFormField(
                                      controller: nik,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1.5,
                                              color: Color(0xffB8B8B8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color(0xffB8B8B8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
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
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("NPWP"),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.065,
                                    width: size.width * 0.905,
                                    child: TextFormField(
                                      controller: npwp,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1.5,
                                              color: Color(0xffB8B8B8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color(0xffB8B8B8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
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
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("* ",
                                      style: TextStyle(color: Colors.red)),
                                  Text("Gender"),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.065,
                                    width: size.width * 0.905,
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide:
                                              BorderSide(width: 1),
                                          ),
                                      ),
                                      hint: Text("Gender"),
                                      onChanged: (String? value) {
                                        setState(() {
                                          gender = value!;
                                        });
                                      },
                                      items: <String>['M', 'F'].map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
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
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("* ",
                                      style: TextStyle(color: Colors.red)),
                                  Text("Place Of Birth"),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.065,
                                    width: size.width * 0.905,
                                    child: TextFormField(
                                      controller: placeOfBirth,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1.5,
                                              color: Color(0xffB8B8B8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color(0xffB8B8B8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
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
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("Date of Birth"),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.065,
                                    width: size.width * 0.905,
                                    child: TextFormField(
                                      controller: dateOfBirth,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.grey),
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        hintText: 'Select Date',
                                        suffixIcon: Icon(Icons.calendar_month),
                                      ),
                                      readOnly: true,
                                      onTap: () async {

                                        DateTime now = DateTime.now();
                                        DateTime minimumDate = DateTime(now.year - 17, now.month, now.day);

                                        DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: minimumDate,
                                          firstDate: DateTime(1900),
                                          lastDate: minimumDate,
                                        );
                                        if(pickedDate != null) {
                                          String formatDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                                          setState(() {
                                            dateOfBirth.text = formatDate;
                                          });
                                        }

                                      },
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
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("* ",
                                      style: TextStyle(color: Colors.red)),
                                  Text("Province"),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.065,
                                    width: size.width * 0.905,
                                    child: regionProvinces == null
                                        ? Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.grey),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                          child: Text(
                                              "Loading Provinces...")),
                                    )
                                        : DropdownButtonFormField<int>(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.grey),
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                      ),
                                      menuMaxHeight: heightScreen * 0.3,
                                      value: selectedProvince,
                                      hint: Text("Select Province"),
                                      items:
                                      regionProvinces!.map((region) {
                                        return DropdownMenuItem<int>(
                                          value: region.provinceId,
                                          child: Text(region.provinceName,
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.w400)),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) async {
                                        setState(() {
                                          selectedDistrict = null;
                                          selectedProvince = newValue;
                                          if (selectedProvince != null) {
                                            _fetchDistrict(
                                                selectedProvince!);
                                          }
                                          print(selectedProvince);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("* ",
                                      style: TextStyle(color: Colors.red)),
                                  Text("District"),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.065,
                                    width: size.width * 0.905,
                                    child: selectedProvince == null
                                        ? Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.grey),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                          child: Text(
                                              "Select a Province First")),
                                    )
                                        : regionDistrict == null
                                        ? Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.grey),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                          child: Text(
                                              "Loading Districts...")),
                                    )
                                        : DropdownButtonFormField<int>(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.grey),
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                        ),
                                      ),
                                      menuMaxHeight:
                                      heightScreen * 0.3,
                                      value: selectedDistrict,
                                      hint:
                                      Text("--Select District--"),
                                      items: regionDistrict!
                                          .map((region) {
                                        return DropdownMenuItem<int>(
                                          value: region.kabId,
                                          child: Text(
                                            region.kabName,
                                            style: TextStyle(
                                              fontWeight:
                                              FontWeight.w400,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedDistrict = newValue;
                                          print(selectedDistrict);
                                        });
                                      },
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
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("* ",
                                      style: TextStyle(color: Colors.red)),
                                  Text("Village"),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.065,
                                    width: size.width * 0.905,
                                    child: TextFormField(
                                      controller: village,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1.5,
                                              color: Color(0xffB8B8B8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color(0xffB8B8B8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
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
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("* ",
                                      style: TextStyle(color: Colors.red)),
                                  Text("Address"),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.065,
                                    width: size.width * 0.905,
                                    child: TextFormField(
                                      controller: address,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1.5,
                                              color: Color(0xffB8B8B8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color(0xffB8B8B8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
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
                              padding: EdgeInsets.symmetric(horizontal: 18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("RT"),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: size.height * 0.065,
                                        width: size.width * 0.4,
                                        child: TextFormField(
                                          controller: rt,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1.5,
                                                  color: Color(0xffB8B8B8)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Color(0xffB8B8B8)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
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
                              padding: EdgeInsets.symmetric(horizontal: 18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("RW"),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: size.height * 0.065,
                                        width: size.width * 0.4,
                                        child: TextFormField(
                                          controller: rw,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1.5,
                                                  color: Color(0xffB8B8B8)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Color(0xffB8B8B8)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
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
                          width: size.width * 0.905,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isPersonalInformation = false;
                                isOfficeInformation = true;
                                page = 1;
                              });
                            },
                            child: Text("Next",
                                style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff0081F1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
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
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("Office"),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.065,
                                    width: size.width * 0.905,
                                    child: TextFormField(
                                      controller: office,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1.5,
                                              color: Color(0xffB8B8B8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color(0xffB8B8B8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
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
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("Departement"),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.065,
                                    width: size.width * 0.905,
                                    child: TextFormField(
                                      controller: departement,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1.5,
                                              color: Color(0xffB8B8B8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Color(0xffB8B8B8)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
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
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("* ",
                                      style: TextStyle(color: Colors.red)),
                                  Text("Role"),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.065,
                                    width: size.width * 0.905,
                                    child: SizedBox(
                                      height: size.height * 0.065,
                                      width: size.width * 0.905,
                                      child: TextFormField(
                                        controller: role,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1.5,
                                                color: Color(0xffB8B8B8)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Color(0xffB8B8B8)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
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
                          height: heightScreen * 0.35,
                        ),
                        SizedBox(
                          height: size.height * 0.06,
                          width: size.width * 0.905,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isOfficeInformation = false;
                                isUploadDocument = true;
                                page = 2;
                              });
                            },
                            child: Text("Next",
                                style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff0081F1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
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
                                  Text("*",
                                      style: TextStyle(color: Colors.red)),
                                  Text(" Upload KTP"),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              imageKTP == null
                                  ? Image.asset(
                                "assets/images/card.png",
                                width: 200,
                              )
                                  : Container(
                                width: 300,
                                height: 200,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(imageKTP!),
                                    )),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Format : jpg, jpeg, pdf | Max : 1 Mb",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              alertImage == true
                                  ? Text(
                                "Maximal file 1 MB or Follow the format file.",
                                style: TextStyle(color: Colors.red),
                              )
                                  : Container(),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        side: BorderSide(
                                            color: bluePrimary, width: 1)),
                                  ),
                                  onPressed: () => _pickImageKTP(),
                                  child: Text(
                                    "Upload KTP",
                                    style: TextStyle(color: bluePrimary),
                                  ),
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
                          decoration: BoxDecoration(color: Colors.black12),
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
                              imageNPWP == null
                                  ? Image.asset(
                                "assets/images/card.png",
                                width: 200,
                              )
                                  : Container(
                                width: 300,
                                height: 200,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(imageNPWP!),
                                    )),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Format : jpg, jpeg, pdf | Max : 1 Mb",
                                style: TextStyle(fontWeight: FontWeight.w500),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        side: BorderSide(
                                            color: bluePrimary, width: 1)),
                                  ),
                                  onPressed: _pickImageNPWP,
                                  child: Text(
                                    "Upload NPWP",
                                    style: TextStyle(color: bluePrimary),
                                  ),
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
                          decoration: BoxDecoration(color: Colors.black12),
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("*",
                                      style: TextStyle(color: Colors.red)),
                                  Text(" Upload Selfie Photo"),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              imageSelfie == null
                                  ? Image.asset(
                                "assets/images/selfie.png",
                                width: 200,
                              )
                                  : Container(
                                width: 300,
                                height: 200,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(imageSelfie!),
                                    )),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Format : jpg, jpeg, pdf | Max : 1 Mb",
                                style: TextStyle(fontWeight: FontWeight.w500),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        side: BorderSide(
                                            color: bluePrimary, width: 1)),
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
                                                leading: new Icon(
                                                    Icons.file_upload_outlined),
                                                title: new Text('Upload File'),
                                                onTap: _pickImageSelfie,
                                              ),
                                              ListTile(
                                                leading: new Icon(
                                                    Icons.camera_alt_outlined),
                                                title: new Text('Camera'),
                                                onTap: () async {
                                                  final camera = await availableCameras();
                                                  final firstCamera = camera![1];
                                                  print("P: $firstCamera");
                                                  await Navigator.push(context, MaterialPageRoute(builder: (context)=>CameraPicture(camera: firstCamera)));
                                                  getCameraImage();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: Text(
                                    "Upload Selfie",
                                    style: TextStyle(color: bluePrimary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: widthScreen * 1,
                          height: heightScreen * 0.005,
                          decoration: BoxDecoration(color: Colors.black12),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: size.height * 0.06,
                          width: size.width * 0.905,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                bodyCollection = {
                                  'firstName': firstName,
                                  'lastName': lastName,
                                  'phoneNumber': phoneNumber,
                                  'eMail': eMail,
                                  'nik': nik.text,
                                  'npwp': npwp.text,
                                  'gender': gender,
                                  'placeOfBirth': placeOfBirth.text,
                                  'dateOfBirth': dateOfBirth.text,
                                  'province': selectedProvince,
                                  'district': selectedDistrict,
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
                              EventDB.RegisterPeruri(token??'', tokenPeruri??'', password??'', bodyCollection);
                            },
                            child: Text("Submit",
                                style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff0081F1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
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
  @override
  void dispose() {
    // TODO: implement dispose
    CameraPref.clearCameraPreference();
    super.dispose();
  }
}
