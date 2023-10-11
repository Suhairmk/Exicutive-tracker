import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/controller/homecontroller.dart';
import 'package:tracker/controller/imagepicker.dart';
import 'package:tracker/provider/provider.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.destId});
  final int destId;
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  File? _meterImage;
  File? _targetImage;
  TextEditingController remarksController = TextEditingController();
  double? meter_latitude;
  double? meter_longitude;
  double? target_latitude;
  double? target_longitude;

  //to get the location
  Future<void> getLocation(value) async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy:
          LocationAccuracy.high, // Replace with accuracy: LocationAccuracy.high
    );
    if (value == 'meter') {
      setState(() {
        meter_latitude = position.latitude;
        meter_longitude = position.longitude;
      });
    }
    if (value == 'target') {
      setState(() {
        target_latitude = position.latitude;
        target_longitude = position.longitude;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final provider = Provider.of<AppProvider>(context);
    final int destId = widget.destId;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Visit Details',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: WillPopScope(
          onWillPop: () async{
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomeController(index: 0,)));
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Imagepicker(
                            onPickImage: ((pickedImage) {
                              _meterImage = pickedImage;
                              getLocation('meter');
                            }),
                          ),
                          Text('Add your Meter image'),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Imagepicker(
                            onPickImage: ((pickedImage) {
                              _targetImage = pickedImage;
                              getLocation('target');
                            }),
                          ),
                          Text('Add your Target image'),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                // Column(
                //   children: [
                //     Text('meter=' +
                //         'latitude ' +
                //         meter_latitude.toString() +
                //         ' ' +
                //         'longitude ' +
                //         meter_longitude.toString()),
                //     Text('target=' +
                //         'latitude ' +
                //         target_latitude.toString() +
                //         ' ' +
                //         'longitude ' +
                //         target_longitude.toString())
                //   ],
                // ),
                Container(
                  height: height - 450,
                  width: width - 30,
                  color: Colors.cyan[50],
                  child: TextFormField(
                    controller: remarksController,
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: 'Remarks..',
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: 40,
                    width: width - 200,
                    child: ElevatedButton(
                      onPressed: () {
                        provider.uploadImages(
                            context,
                            _meterImage,
                            _targetImage,
                            remarksController.text,
                            meter_latitude,
                            meter_longitude,
                            destId);
                      },
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.cyan,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
