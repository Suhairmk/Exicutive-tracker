import 'dart:io';

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:tracker/Screens/preview.dart';
import 'package:tracker/controller/homecontroller.dart';
import 'package:tracker/login/forgotPass/conformCode.dart';
import 'package:tracker/login/login.dart';
import 'package:tracker/model/model.dart';

class AppProvider extends ChangeNotifier {
  Map? authData;
  Map? preview;
  String? imagedata;
  bool? isLogined;
  final _dio = Dio(); // Create a Dio instance
  List<Destination> destination = [];
  List<Pending> pendingList = [];
//to make phone call
  void makePhoneCall(String phoneNumber) async {
    final Uri phoneCallUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(phoneCallUri.toString())) {
      await launch(phoneCallUri.toString());
    } else {
      throw 'Could not launch $phoneCallUri';
    }
  }

//login api start
  Future<void> postEmailAndPassword(String email, String password) async {
    try {
      final String apiUrl =
          "https://apitest.ynotz.in/api/login"; // Replace with your API endpoint

      final data = {
        'email': email,
        'password': password,
      };

      final response = await _dio.post(
        apiUrl,
        data: data,
        options: Options(
          followRedirects: false,
          headers: {
            'Content-Type':
                'application/json' // Set the content type as per your API requirements
          },
        ),
      );

      if (response.statusCode == 200) {
        // Successful response, handle the data here

        authData = response.data;
        print("Response Data: $authData");
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('user_id', authData!['user_id']);
        prefs.setString('access_token', authData!['access_token']);
        prefs.setString('name', authData!['name']);
        prefs.setString('email', authData!['email']);
        prefs.setString('contact_no', authData!['contact_no']);
        prefs.setBool('isAuthenticated', true);

        notifyListeners();
      } else {
        print("API Error - Status Code: ${response.statusCode}");
        print("API Error - Response Data: ${response.data}");
      }
    } catch (error) {
      print("Error: $error");
    }

    notifyListeners();
  }

  //login api finish
//logout user Start
  Future<void> logoutUser(context) async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('user_id');
    final String? token = prefs.getString('access_token');

    try {
      final String apiUrl = "https://apitest.ynotz.in/api/logout";

      print(token);
      print(userId);
      final response = await _dio.post(
        apiUrl,
        options: Options(
          followRedirects: true, // Allow Dio to follow redirections
          maxRedirects: 5, // Set a maximum number of redirections (if needed)
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Logout successful
        // Clear user data and navigate to the login screen

        print(response.data);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
        authData!.clear(); // Replace with your login screen route
      } else {
        // Handle logout error (e.g., display an error message)
        // You can add error handling here based on the response from your server
        print("Logout Error - Status Code: ${response.statusCode}");
        print("Logout Error - Response Data: ${response.data}");
      }
    } catch (e) {
      print("Logout Error: $e");
    }
    notifyListeners();
  }
  //logout user Finish

  //getdata from api for targetlist
  Future<void> getTargetList(currentDate) async {
    final String _baseUrl = 'https://apitest.ynotz.in/api/getlist';

    final prefs = await SharedPreferences.getInstance();
    final int? endpoint = prefs.getInt('user_id');
    final String? _authToken = prefs.getString('access_token');

    final date = DateFormat('yyyy-MM-dd').format(currentDate).toString();
    _dio.options.headers['Authorization'] = 'Bearer $_authToken';

    final queryParams = {
      'scheduled_date': date,
    };

    try {
      final Response response = await _dio.get(
        '$_baseUrl/$endpoint',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        // Assuming the response data is a list of destinations
        
        // print(response.data);
        Map<String, dynamic> responseData = response.data;
        Map<String, dynamic> destinationMap = responseData['destinations'];

        // Clear the existing data in the destination list

        // Iterate through the response list and create Destination objects
        destinationMap.forEach((key, value) {
          Destination dest = Destination(
              destinationId: value['destination_id'],
              name: value['name'],
              contactNumber: value['contact_number'],
              location: value['location'],
              scheduledTime: value['scheduled_time'],
              status: value['status'],
              visitedDate: value['visited_date']);

          destination.add(dest);
        });
      } else {
        
        print('Error: Request failed with status code ${response.statusCode}');

        throw 'Error: Request failed with status code ${response.statusCode}';
      }
    } catch (error) {
      
      throw error;
    }
    notifyListeners();
  }

