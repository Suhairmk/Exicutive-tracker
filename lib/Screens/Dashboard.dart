import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/Screens/account.dart';
import 'package:tracker/controller/drawer.dart';
import 'package:tracker/controller/homecontroller.dart';
import 'package:tracker/provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

String? name;

class _DashboardState extends State<Dashboard> {
  Future<void> retrieveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
    });
  }

  @override
  void initState() {
    final provider = Provider.of<AppProvider>(context,listen: false);
    retrieveUserData();
    provider.fetchImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    DateTime? currentBackPressTime;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Dashboard',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.cyan,
          elevation: 0,
        ),
        drawer: CustomDrawer(
          onLogoutPressed: () {
            provider.logoutUser(context);

            // Navigator.push(
            // context, MaterialPageRoute(builder: (context) => LoginScreen()));
          },
          name: name,
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (currentBackPressTime == null ||
                DateTime.now().difference(currentBackPressTime!) >
                    Duration(seconds: 2)) {
              // Show "Press again to exit" Snackbar

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Press again to exit'),
                  duration: Duration(seconds: 2),
                ),
              );
              currentBackPressTime = DateTime.now();

              return false;
            }
            // If pressed twice within 2 seconds, exit the app
             SystemNavigator.pop();
            return true;
          },
          child: SafeArea(
            child: Stack(
              children: [
                // Container at the top
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 300,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
                // Four containers below
                Positioned(
                  top:
                      280, // Adjust the top position to overlap with the above container
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildButton(context, 'Targets', () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeController(
                                          index: 0,
                                        )));
                          }),
                          SizedBox(width: 50),
                          buildButton(context, 'Pending', () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeController(
                                          index: 1,
                                        )));
                          }),
                        ],
                      ),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildButton(context, 'Visited', () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeController(
                                          index: 2,
                                        )));
                          }),
                          SizedBox(width: 50),
                          buildButton(context, 'Profile', () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Account()));
                          })
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

//buttons

@override
Widget buildButton(BuildContext context, text, onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 130,
      width: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400]!,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
          child: Text(
        text,
        style: TextStyle(
            color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 20),
      )),
    ),
  );
}
