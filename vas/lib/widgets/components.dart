import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:vas/screens/e-Kyc/regist_esign.dart';


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
Color tertiaryColor4 = Color(0xffFFFBEC);
Color whiteColor = Color(0xffFFFFFF);




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

Widget CertificateStatusNotActive(height, width, context) {
  return Container(
    padding: EdgeInsets.all(15),
    width: width * 0.9,
    height: 150,
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
              "You have not activated e-KYC!",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: tertiaryColor
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              "Please activate e-KYC immediately before placing a e-Signature",
              style: GoogleFonts.roboto(
                  fontSize: 12
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          width: 500,
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(top: BorderSide(color: Colors.yellow, width: 10)),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10))
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(height: 30.0), // Add spacing for the floating icon
                              Text(
                                'Your e-KYC is Not Active!',
                                style: GoogleFonts.roboto(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w600
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                width: 300,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2,color: tertiaryColor),
                                  color: tertiaryColor4
                                ),
                                child: Center(
                                  child: Text(
                                    'For using e-Sign please register e-KYC first',
                                    style: GoogleFonts.roboto(
                                      fontSize: 10,
                                      color: tertiaryColor
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                width: 300,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: bluePrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                    )
                                  ),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistEsign()));
                                  },
                                  child: Text(
                                    'Activate',
                                    style: TextStyle(
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Floating Icon
                        Positioned(
                          top: -30.0,
                          child: CircleAvatar(
                            backgroundColor: tertiaryColor,
                            radius: 30.0,
                            child: Image.asset("assets/images/alert.png", width: 50,)
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Text("Activate e-Kyc", style: TextStyle(color: Colors.white),),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              backgroundColor: bluePrimary
            ),
          ),
        ),
      ],
    ),
  );
}

Widget CertificateStatusActive(height, width) {
  return Container(
    padding: EdgeInsets.all(15),
    width: width * 0.9,
    height: 110,
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

Future<void> ModalSendEmail(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 300,
            height: 300,
            child: Lottie.asset(
              "assets/json/done.json",
              repeat: false,
              fit: BoxFit.contain,
            ),
          ),
        );
      }
  );
}




Future<void> ModalWait(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Lottie.asset("assets/json/loading.json", repeat: true, fit: BoxFit.contain, width: 100, height: 100);
      }
  );
}