//to upload image
  Future<void> uploadImages(
    context,
    File? meterImage,
    File? targetImage,
    String? remarks,
    double? latitude,
    double? longitude,
    int? destinationId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('user_id');
    final String? token = prefs.getString('access_token');

    final dio = Dio();

    // Define the API endpoint URL
    final apiUrl = 'https://apitest.ynotz.in/api/store';

    // Create a FormData object to send the images and remarks
    FormData formData = FormData();

    // Add meter image if provided
    if (meterImage != null) {
      formData.files.add(
        MapEntry(
          'meter_img',
          await MultipartFile.fromFile(
            meterImage.path,
            filename: 'meter_img.jpg',
          ),
        ),
      );
    } else {
      print('meter image empty');
    }

    // Add target image if provided
    if (targetImage != null) {
      formData.files.add(
        MapEntry(
          'dest_img',
          await MultipartFile.fromFile(
            targetImage.path,
            filename: 'target_image.jpg',
          ),
        ),
      );
    } else {
      print('target image empty');
    }

    // Add remarks if provided
    if (remarks != null) {
      formData.fields.add(
        MapEntry('remarks', remarks),
      );
    } else {
      print('remarks empty');
    }

    // Add latitude if provided
    if (latitude != null) {
      formData.fields.add(
        MapEntry('lattitude',
            latitude.toString()), // Correct the field name to 'latitude'
      );
    } else {
      print('latitude  empty');
    }

    // Add longitude if provided
    if (longitude != null) {
      formData.fields.add(
        MapEntry('longitude', longitude.toString()),
      );
    } else {
      print('longitude empty');
    }

    // Add user_id if provided
    if (userId != null) {
      formData.fields.add(
        MapEntry('user_id', userId.toString()),
      );
    } else {
      print('usrId empty');
    }

    // Add destination_id if provided
    if (destinationId != null) {
      formData.fields.add(
        MapEntry('destination_id', destinationId.toString()),
      );
    } else {
      print('destId empty');
    }

    try {
      // Send the POST request with FormData and set the 'token' as a header
      Response response = await dio.post(
        apiUrl,
        data: formData,
        options: Options(
          headers: {
            'Authorization':
                'Bearer $token', // Set the token as a Bearer token in the header
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Images uploaded successfully');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeController(index: 0,)));
        print('Response: ${response.data}');
      } else {
        print('Error: Request failed with status code ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

//to get preview data
  Future<void> getpreviewData(context, visitId) async {
    final String _baseUrl = 'https://apitest.ynotz.in/api/show/visit';

    final prefs = await SharedPreferences.getInstance();

    final String? _authToken = prefs.getString('access_token');

    int endpoint = visitId;
    _dio.options.headers['Authorization'] = 'Bearer $_authToken';

    try {
      print(visitId);

      final Response response = await _dio.get('$_baseUrl/$endpoint');
      print(visitId);
      if (response.statusCode == 200) {
        preview = response.data;
        print(response.data);
        print(preview!['remarks']);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PreviewScreen(
                      visitId: preview!['visit_id'],
                    )));
      } else {
        print('Error: Request failed with status code ${response.statusCode}');
        throw 'Error: Request failed with status code ${response.statusCode}';
      }
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  //to update remarks
  Future<void> updateRemarks(remark, visitId, context) async {
    final String apiUrl = 'https://apitest.ynotz.in/api/update';

    final prefs = await SharedPreferences.getInstance();

    final String? _authToken = prefs.getString('access_token');

    int endpoint = visitId;
    try {
      final dio = Dio();
      final data = {
        'remarks': remark,
      };
      dio.options.headers["Authorization"] = "Bearer $_authToken";

      final response = await dio.put(
        '$apiUrl/$endpoint',
        data: data,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Remarks Updated'),
          duration: Duration(seconds: 2),
        ));
        print('Remarks updated successfully');
      } else {
        print('Failed to update remarks. Status code: ${response.statusCode}');
        // You can handle error cases here, such as showing a message to the user.
      }
    } catch (error) {
      print('Error while updating remarks: $error');
      // You can handle exceptions here, such as network errors.
    }
  }

//add new Targets
  Future<void> addTargetData(String targetName, String location, String phone,
      context, DateTime date, TimeOfDay time) async {
    final dio = Dio();
    final baseurl = 'https://apitest.ynotz.in/api/addlist';

    final prefs = await SharedPreferences.getInstance();
    final int? endpoint = prefs.getInt('user_id');
    final String? token = prefs.getString('access_token');

    final currentDate = DateFormat('yyyy-MM-dd').format(date);
    final formattedTime =
        '${time.hour}:${time.minute.toString().padLeft(2, '0')}';

    final data = {
      'destName': targetName,
      'Location': location,
      'contactNo': phone,
      'scheduled_date': currentDate,
      'scheduled_time': formattedTime,
    };
    try {
      // print(targetName);
      // print(location);
      // print(phone);
      // print(currentDate);
      // print(formattedTime);
      // print(token);
      //  print(endpoint);
      Response response = await dio.post(
        '$baseurl/$endpoint',
        data: data,
        options: Options(
          headers: {
            'Authorization':
                'Bearer $token', // Set the token as a Bearer token in the header
            'Content-Type': 'application/json',
          },
        ),
      );
      print('sssssssssssss');
      if (response.statusCode == 201) {
        print('Data sent successfully');
        // You can handle success here
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeController(index: 0,)));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('target Added Successfully'),
          duration: Duration(seconds: 2),
        ));
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
        // You can handle error cases here, such as showing a message to the user.
      }
    } catch (error) {
      print('Error while sending data: $error');
      // You can handle exceptions here, such as network errors.
    }
  }

