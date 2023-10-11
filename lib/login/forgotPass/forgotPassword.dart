import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/login/forgotPass/conformCode.dart';
import 'package:tracker/provider/provider.dart';

class ForgoPassword extends StatefulWidget {
  const ForgoPassword({super.key});

  @override
  State<ForgoPassword> createState() => _ForgoPasswordState();
}

class _ForgoPasswordState extends State<ForgoPassword> {
  TextEditingController emailController = TextEditingController();
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
      body: Stack(children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/trackbg.png'),
                fit: BoxFit.fill),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(children: [
                  // SizedBox(
                  //   height: height - 600,
                  // ),
                  Image.asset('assets/images/forgtpass.png'),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Forgot Password',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: 'Enter E-mail here',
                        labelText: 'E-mail',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  Container(
                    height: 40,
                    width: width,
                    child: ElevatedButton(
                      onPressed: () async {
                        simulateLoading();
                        provider.postEmailForForgottPassword(
                            emailController.text, context);
                      },
                      child:isLoading?Transform.scale(
                        scale: .5,
                        child: CircularProgressIndicator(color: Colors.white,)):
                       Text(
                       'Sent E-mail',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.cyan,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
