import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:vas/event/event_db.dart';
import 'package:vas/event/event_pref.dart';
import 'package:vas/models/office.dart';
import 'package:vas/widgets/components.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class UploadSingle extends StatefulWidget {
  const UploadSingle({super.key});

  @override
  State<UploadSingle> createState() => _UploadSingleState();
}

class _UploadSingleState extends State<UploadSingle> {

  var _selectedFile;
  var baseName;
  var lastModified;
  var token;

  var docNameController = TextEditingController();
  var descriptionController = TextEditingController();

  var fileBinaries;

  var dateController = TextEditingController();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc']
    );

    if (result != null) {
      // _selectedFile = File(result.files.single.path!);
      _selectedFile = result.files.single.path;
      fileBinaries = await _selectedFile.readAsBytes();

      setState(() {
        baseName = basename(_selectedFile!.path);
        print(fileBinaries);
        print(baseName);
      });
    }
  }

  List<Office>? officeController;
  int? selectedOffice;

  void _fetchOffice() async {
    token = (await EventPref.getCredential())?.data.token;
    List<Office>? officeData = await EventDB.getOffice(token);
    setState(() {
      officeController = officeData;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _fetchOffice();
    super.initState();
  }



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
                          controller: docNameController,
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
                          controller: dateController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Colors.grey),
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                            hintText: 'dd/MM/yyyy',
                            suffixIcon: Icon(Icons.calendar_month),
                          ),
                          readOnly: true,
                          onTap: () async {

                            DateTime now = DateTime.now();

                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: now,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2200),
                            );
                            if(pickedDate != null) {
                              String formatDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                              setState(() {
                                dateController.text = formatDate;
                              });
                            }

                          },
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
                        child: officeController == null
                            ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.grey),
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: Text(
                                  "Loading Office...")),
                        )
                            : DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.grey),
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                          ),
                          menuMaxHeight: size.height * 0.3,
                          value: selectedOffice,
                          hint: Text("Select Office"),
                          items:
                          officeController!.map((office) {
                            return DropdownMenuItem<int>(
                              value: office.officeId,
                              child: Text(office.officeName,
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight.w400)),
                            );
                          }).toList(),
                          onChanged: (newValue) async {
                            setState(() {
                              selectedOffice = newValue;
                              if (selectedOffice != null) {
                                _fetchOffice();
                              }
                              print(selectedOffice);
                            });
                          },
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
                          controller: descriptionController,
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
                    color: Colors.black.withOpacity(0.2),
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
                                onPressed: _pickFile,
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
                  SizedBox(
                    height: 20,
                  ),
                  _selectedFile != null?
                      Row(
                        children: [
                          Icon(
                            Icons.file_present,
                            size: 50,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$baseName",
                              ),
                              Text(
                                "20 Mb",
                              ),
                            ],
                          )
                        ],
                      ):
                      Text("no data")
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
          onPressed: () async {
            // EventDB.UploadDocSingle(token, docNameController.text, selectedOffice, descriptionController.text, "tags", dateController.text, _selectedFile);
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
