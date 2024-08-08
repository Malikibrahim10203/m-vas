import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/screens/auth/change_password.dart';
import 'package:vas/widgets/components.dart';
import 'package:vas/widgets/logovas.dart';

class OtpCode extends StatefulWidget {
  const OtpCode({super.key});

  @override
  State<OtpCode> createState() => _OtpCodeState();
}

class _OtpCodeState extends State<OtpCode> {
  var size;
  final _otpControllers = List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: size.height * 0.07
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LogoVas(size.width * 0.25)
              ],
            ),
            Text(
              "Reset Password",
              style: GoogleFonts.poppins(
                color: Color(0xff4B4B4B),
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Please enter 6 - digits code we send on\nyour email.",
              style: GoogleFonts.poppins(
                  color: Color(0xff717171),
                  fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Container(
              width: size.width * 0.85,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: SizedBox(
                            width: 50,
                            height: 50,
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
                                  FocusScope.of(context).nextFocus();
                                } else if (value.isEmpty && index > 0) {
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "If you dont find OTP code that we send try",
                                    style: GoogleFonts.poppins(
                                      color: Color(0xff717171),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "checking spam, or ",
                                    style: GoogleFonts.poppins(
                                      color: Color(0xff717171),
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Text(
                                    "send code again.",
                                    style: GoogleFonts.poppins(
                                      color: bluePrimary,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomOtp(),
    );
  }

  Widget _bottomOtp() {
    return Container(
      height: size.height * 0.12,
      child: Column(
        children: [
          Container(
            height: size.height * 0.06,
            width: size.width * 0.85,
            child: ElevatedButton(
              onPressed: (){
                final otpValues = _otpControllers.map((controller) => controller.text).toList();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePassword(otp: otpValues.join())));
              },
              child: Text(
                "Verification",
                style: TextStyle(
                    color: Colors.white
                ),
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
    );
  }
}
