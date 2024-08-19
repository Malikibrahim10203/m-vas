import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/event/event_db.dart';
import 'package:vas/widgets/components.dart';
import 'package:vas/widgets/logovas.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  var emailController = TextEditingController();

  var size;
  var widthScreen, heightScreen;

  bool isExist = true;
  bool isWait  = false;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    widthScreen = size.width;
    heightScreen = size.height;

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
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
                  Text(
                    "Please enter your email.",
                    style: GoogleFonts.poppins(
                        color: Color(0xff717171),
                        fontSize: 12
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Container(
                    width: size.width * 0.8,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                Text("*", style: TextStyle(color: Colors.red),),
                                Text(
                                  " Email",
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff4F4747),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                            height: size.height * 0.06,
                            width: size.width * 1,
                            child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1,color: Color(0xffB8B8B8)),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),

                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Color(0xffB8B8B8)),
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                              ),
                            )
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        isExist==false? InputWrong(heightScreen, widthScreen, "Email"):SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: _bottomReset(),
      ),
    );
  }

  Widget _bottomReset() {
    return Container(
      height: size.height * 0.12,
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.065,
            width: size.width * 0.8,
            child: ElevatedButton(
              onPressed: () async {
                var data = await EventDB.ForgotPassword(emailController.text);

                if (data == null) {
                  setState(() {
                    isExist = false;
                  });
                } else {
                  setState(() {
                    isExist = true;
                    isWait = true;
                  });
                  ModalSendEmail(context);
                  Future.delayed(Duration(seconds: 2), () => Navigator.pushNamed(context,'/Login'));
                }
              },
              child: Text(
                  "Send email reset password",
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
          )
        ],
      ),
    );
  }
}
