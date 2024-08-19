import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/event/event_db.dart';
import 'package:vas/widgets/logovas.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({super.key, required this.token});

  final String? token;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var size;

  bool isSame = true;

  var newPassword = TextEditingController();
  var confirmationPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Widget indicator() {
    return newPassword.text == confirmationPassword.text? Container(
      width: 10,
      height: 10,
      color: Colors.green,
    ): Container(
      width: 10,
      height: 10,
      color: Colors.red,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    indicator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
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
                "New Password",
                style: GoogleFonts.poppins(
                  color: Color(0xff4B4B4B),
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Please enter new password.",
                style: GoogleFonts.poppins(
                    color: Color(0xff717171),
                    fontSize: 12
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
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
                                    " New Password",
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
                              height: size.height * 0.065,
                              width: size.width * 1,
                              child: TextFormField(
                                controller: newPassword,
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
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
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
                                    " Confirmation New Password",
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
                              height: size.height * 0.065,
                              width: size.width * 1,
                              child: TextFormField(
                                controller: confirmationPassword,
                                validator: (value) {
                                  if (newPassword.text != confirmationPassword.text) {
                                    setState(() {
                                      isSame = false;
                                    });
                                    return "Password not match!";
                                  } else {
                                    setState(() {
                                      isSame = true;
                                    });
                                  }
                                  return null;
                                },
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
                          indicator(),
                        ],
                      ),
                    ),
                  ],
                ),
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
              onPressed: (){
                if (newPassword.text != confirmationPassword.text) {
                  print("Not Same");
                } else {
                  EventDB.ChangePassword(confirmationPassword.text, widget.token??"");
                }
              },
              child: Text(
                  "Confirm",
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
