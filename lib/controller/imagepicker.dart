import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Imagepicker extends StatefulWidget {
  const Imagepicker({super.key, required this.onPickImage});
  final void Function(File pickedImage) onPickImage;

  @override
  State<Imagepicker> createState() => _ImagepickerState();
}

class _ImagepickerState extends State<Imagepicker> {
  //requesting for permission
  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      // Permission granted. You can now access location.
    } else if (status.isDenied) {
      // Permission denied. Handle accordingly.
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied. Open settings to enable manually.
    }
  }

  File? _pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: MediaQuery.of(context).size.width / 2 - 20,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          width: MediaQuery.of(context).size.width / 2 - 20,
          decoration: BoxDecoration(
            color: const Color.fromARGB(222, 224, 247, 250),
            image: DecorationImage(
              image: AssetImage('assets/images/camsmall.png'),
              fit: BoxFit.none, // Adjust the fit as needed
            ),
          ),
          child: InkWell(
            onTap: () {
              requestLocationPermission();
              _pickImage();
            },
            // You can optionally add child widgets within the Container here
            child: _pickedImageFile != null
                ? Image(
                    image: FileImage(_pickedImageFile!),fit: BoxFit.fill,
                  )
                : null,
          ),
        )

        // InkWell(
        //   onTap: () {
        //     requestLocationPermission();

        //      _pickImage();
        //   },
        //   child: CircleAvatar(

        //     child: Image(image: AssetImage('assets/images/camsmall.png',),height: 20,width: 20,color: Colors.black,),
        //     radius: 30,
        //     backgroundColor: Color.fromARGB(153, 241, 239, 239),
        //     foregroundImage:
        //         _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        //   ),
        // ),
      ],
    );
  }
}