//to update password
  Future<void> updatePassword(
      String currentPassword, String newPassword, context) async {
    final dio = Dio();
    final baseUrl = 'https://apitest.ynotz.in/api/update/password';

    final prefs = await SharedPreferences.getInstance();
    final int? endpoint = prefs.getInt('user_id');
    final String? token = prefs.getString('access_token');

    final data = {
      'password': currentPassword,
      'new_password': newPassword,
    };

    try {
      final response = await dio.put(
        '$baseUrl/$endpoint',

        data: data,
        options: Options(
          headers: {
            'Authorization':
                'Bearer $token', // Set the token as a Bearer token in the header
            'Content-Type': 'application/json',
          },
        ),
        // You can set headers or authentication tokens here if needed
      );

      if (response.statusCode == 200) {
        print('Password updated successfully');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password Updated'),
          duration: Duration(seconds: 2),
        ));
        // You can handle success here, such as displaying a success message to the user.
      } else {
        print('Failed to update password. Status code: ${response.statusCode}');
        // You can handle error cases here, such as showing an error message to the user.
      }
    } catch (error) {
      print('Error while updating password: $error');
      // You can handle exceptions here, such as network errors.
    }
  }

  //to update profile
  Future<void> updateProfileImage(File imageFile) async {
    final dio = Dio();
    final prefs = await SharedPreferences.getInstance();
    final int? endpoint = prefs.getInt('user_id');
    final String? token = prefs.getString('access_token');

    String url =
        'https://apitest.ynotz.in/api/update/profileimage'; // Replace with your API endpoint
    FormData formData = FormData.fromMap({
      'profile_image': await MultipartFile.fromFile(imageFile.path),
      //await MultipartFile.fromFile(imageFile.path),
    });

    // Add any additional headers you need, such as an authorization token
    Options options = Options(
      headers: {
        'Authorization': 'Bearer $token',
        //  'Content-Type': 'application/json',
      },
    );
    try {
      print('start');
      print(imageFile.path);
      Response response = await dio.post(
        '$url/$endpoint',
        data: formData,
        options: options,
      );

      if (response.statusCode == 200) {
        // Image upload successful, handle the response
        print('Profile image updated successfully');
      } else {
        // Handle error
        print('Profile image update failed');
      }
    } catch (error) {
      // Handle exceptions
      print('Error: $error');
    }
    notifyListeners();
  }

  //to get profile image

  Future<void> fetchImage() async {
    String imageUrl = 'https://apitest.ynotz.in/api/show/updatedimage';

    final prefs = await SharedPreferences.getInstance();
    final int? endpoint = prefs.getInt('user_id');
    final String? token = prefs.getString('access_token');

    Dio dio = Dio();
    Options options = Options(headers: {
      'Authorization': 'Bearer $token',
      //  'Content-Type': 'application/json',
    });
    try {
      Response response =
          await dio.get('$imageUrl/$endpoint', options: options);

      if (response.statusCode == 200) {
        imagedata = response.data['image_url'];
        print(response.data);
      } else {
        print(
            'Error: Image request failed with status code ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

//email sending for getting otp
  Future<void> postEmailForForgottPassword(String email, context) async {
    try {
      final String apiUrl =
          "https://apitest.ynotz.in/api/forgot/password"; // Replace with your API endpoint
      final data = {
        'email': email,
      };

      Response response = await _dio.post(
        apiUrl,
        data: data,
        options: Options(
          // followRedirects: false,
          headers: {
            'Content-Type':
                'application/json' // Set the content type as per your API requirements
          },
        ),
      );
      if (response.statusCode == 200) {
        // Successful response, handle the data here
        print("Response Data:" + response.data.toString());
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ConformCode()));
        notifyListeners();
      } else {
        print("API Error - Status Code: ${response.statusCode}");
        print("API Error - Response Data: ${response.data}");
      }
    } catch (error) {
      print("error: $error");
    }
    notifyListeners();
  }

//otp and password sending for update
  Future<void> postVerificationCodePassword(int code, String password) async {
    try {
      final String apiUrl =
          "https://apitest.ynotz.in/api/checkcode"; // Replace with your API endpoint
      final data = {
        'code': code,
        'password': password,
      };
      final response = await _dio.post(
        apiUrl,
        data: data,
        options: Options(
          followRedirects: false,
          headers: {
            'Content-Type':
                'application/json' // Set the content type as per your API requirements
          },
        ),
      );
      if (response.statusCode == 200) {
        // Successful response, handle the data here
        //print('sent seccess');
        print("Response Data:" + response.data);
        notifyListeners();
      } else {
        print("API Error - Status Code: ${response.statusCode}");
        print("API Error - Response Data: ${response.data}");
      }
    } catch (error) {
      print("Error: $error");
    }
    notifyListeners();
  }

  //get pending list
  Future<void> getPendingist() async {
    final String _baseUrl = 'https://apitest.ynotz.in/api/pending';

    final prefs = await SharedPreferences.getInstance();
    final int? endpoint = prefs.getInt('user_id');
    final String? _authToken = prefs.getString('access_token');

    _dio.options.headers['Authorization'] = 'Bearer $_authToken';

    try {
      final Response response = await _dio.get('$_baseUrl/$endpoint');

      if (response.statusCode == 200) {
        // Assuming the response data is a map
        Map<String, dynamic> responseData = response.data;

        if (responseData.containsKey('destinations')) {
          Map<String, dynamic> destinationMap = responseData['destinations'];

          pendingList.clear();

          destinationMap.forEach(
            (key, value) {
              // DateTime scheduledDate = DateTime.parse(value['scheduled_date']);
              // List<String> timeParts = value['scheduled_time'].split(':');
              // int hours = int.parse(timeParts[0]);
              // int minutes = int.parse(timeParts[1]);
              // TimeOfDay scheduledTime = TimeOfDay(hour: hours, minute: minutes);

              Pending datas = Pending(
                destinationId: value['destination_id'],
                name: value['name'],
                contactNumber: value['contact_number'],
                location: value['location'],
                scheduledDate: value['scheduled_date'],
                scheduledTime: value['scheduled_time'],
              );

              pendingList.add(datas);
            },
          );
        } else {
          // Handle the case where 'destinations' key is missing
          print('Invalid response structure: "destinations" key is missing.');
        }

        print(' length: ${pendingList.length}');
      } else {
        print('Error: Request failed with status code ${response.statusCode}');
        throw 'Error: Request failed with status code ${response.statusCode}';
      }
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }
}
