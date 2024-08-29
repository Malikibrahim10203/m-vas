import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas/event/event_db.dart';
import 'package:vas/screens/pages/dashboard.dart';
import 'package:vas/widgets/components.dart';

class CameraVideo extends StatefulWidget {
  const CameraVideo({super.key, required this.token, required this.tokenPeruri, required this.otp});

  final token, tokenPeruri, otp;

  @override
  State<CameraVideo> createState() => _CameraVideoState();
}

class _CameraVideoState extends State<CameraVideo> {
  late List<CameraDescription> cameras;
  CameraController? cameraController;  // Use CameraController? to handle null case
  bool isRecording = false;
  String? videoBase64;
  Future<void>? _initializeControllerFuture;  // Future for initializing camera

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras[1], ResolutionPreset.low);
    _initializeControllerFuture = cameraController!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  @override
  void dispose() {
    cameraController?.dispose();  // Use ?. to safely dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Camera has been initialized successfully
            return Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      child: CameraPreview(cameraController!),
                    ),
                    ClipPath(
                      clipper: HoleClipper(context: context),
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        width: MediaQuery.of(context).size.width * 1,
                        height: MediaQuery.of(context).size.height * 1,
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.23,
                        ),
                        Center(
                          child: Image.asset(
                            "assets/images/border.png",
                            width: MediaQuery.of(context).size.width * 0.8,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.75,
                        ),

                        isRecording
                            ? Center(
                          child: GestureDetector(
                            onTap: () {

                            },
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 22.0,
                                backgroundColor: textAlertColor4,
                                child: CircleAvatar(
                                  radius: 12.0,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    backgroundColor: textAlertColor4,
                                    radius: 7.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                            : Center(
                          child: GestureDetector(
                            onTap: () {
                              startVideoRecording();
                            },
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 22.0,
                                backgroundColor: textAlertColor2,
                                child: CircleAvatar(
                                  radius: 12.0,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    backgroundColor: textAlertColor2,
                                    radius: 7.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (videoBase64 != null)
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Video captured successfully."),
                      ),
                  ],
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error initializing camera: ${snapshot.error}'),
            );
          } else {
            // While waiting for the camera to initialize
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(20),
        child: bottomSave(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> startVideoRecording() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    if (cameraController!.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController!.startVideoRecording();
      setState(() {
        isRecording = true;
      });

      Future.delayed(Duration(seconds: 1),() {
        return showFloatingSnackBar(context, "Please your face should inside the circle, Look at the camera. Please follow the instructiion. Click button bellow to start recording");
      },);

      Future.delayed(Duration(seconds: 4),() {
        return showFloatingSnackBar(context, "Blink your eyes twice");
      },);

      Future.delayed(Duration(seconds: 7),() {
        return showFloatingSnackBar(context, "Open your mouth");
      },);

      Future.delayed(Duration(seconds: 10),() {
        return showFloatingSnackBar(context, "Yup, your face recording is successfull");
      },);

      Future.delayed(Duration(seconds: 15), () {
        setState(() {
          stopVideoRecording();
        });
      },);

    } catch (e) {
      print(e);
    }
  }

  Future<void> stopVideoRecording() async {
    if (cameraController == null || !cameraController!.value.isRecordingVideo) {
      return;
    }

    try {
      XFile videoFile = await cameraController!.stopVideoRecording();

      setState(() {
        isRecording = false;
      });
      print("Video recorded to ${videoFile.path}");

      videoBase64 = await convertVideoToBase64(videoFile.path);
      print("Video Base64: $videoBase64");

      activateAccount(videoBase64!);

    } catch (e) {
      print(e);
    }
  }

  Future<String> convertVideoToBase64(String filePath) async {
    try {
      File videoFile = File(filePath);
      List<int> videoBytes = await videoFile.readAsBytes();
      return base64Encode(videoBytes);
    } catch (e) {
      print('Error converting video to Base64: $e');
      return '';
    }
  }

  void activateAccount(String videoBase64) {
    print('Submitting video for account activation...');
  }

  Widget bottomSave() {
    return Container(
      width: 500,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bluePrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {

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
                      padding: const EdgeInsets.all(30.0),
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
                            "labelText",
                            style: GoogleFonts.roboto(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w600
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: 400,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(width: 2,color: bluePrimary),
                              color: primaryColor5,
                            ),
                            child: Center(
                              child: Text(
                                "contentText",
                                style: GoogleFonts.roboto(
                                    fontSize: 10,
                                    color: bluePrimary
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
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
                                          side: BorderSide(width: 2, color: primaryColor2.withOpacity(0.5))
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
                                  onPressed: () async {

                                    var data = await EventDB.VideoKyc(widget.token, widget.tokenPeruri, videoBase64!, widget.otp);

                                    print("Token: ${widget.token}");
                                    print("Token Peruri: ${widget.tokenPeruri}");
                                    print("OTP: ${widget.otp}");
                                    print("Token: ${videoBase64}");

                                    if(data == "error") {
                                      print("Video Kyc: $data");
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard(token: widget.token)));
                                      print("Video Kyc: $data");
                                    }
                                  },
                                  child: Text(
                                    'Send',
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

          print("${widget.token}, ${widget.tokenPeruri}, ${widget.otp}, ${videoBase64}");
        },
        child: Text(
          "Send",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void showFloatingSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 10
          ),
        ),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,  // Set behavior to floating
        backgroundColor: primaryColor2.withOpacity(0.5),  // Customize background color
        padding: EdgeInsets.all(16),  // Customize padding
        margin: EdgeInsets.symmetric(vertical: 130),   // Customize margin
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),  // Customize shape
        ),
      ),
    );
  }
}

class HoleClipper extends CustomClipper<Path> {
  const HoleClipper({required this.context});

  final BuildContext context;

  @override
  Path getClip(Size size) {
    Path path = Path();
    // Define the outer rectangle
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Define the circle hole and subtract it from the outer rectangle
    Path holePath = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2.13),
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.48,
      ));

    // Combine the paths to subtract the hole from the main path
    path = Path.combine(PathOperation.difference, path, holePath);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
