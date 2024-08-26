import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

import 'package:vas/event/event_camerapref.dart';
import 'package:vas/models/camera.dart';

class CameraPicture extends StatefulWidget {
  const CameraPicture({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<CameraPicture> createState() => _CameraPictureState();
}

class _CameraPictureState extends State<CameraPicture> {

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;



  @override
  void initState() {
    // TODO: implement initState
    _controller = CameraController(widget.camera, ResolutionPreset.low);
    _initializeControllerFuture = _controller.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close, color: Colors.white,),
        ),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                CameraPreview(_controller),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 70,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            )
                          ),
                          onPressed: () async {
                            try {
                              await _initializeControllerFuture;
                              final image = await _controller.takePicture();
                              final directory = await getExternalStorageDirectory();
                              final imagePath = path.join(
                                directory!.path,
                                '${DateTime.now().millisecondsSinceEpoch}.jpeg',
                              );

                              final savedImage = File(imagePath);
                              await image.saveTo(savedImage.path);

                              Camera camera = Camera(cameraPath: imagePath.toString());
                              await CameraPref.saveCamera(camera);

                              Future.delayed(Duration(seconds: 2), () {
                                Navigator.pop(context);
                              },);

                              print(camera.cameraPath);

                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(content: Text('Picture saved to ${savedImage.path}')),
                              // );
                            } catch(e) {
                              print(e);
                            }
                          },
                          child: Icon(Icons.camera,),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
}
