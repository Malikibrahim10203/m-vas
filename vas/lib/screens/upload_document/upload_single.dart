import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:vas/widgets/components.dart';

class UploadSingle extends StatefulWidget {
  const UploadSingle({super.key});

  @override
  State<UploadSingle> createState() => _UploadSingleState();
}

class _UploadSingleState extends State<UploadSingle> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Upload Document"),
            IconButton(
              onPressed: () {

              },
              icon: Icon(Icons.call),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("* ",
                          style: TextStyle(color: Colors.red)),
                      Text("Document Name"),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: size.height * 0.065,
                        width: size.width * 0.905,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.5,
                                  color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("* ",
                          style: TextStyle(color: Colors.red)),
                      Text("Date"),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: size.height * 0.065,
                        width: size.width * 0.905,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.5,
                                  color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("* ",
                          style: TextStyle(color: Colors.red)),
                      Text("Office"),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: size.height * 0.065,
                        width: size.width * 0.905,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.5,
                                  color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("* ",
                          style: TextStyle(color: Colors.red)),
                      Text("Description"),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: size.height * 0.065,
                        width: size.width * 0.905,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.5,
                                  color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xffB8B8B8)),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Upload Single Document",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DottedBorder(
                    color: Colors.black.withOpacity(0.5),
                    strokeWidth: 2,
                    dashPattern: [10,10],
                    borderType: BorderType.RRect,
                    radius: Radius.circular(10),
                    child: Container(
                      width: 400,
                      height: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload_outlined, size: 70, color: Colors.black.withOpacity(0.1),),
                            SizedBox(height: 20,),
                            Text("Format : PDF | Max : 5 Mb"),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: size.width * 0.7,
                              height: size.height * 0.05,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    side: BorderSide(
                                      width: 1,
                                      color: primaryColor2,
                                    ),
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    )
                                ),
                                onPressed: () {},
                                child: Text(
                                  "Upload Document",
                                  style: TextStyle(
                                    color: primaryColor2
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(15),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bluePrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            )
          ),
          onPressed: () {

          },
          child: Text(
            "Kirim",
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}
