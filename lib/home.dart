import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:twilio/models/message.dart';
import 'package:twilio/twilio.dart';

import 'model/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ExcelData> excelDataList = [];



  late Twilio twilio;

  @override
  void initState() {
    super.initState();

    //Creating Twilio Object
     twilio = Twilio(
      accountSid: 'AC9861191e1a430fa7a2f97a45ce0e4709',
      authToken: 'b6f8a7b1b3937b76aa0ee4011a66f80f', twilioNumber: '+12243158207',
    );
  }


  //new
  Future<void> _pickFileNew() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'], // Change according to your file types
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;

      try {
        // Read file contents using file path
        var bytes = await File(file.path!).readAsBytes();

        if (bytes.isNotEmpty) {
          var excel = Excel.decodeBytes(bytes);
          print('hello $excel >>>>>>>>');

          // Process Excel data
          // for (var table in excel.tables.keys) {
          //   for (var row in excel.tables[table]!.rows) {
          //     // Process rows and cells here as needed
          //   }
          // }
          // Assuming the first row is to be skipped
          bool firstRow = true;
          for (var table in excel.tables.keys) {
            for (var row in excel.tables[table]!.rows) {
              if (firstRow) {
                firstRow = false;
                continue; // Skip the first row
              }


             // List<String> rowData = [];


              // Process rows and cells starting from the second row
              String name = row[0]!.value.toString();
              String gender = row[1]!.value.toString();
              String phoneNumber = row[2]!.value.toString();

              // Create an instance of ExcelData and add to the list
              ExcelData rowData = ExcelData(
                name: name,
                gender: gender,
                phoneNumber: phoneNumber,
              );
              setState(() {
                excelDataList.add(rowData);
              });

              // for (var cell in row) {
              //   String cellValue = cell!.value?.toString() ?? ''; // Handling potential null values
              //   rowData.add(cellValue);
              //   print("$rowData<<<<<<<<");
              // }
              // setState(() {
              //   excelData.add(rowData);
              // });
              print(excelDataList.length);
            }
          }
        } else {
          // Handle empty file
          print('Selected file is empty');
        }
      } catch (e) {
        // Handle file read error
        print('Error reading file: $e');
      }
    } else {
      // Handle no file selected or result is null
      print('No file selected or result is null');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
         const SizedBox(height: 100),
          Center(child: ElevatedButton(onPressed: (){
            _pickFileNew();
            //_pickFile();
          },child: const Text('Pick A File'),),),

          //
        const  SizedBox(height: 20),
          if (excelDataList.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: excelDataList.length - 1, // Subtract 1 to skip the first row
                itemBuilder: (context, index) {
                  final rowIndex = index + 1; // Adjust index to fetch correct data row
                  return Card(
                    margin:const EdgeInsets.all(10),
                    child: ListTile(
                      title:const Text(
                        'Phone Number',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(excelDataList[index].phoneNumber),

                    ),
                  );
                },
              ),
            ),
          excelDataList.isEmpty?const Center(child: Text('Select A file first'),): Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: ()async{
              Message? message =
              await twilio.messages.sendMessage(
                  '+2348028573121', "Hi There its ikenna from Autoskada").then((value){
                print('Message Sent ');
                //  print('${message!.body.toString()}');
              });
             try{
               Message? message =
               await twilio.messages.sendMessage(
                   '+2348028573121', "Hi There its ikenna from Autoskada").then((value){
                 print('Message Sent ');
                 //  print('${message!.body.toString()}');
               });
             }catch(e){
               print('${e.toString()}>>>>>>>');
             }

              // excelDataList.forEach((element) {
              //   print('Message sent to ${element.name}');
              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Message Sent to ${element.name}')));
             // });
            }, child:const Text('Send All emails')),
          ),

          ElevatedButton(onPressed: () async{
            try{
              Message? message =
              await twilio.messages.sendMessage(
                  '08028573121', "Hi There its ikenna from Autoskada").then((value){
                print('Message Sent to New Num');
                print('New Num Error ${value!.body}>>>>>>>>');
                //  print('${message!.body.toString()}');
              });
            }catch(e){
              print('${e.toString()}>>>>>>>');
            }
            await twilio.messages.sendMessage(
                '08028573121', "Hi There its ikenna from Autoskada").then((value){
              print('Message Sent ');
              //  print('${message!.body.toString()}');
            });


          }, child: Text('Send Message'))
        ],
      ),
    );
  }
}
