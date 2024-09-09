import 'package:flutter/material.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/event/event_db.dart';
import 'package:vas/event/event_pref.dart';
import 'package:vas/screens/pages/camera_video.dart';
import 'package:vas/widgets/components.dart';
import 'package:vas/widgets/logovas.dart';

class ActivateAccount extends StatefulWidget {
  const ActivateAccount({super.key, required this.token});

  final token;

  @override
  State<ActivateAccount> createState() => _ActivateAccountState();
}

class _ActivateAccountState extends State<ActivateAccount> {

  var tokenEmail;
  int page = 0;
  int counter = 2;
  List list = [0, 1, 2];

  bool isEmailConfirmation = true;
  bool isOTPCode = false;
  bool isFaceRecording = false;

  bool isOtpWrong = false;

  bool checkInputOtp = false;

  var token;
  var email;
  var password;

  var generateOtpStatus;

  var size, heightScreen, widthScreen;
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  var otpValues;

  var tokenPeruri;

  var isEmailActivate = false;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> getJsonResponse() async {
    tokenEmail = (await EventPref.getCredential())?.data.token;
    email = (await EventPref.getCredential())?.email;
    password = (await EventPref.getCredential())?.password;

    tokenPeruri = (await EventDB.getPeruriJWTToken(tokenEmail))?.tokenPeruriSign;
    print(tokenPeruri);

    var activate = (await EventDB.ActivateEmail(tokenEmail, widget.token));
    print("Activate first: $activate");

    if (activate == "Email has already been activated") {
      isEmailActivate = true;
      print("Activate 1: $activate");
    }

    print("Token Credential Preff: $tokenEmail");
    print("Token Email Credential: ${widget.token}");
    print("Token Peruri: $tokenPeruri");

    setState(() {

    });
  }

  String getOtp() {
    // return _otpControllers.map((controller) => controller.text).join();
    return _otpControllers.map((controller)=>controller.text).join();
  }

