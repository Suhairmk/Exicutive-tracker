import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/Screens/Dashboard.dart';
import 'package:tracker/Screens/changepassowrd.dart';
import 'package:tracker/controller/homecontroller.dart';
import 'package:tracker/provider/provider.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  // String _imagePath = ""; // Store the selected image path here
  bool _isCameraSelected = true; // Track the current action (camera or gallery)
  File? profileImg;
  String? name;
  String? email;
  String? phone;
  // Function to pick an image using image_picker
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: _isCameraSelected ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        profileImg = File(pickedImage.path);
        final provider = Provider.of<AppProvider>(context, listen: false);
        provider.updateProfileImage(profileImg!);
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AlertDialog(
              //   contentPadding: EdgeInsets.all(15),
              insetPadding: EdgeInsets.symmetric(horizontal: 4),
              content: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.photo_camera,
                        color: Colors.blue,
                      ),
                      title: Text('Camera'),
                      onTap: () {
                        setState(() {
                          _isCameraSelected = true;
                        });
                        Navigator.of(context).pop(); // Close the dialog
                        _pickImage(); // Open Camera
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.photo_library,
                        color: Colors.blue,
                      ),
                      title: Text('Gallery'),
                      onTap: () {
                        setState(() {
                          _isCameraSelected = false;
                        });
                        Navigator.of(context).pop(); // Close the dialog
                        _pickImage();
                        // Open Gallery
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> retrieveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      email = prefs.getString('email');
      phone = prefs.getString('contact_no');
    });
  }

  @override
  void initState() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.fetchImage(); // Assuming this fetches some data
    retrieveUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Account'),
        backgroundColor: Colors.white,
      ),
      body: WillPopScope(
        onWillPop: () async {
          //provider.fetchImage();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Dashboard()));
          return true;
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment
                      .bottomRight, // Align items to the bottom right corner
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.cyan[50],
                      radius: 80,
                      backgroundImage: provider.imagedata != null
                          ? NetworkImage(provider.imagedata!)
                          : null,
                      foregroundImage:
                          profileImg != null ? FileImage(profileImg!) : null,
                    ),
                    // Edit icon positioned at the bottom right corne
                    Positioned(
                      bottom: 0,
                      child: FloatingActionButton(
                        backgroundColor: Colors.cyan,
                        child: Icon(
                          Icons.edit,
                          color: const Color.fromARGB(
                              255, 21, 20, 20), // Customize the icon color
                          size: 25.0,
                        ),
                        onPressed: () {
                          _showImageSourceDialog();
                        },
                        // Customize the icon size
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Text(
                  name.toString(),
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 20),
                Divider(height: 2),
                SizedBox(height: 20),
                // Use a ListView for the Email and Phone Number sections
                ListView(
                  shrinkWrap:
                      true, // Important to make ListView scrollable in a Column
                  children: [
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text(
                        'Email',
                        style: TextStyle(fontSize: 12),
                      ),
                      subtitle: Text(
                       email.toString(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text(
                        'Phone Number',
                        style: TextStyle(fontSize: 12),
                      ),
                      subtitle: Text(
                       phone.toString(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.key),
                  trailing: Icon(Icons.arrow_forward_ios),
                  title: Text('Change Password'),
                  onTap: () {
                    // Handle Home navigation
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePassword()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
