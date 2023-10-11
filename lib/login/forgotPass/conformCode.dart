
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';
import 'package:tracker/provider/provider.dart';

class ConformCode extends StatefulWidget {
  const ConformCode({Key? key});

  @override
  State<ConformCode> createState() => _ConformCodeState();
}

class _ConformCodeState extends State<ConformCode> {
  TextEditingController _otpController = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  bool hasError = false;
  String? errorMessage;

  bool isLoading = false;

  void simulateLoading() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final provider = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/trackbg.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 70,
                      ),
                      Image.asset(
                        'assets/images/verfcode.png',
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Confirmation Code',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                     
                  PinCodeTextField(
                    pinBoxRadius: 10,
                    pinBoxOuterPadding: EdgeInsets.all(17),
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    hideCharacter: false,
                    highlight: true,
                    highlightColor: Colors.black,
                    defaultBorderColor: Colors.blue,
                    hasTextBorderColor: Colors.green,
                    maxLength: 4, // Change this as needed for your OTP length

                    onTextChanged: (text) {
                      setState(() {
                        hasError = false;
                      });
                    },
                    onDone: (text) {
                      // Handle OTP verification here
                     
                      if (text != '123456') {
                        setState(() {
                          hasError = true;
                          errorMessage = 'Incorrect OTP';
                        });
                      } else {
                        // Correct OTP
                        // You can navigate to the next screen or perform your desired action here
                      }
                    },
                    pinBoxWidth: 45,
                    pinBoxHeight: 45,

                    pinTextStyle: TextStyle(fontSize: 20),
                    highlightAnimationBeginColor: Colors.black,
                    highlightAnimationEndColor: Colors.white12,
                    hasError: hasError,
                  ),
                     
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _password,
                        decoration: InputDecoration(
                          hintText: 'Enter New Password',
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          if (!value.contains(RegExp(r'[0-9]'))) {
                            return 'Password must contain at least one number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _confirmPassword,
                        decoration: InputDecoration(
                          hintText: 'Enter Confirm Password',
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) {
                          if (value != _password.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                       SizedBox(height: 10),
                       Row(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 25,),
                        hasError
                          ? Text(
                              errorMessage!,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            )
                          : Container(),],),
                      
                      SizedBox(
                        height: 60,
                      ),
                      Container(
                        height: 40,
                        width: width,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (_validateForm()) {
                                    simulateLoading();
                                    provider.postVerificationCodePassword(
                                      int.parse(_otpController.text),
                                      _password.text,
                                    );
                                  }
                                },
                          child: isLoading
                              ? Transform.scale(
                                  scale: 0.5,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Verify Code',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.cyan,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateForm() {
    setState(() {
      hasError = false;
      errorMessage = null;
    });

    if (_otpController.text.isEmpty) {
      setState(() {
        hasError = true;
        errorMessage = 'OTP is required';
      });
      return false;
    }

    if (_password.text.length < 8) {
      setState(() {
        hasError = true;
        errorMessage = 'Password must be at least 8 characters';
      });
      return false;
    }

    if (!(_password.text.contains(RegExp(r'[0-9]')))) {
      setState(() {
        hasError = true;
        errorMessage = 'Password must contain at least one number';
      });
      return false;
    }

    if (_password.text != _confirmPassword.text) {
      setState(() {
        hasError = true;
        errorMessage = 'Passwords do not match';
      });
      return false;
    }

    return true;
  }
}