  @override
  void initState() {
    // TODO: implement initState
    getJsonResponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    heightScreen = size.height;
    widthScreen = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration e-Sign", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),),
        leading: IconButton(
          onPressed: () {
            if (page == 0) {
              Navigator.pop(context);
            } else {
              setState(() {
                page--;
                if (page == 1) {
                  isEmailConfirmation = false;
                  isOTPCode = true;
                } else if (page == 0) {
                  isFaceRecording = false;
                  isEmailConfirmation = true;
                }
              });
            }
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black,),
        ),
        centerTitle: true,
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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                isEmailConfirmation = true;
                                isOTPCode = false;
                                isFaceRecording = false;
                              } else if (page == 1) {
                                isEmailConfirmation = false;
                                isOTPCode = true;
                                isFaceRecording = false;
                              } else if (page == 2) {
                                isEmailConfirmation = false;
                                isOTPCode = false;
                                isFaceRecording = true;
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
                          "Email\nConfirmation",
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "OTP\nCode",
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Face\nRecording",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isEmailConfirmation,
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  isEmailActivate? Column(
                    children: [
                      CircleAvatar(
                          backgroundColor: primaryColor2,
                          radius: 70.0,
                          child: Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 55.0,
                              child: CircleAvatar(
                                backgroundColor: primaryColor2,
                                radius: 45.0,
                                child: Icon(Icons.done, size: 50, color: Colors.white,),
                              ),
                            ),
                          )
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: size.width * 0.9,
                        child: Column(
                          children: [
                            Text("Your email has been successfully confirmed", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Please continue the verification process with your handphone number",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ):Column(
                    children: [
                      CircleAvatar(
                          backgroundColor: textAlertColor2,
                          radius: 70.0,
                          child: Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 55.0,
                              child: CircleAvatar(
                                backgroundColor: textAlertColor2,
                                radius: 45.0,
                                child: Icon(Icons.close, size: 50, color: Colors.white,),
                              ),
                            ),
                          )
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: size.width * 0.9,
                        child: Column(
                          children: [
                            Text("Token Email Expired", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Please resend activate E-mail",
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                              onPressed: () async {
                                var resendActivate = (await EventDB.ResendActivateEmail(tokenEmail));
                                print("Activate Email Confirm: $resendActivate");

                                setState(() {

                                });
                              },
                              child: Text("Resend Activation"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.2,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isOTPCode,
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    width: size.width * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enter your OTP Code",
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "We send the OTP Code via Whatsapp for the verification process of your mobile number. Please enter the OTP code.",
                          style: GoogleFonts.poppins(
                            color: Color(0xff717171),
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Container(
                        width: size.width * 0.91,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(6, (index) {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: TextField(
                                        controller: _otpControllers[index],
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        maxLength: 1,
                                        decoration: InputDecoration(
                                            counterText: '',
                                            border: OutlineInputBorder(),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(color: greyColor)
                                            )
                                        ),
                                        onChanged: (value) {
                                          if (value.length == 1 && index < 6) {
                                            if (index == 5) {
                                              setState(() {
                                                otpValues = getOtp();
                                                checkInputOtp = true;
                                              });
                                              // print(checkInputOtp);
                                            }
                                            FocusScope.of(context).nextFocus();
                                          } else if (value.isEmpty && index > 0) {
                                            if (index < 6 && index >= 5) {
                                              setState(() {
                                                checkInputOtp = false;
                                              });
                                              // print(checkInputOtp);
                                            }
                                            FocusScope.of(context).previousFocus();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      isOtpWrong ?
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: InputWrong(heightScreen, widthScreen, "Otp"),
                          ) : SizedBox(),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              otpValues??''
                            ),
                            Text(
                              "Didn't receive the OTP code?",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Color(0xff717171),
                                fontSize: 10,
                              ),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateColor.transparent
                              ),
                              onPressed: () {

                              },
                              child: Text(
                                "Resend",
                                style: GoogleFonts.poppins(
                                  color: bluePrimary,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.3,
                      ),
                    ],
                  ),

                ],
              ),
            ),
            Visibility(
              visible: isFaceRecording,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Image.asset("assets/images/face-recording.png", width: 200,),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: size.width * 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Face Recording",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                width: size.width * 0.85,
                                child: Text(
                                  "We record the face and verify the biometric data by analyzing and comparing reference data.",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontSize: 14
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: primaryColor2,
                                child: Icon(Icons.light, color: Colors.white, size: 25,),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: size.width * 0.7,
                                child: Text(
                                  "Please do not wear accessories on your face when recording (example : glasses, hat).",
                                  style: TextStyle(
                                      fontSize: 12
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: primaryColor2,
                                child: Icon(Icons.light, color: Colors.white, size: 25,),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: size.width * 0.7,
                                child: Text(
                                  "For better photo results, please take photos in a place that has good lighting.",
                                  style: TextStyle(
                                    fontSize: 12
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 170,
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: bottomWidget(isEmailConfirmation, isOTPCode, isFaceRecording),
      ),
    );
  }
  Widget bottomWidget(isEmail, isOtp, isFace) {
    if(isEmail == true) {
      return Container(
        width: size.width * 0.9,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: bluePrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              )
          ),
          onPressed: () async {
            print("Token Login: $tokenEmail");
            print("Token Peruri: $tokenPeruri");
            generateOtpStatus = (await EventDB.SendOtp(tokenEmail, tokenPeruri));
            print("Generate Token: $generateOtpStatus");
            setState(() {
              isEmailConfirmation = false;
              isOTPCode = true;
              isFaceRecording = false;
              page = 1;
            });
          },
          child: Text("Next", style: TextStyle(color: Colors.white),),
        ),
      );
    } else if(isOtp == true) {
      if (checkInputOtp == true) {
        return Container(
          width: 400,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: bluePrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                )
            ),
            onPressed: () async {
              var data = await EventDB.CheckOtp(tokenEmail, tokenPeruri, otpValues);
              if (data == "success") {
                setState(() {
                  isEmailConfirmation = false;
                  isOTPCode = false;
                  isFaceRecording = true;
                  page = 2;
                });
              } else {
                setState(() {
                  isOtpWrong = true;
                });
              }
              print(data);
            },
            child: Text("Next", style: TextStyle(color: Colors.white),),
          ),
        );
      } else {
        return Container(
          width: 400,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: bluePrimary.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                )
            ),
            onPressed: () {

            },
            child: Text("Next", style: TextStyle(color: Colors.white),),
          ),
        );
      }
    } else if(isFace == true) {
      return Container(
        width: 400,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: bluePrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              )
          ),
          onPressed: () {
            print("Token: ${tokenEmail}");
            print("Token Peruri: ${tokenPeruri}");
            print("OTP: ${otpValues}");
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CameraVideo(token: tokenEmail, tokenPeruri: tokenPeruri, otp: otpValues,)));
          },
          child: Text("Next", style: TextStyle(color: Colors.white),),
        ),
      );
    }
    return Container();
  }
}
