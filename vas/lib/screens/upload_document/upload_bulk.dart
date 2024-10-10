import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:vas/event/event_db.dart';
import 'package:vas/event/event_pref.dart';
import 'package:vas/models/office.dart';
import 'package:vas/screens/pages/dashboard.dart';
import 'package:vas/widgets/components.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class UploadBulk extends StatefulWidget {
  const UploadBulk({super.key});

  @override
  State<UploadBulk> createState() => _UploadBulkState();
}

class _UploadBulkState extends State<UploadBulk> {
  var _selectedFile;

  var fileName;
  var lastModified;
  var token;

  var docNameController = TextEditingController();
  var descriptionController = TextEditingController();

  var fileController;
  var filePath;

  List fileList = [];
  List nameList = [];
  List sizeList = [];

  double autoHeight = 10.0;


  var nameOffice;

  var counterTag = 0;

  var dateController = TextEditingController();

  var tagKey = TextEditingController();
  var tagInformation = TextEditingController();
  var stringTagList;

  Map<String, dynamic> tagsMap = {};
  List<Map<String, dynamic>> tagsList = [];

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        var originalPath = result.files.single.path!;

        File file = File(originalPath);

        if (await file.exists()) {
          String baseName = path.basenameWithoutExtension(originalPath);
          String extension = path.extension(originalPath).replaceFirst('.', '').toUpperCase(); // Remove the dot and convert to uppercase

          String newFileName = '$baseName.$extension';
          Directory documentsDirectory = await getApplicationDocumentsDirectory();
          String newPath = path.join(documentsDirectory.path, newFileName);

          await file.copy(newPath);

          fileController = newPath;
          fileName = baseName;
          filePath = originalPath;
          var fileSize = await getFileSize(filePath, 1);
          print(fileSize);

          print('File saved to: $newPath');

          setState(() {
            fileList.add(file);
            nameList.add(fileName);
            sizeList.add(fileSize);
            autoHeight = autoHeight + 60.0;
            print(fileList);
          });

        } else {
          print('File does not exist at path: $originalPath');
        }
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  Future<String> getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = file.lengthSync();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
  }

  void removeFile(int index) {
    setState(() {
      fileList.removeAt(index);
      nameList.removeAt(index);
      sizeList.removeAt(index);
    });
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
          icon: Icon(Icons.close, color: Colors.black,),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Upload Document Bulk", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),),
            IconButton(
              onPressed: () {
                print(token);
              },
              icon: Icon(Icons.call, color: Colors.black,),
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
                  SizedBox(
                    height: 20,
                  ),
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
                            hintText: "Document Name",
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

                              if (newValue == 382) {
                                nameOffice = "Bank Jateng Pusat";
                              } else if (newValue == 664) {
                                nameOffice = "Bank Jateng Cabang Tegal";
                              } else if (newValue == 550) {
                                nameOffice = "Bank Jateng Cabang Jakarta";
                              } else {
                                nameOffice = "Bank Jateng Cabang Bandung";
                              }

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
                            hintText: "Description",
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
                    color: Colors.grey.withOpacity(0.5),
                    strokeWidth: 2,
                    dashPattern: [10,10],
                    borderType: BorderType.RRect,
                    radius: Radius.circular(10),
                    child: Container(
                      width: 400,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white70,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload, size: 100, color: Colors.black.withOpacity(0.1),),
                            SizedBox(height: 10,),
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
                                      color: bluePrimary,
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
                                      color: bluePrimary
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
                  fileList != null?
                  Column(
                    children: [
                      SizedBox(
                        height: autoHeight,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: fileList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[200],
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: Image.asset(
                                        "assets/images/pdf.png",
                                        width: MediaQuery.of(context).size.width * 0.1,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            nameList[index],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            sizeList[index],
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    IconButton(
                                      icon: Icon(Icons.close, color: Colors.red[400]),
                                      onPressed: () {
                                        setState(() {
                                          fileList.removeAt(index);
                                          nameList.removeAt(index);
                                          sizeList.removeAt(index);
                                          autoHeight = autoHeight - 60.0;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ):
                  Center(
                    child: Text(
                      "No Data",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Table(
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                  2: IntrinsicColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: bluePrimary.withOpacity(0.1),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "Tags Key",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: bluePrimary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "Tags Information",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: bluePrimary,
                          ),
                        ),
                      ),
                      SizedBox(),
                    ],
                  ),
                  for (int index = 0; index < tagsList.length; index++)
                    TableRow(
                      decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? Colors.grey[100]
                            : Colors.white,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                            width: 100,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: Border.all(
                                width: 1,
                                color: bluePrimary,
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.menu, color: bluePrimary),
                                  Text(
                                    "${tagsList[index]['tag_key']}",
                                    style: TextStyle(color: bluePrimary, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                            width: 100,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: Border.all(
                                width: 1,
                                color: bluePrimary,
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.menu, color: bluePrimary),
                                  Text(
                                    "${tagsList[index]['tag_value']}",
                                    style: TextStyle(color: bluePrimary, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                          onPressed: () {
                            tagsList.removeAt(index);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Column(
                children: [
                  Container(
                    width: size.width * 0.9,
                    height: size.height * 0.05,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: bluePrimary,
                              ),
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                width: size.width * 0.9,
                                height: size.height * 0.35,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                  "Add Tags",
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500
                                                  )
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(Icons.close, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.black.withOpacity(0.2),
                                        height: 10,
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.72,
                                            child: Text(
                                              "You can replace the tags of all selected resources or add new tags to them",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 12,
                                                  color: Colors.black.withOpacity(0.5)
                                              ),
                                              maxLines: null,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("*", style: TextStyle(color: Colors.red)),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      "Tag Key",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                SizedBox(
                                                  height: size.height * 0.065,
                                                  child: TextFormField(
                                                    controller: tagKey,
                                                    decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                                      border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 1.5,
                                                          color: Color(0xffB8B8B8),
                                                        ),
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 1,
                                                          color: Color(0xffB8B8B8),
                                                        ),
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Tag Information",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                SizedBox(
                                                  height: size.height * 0.065,
                                                  child: TextFormField(
                                                    controller: tagInformation,
                                                    decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                                      border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 1.5,
                                                          color: Color(0xffB8B8B8),
                                                        ),
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          width: 1,
                                                          color: Color(0xffB8B8B8),
                                                        ),
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 30),
                                      Container(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(vertical: 12),
                                            backgroundColor: bluePrimary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {
                                            tagsList.add({
                                              'tag_key': tagKey.text,
                                              'tag_value': tagInformation.text,
                                            });
                                            stringTagList = tagsList.map((map) {
                                              return map.entries.map((entries) {
                                                return "${entries.value}";
                                              }).join(", ");
                                            }).join("\n\n");

                                            Navigator.pop(context);
                                            setState(() {
                                              print(tagsList);
                                            });
                                            tagKey.clear();
                                            tagInformation.clear();
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.add, color: Colors.white),
                                              SizedBox(width: 8),
                                              Text(
                                                "Add Key",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: bluePrimary),
                          SizedBox(width: 8),
                          Text(
                            "Add Tags",
                            style: TextStyle(
                              color: bluePrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(15),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.05,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: bluePrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                )
            ),
            onPressed: () async {
              print("$token ${docNameController.text} $selectedOffice ${descriptionController.text} $tagsList ${dateController.text} $fileController");
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
                          height: 420,
                          decoration: BoxDecoration(
                              border: Border(top: BorderSide(color: tertiaryColor50, width: 10)),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(10))
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(height: 20.0),
                              Text(
                                "Are you sure?",
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
                                    height: 60,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 2,color: tertiaryColor100),
                                        color: tertiaryColor4
                                    ),
                                    child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              "Once a document is uploaded, you cannot change the document data. Make sure the data is correct.",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 10,
                                                  color: Colors.black
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 350,
                                height: 165,
                                padding: EdgeInsets.all(10),
                                child: Center(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Document Name",
                                              style: TextStyle(
                                                  fontSize: 12
                                              ),
                                            ),
                                            Container(
                                              width: 200,
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                docNameController.text,
                                                style: TextStyle(
                                                    fontSize: 12
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Tag",
                                              style: TextStyle(
                                                  fontSize: 12
                                              ),
                                            ),
                                            Text(
                                              stringTagList,
                                              style: TextStyle(
                                                  fontSize: 12
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "File Attachments",
                                              style: TextStyle(
                                                  fontSize: 12
                                              ),
                                            ),
                                            Container(
                                              width: 200,
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                fileName,
                                                style: TextStyle(
                                                    fontSize: 12
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Date",
                                              style: TextStyle(
                                                  fontSize: 12
                                              ),
                                            ),
                                            Text(
                                              dateController.text,
                                              style: TextStyle(
                                                  fontSize: 12
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Office",
                                              style: TextStyle(
                                                  fontSize: 12
                                              ),
                                            ),
                                            Text(
                                              nameOffice,
                                              style: TextStyle(
                                                  fontSize: 12
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Description",
                                              style: TextStyle(
                                                  fontSize: 12
                                              ),
                                            ),
                                            Container(
                                              width: 200,
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                descriptionController.text,
                                                style: TextStyle(
                                                    fontSize: 12
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                ),
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
                                              side: BorderSide(width: 1, color: bluePrimary)
                                          )
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Back',
                                        style: TextStyle(
                                            color: bluePrimary,
                                            fontSize: 12

                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 150,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: bluePrimary,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10))
                                          )
                                      ),
                                      onPressed: () async {

                                        List status = await EventDB.UploadDocBulk(token, docNameController.text, selectedOffice.toString(), descriptionController.text, tagsList, dateController.text, fileList);
                                        if(status[0] == true) {
                                          Navigator.pop(context);
                                          ModalSuccessUpload(context, Dashboard(token: token), "Upload Successful!", "Documents have been added! You can now view document details or continue browsing");
                                        } else {
                                          Navigator.pop(context);
                                          AlertFailed(context, "Upload File", "Error: ${status[1]}");
                                        }
                                      },
                                      child: Text(
                                        'Upload',
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
                              backgroundColor: tertiaryColor50,
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
            child: Text(
              "Kirim",
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        ),
      ),
    );
  }
}
