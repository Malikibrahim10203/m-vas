import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/widgets/logovas.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {

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
              height: size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LogoVas(size.width * 0.25)
              ],
            ),
            ImageGetStarted(size.width * 0.6),
            SizedBox(
              height: size.height * 0.15,
            ),
            Text(
              "Let`s begin",
              style: GoogleFonts.poppins(
                color: Color(0xff4B4B4B),
                fontSize: 30,
                fontWeight: FontWeight.w600,
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
                  "Get Started",
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
