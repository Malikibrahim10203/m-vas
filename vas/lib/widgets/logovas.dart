import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget LogoVas(width){
  return Image.asset(
    "assets/images/vas-logo.png",
    width: width,
  );
}

Widget ImageSplash(image,width){
  return Image.asset(
    "assets/images/$image.png",
    width: width,
  );
}

Widget ImageGetStarted(width){
  return Image.asset(
    "assets/images/get_started.png",
    width: width,
  );
}

Widget TextSplash(head, main){
  return Column(
    children: [
      Text(
        "$head",
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w500
        )
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        "$main",
        style: GoogleFonts.poppins(
          color: Color(0xff929292),
          fontSize: 12,
        ),
      ),
    ],
  );
}