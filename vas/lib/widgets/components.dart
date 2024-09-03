import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:vas/event/event_db.dart';
import 'package:vas/screens/e-Kyc/regist_esign.dart';


// Colors

// Input Box Colors
Color greyColor = Color(0xffB8B8B8);
Color greyColor3 = Color(0xff8B8B8B);
Color greyColor6 = Color(0xffF5F5F5);
Color bluePrimary = Color(0xff3A8FFF);
Color indigoColor = Color(0xff3368FF);
Color primaryColor2 = Color(0xff2355DC);
Color alertRedColor = Color(0xffFFE0E0);
Color textAlertRedColor3 = Color(0xffFF7B7B);
Color primaryColor4 = Color(0xff48A1D9);
Color tertiaryColor100 = Color(0xffEAC100);
Color tertiaryColor50 = Color(0xffF4E080);
Color tertiaryColor4 = Color(0xffFFFBEC);
Color whiteColor = Color(0xffFFFFFF);
Color primaryColor5 = Color(0xffD7ECF9);
Color textAlertColor2 = Color(0xffED543F);
Color textAlertColor4 = Color(0xffFFECE9);




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
          color: textAlertRedColor3,
        ),
        SizedBox(
          width: width * 0.03,
        ),
        Text(
          "Oops! It looks like the ${input} you entered is incorrect.\nPlease try again.",
          style: GoogleFonts.roboto(
              fontSize: 10,
              color: textAlertRedColor3
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
                  color: tertiaryColor100
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Container(
              child: Text(
                overflow: TextOverflow.clip,
                "Please activate e-KYC immediately before placing a \ne-Signature",
                style: GoogleFonts.roboto(
                    fontSize: 12
                ),
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
                                  border: Border.all(width: 2,color: tertiaryColor100),
                                  color: tertiaryColor4
                                ),
                                child: Center(
                                  child: Text(
                                    'For using e-Sign please register e-KYC first',
                                    style: GoogleFonts.roboto(
                                      fontSize: 10,
                                      color: tertiaryColor100
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
                                    Navigator.pop(context);
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
                            backgroundColor: tertiaryColor100,
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
                  fontSize: 12,
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
    height: height * 0.12,
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
                color: tertiaryColor100,
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
              "Registration Success, You have submit the data!\nPlease check your email to activate your account",
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

Widget CertificateStatusExpired(height, width) {
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
                color: textAlertColor2,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text("Expired", style: TextStyle(color: Colors.white, fontSize: 8),),
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
                fontSize: 12,
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

Future<void> AlertSuccess(context, route, labelText, contentText) {
  return showDialog(
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
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: primaryColor4, width: 10)),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10))
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 30.0), // Add spacing for the floating icon
                  Text(
                    labelText,
                    style: GoogleFonts.roboto(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w600
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1,color: bluePrimary),
                        color: primaryColor5,
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          contentText,
                          style: GoogleFonts.roboto(
                              fontSize: 10,
                              color: bluePrimary
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
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
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>route));
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            // Floating Icon
            Positioned(
              top: -30.0,
              child: CircleAvatar(
                  backgroundColor: primaryColor2,
                  radius: 30.0,
                  child: Image.asset("assets/images/alert.png", width: 50,)
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> AlertFailed(context, labelText, contentText) {
  return showDialog(
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
                  border: Border(top: BorderSide(color: textAlertRedColor3, width: 10)),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10))
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 30.0),
                  Text(
                    labelText,
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
                      border: Border.all(width: 2,color: textAlertRedColor3),
                      color: textAlertColor4,
                    ),
                    child: Center(
                      child: Text(
                        contentText,
                        style: GoogleFonts.roboto(
                            fontSize: 10,
                            color: textAlertRedColor3
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
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Back',
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
                  backgroundColor: textAlertColor2,
                  radius: 30.0,
                  child: Icon(Icons.close, size: 50, color: Colors.white,)
              ),
            ),
          ],
        ),
      );
    },
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

Future<void> ModalSK(context, route, labelText, contentText) {
  return showDialog(
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
                  border: Border(top: BorderSide(color: primaryColor4, width: 10)),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10))
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 30.0), // Add spacing for the floating icon
                  Text(
                    labelText,
                    style: GoogleFonts.roboto(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w600
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (value) {

                      },),
                      Text(
                        contentText,
                        style: GoogleFonts.roboto(
                            fontSize: 10,
                            color: Colors.black
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                side: BorderSide(width: 1, color: primaryColor2)
                              )
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Back',
                            style: TextStyle(
                                color: primaryColor2
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              )
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>route));
                          },
                          child: Text(
                            'Done',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Floating Icon
            Positioned(
              top: -30.0,
              child: CircleAvatar(
                  backgroundColor: primaryColor2,
                  radius: 30.0,
                  child: Image.asset("assets/images/alert.png", width: 50,)
              ),
            ),
          ],
        ),
      );
    },
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

Future<void> ModalSuccessUpload(context, route, labelText, contentText) {
  return showDialog(
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
                  border: Border(top: BorderSide(color: primaryColor4, width: 10)),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10))
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 30.0), // Add spacing for the floating icon
                  Text(
                    labelText,
                    style: GoogleFonts.roboto(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w600
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        child: Text(
                          contentText,
                          style: GoogleFonts.roboto(
                              fontSize: 10,
                              color: Colors.black
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 160,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  side: BorderSide(width: 1, color: primaryColor2)
                              )
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Document Details',
                            style: TextStyle(
                              color: primaryColor2,
                              fontSize: 12

                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                              )
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>route));
                          },
                          child: Text(
                            'Done',
                            style: TextStyle(
                              color: Colors.white,

                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Floating Icon
            Positioned(
              top: -30.0,
              child: CircleAvatar(
                  backgroundColor: primaryColor2,
                  radius: 30.0,
                  child: Image.asset("assets/images/alert.png", width: 50,)
              ),
            ),
          ],
        ),
      );
    },
  );
}