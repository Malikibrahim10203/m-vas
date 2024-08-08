import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/widgets/logovas.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({super.key, required this.otp});

  final otp;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var size;

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
            Container(
              width: size.width * 0.8,
              child: Column(
                children: [
                  Text("${widget.otp}"),
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
          ],
        ),
      ),
      bottomNavigationBar: _bottomReset(),
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
                Navigator.pushNamed(context, "/Login");
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
