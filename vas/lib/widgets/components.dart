import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// Colors

// Input Box Colors
Color greyColor = Color(0xffB8B8B8);
Color greyColor3 = Color(0xff8B8B8B);
Color greyColor6 = Color(0xffF5F5F5);
Color bluePrimary = Color(0xff3A8FFF);
Color indigoColor = Color(0xff3368FF);
Color primaryColor2 = Color(0xff054BA6);
Color alertRedColor = Color(0xffFFE0E0);
Color textAlertRedColor = Color(0xffFF7B7B);
Color primaryColor4 = Color(0xff48A1D9);
Color tertiaryColor = Color(0xffEAC100);




// Widget Profile Dashboard





// Widget Alert


// height: size.height * 0.065,
// width: size.width * 1,

Widget InputWrong(height, width, input) {
  return Container(
    height: height * 0.065,
    width: width * 1,
    decoration: BoxDecoration(
        color: alertRedColor,
        borderRadius: BorderRadius.all(Radius.circular(10))
    ),
    child: Row(
      children: [
        SizedBox(
          width: width * 0.05,
        ),
        Icon(
          Icons.warning_amber,
          color: textAlertRedColor,
        ),
        SizedBox(
          width: width * 0.03,
        ),
        Text(
          "Oops! It looks like the ${input} you entered is incorrect.\nPlease try again.",
          style: GoogleFonts.roboto(
              fontSize: 10,
              color: textAlertRedColor
          ),
        ),
      ],
    ),
  );
}


// Certificate Status

Widget CertificateStatusActive(height, width) {
  return Container(
    padding: EdgeInsets.all(15),
    width: width * 0.9,
    height: height * 0.15,
    decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 5,
            blurRadius: 20,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(10))
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Certificate status",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: primaryColor2
              ),
            ),
            Container(
              width: 80,
              height: 15,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primaryColor4,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text("Active", style: TextStyle(color: Colors.white, fontSize: 8),),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              "Your e-kyc data has been successfully submitted, \nthe digital certificate has been issued",
              style: GoogleFonts.roboto(
                  fontSize: 12
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget CertificateStatusProgress(height, width) {
  return Container(
    padding: EdgeInsets.all(15),
    width: width * 0.9,
    height: height * 0.15,
    decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 5,
            blurRadius: 20,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(10))
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Certificate status",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: primaryColor2
              ),
            ),
            Container(
              width: 80,
              height: 15,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tertiaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text("On Progress", style: TextStyle(color: Colors.white, fontSize: 8),),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              "Your e-kyc data has been successfully submitted, \nthe digital certificate has been issued",
              style: GoogleFonts.roboto(
                  fontSize: 12
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// Menu Active
Widget MenuActive() {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 20,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(10))
    ),
    child: ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: greyColor6,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Image.asset("assets/images/e-sign.png"),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Stamp e-Sign'),
          Text('Active')
        ],
      ),
      trailing: Icon(Icons.keyboard_arrow_right_outlined,color: primaryColor2,),
    ),
  );
}




